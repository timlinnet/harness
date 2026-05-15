#!/usr/bin/env bash
#
# session-chapter-digest.sh — surface OTHER recently-active Claude Code
# sessions and their latest mark_chapter title at SessionStart.
#
# Why: Claude Code's FleetView session titles are auto-generated from the
# first user message and drift as work pivots. The mark_chapter calls inside
# each session JSONL are the ground truth of what's currently being worked
# on. Without surfacing this, the operator (or a new session) loses an hour
# trying to figure out "what was that other session doing?".
#
# Output: at most ~6 lines. Sorted by recency. Current session excluded by
# mtime threshold (files touched within MIN_AGE seconds are assumed to be us).
#
# Window: last 4h. Adjust MAX_AGE if you want a different lookback.

set -euo pipefail
export LC_ALL=C

PROJ_DIR="${CLAUDE_PROJECT_DIR:-$HOME/.claude/projects/-Users-timlinnet}"
[ -d "$PROJ_DIR" ] || exit 0

NOW=$(date +%s)
MIN_AGE=30        # seconds — exclude the session firing this hook
MAX_AGE=14400     # 4 hours — keep the digest tight

declare -a ENTRIES=()

while IFS= read -r f; do
  # mtime: macOS vs GNU stat
  mtime=$(stat -f %m "$f" 2>/dev/null || stat -c %Y "$f" 2>/dev/null || echo 0)
  age=$(( NOW - mtime ))
  if [ "$age" -lt "$MIN_AGE" ] || [ "$age" -gt "$MAX_AGE" ]; then continue; fi

  # Pull the LATEST mark_chapter title from this session's JSONL.
  # Tool name is namespaced: "mcp__ccd_session__mark_chapter".
  chapter=$( { grep -o '"name":"mcp__ccd_session__mark_chapter"[^}]*"title":"[^"]*"' "$f" 2>/dev/null || true; } \
    | tail -1 \
    | sed -E 's/.*"title":"([^"]*)".*/\1/' || true)

  # Fallback: first real user text message (≤70 chars).
  # The JSONL has both real user messages ("content":"<string>") and
  # tool_result entries ("content":[{...}]). Match only string content.
  if [ -z "${chapter:-}" ]; then
    first_user=$( { grep -o '"role":"user","content":"[^"]\{5,200\}"' "$f" 2>/dev/null || true; } \
      | head -1 \
      | sed -E 's/.*"content":"([^"]*)".*/\1/' \
      | tr '\n\t' '  ' \
      | cut -c1-70 || true)
    if [ -n "${first_user:-}" ]; then chapter="[no chapter] ${first_user}…"; fi
  fi

  [ -z "$chapter" ] && continue
  ENTRIES+=("${age}|${chapter}")
done < <(find "$PROJ_DIR" -maxdepth 1 -name "*.jsonl" -type f 2>/dev/null)

[ "${#ENTRIES[@]}" -eq 0 ] && exit 0

echo "📡 Other recent sessions (last 4h, latest chapter):"
printf '%s\n' "${ENTRIES[@]}" \
  | sort -t'|' -k1 -n \
  | head -6 \
  | while IFS='|' read -r age title; do
      if [ "$age" -lt 3600 ]; then
        label="$(( age / 60 ))m"
      else
        h=$(( age / 3600 )); m=$(( (age % 3600) / 60 ))
        label="${h}h${m}m"
      fi
      echo "  [${label} ago] ${title}"
    done
