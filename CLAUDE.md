# Claude Code — Harness

You are Claude Code working inside the `harness` repo — the public first-principles framework for building in the AI age (`github.com/timlinnet/harness`).

This file orients you when working **on Harness itself**. If you're working in another project that *uses* Harness, see that project's own `CLAUDE.md`.

## What this repo is

Harness is the wiring layer between user context (the moat) and AI primitives (the LLMs). Public base, designed to be cloned and used by anyone — founders, operators, agent builders. It ships:

- `FIRST_PRINCIPLES.md` — the canonical: 18 principles, 13 strategic positions, the Questioning Framework, the Canyon Model, the Decision Template, the Epistemic Stance.
- `skills/` — 5 portable Claude Code skills (`harness`, `ceo-plan-review`, `engineering-review`, `office-hours`, `autoplan`). Installed globally via `install.sh`.
- `decisions/` — public/private architecture pattern + sanitized teaching examples. Real worked decisions live in a private companion overlay.
- `CHANGELOG.md` — versioned history of structural shifts. The framework is itself a feedback machine (Principle #8).

## Read order on session start

1. **This file** — orientation.
2. **`FIRST_PRINCIPLES.md`** — the substrate. Every change to Harness must pass through these principles. The `harness` skill at `.claude/skills/harness/` auto-fires on decision-shaped work — don't wait to be invoked.
3. **`CHANGELOG.md`** — see what shipped recently and why. Each version entry names the *catalyst* (what surfaced the change). Honor the same pattern when adding entries.
4. **`README.md`** — the public face. What external adopters see first.
5. **`decisions/README.md`** — the public/private architecture pattern. Anything Tim-specific belongs in the private overlay, not here.

## Dogfooding — skills auto-load here

`.claude/skills/` symlinks all 5 published skills back into the repo so Claude Code working on Harness auto-discovers them. The harness skill fires on Harness's own meta-decisions. Eating our own cooking is the falsifiability test for the framework — if the skills don't help us improve Harness, they don't help anyone.

## How to change Harness

Every meaningful change is a decision. Run it through the framework before writing.

- **New principle or strategic position** — pass the Questioning Framework (`FIRST_PRINCIPLES.md` → "The Questioning Framework"). If a candidate principle survives, write a CHANGELOG entry naming the catalyst.
- **New skill or skill change** — challenge with `ceo-plan-review` (is this the 10x version?) and `engineering-review` (will it work for someone who isn't Tim?). Skills must work for external adopters, not just here.
- **Heuristic added or refined** — usually surfaced from real use. Note the originating retro in the CHANGELOG entry (see v4 for the pattern).
- **Architecture shifts** — public/private boundary changes, install pattern changes, etc. — these are Harness-shaped decisions and earn a worked decision in `decisions/` (sanitized for public).

## Public vs private — what stays here

This repo is public. Anything committed ships to anyone who clones.

**Belongs here**: the framework, the skills, the install tooling, sanitized teaching decisions, generic guidance.
**Does NOT belong here**: specific business context, customer names, internal metrics, project-specific worked decisions, credentials, private repo paths.

If a fact is only useful to one person or one business, it goes in their private overlay — not here.

## Versioning

Semantic-ish, monotonically-increasing single integer (`v1`, `v2`, …). CHANGELOG entries are the source of truth. Bump on structural change, not every typo.

## Before pushing — enable the pre-push security scan

On a fresh clone, activate the hook once:

```bash
git config core.hooksPath .githooks
```

It scans the outgoing diff for secrets, internal infra refs, private names, and money figures (`scripts/security-scan.sh`). Push is blocked with line-by-line hits if anything trips. Override (rare): `HARNESS_SECURITY_SKIP=1 git push`. Edit the `PATTERNS` array in the scanner to extend coverage as new categories appear.

## Tone

Terse. Direct. No filler. The framework rewards clarity — the docs should model it.
