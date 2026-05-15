#!/usr/bin/env bash
# Security scan for outgoing public commits.
#
# Scans the range $1..$2 (e.g. origin/main..HEAD) for content that should not
# leave this repo. Exits non-zero if anything matches.
#
# Usage:
#   scripts/security-scan.sh <base_ref> <head_ref>
#   scripts/security-scan.sh                          # defaults to origin/main..HEAD
#
# Override (escape hatch — use sparingly):
#   HARNESS_SECURITY_SKIP=1 git push

set -e

BASE="${1:-origin/main}"
HEAD="${2:-HEAD}"

if [ "${HARNESS_SECURITY_SKIP:-0}" = "1" ]; then
  echo "  ⚠️  HARNESS_SECURITY_SKIP=1 — scan bypassed."
  exit 0
fi

# Pattern groups: <label>::<regex>
# Edit this list as patterns evolve. Keep regexes specific to reduce false positives.
PATTERNS=(
  # Secrets / credentials
  "secret-prefix::(sk_[a-zA-Z0-9_]{16,}|pat_[a-zA-Z0-9_]{16,}|ghp_[a-zA-Z0-9_]{16,}|sbp_[a-zA-Z0-9_]{16,}|gho_[a-zA-Z0-9_]{16,}|AKIA[0-9A-Z]{16})"
  "secret-keyword::(api[_-]?key|password|bearer)[\"'[:space:]]*[:=][\"'[:space:]]*[a-zA-Z0-9_/+=-]{12,}"
  "private-key-header::-----BEGIN (RSA |EC |DSA |OPENSSH |ENCRYPTED )?PRIVATE KEY-----"

  # Personal contact
  "email-personal::(tim@linnetlegacies|tlinnet@linnetpharm|timlinnet@gmail)"
  "phone-us::\+?1?[[:space:]-]?\(?[2-9][0-9]{2}\)?[[:space:]-]?[0-9]{3}[[:space:]-]?[0-9]{4}"

  # Internal infrastructure
  "supabase-pcai-ref::wdsdgqahluswbdfshruu"
  "supabase-freedomos-ref::twuluxmoognlwtmaoqgo"
  "local-filesystem-path::/Users/timlinnet"
  "internal-org::(linnetlegacies|797tracker)"

  # Customers, contractors, anyone not Tim
  # Tim's own name is allowed (he's the public author). Add others here as they appear.
  "private-person::(Kendall|Lonnie|Aiko)"

  # Tim-specific business entities and sister products. These should never appear in
  # public framework content; they belong in the private overlay. FreedomOS is the one
  # exception — allowed in README's "Related" section as the product-to-framework bridge.
  # PCAI and Conduit are accepted in passing prose as generic-enough references but
  # not as strategic positions or worked decisions; review case-by-case.
  "tim-business-name::(Linnet Labs|Linnet Biopharm|Linnet Biopharmaceuticals|Linnet Legacies|Freedom Pledge)"

  # Position names that were sanitized out of public — block re-introduction.
  # Matched only as Strategic-Position-style markdown headings (### prefix) so that
  # CHANGELOG / CLAUDE.md / decisions docs can describe these positions in prose
  # (e.g. "moved to private") without tripping the scanner.
  "private-position-heading::^\\+#{2,4}[[:space:]]+(Faith-aligned product surface|Linnet Labs as autonomous R&D)"

  # Business specifics
  "money-figure::\\\$[0-9]+(,[0-9]{3})*(\\.[0-9]+)?(K|M|k|m)?(/mo|/month|/yr|/year| MRR| ARR)"
)

# Get the diff content, excluding the scanner itself (its pattern definitions
# look like leaks but are the definitions of what to scan for). Reviewers should
# audit the scanner separately.
EXCLUDES=(':(exclude)scripts/security-scan.sh')

if ! git rev-parse --verify "$BASE" >/dev/null 2>&1; then
  echo "  ℹ️   Base ref '$BASE' not found — scanning full $HEAD instead."
  DIFF=$(git show --no-color "$HEAD" -- "${EXCLUDES[@]}")
else
  DIFF=$(git diff --no-color "$BASE..$HEAD" -- "${EXCLUDES[@]}")
fi

if [ -z "$DIFF" ]; then
  echo "  ✅  No outgoing changes to scan."
  exit 0
fi

# Only scan added lines (+) so we don't re-flag content already on remote.
ADDED=$(printf '%s\n' "$DIFF" | grep -E '^\+[^+]' || true)

if [ -z "$ADDED" ]; then
  echo "  ✅  No added lines in this push."
  exit 0
fi

HITS=0
HITS_OUTPUT=""

for entry in "${PATTERNS[@]}"; do
  label="${entry%%::*}"
  regex="${entry#*::}"

  matches=$(printf '%s\n' "$ADDED" | grep -niE -e "$regex" || true)
  if [ -n "$matches" ]; then
    HITS=$((HITS + 1))
    HITS_OUTPUT+="  ❌  [$label]"$'\n'
    HITS_OUTPUT+=$(printf '%s\n' "$matches" | sed 's/^/        /')$'\n'
    HITS_OUTPUT+=$'\n'
  fi
done

if [ "$HITS" -gt 0 ]; then
  echo ""
  echo "  🛑  Security scan blocked the push — $HITS pattern group(s) matched:"
  echo ""
  printf '%s' "$HITS_OUTPUT"
  echo ""
  echo "  Fix the lines above, amend or new-commit, and push again."
  echo "  To override (rare — be sure): HARNESS_SECURITY_SKIP=1 git push"
  echo ""
  exit 1
fi

echo "  ✅  Security scan clean — no flagged patterns in outgoing changes."
exit 0
