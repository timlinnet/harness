# Convention: Orchestration Shape — when to fan out to a multi-agent Workflow

The human-facing home of the 📐 Heuristic *"Fire on orchestration shape, not orchestration size"* (`FIRST_PRINCIPLES.md`). Its sibling *"Fire on decision shape"* governs the **free** review chain; this one governs work with **real marginal cost** — multi-agent orchestration (fan-out across many independent units). It exists because that lift is routinely *missed*: the agent reads N files serially instead of fanning out, and the operator never feels the acceleration.

## The fan-out test

Reach for multi-agent fan-out when **all five** hold:

1. **Crisp per-unit contract** — the work on each unit is specifiable in a few sentences + an output schema, with no mid-stream Q&A.
2. **Many independent similar units** (~5+) — per file / function / source / channel / record, with no cross-dependencies.
3. **Verifiable output** — a schema, test, or build checks it; not blind trust.
4. **Worth the tokens** — big enough to justify the spend (fan-out costs *usage* tokens, not your main context).
5. **Operator out of the loop** — no course-correction needed once it starts.

One-liner: **fan out when the contract is crisp and you're not in the loop.**

- **Read / audit / research** (read-only) → almost always a candidate; use a read-only agent type so it can't write.
- **Mechanical transform** with a clear contract → **canary ONE by hand** to lock the pattern, then fan out the rest against it as the template.
- **Judgment / taste / per-item decisions** → stay interactive. Never fan out judgment.

## Cheap-vs-expensive — the disposition table

Once the test passes, *how* you act is a deterministic lookup, not a fresh deliberation:

| Disposition | Condition | Action |
|---|---|---|
| **Just do it** | read-only, OR cheap + reversible | Fan out silently, like a free chain step. **Do not ask** — asking would forward a judgment you were hired to make. (For a *large* read-only sweep, a one-line "fanning this out, N units, read-only" notice is courtesy, not a gate.) |
| **Surface** | expensive + irreversible spend (spawns N agents, burns usage tokens you can't un-spend) | Emit a one-line **costed disposition**: what the fan-out would do + an order-of-magnitude usage-token cost + an explicit veto beat. Then **proceed unless vetoed.** |

This is **not** the forbidden *"want me to run X?"*. The cost line is load-bearing: you are presenting a costed disposition for veto, not forwarding the decision. It is *Resolve, don't float* applied to a spend — recommend with ownership and a price, never hand over a bare option.

## Why this reconciles "never ask"

The standing rule is *never forward a decision the agent was hired to make* ("filter, don't ask"). The review chain fires on shape and runs **without** asking because it's free + reversible — there's no cost to weigh, so asking could only be the forbidden forwarding. Fan-out differs on exactly one axis: it has **real marginal cost** and is **weakly reversible** (you can't un-spend the tokens). When an action carries non-recoverable cost, the responsible form of *not*-forwarding-judgment is to **state the cost and leave a veto beat** — spending the operator's budget blind is itself a failure of the filter. The agent has already made the judgment (the test passed; this *is* worth doing); it surfaces a **spend** for authorization, the way a CFO doesn't ask "should we do marketing?" but does flag "this commits $X." Grounded in Principles #9 (token economics), #17 (asymmetric attention), #18 (cost collapses) and the positions *User = Director* + *Clarity Over Gates*.

## Independence is the trap

The one realistic *costly* false positive is mis-counting independence: N files that look parallel but share a cross-dependency, so the "crisp per-unit contract" was a mirage and the fan-out burns tokens on wrong work. When independence is uncertain, **canary one unit first** (read-only) and confirm the units are truly independent before fanning out the rest.

## Graceful absence

On a host with no multi-agent / fan-out primitive, this heuristic is **inert** — serial execution is the fallback and nothing breaks. The rule sharpens a host that *has* fan-out; it never requires one.

## Background leverage

The same primitive a scheduled / recurring agent runs on makes **background** fan-out especially high-leverage for a step-away operator: big read-only sweeps and mechanical transforms run while you're away, and you review the compact output. Fan-out also protects your main context — the agents hold the reading; you get the conclusion, not the N files.
