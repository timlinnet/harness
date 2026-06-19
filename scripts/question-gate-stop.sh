#!/usr/bin/env bash
# question-gate-stop.sh — Stop hook. The OUTBOUND forcing function for "Resolve, don't float".
#
# WHY THIS EXISTS
#   The anti-float family (Resolve-don't-float / Self-drive-within-the-never-ask-envelope /
#   Fire-on-{decision,orchestration}-shape) is context-resident PROSE. It under-fires against a
#   *dispositional* deference pull (asking feels safe), so the agent floats decisions the substrate
#   already resolves — proven by same-day recurrence under a fresh correction. You can't out-prose a
#   reflex. This hook is the structural backstop: it BLOCKS a turn that ends in a permission-to-proceed
#   closer and forces the agent to re-run the question gate (act + veto, not ask) before the turn lands.
#
# HONEST SCOPE (review-assisted, NOT pure by-construction): the hook sees the message TEXT, not the
#   cost×reversibility classification — so it guarantees the CHECK happens, not that the verdict is
#   right (same honesty as the /cso gate). Genuine consequence/taste/irreversible asks survive: the
#   agent re-justifies and re-emits, and stop_hook_active bounds this to ONE re-check (no loop).
#
# SOAK: this is unproven. If it adds latency without catching real floats, RIP IT OUT — do not tune
#   it forever (the lesson from the orchestration-shape wake-hook it replaces). Window: ~2 weeks.

input=$(cat)
python3 - "$input" <<'PY'
import sys, json, re
try:
    data = json.loads(sys.argv[1])
except Exception:
    sys.exit(0)

# Already re-checked once this turn → let it through. Bounds to a single re-check; never loops.
if data.get("stop_hook_active"):
    sys.exit(0)

tp = data.get("transcript_path")
if not tp:
    sys.exit(0)

# Pull the LAST assistant text message from the transcript JSONL.
last_text = ""
try:
    with open(tp) as f:
        for line in f:
            line = line.strip()
            if not line:
                continue
            try:
                ev = json.loads(line)
            except Exception:
                continue
            msg = ev.get("message") if isinstance(ev.get("message"), dict) else ev
            is_assistant = ev.get("type") == "assistant" or (isinstance(msg, dict) and msg.get("role") == "assistant")
            if not is_assistant:
                continue
            content = (msg or {}).get("content")
            if isinstance(content, list):
                txt = " ".join(c.get("text", "") for c in content if isinstance(c, dict) and c.get("type") == "text")
            elif isinstance(content, str):
                txt = content
            else:
                txt = ""
            if txt.strip():
                last_text = txt
except Exception:
    sys.exit(0)

# Closers live at the END of a turn — only inspect the tail (keeps false positives low).
tail = last_text[-700:].lower()
closers = [
    r"\bwant me to\b",
    r"\bshould i\b",
    r"\bshall i\b",
    r"\bdo you want me to\b",
    r"\bwould you like me to\b",
    r"\bready for me to\b",
    r"\blet me know if you want\b",
    r"\bwant me to (start|build|wire|run|deploy|grant|proceed|kick)\b",
]
if any(re.search(p, tail) for p in closers):
    reason = (
        "STOP-GATE (Resolve, don't float — the outbound question gate): this turn ends in a "
        "permission-to-proceed closer. Before it lands, run the gate: (1) does a Harness principle "
        "or a live Freedom-Engine output ALREADY RESOLVE this? (2) is the work cheap + reversible? "
        "(3) is the only reason to ask deference? If ANY is yes -> do NOT ask; ACT and offer a one-line "
        "veto beat ('proceeding unless you say otherwise'). Deference is NOT a pass-reason. Re-emit the "
        "question ONLY if it is genuinely consequential / taste / irreversible / principle-conflict that "
        "the substrate does NOT resolve — then it legitimately passes the gate."
    )
    print(json.dumps({"decision": "block", "reason": reason}))

sys.exit(0)
PY
