#!/usr/bin/env bash
# verify-on-deploy-wake.sh — PostToolUse hook: the firing surface for the qa/verify
# step. When a PRODUCTION deploy happens (Lovable publish or a Supabase edge-function
# deploy), nudge the agent to VERIFY the live result before claiming done.
#
# WHY: gstack enforces verify *inside* its deploy workflow (land-and-deploy → canary,
# /verify), but has no firing surface for a deploy done OUTSIDE that workflow — a raw
# deploy_project / `supabase functions deploy`. Those deploy tools are permission
# pre-authorized, so one frictionless call ships with no verify. This hook catches the
# bypass path. It's the PostToolUse analog of v22's UserPromptSubmit workflow-shape-wake.
#
# LOCAL INTERIM, designed for deletion: proposed upstream to gstack (decisions/0007).
# When gstack ships an equivalent, remove with
# `gstack-settings-hook remove-source verify-on-deploy` and delete this file.
#
# RECALL-RAISER, NOT A BLOCKER. Fires on the deploy *action*; the agent decides what
# verification fits. Fail-soft: empty / non-JSON stdin, missing tool, or no jq -> silent
# exit 0. NEVER exits 2 — it can never block a deploy that already happened.
set -u

PAYLOAD="$(cat 2>/dev/null)" || exit 0
[ -n "$PAYLOAD" ] || exit 0
command -v jq >/dev/null 2>&1 || exit 0

TOOL="$(printf '%s' "$PAYLOAD" | jq -r '.tool_name // empty' 2>/dev/null)" || exit 0
[ -n "$TOOL" ] || exit 0

# What kind of prod deploy was this? Empty = not a deploy -> silent.
WHAT=""
case "$TOOL" in
  *deploy_project*)        WHAT="Lovable frontend publish" ;;
  *deploy_edge_function*)  WHAT="Supabase edge-function deploy" ;;
  Bash)
    CMD="$(printf '%s' "$PAYLOAD" | jq -r '.tool_input.command // empty' 2>/dev/null)"
    # Require an ACTUAL `supabase functions deploy` invocation at a command boundary
    # (start of command, or after ; && | ), so the same string sitting inside a commit
    # message / grep pattern / echo does NOT false-fire. (Origin: v1 of this hook
    # false-fired on its own commit message, which contained "supabase functions deploy"
    # as descriptive text. 2026-06-04.)
    if printf '%s' "$CMD" | grep -qE '(^|[;&|])[[:space:]]*(npx[[:space:]]+)?supabase[[:space:]]+functions[[:space:]]+deploy([[:space:]]|$)'; then
      WHAT="Supabase edge-function deploy (CLI)"
    fi
    ;;
esac
[ -n "$WHAT" ] || exit 0

MSG="verify-on-deploy (firing surface for the qa step): a production deploy just happened ($WHAT), and it may have bypassed the /deploy -> /verify (gstack land-and-deploy / canary) workflow. Before you report this done: VERIFY the live result — run /verify or /canary <url> (open the real user path, confirm behavior + state, screenshot). Then report exactly one of: 'deployed + verified — <evidence>' OR 'deployed, NOT verified — verify pending'. Never 'shipped/done' on the strength of the deploy call alone — a deploy is an action you took; verified is a fact you observed. If you already ran the deploy workflow and it verified, this is a no-op — just say it's verified."

jq -n --arg m "$MSG" '{hookSpecificOutput:{hookEventName:"PostToolUse",additionalContext:$m}}'
exit 0
