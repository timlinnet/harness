#!/usr/bin/env bash
# workflow-shape-wake.sh — UserPromptSubmit hook: wake the "Fire on orchestration
# shape" heuristic when a prompt *might* be many-independent-units work.
#
# RECALL-RAISER, NOT A DECIDER. Fires on a deliberately LOW bar (one fan-out verb
# OR one breadth/collective token), after a pure-execution exclusion, and injects
# ONE sentence pointing the agent at the fan-out test in
# conventions/orchestration-shape.md. The agent's semantic 5-point test is the
# precision filter, so a text false-positive costs ~one discarded sentence, never
# operator attention. See FIRST_PRINCIPLES.md "Fire on orchestration shape".
#
# Fires AT MOST ONCE PER SESSION (sentinel keyed on session_id) so follow-ups and
# scope-narrowing course-corrections never re-trigger — this is the guard against
# the wall-of-text tune-out failure mode. Fail-soft: empty / non-JSON stdin,
# missing prompt, or no jq -> silent exit 0. Never exits 2, so it can never block
# a prompt.
set -u

PAYLOAD="$(cat 2>/dev/null)" || exit 0
[ -n "$PAYLOAD" ] || exit 0
command -v jq >/dev/null 2>&1 || exit 0

PROMPT="$(printf '%s' "$PAYLOAD" | jq -r '.prompt // empty' 2>/dev/null)" || exit 0
[ -n "$PROMPT" ] || exit 0
SID="$(printf '%s' "$PAYLOAD" | jq -r '.session_id // empty' 2>/dev/null)"

# Once-per-session guard, before any matching work.
SENTINEL=""
if [ -n "$SID" ]; then
  SENTINEL="${TMPDIR:-/tmp}/harness-wake-${SID}"
  [ -e "$SENTINEL" ] && exit 0
fi

# Lowercase + pad with spaces so " word " patterns also match at string edges.
LP=" $(printf '%s' "$PROMPT" | tr '[:upper:]' '[:lower:]') "

# 1) Pure-execution exclusion FIRST — these are never orchestration-shaped.
case "$LP" in
  *deploy*|*"ship it"*|*"push to prod"*|*"the approved plan"*|*"the reviewed change"*|*typo*|*hotfix*|*revert*|*"merge this"*|*"cherry-pick"*|*"cherry pick"*)
    exit 0 ;;
esac

# 2) LOW-bar match: a single fan-out verb OR a single breadth/collective token.
WAKE=""
case "$LP" in
  *audit*|*review*|*analyz*|*analys*|*research*|*classif*|*categoriz*|*categoris*|*extract*|*compare*|*migrate*|*transform*|*refactor*|*standardiz*|*standardis*|*summariz*|*summaris*|*"go through"*|*inventory*|*sweep*)
    WAKE="verb" ;;
esac
if [ -z "$WAKE" ]; then
  case "$LP" in
    *" all "*|*"all of "*|*"every "*|*" each "*|*across*|*"both "*|*multiple*|*several*|*" whole "*|*entire*)
      WAKE="breadth" ;;
  esac
fi
[ -n "$WAKE" ] || exit 0

# Wake only once per session.
[ -n "$SENTINEL" ] && : > "$SENTINEL" 2>/dev/null

MSG="workflow-shape signal (recall nudge, not a verdict): this may be many-independent-units work — run the fan-out test in conventions/orchestration-shape.md against the real task shape; if it passes and the work is read-only or cheap+reversible, just fan out (no need to ask); if it is an expensive + irreversible spend, surface a one-line costed disposition with a veto beat, then proceed unless vetoed; if units < ~5, cross-dependent, or it needs per-item judgment, say nothing and proceed serially."

jq -n --arg m "$MSG" '{hookSpecificOutput:{hookEventName:"UserPromptSubmit",additionalContext:$m}}'
exit 0
