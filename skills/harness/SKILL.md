---
name: Harness
description: Automatically apply when making architectural, product, business, agent, or team decisions in any project. Loads first principles from the Harness canonical and runs the questioning framework before implementation. Cross-project, project-agnostic. Triggers on decision language ("should we build X", "let's add Y", "do we need Z", "A or B?"), architecture-shaped work, or product/business choices.
---

# Harness — First Principles Decision Gate

This skill fires **automatically** during any work that involves a meaningful choice — architecture, UX, agent behavior, product features, business positioning, team decisions, personal operating mode.

> **Key mindset shift**: Don't wait to be invoked. If you're at an "A or B?" moment, apply the framework. If a prior decision is documented in the project or in `~/Documents/GitHub/harness/decisions/`, follow it unless explicit user agreement to change.

## Silent mode is the default (read this first)

**Run the framework as a silent mental checklist on every feature/decision-shaped request, before writing code or migrations. Surface only what's substantive.** Three valid outcomes:

1. **Silent → terse surface** (default): run the questioning framework + architecture lenses internally; output 3-5 lines: framing + key insight + recommendation. Then proceed.
2. **Silent → no surface needed**: when the framework produces nothing non-obvious (cosmetic fix, copy change, obviously-right refactor), proceed without mentioning it.
3. **Explicit invocation by user** (`/harness`, "run harness", "pressure-test this"): output the full Decision Template below. Invocation is consent for depth.

**Two failure modes, both bad:**

- ❌ **"Want me to run harness first?"** — forwarding the decision back. The decision to run is yours; the user hired you to filter, not to ask permission to think.
- ❌ **Silent skip from inattention** — reading a multi-requirement feature ask and jumping straight to code. If the request has 2+ constraints/forward-compat needs/anti-abuse requirements, the checklist is mandatory.

**Auto mode is COMPATIBLE with silent mode.** Auto means execute decisively on routine calls; it does not override product/architecture diagnostics. Run silently, surface the takeaway, then act.

Adopters may extend with project-specific calibration (escalation thresholds, custom phrasing) via CLAUDE.md or memory files; this canonical sets the framework default.

## What Harness is

Harness is the canonical first-principles framework for designing systems in the AI age. It lives at `~/Documents/GitHub/harness/` (repo: `timlinnet/harness`). It is cross-project — used by FreedomOS, PCAI, Linnet Labs, and any future work.

Four layers, each changing at a different rate:

1. **🪨 First Principles** — irreducible truths about LLMs / agents / users / builders. Change rarely.
2. **🎯 Strategic Positions** — bets that follow from principles + business context. Re-examined when the world signals.
3. **📐 Heuristics** — rules of thumb. Tested against outcomes.
4. **🔧 Tactics** — implementation choices. Refactored constantly.

## When this triggers automatically

- Working on agent behavior, skills, memory, autonomy, or tool execution
- Modifying chat or execution pipelines
- Making UX decisions for any frontend
- Adding new features or capabilities
- Designing data models or API patterns
- Picking between integration vs build, build vs buy, native vs wrapper
- Choosing where infrastructure lives (location decisions like the one that produced Harness itself)
- Any work where you face a "should I do A or B?" choice — including non-engineering decisions (business, marketing, team)

## Step 1: Load relevant principles (progressive disclosure)

Read `~/Documents/GitHub/harness/FIRST_PRINCIPLES.md` — but do not bulk-load all 18 principles every time. Per Principle #1 (Context is finite and ordered) and #13 (Self-discovery is progressive disclosure for capabilities): retrieve only the layers and entries relevant to the current decision.

**Heuristic for what to load**:
- Decisions about architecture / agents / data → First Principles + relevant Strategic Positions
- Decisions about product / users / market → Strategic Positions + Heuristics
- Decisions about implementation details → Tactics + the underlying principle each tactic descends from

## Step 2: Apply the Questioning Framework

**The Five Questions** (delete is the strongest lever):

1. Is this important? Or a distraction dressed as opportunity?
2. Can we delete it? If yes, do.
3. If not, can we simplify? Minimum that delivers the value?
4. Can we accelerate? Same result in less time?
5. Can we automate? Same result without us?

**The Architecture Lenses** — for decisions touching the bridge:

- Does this deepen the moat (focused-ICP context + trust)?
- Does this ride a primitive that's improving (capability + cost), or compete with it?
- Is it dynamic-by-user, or static?
- Does it close a loop, or open a new one — and is closure the right metric for this goal?
- Does it honor complementary strengths (use the right intelligence type for the work)?
- Does it preserve human attention for what matters (Principle #17)?
- Is the spec clear enough to be a real spec (Principle #16)?
- Are wisdom and intelligence in the right places (wisdom directing, intelligence executing)?
- Is shipping/distribution part of this plan, not after?
- Is the structure right — or is a rewrite cheaper than incremental refactor? *(Watch for sunk-cost dressed up as Kaizen.)*

## Step 3: Check project context

Harness is cross-project. After applying it, check the project-level `.agent/AGENT.md` or `CLAUDE.md` for project-specific overrides (e.g., FreedomOS Strategic Posture, PCAI specifics, ICPs, business context). Project context **refines** Harness; it does not override principles.

## Step 4: Output using the Decision Template

```
## Options
A) [option]
B) [option]

## Principles Engaged
- Principle/Position X applies because [reasoning]
- Tradeoff Y at stake because [reasoning]
- Alternative bets not taken: [list]

## Recommendation
[Option] because [reasoning derived from the layers above]
```

For decisions that are genuinely cross-cutting (not project-specific), suggest documenting in `~/Documents/GitHub/harness/decisions/` as a numbered entry — these get committed and become part of the framework's history.

## Loop maintenance (update OPEN_LOOPS.md as work completes)

When a decision applied via this skill **completes a chain item** in an active loop in the project's `OPEN_LOOPS.md`, update that entry:

- Mark the completed step `✅`
- Move the `← YOU ARE HERE` marker to the next pending step
- Update `Last touched:` with today's date
- If the completion advances the Compound Test score, update that
- Sign the edit `<!-- claude-{operator} YYYY-MM-DD -->` (the operator's first name lowercased — matches git identity routing)

This keeps OPEN_LOOPS.md as the live source of truth instead of decaying. The SessionStart hook surfaces YOU ARE HERE markers; this directive keeps those markers accurate.

If a decision opens a *new* loop (a non-trivial chain of work), propose adding a new entry to OPEN_LOOPS.md before exiting. Don't auto-create — surface the candidate so the operator agrees it's a real loop.

## Distribution sync (keep public harness aligned with local skill changes)

User-level skill files in `~/.claude/skills/` are **working copies**. The same skills published in `timlinnet/harness/skills/` are the **distributable copies** that adopters get via `./install.sh`. They don't auto-sync.

**When you make a substantive change to a user-level skill** (cherry-pick from upstream gstack, add/refine a HARNESS INTEGRATION marker, sharpen a prompt, add a new section) — also copy it to `~/Documents/GitHub/harness/skills/{skill}/SKILL.md` and commit to the public harness repo with a CHANGELOG entry (v{N+1}).

The skills to keep in sync:
- `harness` itself (this file)
- `ceo-plan-review`
- `engineering-review`
- `office-hours`
- `autoplan`

**Trigger this sync directive when you see**: "applying cherry-pick from gstack", "adding/refining HARNESS INTEGRATION", "sharpening prompt language", "v{N} of harness".

**Skip sync for**: typo fixes, personal preferences specific to Tim's setup, experiments not yet proven. Adopter-facing changes only.

## Epistemic stance

Hold the framework as a working hypothesis, not doctrine:

- **Humility** — every entry can be wrong, especially the bets, possibly the principles.
- **Active challenge** — bring the framework to every decision, *and* bring every decision back to the framework. If it keeps producing answers that feel wrong, it is wrong.
- **Comfort with named bets** — Strategic Positions are explicitly contingent. The failure mode is dressing a bet as a principle (rigidity).
- **Sunk-cost vigilance** — when structure is wrong, rewrite is the cheapest improvement. Kaizen ≠ preservation.

## When Harness is not enough

If you encounter a decision where Harness produces no clear answer, or where the principles seem to contradict each other:

1. Name the contradiction explicitly to the user.
2. Surface which Strategic Positions are in tension.
3. Propose a refinement to the framework itself (a new principle, a sharpened position, a removed heuristic) — these go into the next CHANGELOG entry after Tim approves.

Active challenge is the practice that keeps the framework alive. Silence is the failure mode.
