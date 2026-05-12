# 0003 — Auto-research loop for Harness

**Date**: 2026-05-12
**Status**: Designed; deferred build
**Decided by**: Tim Linnet
**Audience**: Tim, Lonnie, future operator or agent that implements this

## The reframe (the thing this decision exists for)

Manual cherry-picking from gstack is not the goal. The goal is an **auto-research loop** that produces Harness improvement proposals continuously, the same way Tim benefits from LLM improvements automatically. He doesn't update Opus 4.7 — Anthropic ships it and his work benefits. The auto-research loop should do the same for Harness: external signals (gstack updates, FreedomOS Ideas, Tim's reading, Lonnie's experience) flow in → improvement proposals come out → Tim approves → integrated.

This is **not** "do more cherry-picks." This is **build the system that proposes cherry-picks (and other refinements) so Tim doesn't have to.**

Without this loop, the framework decays in two ways:
1. Tim has to remember to sync with gstack, which he won't do reliably.
2. Insights from his Ideas tab and reading stay scattered, never folded into the canonical.

## Architecture

Three layers: inputs → synthesis → output.

### Inputs

1. **gstack changelog + git log** (every N days, fetch `garrytan/gstack` upstream, diff against last-sync marker, filter for substantive changes — skip scaffolding/test-only commits)
2. **FreedomOS Ideas tab** (Supabase MCP query — `ideas` table, filtered for new/unprocessed since last run, weighted toward architecture/principle-flavored entries)
3. **Tim's bookmarks/reading** (future: X.com bookmarks, papers added to a known location, Notion clippings — TBD where these live)
4. **Lonnie's flagged learnings** (future: a `learnings.md` in his FOCUS area where he can drop "this surprised me" notes)

### Synthesis

A skill or scheduled agent that, on each run:

1. Reads current `FIRST_PRINCIPLES.md` to load the current framework state.
2. Reads each input source for new content since last run.
3. For each candidate input, runs it through the Harness lens:
   - Does this challenge an existing principle? (could promote to refinement)
   - Does this fill a gap? (candidate new principle/position)
   - Is this a duplicate of an existing principle? (skip)
   - Is this gstack-runtime-specific? (skip — not portable)
   - Is this content-level / portable? (candidate cherry-pick)
4. Classifies each: **strong proposal**, **weak proposal**, **for-reading-only**, **skip**.
5. Generates a proposal doc.

### Output

A timestamped proposal at `harness/proposals/YYYY-MM-DD-research-loop.md`:

```markdown
# Harness improvement proposals — YYYY-MM-DD

## Strong proposals (recommend Tim approve)
1. [name] — Source: [gstack v1.X / Ideas tab / etc.]
   - Why it matters: [reasoning derived from Harness lens]
   - Where it goes: [specific section of FIRST_PRINCIPLES.md or specific skill]
   - Proposed text: [the actual addition/refinement]

## Weak proposals (Tim should look but not necessarily pull)
[same shape, lower confidence]

## For reading only (signal without action)
[summaries of inputs that don't justify a framework change]

## Skipped (with reason)
[inputs filtered out and why]
```

Tim reviews. For each strong proposal, he either:
- **Accept** — agent commits the change to harness repo
- **Modify** — agent applies the modified version
- **Reject** — proposal marked rejected; reason captured for the next run's signal-vs-noise calibration

### Cadence

- **Weekly** for steady-state. Sundays maybe.
- **On-demand trigger**: Tim or Lonnie can invoke "run harness research now" if they encounter a specific question.

## Why this matters more than manual cherry-picks

- **Compounds without Tim's attention** (Principle #17 — preserves human attention for what matters).
- **Survives Tim's completion anxiety** — the system runs whether Tim is shipping Conduit or not.
- **Symmetric with how Tim benefits from LLM improvements** — Anthropic ships, Tim benefits passively. Auto-research ships, Tim benefits passively (with an approval gate).
- **Auditable** — every proposal lives in the harness repo with reasoning. Lonnie can see why decisions were made.
- **Self-improving** — rejection signal teaches the synthesis prompt over time. The system gets better at filtering signal from noise.

## Why we're not building it today

Per the framework itself (applied to itself):
- Conduit launch is the active closure metric (Match Closure Metric to Goal).
- This loop is meaningful infrastructure, not a 30-minute task.
- Building it now extends the "perfect infrastructure before shipping" pattern that Strategic Position #13 (Marketing is Part of the Product) explicitly names as a failure mode.
- Patience over code: the loop can be built lighter and faster once Tim has shipped *anything* end-to-end with Harness in production use.

## What to do in the meantime (lightweight version)

Until the full scheduled loop exists, do this:

1. **Manual quarterly sync** — every 2-3 months, Tim or Lonnie spends an afternoon running the synthesis manually: pull gstack changelog, scan Ideas tab, write a proposal doc, decide what to integrate. Decision 0002 (gstack sync, May 2026) is the template.
2. **On-friction cherry-picks** — when a specific gstack skill produces a worse outcome than expected, *that's* the friction signal that justifies pulling the relevant fix. Don't pull preemptively.
3. **Ideas tab tagging** — when capturing in FreedomOS Ideas, add tag `harness-candidate` to entries that might inform the framework. Makes the manual sync faster, and pre-builds the data the auto loop will use.

## Falsifiability — when to actually build this

Build the full auto-loop when at least two of these are true:

- Conduit is shipped and has paying users (closure metric satisfied for the primary goal).
- Tim has missed a quarterly manual sync (proves the manual cadence isn't holding).
- Lonnie is asking "what should I be pulling from gstack?" (the system has a real user beyond Tim).
- A specific gstack release has multiple high-value items that get manually deferred (proves the volume justifies automation).

## Implementation sketch (when ready)

- **Scheduled task** via the `schedule` skill, weekly cadence.
- **Agent definition** with tool access: `gh` (for gstack changelog), `mcp__supabase-freedomos` (for Ideas tab), filesystem (for harness repo + proposal output).
- **Synthesis prompt** lives at `harness/skills/harness-research/SKILL.md` (a future skill).
- **Last-sync marker** in `harness/.last-sync.json` so each run picks up where the last left off.
- **Proposal review UI** — for v1, just markdown in `harness/proposals/`. For v2, could become a FreedomOS table with accept/reject buttons.
- **Approval action** — Tim opens the proposal doc, edits/decides, runs a follow-up skill or manually commits the changes.

## Note on the broader pattern

This loop is one instance of a larger pattern: **build the system that improves itself rather than improving it manually each time.** Same pattern applies to:

- Conduit's marketing/positioning loop (Lonnie + agent vs Tim hand-running it)
- timlinnet.com agent (an agent that maintains the site rather than Tim updating it)
- Lonnie's onboarding (the system that helps him decide vs Tim answering each question)

The pattern is the meta-architecture Tim is building toward across all of his projects. Auto-research for Harness is the smallest, most contained version — good place to prove the pattern.
