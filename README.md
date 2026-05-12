# Harness

> First principles for the AI age — a framework for builders, founders, and pioneers making decisions in an era where intelligence is cheap, capability is expanding faster than we can map, and wisdom remains scarce.

Harness is the wiring layer between user context (the moat) and AI primitives (the LLMs). It's where decisions are made — not as ad-hoc judgments, but as principled bets backed by physics, economics, and observed dynamics.

## Quick start

```bash
git clone https://github.com/timlinnet/harness.git ~/Documents/GitHub/harness
cd ~/Documents/GitHub/harness
./install.sh
```

That installs Harness as a substrate in your Claude Code environment — the portable `harness` skill (auto-fires on architectural / product / business decisions) and four adapted gstack skills (`ceo-plan-review`, `engineering-review`, `office-hours`, `autoplan`) with HARNESS INTEGRATION markers wired in.

See [INSTALL.md](INSTALL.md) for detail, SessionStart hook setup, and private-overlay pattern.

## What's inside

```
harness/
├── FIRST_PRINCIPLES.md          ← the canonical doc
├── CHANGELOG.md                  ← version history
├── INSTALL.md                    ← detailed setup
├── install.sh                    ← one-command setup
├── skills/
│   ├── harness/SKILL.md          ← portable trigger skill (auto-fires on decisions)
│   └── gstack-adapted/           ← lean adaptations of Garry Tan's gstack
│       ├── ceo-plan-review/SKILL.md
│       ├── engineering-review/SKILL.md
│       ├── office-hours/SKILL.md
│       └── autoplan/SKILL.md
└── decisions/
    ├── README.md                  ← the public/private architecture pattern
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

- **Public base** — this repo. Universal framework + adapted gstack skills + install tooling. **Free for anyone.**
- **Private overlay** — your specific worked decisions, project-specific context layers, business context. **Stays yours.**

The portable `harness` skill loads principles from the public canonical and surfaces decisions from your private overlay when relevant.

For Tim's specific overlay (and the framework's author's own worked decisions), access is gated. For your own use, see [INSTALL.md](INSTALL.md) → "Optional: set up your own private overlay."

## Why "Harness"

The metaphor that runs through the work: a canyon with user context on one ledge, AI primitives on the other, and the wiring harness between them — the structure that decides how user context meets AI capability. The harness is what we build. The principles in this repo are what guide its shape.

## Using Harness in a project

Add to your project's `CLAUDE.md` or `.agent/AGENT.md`:

```markdown
## Read order on session start

1. This file — orientation
2. `~/Documents/GitHub/harness/FIRST_PRINCIPLES.md` — the north star.
   When you're at a design fork, Harness is the tiebreaker.
3. [your project-specific docs]
```

The portable `harness` skill auto-fires on decision language ("should we build X", "let's add Y", "A or B?", "do we need Z?") and loads the relevant principles via progressive disclosure.

## Background

- **Tim Linnet** wrote this. The principles are distilled from research, conversations, lived experience operating multiple companies (FreedomOS, Conduit/PCAI, Linnet Biopharm, others), and active practice.
- **gstack** ([Garry Tan's open-source skill suite](https://github.com/garrytan/gstack), MIT licensed) provides the cognitive patterns and process scaffolding. The adapted versions in `skills/gstack-adapted/` are lean Tim-adaptations with HARNESS INTEGRATION markers added. The full unmodified gstack is more elaborate; you may want it for reference or to pull future upstream updates.
- **The Decision Template** in `FIRST_PRINCIPLES.md` → "The Questioning Framework" is the canonical shape for capturing a non-trivial decision. Examples in `decisions/examples/`.

## Status

v4 (2026-05-12) — public release. The framework is itself a feedback machine; expect refinements as the world gives signal. Each Strategic Position carries a *"could be wrong if..."* condition and a map of alternative bets not taken.

## Author

Tim Linnet — [timlinnet.com](https://timlinnet.com)

## License

To be finalized. Likely **MIT** for `skills/gstack-adapted/` (required by MIT propagation from upstream gstack), and **CC-BY-SA** for `FIRST_PRINCIPLES.md` and other principles content (attribution + share-alike for derivative frameworks).

Until LICENSE finalized: content is shared in good faith for adopters to use and adapt. Attribution to `github.com/timlinnet/harness` requested. Don't commercially repackage without contacting Tim.
