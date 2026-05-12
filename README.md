# Harness

> First principles for the AI age — a framework for builders, founders, and pioneers making decisions in an era where intelligence is cheap, capability is expanding faster than we can map, and wisdom remains scarce.

Harness is the wiring layer between user context (the moat) and AI primitives (the LLMs). It's where decisions are made — not as ad-hoc judgments, but as principled bets backed by physics, economics, and observed dynamics.

## Quick start

```bash
git clone https://github.com/timlinnet/harness.git ~/Documents/GitHub/harness
cd ~/Documents/GitHub/harness
./install.sh
```

That's it. You get five skills installed into your Claude Code environment:

- **`harness`** — auto-fires on architectural / product / business decisions; loads the first principles substrate
- **`ceo-plan-review`** — challenge premises, find the 10x version, ICP pressure test before planning
- **`engineering-review`** — pressure-test architecture, map failure modes, generate Mermaid diagrams
- **`office-hours`** — YC-style product diagnostic — name the actual human, find the smallest wedge
- **`autoplan`** — auto-run CEO + Eng review with auto-decisions; surface taste calls at a single approval gate

See [INSTALL.md](INSTALL.md) for SessionStart hook setup and the private-overlay pattern (for your own worked decisions).

## What's inside

```
harness/
├── FIRST_PRINCIPLES.md          ← the canonical doc — 18 principles, 13 strategic positions
├── CHANGELOG.md                  ← version history
├── INSTALL.md                    ← detailed setup
├── install.sh                    ← one-command setup
├── skills/
│   ├── harness/                  ← portable trigger skill
│   ├── ceo-plan-review/
│   ├── engineering-review/
│   ├── office-hours/
│   └── autoplan/
└── decisions/
    ├── README.md                  ← public/private architecture pattern + Decision Template
    └── examples/                  ← sanitized teaching decisions
```

## The framework

[`FIRST_PRINCIPLES.md`](FIRST_PRINCIPLES.md) is sorted by **layer**, because each layer changes at a different rate:

1. **🪨 First Principles** — irreducible truths about LLMs / agents / users / builders. Change rarely.
2. **🎯 Strategic Positions** — bets that follow from principles + business context. Re-examined when the world signals.
3. **📐 Heuristics** — rules of thumb. Tested against outcomes.
4. **🔧 Tactics** — implementation choices. Refactored constantly.

Plus the Canyon Model, the Questioning Framework, the Decision Template, and the Epistemic Stance section that explains how to *hold* the framework (humility, active challenge, comfort with named bets).

## Architecture: public base + private overlay

Harness ships as two layers, composed at runtime:

- **Public base** — this repo. Universal framework + skills + install tooling.
- **Private overlay** — your specific worked decisions, project layers, business context. **Stays yours.**

The `harness` skill loads principles from the public canonical and surfaces decisions from your private overlay (when configured) when relevant.

For your own setup, see [INSTALL.md](INSTALL.md) → "Optional: set up your own private overlay."

## Why "Harness"

The metaphor: a canyon with user context on one ledge, AI primitives on the other, and the wiring harness between them — the structure that decides how user context meets AI capability. The harness is what we build. The principles in this repo are what guide its shape.

## Using Harness in a project

Add to your project's `CLAUDE.md` or `.agent/AGENT.md`:

```markdown
## Read order on session start

1. This file — orientation
2. `~/Documents/GitHub/harness/FIRST_PRINCIPLES.md` — the north star.
   When you're at a design fork, Harness is the tiebreaker.
3. [your project-specific docs]
```

The `harness` skill auto-fires on decision language ("should we build X", "let's add Y", "A or B?", "do we need Z?") and loads the relevant principles via progressive disclosure. The agent role skills (`ceo-plan-review`, etc.) build on top of it.

## Status

v5 (2026-05-12) — public release. The framework is itself a feedback machine; expect refinements as the world gives signal. Each Strategic Position carries a *"could be wrong if..."* condition and a map of alternative bets not taken.

## Author

Tim Linnet — [timlinnet.com](https://timlinnet.com)

## Related

**[FreedomOS](https://getfreedomos.com)** — Tim's SaaS for faith-driven founders running portfolios of side hustles. Productizes the **Context Shell Pattern** (see `FIRST_PRINCIPLES.md` → Strategic Positions): user's business context + Harness substrate + agent execution loop in one place. Harness is the framework Tim thinks with; FreedomOS is where the thinking ships at scale.

## Built on

The four agent role skills (`ceo-plan-review`, `engineering-review`, `office-hours`, `autoplan`) are adaptations of skills from [Garry Tan's `gstack`](https://github.com/garrytan/gstack) (MIT). Source attribution is preserved at the top of each adapted SKILL.md file. The lean Harness versions trade gstack-runtime scaffolding for portability — they run in any Claude Code environment without additional dependencies.

## License

**[MIT](LICENSE)** — free to use, modify, redistribute, commercially or otherwise. Attribution to `github.com/timlinnet/harness` not required by license but appreciated when adapting the framework. Same license as upstream gstack ([Garry Tan, MIT](https://github.com/garrytan/gstack)) — keeps everything compatible.
