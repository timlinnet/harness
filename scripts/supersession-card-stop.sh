#!/usr/bin/env bash
# supersession-card-stop.sh — Stop hook. The in-session half of the supersession card-cleanup
# (design .agent/design-docs/2026-06-25-supersession-card-cleanup.md, D2: "Stop-hook nudge + cron
# backstop"). When a session DEPLOYS A FIX but never looks at the command center, the cards that fix
# mooted rot there and confuse the next debug session. This nudges the agent to clear them.
#
# WHY THIS EXISTS
#   The cron sweep (card-quality-sweep) auto-clears only the MECHANICALLY-PROVABLE supersession class
#   (a capability now base/granted). The bulk of stale cards are JUDGMENT-class — only the agent that
#   just fixed the underlying bug knows which open cards its fix mooted. That knowledge lives in this
#   session and nowhere else, so a context-resident reminder is the only place to catch it. This hook
#   is the structural backstop for "clean up after your fix" so it doesn't depend on remembering.
#
# HONEST SCOPE (review-assisted, NOT pure by-construction): the hook sees TOOL-CALL SIGNATURES in the
#   transcript (a deploy happened; cards were / weren't consulted), not whether a specific card is
#   truly moot — so it guarantees the agent LOOKS, not the verdict. The agent dismisses (NEVER denies)
#   only the cards it can see are moot, and a clean queue passes by saying so. stop_hook_active bounds
#   this to ONE re-check (never loops).
#
# LEARNING-SAFETY: the nudge text is explicit — clear moot cards via decide_command_center_item with
#   decision='dismissed' (the learning-neutral terminal), NEVER 'denied' (which poisons the agent's
#   training_score / anti-patterns / the scheduler deniedSet). superseded ≠ corrective.
#
# SOAK: unproven. If it nags without catching real stale-card misses, RIP IT OUT — do not tune it
#   forever (the lesson question-gate-stop.sh records). Window: ~2 weeks from 2026-06-26.

input=$(cat)
python3 - "$input" <<'PY'
import sys, json, re
try:
    data = json.loads(sys.argv[1])
except Exception:
    sys.exit(0)

# Already re-checked once this turn -> let it through. Bounds to a single re-check; never loops.
if data.get("stop_hook_active"):
    sys.exit(0)

tp = data.get("transcript_path")
if not tp:
    sys.exit(0)

# TRIGGER — "a fix landed this session": an edge-function deploy (the moment a fix reaches prod, where
# the cards it gated become moot). Matched as the tool_use name / a bash deploy command.
TRIGGER = re.compile(r'"name"\s*:\s*"mcp__supabase[^"]*__deploy_edge_function"|supabase functions deploy')

# MARKER — the session already ATTENDED to the command center (scanned or cleared cards, ran the
# card sweep, or reasoned about supersession). Any of these means "looked" -> pass.
MARKER = re.compile(r'command_center_item|card-quality-sweep|supersed|get_pending_approvals')

trigger = False
marker = False
try:
    with open(tp) as f:
        for line in f:
            line = line.strip()
            if not line:
                continue
            if not trigger and TRIGGER.search(line):
                trigger = True
            if not marker and MARKER.search(line):
                marker = True
            if trigger and marker:
                break
except Exception:
    sys.exit(0)

if trigger and not marker:
    reason = (
        "STOP-GATE (supersession card cleanup): this session DEPLOYED A FIX but never checked the "
        "command center for cards that fix made moot — they will sit there stale and confuse the next "
        "debug session. Before the turn lands, do ONE: (a) scan the open cards (get_command_center_items / "
        "get_pending_approvals) for the company you fixed, and DISMISS any whose reason your fix resolved "
        "via decide_command_center_item(decision='dismissed') — the learning-NEUTRAL terminal; NEVER "
        "'denied' (that poisons the agent's learning: training_score reset, anti-pattern, scheduler "
        "deniedSet — superseded is moot, not a correction). Or (b) confirm in one line that the fix "
        "mooted no open card, and it passes."
    )
    print(json.dumps({"decision": "block", "reason": reason}))

sys.exit(0)
PY
