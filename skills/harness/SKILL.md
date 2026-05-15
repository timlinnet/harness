---
name: Harness
description: Automatically apply when making architectural, product, business, agent, or team decisions in any project. Loads first principles from the Harness canonical and runs the questioning framework before implementation. Cross-project, project-agnostic. Triggers on decision language ("should we build X", "let's add Y", "do we need Z", "A or B?"), architecture-shaped work, or product/business choices.
---

# Harness — First Principles Decision Gate

This skill fires **automatically** during any work that involves a meaningful choice — architecture, UX, agent behavior, product features, business positioning, team decisions, personal operating mode.

> **Key mindset shift**: Don't wait to be invoked. If you're at an "A or B?" moment, apply the framework. If a prior decision is documented in the project or in `~/Documents/GitHub/harness/decisions/`, follow it unless explicit user agreement to change.

## Run as designed (the default)

**Run the framework on every decision-shaped request. Show the work in the output.** The framework already calibrates its own readability — the Five Questions are short, the Architecture Lenses ask you to pick the few that apply (not dump all ten), the Decision Template names principles by number rather than re-deriving them. Trust the skill to be readable; don't pre-emptively strip the reasoning trail.

**Active challenge is the practice that keeps the framework alive.** When the user can see which principles were applied and which alternatives were considered, they can push back on weighting, catch missed Strategic Positions, refine the framework itself. **Silence is the failure mode** — the framework's job is to BE VISIBLE.

**Two failure modes, both bad:**

- ❌ **"Want me to run harness first?"** — forwarding the decision back. The decision to run is yours; the user hired you to filter, not to ask permission to think.
- ❌ **Silent skip from inattention** — reading a multi-requirement feature ask and jumping straight to code. If the request has 2+ constraints/forward-compat needs/anti-abuse requirements, the checklist is mandatory.

**Auto mode is COMPATIBLE.** Auto means execute decisively on routine calls; it does not override product/architecture diagnostics. Run the framework, show the work, then act.

**Distraction signal (contextual collapse, not default):** if the user explicitly signals overwhelm in the moment ("too much text right now," "give me one line," rapid context-switching) → collapse to terse conclusion for that thread, then resume the visible framework on the next decision. The pendulum is contextual; it doesn't stay at "hidden default."

Adopters may extend with project-specific calibration (escalation thresholds, custom phrasing) via CLAUDE.md or memory files; this canonical sets the framework default.

## What Harness is

Harness is the canonical first-principles framework for designing systems in the AI age. It lives at `~/Documents/GitHub/harness/` (repo: `timlinnet/harness`). It is cross-project — applied across the framework owner's projects and any future work.

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

## Step 1: Bring the Postures (operative directives)

Before loading principles or running the questioning framework, bring these five postures to the decision. They're not facts about the world — they're stances you carry into the moment of decision. Each is the *shape of thinking* you bring before you know which principle applies.

Postures shape *what you reach for*; the five questions (Step 3) shape *what you choose*. They complement, they don't duplicate.

**1. Decompose every bundle. Reason in atoms.**
The world ships you composites — SaaS products, "the way it's done," inherited categories. The atom is what each component physically costs to build, run, and operate. Decompose before deciding. *(Operative version of Principle #6.)*

**2. Doubt the inherited boundary.**
"This is what a CRM is." "This is how marketing works." "This is the standard architecture." Inherited boundaries are conventions, not laws. Surface them, name them, test whether they bind.

**3. Make the requirement less dumb — especially your own.**
Most "requirements" carry someone's stale assumption. Including the ones you wrote yesterday. Question every requirement before accepting it. The smart-person-said-it bias is real.

**4. Start from atoms and dollars, not analogy.**
"It's like X but cheaper" is downstream reasoning. Upstream: what does it physically cost in time, energy, capability, dollars? Analogies hide assumptions; atoms expose them.

**5. The default move is sharpen or delete, not add.**
When you reach for "add a section / add a flag / add a step" — first try "sharpen what exists" or "delete the friction entirely." Adding is the obvious move; subtraction is usually correct. (When structure is wrong, replacement is right — but that's still subtractive: rewrite, don't accrete.)

These fire FIRST. Loading principles (Step 2) and the questioning framework (Step 3) come after.

## Step 2: Load relevant principles (progressive disclosure)

Read `~/Documents/GitHub/harness/FIRST_PRINCIPLES.md` — but do not bulk-load all 18 principles every time. Per Principle #1 (Context is finite and ordered) and #13 (Self-discovery is progressive disclosure for capabilities): retrieve only the layers and entries relevant to the current decision.

**Heuristic for what to load**:
- Decisions about architecture / agents / data → First Principles + relevant Strategic Positions
- Decisions about product / users / market → Strategic Positions + Heuristics
- Decisions about implementation details → Tactics + the underlying principle each tactic descends from

## Step 3: Apply the Questioning Framework

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

## Step 4: Check project context

Harness is cross-project. After applying it, check the project-level `.agent/AGENT.md` or `CLAUDE.md` for project-specific overrides (e.g., per-project Strategic Posture, vertical specifics, ICPs, business context). Project context **refines** Harness; it does not override principles.

## Step 5: Output using the Decision Template

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

## Step 6: Surface a Parallel Launchpad (if a qualifying candidate exists)

After producing the Decision Template (or any deep response), scan for a candidate to surface in a top-of-response **Parallel Launchpad**: a paste-ready prompt the operator can drop into a fresh Claude Code session to launch deterministic work while they continue reading this thread.

**The principle**: *wisdom is the limited resource; everything else parallelizes.* (Principles #15 + #17.) Operator read/decide time is the binding constraint on throughput. Every read-window that does not also produce parallel work-in-flight is leverage left on the table.

### Three candidate pools (scan all three)

1. **In-thread** — chunks where a decision just got made and the build is ready
2. **Adjacent** — topics referenced or implied in this conversation that have ready next steps
3. **Portfolio** — items at `← YOU ARE HERE` in any project's `OPEN_LOOPS.md` where the next step is build-shaped and self-contained (SessionStart hooks typically prefetch these)

Pick the single highest-leverage candidate that passes all gates. (Rarely two, only if non-conflicting and the operator has clearly indicated big-batch mode.)

### Gates (ALL must pass to include a Launchpad)

1. **Decided, not pending** — the chunk does not depend on a question still open in this thread.
2. **Self-contained** — the prompt can act *cold* with no memory of this conversation: project, working directory, file paths, what's been done, what success looks like.
3. **Worth the paste friction** — agent work would take >5 min. Below that, inline action is faster.
4. **Non-conflicting** — won't race with work the operator is about to start in this thread. Worktree isolation or different-files mitigates; flag explicitly when relevant.
5. **Launchable as-is** — no further operator input needed beyond pasting, or any required input is spelled out as `[FILL IN: ...]`.

### Calibration: false-positive bias

When uncertain whether a candidate qualifies, **include** rather than omit. The operator can ignore an unusable launchpad in seconds; a missed parallel launch costs an entire wisdom-window. (Decision: `CHANGELOG.md` v11.)

The bias governs *ambiguous cases*, not the gates themselves. A candidate that fails a gate is omitted, not surfaced as "low confidence."

### Format

```
⚡ Parallel Launchpad — [one-line title]
Source: [in-thread / adjacent / portfolio: <loop name>]
Estimated agent time: ~Xmin. Safe to run in parallel because [reason].

----- PASTE-READY PROMPT -----
[Self-contained block: project, working directory, context, what to do, success criteria, where to commit/report]
-----------------------------
```

If no candidate passes all gates → **omit the section entirely**. Do not manufacture launchpads. Silence is correct when nothing qualifies.

### When NOT to fire

- The operator's response IS the build (you're doing the inline work — no parallel pool-1 candidate exists)
- The conversation is mid-decision (a would-be launchpad depends on a still-open question)
- The candidate races with imminent thread work
- No qualifying candidate in any pool

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
