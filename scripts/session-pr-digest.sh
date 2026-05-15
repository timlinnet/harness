#!/usr/bin/env bash
# session-pr-digest.sh — author-aware filtered PR digest for SessionStart.
#
# Part of Harness multi-operator coordination primitives. Solves the
# attribution-and-status problem that a raw `gh pr list` dump creates:
# you can't tell at a glance which PRs are yours, which are someone else's
# ready for review, and which are someone else's still drafting.
#
# Usage:  session-pr-digest.sh <owner/repo> [<owner/repo> ...]
#
# What it renders, in priority order:
#
#   🔴 NEEDS YOUR REVIEW   — others' open, non-draft PRs
#   🟢 YOURS — ready       — your open, non-draft PRs
#   🟡 YOURS — drafting    — your open drafts
#   👤 Others' drafts      — collapsed summary; flagged if body suggests "ready"
#                            but PR is still DRAFT (the common discipline gap)
#
# Identity: inferred from `gh api user --jq .login`. The script never argues
# with what GitHub thinks your login is — it just uses author.login from each
# PR to decide which bucket the PR belongs in.
#
# Defensive: silent-exits if `gh` is unauthenticated or `jq` is missing.
# Skips repos that 404 (org permissions changed, repo renamed, etc.) without
# breaking the rest of the digest.

set -eu

if [ "$#" -eq 0 ]; then
  echo "Usage: session-pr-digest.sh <owner/repo> [<owner/repo> ...]" >&2
  exit 64
fi

# Dependencies — fail soft so we never break a SessionStart
if ! command -v gh >/dev/null 2>&1; then
  echo "  ⚠️  PR digest skipped — gh CLI not installed"
  exit 0
fi
if ! command -v jq >/dev/null 2>&1; then
  echo "  ⚠️  PR digest skipped — jq not installed"
  exit 0
fi

ME=$(gh api user --jq .login 2>/dev/null || echo "")
if [ -z "$ME" ]; then
  echo "  ⚠️  PR digest skipped — gh CLI not authenticated"
  exit 0
fi

# Phrases that suggest "I'm ready for review" in a PR body. Used to flag
# discipline mismatches — PR body says ready, GitHub flag still DRAFT.
# Broader than strictly necessary; tolerates whitespace variation and
# common "I need your X" phrasings. False positives just become a yellow
# flag in the digest, not a block — the cost of a false positive is small.
READY_REGEX='Status:[[:space:]]*(DONE|COMPLETE|READY)|ready[[:space:]]+(for|to)[[:space:]]+(review|merge|be[[:space:]]+merged)|please[[:space:]]+review|requesting[[:space:]]+review|seeking[[:space:]]+review|awaiting[[:space:]]+(your[[:space:]]+)?(review|approval|sign-?off|ratification|merge)|need[[:space:]]+(your[[:space:]]+)?(approval|sign-?off|ratification|review|input|ratify)|i[[:space:]]+need[[:space:]]+(you|your|tim)[[:space:]]+(to[[:space:]]+)?(review|approve|ratify|sign)|i[[:space:]]+need[[:space:]]+your[[:space:]]+(approval|sign-?off|ratification|review|input)'

TMP=$(mktemp)
trap "rm -f \"$TMP\"" EXIT

# Collect: repo, number, author, title, branch, isDraft, body_hint
for repo in "$@"; do
  gh pr list --repo "$repo" --state open \
    --json number,title,author,headRefName,isDraft,body \
    --limit 50 2>/dev/null \
    | jq -r --arg repo "$repo" --arg re "$READY_REGEX" '
        .[] |
        [ $repo,
          (.number|tostring),
          .author.login,
          .title,
          .headRefName,
          (.isDraft|tostring),
          ( (.body // "") | test($re; "i") | tostring )
        ] | @tsv
      ' >> "$TMP" 2>/dev/null || true
done

MINE_READY=()
MINE_DRAFT=()
OTHER_READY=()
OTHER_DRAFT=()
OTHER_DRAFT_MISMATCH=()

while IFS=$'\t' read -r repo number author title branch is_draft body_hint; do
  [ -z "${repo:-}" ] && continue
  line="[$repo] #$number — $title"
  if [ "$author" = "$ME" ]; then
    if [ "$is_draft" = "true" ]; then
      MINE_DRAFT+=("$line  ($branch)")
    else
      MINE_READY+=("$line")
    fi
  else
    if [ "$is_draft" = "true" ]; then
      if [ "$body_hint" = "true" ]; then
        OTHER_DRAFT_MISMATCH+=("$line  ($author, $branch) ⚠ body suggests ready — author may need to un-draft")
      else
        OTHER_DRAFT+=("$line  ($author)")
      fi
    else
      OTHER_READY+=("$line  ($author)")
    fi
  fi
done < "$TMP"

echo ""
echo "📋 PR digest (you = $ME):"

if [ "${#OTHER_READY[@]}" -gt 0 ]; then
  echo ""
  echo "  🔴 NEEDS YOUR REVIEW (${#OTHER_READY[@]}):"
  printf '    %s\n' "${OTHER_READY[@]}"
fi

if [ "${#OTHER_DRAFT_MISMATCH[@]}" -gt 0 ]; then
  echo ""
  echo "  ⚠️  Others' drafts that READ as ready (${#OTHER_DRAFT_MISMATCH[@]}) — discipline gap:"
  printf '    %s\n' "${OTHER_DRAFT_MISMATCH[@]}"
fi

if [ "${#MINE_READY[@]}" -gt 0 ]; then
  echo ""
  echo "  🟢 YOURS — ready to merge (${#MINE_READY[@]}):"
  printf '    %s\n' "${MINE_READY[@]}"
fi

if [ "${#MINE_DRAFT[@]}" -gt 0 ]; then
  echo ""
  echo "  🟡 YOURS — drafting (${#MINE_DRAFT[@]}):"
  printf '    %s\n' "${MINE_DRAFT[@]}"
fi

if [ "${#OTHER_DRAFT[@]}" -gt 0 ]; then
  echo ""
  echo "  👤 Others' drafts (${#OTHER_DRAFT[@]} in progress — not yet for you):"
  printf '    %s\n' "${OTHER_DRAFT[@]}"
fi

if [ "${#OTHER_READY[@]}" -eq 0 ] \
   && [ "${#OTHER_DRAFT_MISMATCH[@]}" -eq 0 ] \
   && [ "${#MINE_READY[@]}" -eq 0 ] \
   && [ "${#MINE_DRAFT[@]}" -eq 0 ] \
   && [ "${#OTHER_DRAFT[@]}" -eq 0 ]; then
  echo "  ✅  No open PRs across the queried repos."
fi

echo ""
