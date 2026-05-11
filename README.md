# Harness

> First principles for the AI age — a framework for builders, founders, and pioneers making decisions in an era where intelligence is cheap, capability is expanding faster than we can map, and wisdom remains scarce.

Harness is the wiring layer between user context (the moat) and AI primitives (the LLMs). It's where decisions are made — not as ad-hoc judgments, but as principled bets backed by physics, economics, and observed dynamics.

## What's inside

- **[FIRST_PRINCIPLES.md](FIRST_PRINCIPLES.md)** — the canonical doc. 18 first principles, 13 strategic positions, 4 heuristics, and the questioning framework that gates every decision.

The doc is sorted by **layer**, because each layer changes at a different rate:

1. **🪨 First Principles** — irreducible truths about LLMs / agents / users / builders. Change rarely.
2. **🎯 Strategic Positions** — bets that follow from principles + business context. Re-examined when the world signals.
3. **📐 Heuristics** — rules of thumb. Tested against outcomes.
4. **🔧 Tactics** — implementation choices. Refactored constantly.

## Using Harness in a project

Reference the canonical doc from your project's agent entrypoint:

```markdown
# In your CLAUDE.md or .agent/AGENT.md
For first principles, read ~/Documents/GitHub/harness/FIRST_PRINCIPLES.md
```

Or invoke the `native-first-decision` skill — it loads from the canonical source here.

## Why "Harness"

The metaphor that runs through the work: a canyon with user context on one ledge, AI primitives on the other, and the wiring harness between them — the structure that decides how user context meets AI capability. The harness is what we build. The principles in this repo are what guide its shape.

## Status

v3 (2026-05-11) — active development. The framework is itself a feedback machine; expect refinements as the world gives signal. Each Strategic Position carries a *"could be wrong if..."* condition and a map of alternative bets not taken.

## Author

Tim Linnet — [timlinnet.com](https://timlinnet.com)

## License

All rights reserved (for now). A formal license will be added before the repo goes public.
