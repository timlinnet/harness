#!/usr/bin/env bash
# dirty-state-ownership.sh — classify dirty working-tree files by ownership.
#
# Part of Harness multi-operator coordination primitives. Solves the
# "11 modified files — fyi" problem: a raw `git status` makes the operator
# investigate ownership themselves. This script does the inference upfront
# and renders one of:
#
#   "Working tree clean."
#   "4 dirty files — all local-config noise. Zero code in flight."
#   "12 dirty files: 4 noise, 6 yours (today), 2 yours (stale)."
#
# Usage:  dirty-state-ownership.sh <repo-dir> [<repo-dir> ...]
#
# Classification per file:
#   📁 local-config — matches a known noise pattern (.mcp.json,
#                     supabase/.temp/*, .claude/launch.json, .DS_Store, etc.)
#   👤 yours        — last commit email matches `git config user.email`
#                     AND file mtime is within $STALE_HOURS hours
#   ⏳ yours-stale  — last commit email matches yours but mtime is older
#   👥 other:NAME   — last commit email differs from yours (NAME inferred
#                     from the email local-part)
#   ❓ untracked    — no git history for the path; not a noise match
#
# Defensive: silent-exits on missing git, unreadable repos, etc. Written for
# bash 3.2 compatibility (macOS default shell) — no associative arrays.

set -eu

if [ "$#" -eq 0 ]; then
  echo "Usage: dirty-state-ownership.sh <repo-dir> [<repo-dir> ...]" >&2
  exit 64
fi

if ! command -v git >/dev/null 2>&1; then
  echo "  ⚠️  Working-tree classifier skipped — git not installed"
  exit 0
fi

STALE_HOURS="${HARNESS_DIRTY_STALE_HOURS:-24}"

# Local-config / noise patterns. Regex matched against file path. Override
# via HARNESS_NOISE_PATTERNS (newline-separated regex list).
DEFAULT_NOISE_PATTERNS='^\.mcp\.json$
^\.claude/launch\.json$
^\.claude/settings\.local\.json$
^supabase/\.temp/
^\.DS_Store$
^.+\.swp$
^.+\.swo$
^\.idea/
^\.vscode/'
NOISE_PATTERNS="${HARNESS_NOISE_PATTERNS:-$DEFAULT_NOISE_PATTERNS}"

now_epoch=$(date +%s)
stale_cutoff=$(( now_epoch - STALE_HOURS * 3600 ))

is_noise() {
  local path="$1"
  while IFS= read -r pat; do
    [ -z "$pat" ] && continue
    if echo "$path" | grep -E -q "$pat"; then
      return 0
    fi
  done <<EOF
$NOISE_PATTERNS
EOF
  return 1
}

# Helper: count non-empty lines in a string
count_lines() {
  if [ -z "$1" ]; then
    echo 0
  else
    printf '%s' "$1" | grep -c .
  fi
}

# Helper: join newline-separated strings as comma-space
join_csv() {
  printf '%s' "$1" | tr '\n' ',' | sed 's/,$//' | sed 's/,/, /g'
}

classify_repo() {
  local repo="$1"
  if [ ! -d "$repo/.git" ]; then
    return 0
  fi

  local status
  status=$(git -C "$repo" status --porcelain=v1 2>/dev/null || echo "")
  if [ -z "$status" ]; then
    echo "  ✅  $(basename "$repo"): working tree clean"
    return 0
  fi

  local me
  me=$(git -C "$repo" config user.email 2>/dev/null || echo "")

  # String accumulators (bash 3.2 compatible — no associative arrays)
  local noise_files=""
  local mine_files=""
  local mine_stale_files=""
  local other_lines=""   # one "who|path" per line
  local untracked_files=""
  local total=0

  while IFS= read -r line; do
    [ -z "$line" ] && continue
    total=$((total + 1))
    local code path
    code="${line:0:2}"
    path="${line:3}"
    path="${path#\"}"
    path="${path%\"}"

    if is_noise "$path"; then
      noise_files="${noise_files}${path}
"
      continue
    fi

    if [ "$code" = "??" ]; then
      untracked_files="${untracked_files}${path}
"
      continue
    fi

    local author_email
    author_email=$(git -C "$repo" log -1 --format='%ae' -- "$path" 2>/dev/null || echo "")

    local mtime
    if [ -e "$repo/$path" ]; then
      mtime=$(stat -f %m "$repo/$path" 2>/dev/null || stat -c %Y "$repo/$path" 2>/dev/null || echo 0)
    else
      mtime=0
    fi

    if [ -n "$author_email" ] && [ "$author_email" = "$me" ]; then
      if [ "$mtime" -ge "$stale_cutoff" ]; then
        mine_files="${mine_files}${path}
"
      else
        mine_stale_files="${mine_stale_files}${path}
"
      fi
    elif [ -n "$author_email" ]; then
      local who="${author_email%@*}"
      other_lines="${other_lines}${who}|${path}
"
    else
      untracked_files="${untracked_files}${path}
"
    fi
  done <<EOF
$status
EOF

  echo "  🌳  $(basename "$repo"): $total dirty file(s)"

  local n
  n=$(count_lines "$noise_files")
  if [ "$n" -gt 0 ]; then
    echo "      📁 local-config noise ($n): $(join_csv "$noise_files")"
  fi
  n=$(count_lines "$mine_files")
  if [ "$n" -gt 0 ]; then
    echo "      👤 yours, recent ($n): $(join_csv "$mine_files")"
  fi
  n=$(count_lines "$mine_stale_files")
  if [ "$n" -gt 0 ]; then
    echo "      ⏳ yours, stale >${STALE_HOURS}h ($n): $(join_csv "$mine_stale_files")"
  fi
  if [ -n "$other_lines" ]; then
    local whos
    whos=$(printf '%s' "$other_lines" | awk -F'|' 'NF==2 {print $1}' | sort -u)
    while IFS= read -r who; do
      [ -z "$who" ] && continue
      local who_paths who_count
      who_paths=$(printf '%s' "$other_lines" | awk -F'|' -v w="$who" 'NF==2 && $1==w {print $2}')
      who_count=$(count_lines "$who_paths")
      echo "      👥 $who ($who_count): $(join_csv "$who_paths")"
    done <<EOF
$whos
EOF
  fi
  n=$(count_lines "$untracked_files")
  if [ "$n" -gt 0 ]; then
    echo "      ❓ untracked, no noise match ($n): $(join_csv "$untracked_files")"
  fi

  # Headline summary if everything is non-code
  local mine_count mine_stale_count other_count untracked_count
  mine_count=$(count_lines "$mine_files")
  mine_stale_count=$(count_lines "$mine_stale_files")
  other_count=$(count_lines "$other_lines")
  untracked_count=$(count_lines "$untracked_files")
  if [ "$mine_count" -eq 0 ] \
     && [ "$mine_stale_count" -eq 0 ] \
     && [ "$other_count" -eq 0 ] \
     && [ "$untracked_count" -eq 0 ]; then
    echo "      ✅  all noise — zero code in flight"
  fi
}

echo ""
echo "🌳 Working-tree state:"

for repo in "$@"; do
  classify_repo "$repo"
done

echo ""
