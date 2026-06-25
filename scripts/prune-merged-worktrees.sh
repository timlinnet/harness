#!/usr/bin/env bash
# prune-merged-worktrees.sh — drain stale git worktrees automatically.
#
# Part of Harness multi-operator hygiene. Every session spins a fresh worktree
# off origin/main; once its branch merges, the worktree is dead weight (disk +
# node_modules + git overhead). Left alone they pile up (60+ observed). This
# removes the ones that are provably safe to remove.
#
# SAFETY BY CONSTRUCTION: removes the WORKTREE DIRECTORY ONLY — never the branch.
# So even a false prune costs a single `git worktree add <path> <branch>`, never
# a commit. Combined with the clean-tree gate (below), no uncommitted work is
# ever lost.
#
# Usage:  prune-merged-worktrees.sh <repo-dir> [<repo-dir> ...]
# Env:    HARNESS_WORKTREE_PRUNE_DRYRUN=1   report what would go, remove nothing
#
# A worktree is pruned only if BOTH hold:
#   clean  — `git status --porcelain` is empty (no uncommitted / untracked work)
#   merged — its branch name is in `gh pr list --state merged` — a CONFIRMED
#            merged PR, the only signal that proves the branch's work shipped.
#            We deliberately do NOT use `merge-base --is-ancestor`: a freshly
#            created worktree points AT origin/HEAD with no commits yet, which is
#            trivially an ancestor — so ancestry would prune a worktree another
#            concurrent session is still setting up (observed: it removed a brand-
#            new worktree mid-build). gh required; if absent, nothing is pruned.
# NEVER touched: the primary checkout, .claude/worktrees/* (harness-managed),
#   detached HEADs, dirty trees, unmerged branches, or any branch without a
#   merged PR (covers fresh / in-flight / direct-push-to-main worktrees).
#
# Defensive: silent-exits on missing git / unreadable repos. bash 3.2 compatible.

set -eu

[ "$#" -eq 0 ] && { echo "Usage: prune-merged-worktrees.sh <repo-dir> [<repo-dir> ...]" >&2; exit 64; }
command -v git >/dev/null 2>&1 || { echo "  ⚠️  worktree-prune skipped — git not installed"; exit 0; }

DRYRUN="${HARNESS_WORKTREE_PRUNE_DRYRUN:-0}"

prune_repo() {
  repo="$1"
  [ -d "$repo/.git" ] || return 0

  primary=$( (cd "$repo" && git rev-parse --show-toplevel) 2>/dev/null ) || return 0

  # Merged-PR head branches — the ONLY prune signal (one network call).
  merged_set=""
  if command -v gh >/dev/null 2>&1; then
    merged_set=$( (cd "$repo" && gh pr list --state merged --limit 400 --json headRefName -q '.[].headRefName') 2>/dev/null || echo "" )
  fi

  pruned=0; kept_dirty=0; kept_unmerged=0; kept_harness=0
  path=""; branch=""; detached=0

  # `git worktree list --porcelain` emits records separated (and terminated) by
  # blank lines; evaluate each record when we hit its blank line.
  while IFS= read -r line; do
    if [ -n "$line" ]; then
      case "$line" in
        "worktree "*) path="${line#worktree }"; branch=""; detached=0 ;;
        "branch "*)   branch="${line#branch refs/heads/}" ;;
        "detached")   detached=1 ;;
      esac
      continue
    fi

    [ -z "$path" ] && continue
    if [ "$path" = "$primary" ]; then path=""; continue; fi
    case "$path" in */.claude/worktrees/*) kept_harness=$((kept_harness + 1)); path=""; continue ;; esac
    if [ "$detached" = 1 ] || [ -z "$branch" ]; then kept_unmerged=$((kept_unmerged + 1)); path=""; continue; fi

    # clean gate
    if [ -n "$(git -C "$path" status --porcelain 2>/dev/null | head -1)" ]; then
      kept_dirty=$((kept_dirty + 1)); path=""; continue
    fi

    # merged gate — CONFIRMED merged PR only. NOT merge-base ancestry: a freshly
    # created worktree's branch is at origin/HEAD with no commits, trivially an
    # ancestor, and ancestry would prune it out from under a concurrent session
    # still setting it up (observed). A merged PR proves the work shipped.
    is_merged=0
    if [ -n "$merged_set" ] && printf '%s\n' "$merged_set" | grep -qxF "$branch"; then
      is_merged=1
    fi
    if [ "$is_merged" = 0 ]; then kept_unmerged=$((kept_unmerged + 1)); path=""; continue; fi

    if [ "$DRYRUN" = 1 ]; then
      echo "      🧹 would prune: $(basename "$path")  [$branch]"
      pruned=$((pruned + 1))
    elif git -C "$repo" worktree remove --force "$path" 2>/dev/null; then
      echo "      🧹 pruned: $(basename "$path")  [$branch]"
      pruned=$((pruned + 1))
    else
      kept_unmerged=$((kept_unmerged + 1))   # removal failed → leave it untouched
    fi
    path=""
  done <<EOF
$( (cd "$repo" && git worktree list --porcelain) 2>/dev/null )
EOF

  [ "$DRYRUN" = 1 ] || git -C "$repo" worktree prune 2>/dev/null || true

  verb="pruned"; [ "$DRYRUN" = 1 ] && verb="would prune"
  echo "  🌳 $(basename "$repo"): ${verb} ${pruned} · kept ${kept_dirty} dirty, ${kept_unmerged} unmerged, ${kept_harness} harness"
}

echo ""
echo "🧹 Worktree prune (merged + clean only; branches kept):"
for repo in "$@"; do
  prune_repo "$repo"
done
echo ""
