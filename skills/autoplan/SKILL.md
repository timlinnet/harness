---
name: Autoplan
description: Auto-review pipeline — reads the CEO Plan Review and Engineering Review skills and runs them sequentially with auto-decisions using 6 decision principles. Surfaces taste decisions at a final approval gate. One command, fully reviewed plan out. Based on Garry Tan's autoplan (gstack, MIT License).
---

# Autoplan — Automated Plan Review Pipeline

> **Source**: Adapted from [garrytan/gstack](https://github.com/garrytan/gstack) `autoplan` (MIT License).
> **Adapted for**: Solo founder on Supabase/Edge Functions.

One command. Rough plan in, fully reviewed plan out.

Autoplan reads the CEO Plan Review and Engineering Review skill files and follows them at full depth — same rigor, same sections, same methodology as running each skill manually. The only difference: intermediate questions are auto-decided using the 6 principles below. Taste decisions (where reasonable people could disagree) are surfaced at a final approval gate.

## When This Triggers

**Use when:**
- The user says "autoplan", "auto review", "run all reviews", "review this plan automatically", "make the decisions for me"
- The user has a plan file and wants the full review gauntlet without answering 15-30 intermediate questions
- Proactively suggest when entering PLANNING mode for non-trivial work where the user wants speed over interactivity

**Skip when:**
- The user explicitly wants interactive review control (→ run CEO Plan Review + Engineering Review separately)
- The plan is trivial (1-2 files, obvious scope) — just build it
- The user says "just do it" or "skip planning"

---

## The 6 Decision Principles

These rules auto-answer every intermediate question:

1. **Choose completeness** — Ship the whole thing. Pick the approach that covers more edge cases. AI-assisted coding compresses implementation 10-100x, so the marginal cost of completeness is near zero.
2. **Boil lakes** — Fix everything in the blast radius (files modified by this plan + direct importers). Auto-approve expansions that are in blast radius AND < 1 day effort (< 5 files, no new infra).
3. **Pragmatic** — If two options fix the same thing, pick the cleaner one. 5 seconds choosing, not 5 minutes.
4. **DRY** — Duplicates existing functionality? Reject. Reuse what exists.
5. **Explicit over clever** — 10-line obvious fix > 200-line abstraction. Pick what a new contributor reads in 30 seconds.
6. **Bias toward action** — Merge > review cycles > stale deliberation. Flag concerns but don't block.

**Conflict resolution (context-dependent tiebreakers):**
- **CEO phase:** P1 (completeness) + P2 (boil lakes) dominate.
- **Eng phase:** P5 (explicit) + P3 (pragmatic) dominate.
- **Design-adjacent decisions:** P5 (explicit) + P1 (completeness) dominate.

---

## Decision Classification

Every auto-decision is classified:

**Mechanical** — one clearly right answer. Auto-decide silently.
Examples: run existing tests (always yes), reduce scope on a complete plan (always no), add observability (always yes).

**Taste** — reasonable people could disagree. Auto-decide with recommendation, but surface at the final gate. Three natural sources:
1. **Close approaches** — top two are both viable with different tradeoffs.
2. **Borderline scope** — in blast radius but 3-5 files, or ambiguous radius.
3. **Architecture style** — two valid patterns exist and the codebase doesn't have a strong precedent.

**User Challenge** — the review reveals the user's stated direction should fundamentally change. This is qualitatively different from taste decisions. When the analysis clearly recommends merging, splitting, adding, or removing features/skills/workflows that the user specified, this is a User Challenge. It is NEVER auto-decided.

User Challenges go to the final approval gate with richer context:
- **What the user said:** (their original direction)
- **What the review recommends:** (the change)
- **Why:** (the reasoning)
- **What context we might be missing:** (explicit acknowledgment of blind spots)
- **If we're wrong, the cost is:** (what happens if the user's original direction was right and we changed it)

The user's original direction is the default. The review must make the case for change, not the other way around.

**Exception:** If the analysis flags the issue as a security vulnerability or feasibility blocker (not a preference), the framing explicitly warns: "⚠️ This is flagged as a security/feasibility risk, not just a preference." The user still decides, but the framing is appropriately urgent.

---

## Sequential Execution — MANDATORY

Phases MUST execute in strict order: **CEO → Eng.**
Each phase MUST complete fully before the next begins.
NEVER run phases in parallel — each builds on the previous.

Between each phase, emit a phase-transition summary and verify that all required outputs from the prior phase are written before starting the next.

**Design Review:** Autoplan runs CEO + Eng automatically. If the plan has UI scope, recommend running `Design Audit` after building — design review is visual and benefits from seeing the real implementation, not just the plan text.

---

## What "Auto-Decide" Means

Auto-decide replaces the USER's judgment with the 6 principles. It does NOT replace the ANALYSIS. Every section in the loaded skill files must still be executed at the same depth as the interactive version. The only thing that changes is who answers the question: you do, using the 6 principles, instead of the user.

**Two exceptions — never auto-decided:**
1. **Premises (Phase 1)** — require human judgment about what problem to solve.
2. **User Challenges** — when analysis clearly shows the user's stated direction should change. The user always has context we lack.

**You MUST still:**
- READ the actual code, diffs, and files each section references
- PRODUCE every output the section requires (diagrams, tables, registries, artifacts)
- IDENTIFY every issue the section is designed to catch
- DECIDE each issue using the 6 principles (instead of asking the user)
- LOG each decision in the audit trail
- WRITE all required artifacts to disk

**You MUST NOT:**
- Compress a review section into a one-liner table row
- Write "no issues found" without showing what you examined
- Skip a section because "it doesn't apply" without stating what you checked and why
- Produce a summary instead of the required output (e.g., "architecture looks good" instead of the mermaid diagram the section requires)

"No issues found" is a valid output for a section — but only after doing the analysis. State what you examined and why nothing was flagged (1-2 sentences minimum).
"Skipped" is never valid.

---

## Phase 0: Setup

### Step 1: Read Context

- Read the plan file (current `implementation_plan.md` or equivalent)
- Read any relevant architecture docs from `.agent/architecture/`
- Run `git log --oneline -15` and `git diff --stat` to understand recent context
- Check for existing test plans in `.agent/test-plans/`
- Detect UI scope: grep the plan for view/rendering terms (component, screen, form, button, modal, layout, dashboard, sidebar, nav, dialog). Require 2+ matches.

### Step 2: Load Skill Files

Read each skill file from disk using the view_file tool:
- `CEO Plan Review` — always
- `Engineering Review` — always

**Section skip list — when following a loaded skill file, SKIP these sections (they are already handled by autoplan):**
- "When This Triggers" (already triggered)
- "Structured Question Format" (autoplan auto-decides)
- "Review Readiness Dashboard" (handled by autoplan completion)
- "Next Step in the Build Chain" (handled by autoplan gate)

Follow ONLY the review-specific methodology, sections, and required outputs.

Output: "Here's what I'm working with: [plan summary]. UI scope: [yes/no]. Starting full review pipeline with auto-decisions."

### Step 3: Load Harness Principles
<!-- HARNESS INTEGRATION START -->

Read `~/GitHub/harness/FIRST_PRINCIPLES.md` to load the principles substrate:
- **18 First Principles** (bedrock — derived from physics, economics, observed dynamics)
- **13 Strategic Positions** (bets, each with "could be wrong if..." conditions and alternative bets)
- **The Architecture Lenses** from the Questioning Framework

This is the substrate for every auto-decision below. The 6 autoplan decision-resolution principles (Choose completeness, Boil lakes, Pragmatic, DRY, Explicit over clever, Bias toward action) are **tiebreakers WITHIN this substrate**, not replacements for it.

**Conflict rule**: if the 6 autoplan principles point in a direction that violates a Harness principle or strategic position, the Harness layer wins — flag it as a **User Challenge** (per the classification in this skill) rather than auto-deciding. The user's stated direction defaults to "stand" until explicitly changed; Harness principle violations require explicit user override.
<!-- HARNESS INTEGRATION END -->

---

## Phase 1: CEO Plan Review

Follow the `CEO Plan Review skill` — all sections, full depth.
Override: every user decision → auto-decide using the 6 principles.

**Override rules:**
- **Mode selection:** SELECTIVE EXPANSION (default for autoplan)
- **Premises:** Accept reasonable ones (P6), challenge only clearly wrong ones
- **GATE: Present premises to user for confirmation** — this is the ONE question that is NOT auto-decided. Premises require human judgment.
- **Alternatives:** Pick highest completeness (P1). If tied, pick simplest (P5). If top 2 are close → mark **TASTE DECISION**.
- **Scope expansion:** In blast radius + <1d effort → approve (P2). Outside → defer to TODOS.md (P3). Duplicates → reject (P4). Borderline (3-5 files) → mark **TASTE DECISION**.
- **All review sections:** Run fully, auto-decide each issue, log every decision.

**Required outputs from Phase 1:**
- Premise challenge with specific premises named and evaluated
- "NOT in scope" section with deferred items and rationale
- "What already exists" section mapping sub-problems to existing code
- Dream state delta (where this plan leaves us vs 12-month ideal)
- All review sections with findings (or "examined X, nothing flagged")
- Completion Summary (the full summary table from the CEO skill)
- Lake Score

**PHASE 1 COMPLETE.** Emit phase-transition summary:
> **Phase 1 (CEO) complete.** [N] decisions auto-made. [M] taste decisions surfaced.
> [K] scope expansions approved/deferred. Passing to Phase 2.

Do NOT begin Phase 2 until all Phase 1 outputs are written to the plan file and the premise gate has been passed.

---

## Phase 2: Engineering Review

Follow the `Engineering Review skill` — all sections, full depth.
Override: every user decision → auto-decide using the 6 principles.

**Override rules:**
- **Scope challenge:** Never reduce scope on a complete plan (P2)
- **Architecture choices:** Explicit over clever (P5). If two valid patterns exist → mark **TASTE DECISION**.
- **Test coverage:** Always choose the approach with more coverage (P1). Generate test plan artifact.
- **Parallelization strategy:** Analyze and produce (P3 — pragmatic lane assignment)
- **TODOS.md:** Collect all deferred scope expansions from Phase 1, auto-write

**Required outputs from Phase 2:**
- Scope challenge with actual code analysis
- Architecture mermaid diagram
- Data flow analysis (4 paths per flow)
- State machines for stateful objects
- Failure mode catalog
- Boundary analysis
- Test matrix + test plan artifact written to `.agent/test-plans/`
- Parallelization strategy
- Deployment plan
- Cross-pipeline check
- Quality Gate checklist
- Lake Score
- Completion Summary

---

## Decision Audit Trail

After each auto-decision, append a row to the plan file:

```markdown
<!-- AUTONOMOUS DECISION LOG -->
## Decision Audit Trail

| # | Phase | Decision | Classification | Principle | Rationale | Rejected Alternative |
|---|-------|----------|---------------|-----------|-----------|---------------------|
| 1 | CEO   | [what]   | Mechanical    | P1        | [why]     | [what was rejected]  |
| 2 | Eng   | [what]   | Taste         | P5        | [why]     | [what was rejected]  |
```

Write one row per decision incrementally. This keeps the audit on disk, not only in conversation context.

---

## Pre-Gate Verification

Before presenting the Final Approval Gate, verify that required outputs were actually produced. Check the plan file for each item.

**Phase 1 (CEO) outputs:**
- [ ] Premise challenge with specific premises named (not just "premises accepted")
- [ ] All applicable review sections have findings OR explicit "examined X, nothing flagged"
- [ ] "NOT in scope" section written
- [ ] "What already exists" section written
- [ ] Dream state delta written
- [ ] Completion Summary produced
- [ ] Lake Score assigned

**Phase 2 (Eng) outputs:**
- [ ] Scope challenge with actual code analysis (not just "scope is fine")
- [ ] Architecture mermaid diagram produced
- [ ] Data flows traced (4 paths each)
- [ ] Failure mode catalog with ≥ 3 entries
- [ ] Test plan artifact written to `.agent/test-plans/`
- [ ] Parallelization strategy defined (or single-lane noted)
- [ ] Deployment plan addresses partial deploy
- [ ] Cross-pipeline check answered
- [ ] Quality Gate checklist completed
- [ ] Lake Score assigned

**Audit trail:**
- [ ] Decision Audit Trail has at least one row per auto-decision (not empty)

If ANY checkbox above is missing, go back and produce the missing output. Max 2 attempts — if still missing after retrying twice, proceed to the gate with a warning noting which items are incomplete.

---

## Final Approval Gate

**STOP here and present the final state to the user.**

```
## /autoplan Review Complete

### Plan Summary
[1-3 sentence summary of what the plan does and the reviewed approach]

### Decisions Made: [N] total ([M] auto-decided, [K] taste choices, [J] user challenges)

### User Challenges (review recommends changing your stated direction)
[For each user challenge:]
**Challenge [N]: [title]** (from [phase])
You said: [user's original direction]
Review recommends: [the change]
Why: [reasoning]
What context we might be missing: [blind spots]
If we're wrong, the cost is: [downside of changing]
[If security/feasibility: "⚠️ This is flagged as a security/feasibility risk, not just a preference."]

Your call — your original direction stands unless you explicitly change it.

### Your Choices (taste decisions)
[For each taste decision:]
**Choice [N]: [title]** (from [phase])
I recommend [X] — [principle]. But [Y] is also viable:
  [1-sentence downstream impact if you pick Y]

### Auto-Decided: [M] decisions [see Decision Audit Trail in plan file]

### Review Scores
- CEO: [completion summary highlights + Lake Score]
- Eng: [completion summary highlights + Lake Score]
- UI Scope: [yes/no — if yes, recommend Design Audit after building]

### Deferred to TODOS.md
[Items auto-deferred with reasons]
```

**Cognitive load management:**
- 0 user challenges: skip "User Challenges" section
- 0 taste decisions: skip "Your Choices" section
- 1-7 taste decisions: flat list
- 8+: group by phase. Add warning: "This plan had unusually high ambiguity ([N] taste decisions). Review carefully."

**Options:**
- **A)** Approve as-is (accept all recommendations)
- **B)** Approve with overrides (specify which taste decisions to change)
- **C)** Interrogate (ask about any specific decision)
- **D)** Revise (the plan itself needs changes)
- **E)** Reject (start over)

**Option handling:**
- A: mark APPROVED, proceed to build
- B: ask which overrides, apply, re-present gate
- C: answer freeform, re-present gate
- D: make changes, re-run affected phases. Max 3 cycles.
- E: start over

---

## On Approval

After the user approves:

1. **Mark plan as approved** in the implementation_plan.md
2. **If UI scope detected:** "Plan approved. After building, run `Design Audit` for visual quality, then `QA Testing`, then `/deploy`."
3. **If backend-only:** "Plan approved. After building, run `QA Testing` if there are testable implications, or `/deploy` directly."
4. **If parallelization lanes exist:** "This plan has [N] parallel lanes. Consider using `Parallel Sessions` to maximize throughput."

---

## Important Rules

- **Never abort.** The user chose /autoplan. Respect that choice. Surface all taste decisions at the gate, never redirect to interactive review.
- **Two gates.** The only non-auto-decided questions are: (1) premise confirmation in Phase 1, and (2) User Challenges. Everything else is auto-decided using the 6 principles.
- **Log every decision.** No silent auto-decisions. Every choice gets a row in the audit trail.
- **Full depth means full depth.** Do not compress or skip sections from the loaded skill files (except the skip list in Phase 0). "Full depth" means: read the code the section asks you to read, produce the outputs the section requires, identify every issue, and decide each one. A one-sentence summary of a section is not "full depth" — it is a skip. If you catch yourself writing fewer than 3 sentences for any review section, you are likely compressing.
- **Artifacts are deliverables.** Test plan artifact, failure modes catalog, mermaid diagrams, parallelization strategy — these must exist on disk or in the plan file when the review completes.
- **Sequential order.** CEO → Eng. Each phase builds on the last.
- **Boil the lake.** This is the core philosophy. The 6 principles exist to ensure completeness is the default, not the exception.
