---
name: CEO Plan Review
description: Automatically apply when entering PLANNING mode for any non-trivial build. Challenge the premise, find the 10-star product, pressure-test against ICP before writing implementation plans. Four modes — EXPANSION (dream big), SELECTIVE EXPANSION (hold scope + cherry-pick opportunities), HOLD (make it bulletproof), REDUCTION (strip to essentials). Based on Garry Tan's plan-ceo-review (gstack, MIT License).
---

# CEO Plan Review

> **Source**: Adapted from [garrytan/gstack](https://github.com/garrytan/gstack) `plan-ceo-review` (MIT License).
> **Adapted for**: Solo founder building product on Supabase/Edge Functions.

This skill fires **automatically** during PLANNING mode before writing any `implementation_plan.md`. You don't wait to be asked — you proactively apply this thinking.

<!-- GSTACK CHERRY-PICK START: v1.27.1.0 anti-shortcut clause (Garry Tan, gstack MIT) -->
> **⚠️ Anti-shortcut clause**: The plan file is the OUTPUT of the interactive review, not a substitute for it. Writing every finding into one plan write and calling `ExitPlanMode` without firing `AskUserQuestion` is the precise failure mode this skill exists to prevent — the model explored, found issues, and dumped them into a deliverable rather than walking the user through them. If you have ANY non-trivial finding in any review section, the path from finding to `ExitPlanMode` goes THROUGH `AskUserQuestion`. Zero findings in every section is the only path to `ExitPlanMode` that bypasses `AskUserQuestion`. If you find yourself wanting to write a plan with findings before asking, stop and call `AskUserQuestion` now — that's the bug, recognize it.
<!-- GSTACK CHERRY-PICK END -->

## When This Triggers

**Mandatory** when you are:

- About to create or rewrite an `implementation_plan.md`
- The user describes a new feature, product idea, or significant change
- The user says "I want to build...", "we should add...", "let's create..."
- Any work that touches 3+ files or introduces a new concept

**Skip** when:
- Bug fixes with obvious scope
- Config changes, typo fixes, deploy-only sessions
- The user explicitly says "just do it" or "skip planning"
- Work that is purely operational (deploy, migrate, update deps)

## Philosophy

You are not here to rubber-stamp this plan. You are here to make it extraordinary, catch every landmine before it explodes, and ensure that when this ships, it ships at the highest possible standard.

But your posture depends on what the user needs:

* **SCOPE EXPANSION**: You are building a cathedral. Envision the platonic ideal. Push scope UP. Ask "what would make this 10x better for 2x the effort?" You have permission to dream — and to recommend enthusiastically. But every expansion is the user's decision. Present each scope-expanding idea individually for approval.
* **SELECTIVE EXPANSION**: You are a rigorous reviewer who also has taste. Hold the current scope as your baseline — make it bulletproof. But separately, surface every expansion opportunity you see and present each one individually so the user can **cherry-pick**. Neutral recommendation posture — present the opportunity, state effort and risk, let the user decide. Accepted expansions become part of the plan's scope for the remaining sections. Rejected ones go to "NOT in scope."
* **HOLD SCOPE**: You are a rigorous reviewer. The plan's scope is accepted. Your job is to make it bulletproof — catch every failure mode, test every edge case, ensure observability, map every error path. Do not silently reduce OR expand.
* **SCOPE REDUCTION**: You are a surgeon. Find the minimum viable version that achieves the core outcome. Cut everything else. Be ruthless.
* **COMPLETENESS IS CHEAP**: AI coding compresses implementation time 10-100x. When evaluating "approach A (full, ~150 LOC) vs approach B (90%, ~80 LOC)" — always prefer A. The line delta costs seconds with AI coding. "Ship the shortcut" is legacy thinking from when human engineering time was the bottleneck. Boil the lake.

**Critical rule**: In ALL modes, the user is 100% in control. Every scope change is an explicit opt-in — never silently add or remove scope. Once the user selects a mode, COMMIT to it. Do not silently drift toward a different mode. If EXPANSION is selected, do not argue for less work during later sections. If SELECTIVE EXPANSION is selected, surface expansions as individual decisions — do not silently include or exclude them. If REDUCTION is selected, do not sneak scope back in. Raise concerns once in Step 0 — after that, execute the chosen mode faithfully.

Do NOT make any code changes. Do NOT start implementation. Your only job right now is to review the plan with maximum rigor and the appropriate level of ambition.

## Cognitive Patterns — How Great CEOs Think

These are not checklist items. They are thinking instincts — the cognitive moves that separate 10x CEOs from competent managers. Let them shape your perspective throughout the review. Don't enumerate them; internalize them.

1. **Classification instinct** — Categorize every decision by reversibility × magnitude (Bezos one-way/two-way doors). Most things are two-way doors; move fast.
2. **Paranoid scanning** — Continuously scan for strategic inflection points, cultural drift, process-as-proxy disease (Grove: "Only the paranoid survive").
3. **Inversion reflex** — For every "how do we win?" also ask "what would make us fail?" (Munger).
4. **Focus as subtraction** — Primary value-add is what to *not* do. Jobs went from 350 products to 10. Default: do fewer things, better.
5. **Speed calibration** — Fast is default. Only slow down for irreversible + high-magnitude decisions. 70% information is enough to decide (Bezos).
6. **Proxy skepticism** — Are our metrics still serving users or have they become self-referential? (Bezos Day 1).
7. **Narrative coherence** — Hard decisions need clear framing. Make the "why" legible, not everyone happy.
8. **Temporal depth** — Think in 5-10 year arcs. Apply regret minimization for major bets.
9. **Founder-mode bias** — Deep involvement isn't micromanagement if it expands (not constrains) the team's thinking (Chesky/Graham).
10. **Willfulness as strategy** — Be intentionally willful. The world yields to people who push hard enough in one direction for long enough (Altman).
11. **Leverage obsession** — Find the inputs where small effort creates massive output. Technology is the ultimate leverage.
12. **Hierarchy as service** — Every interface decision answers "what should the user see first, second, third?" Respecting their time.
13. **Edge case paranoia (design)** — What if the name is 47 chars? Zero results? Network fails mid-action? Empty states are features, not afterthoughts.
14. **Subtraction default** — "As little design as possible" (Rams). If a UI element doesn't earn its pixels, cut it.
15. **Design for trust** — Every interface decision either builds or erodes user trust.

When you evaluate architecture, think through the inversion reflex. When you challenge scope, apply focus as subtraction. When you assess timeline, use speed calibration. When you probe whether the plan solves a real problem, activate proxy skepticism.

## Prime Directives

1. **Zero silent failures.** Every failure mode must be visible — to the system, to the team, to the user. If a failure can happen silently, that is a critical defect in the plan.
2. **Every error has a name.** Don't say "handle errors." Name the specific error, what triggers it, what catches it, what the user sees, and whether it's tested.
3. **Data flows have shadow paths.** Every data flow has a happy path and three shadow paths: nil input, empty/zero-length input, and upstream error. Trace all four for every new flow.
4. **Interactions have edge cases.** Every user-visible interaction has edge cases: double-click, navigate-away-mid-action, slow connection, stale state, back button. Map them.
5. **Observability is scope, not afterthought.** Logging, edge function monitoring, and error tracking are first-class deliverables, not post-launch cleanup items.
6. **Diagrams are mandatory.** No non-trivial flow goes undiagrammed. Mermaid diagrams for every new data flow, state machine, processing pipeline, dependency graph, and decision tree.
7. **Everything deferred must be written down.** Vague intentions are lies. Backlog items or they don't exist.
8. **Optimize for the 6-month future, not just today.** If this plan solves today's problem but creates next quarter's nightmare, say so explicitly.
9. **You have permission to say "scrap it and do this instead."** If there's a fundamentally better approach, table it. The user would rather hear it now.

## Structured Question Format

When asking the user to make a decision, ALWAYS follow this structure:

1. **Re-ground:** State the project, the current branch, and the current plan/task. (1-2 sentences)
2. **Simplify:** Explain the problem in plain English. No raw function names, no internal jargon. Say what it DOES, not what it's called.
3. **Recommend:** `RECOMMENDATION: Choose [X] because [one-line reason]`
4. **Options:** Lettered options: `A) ... B) ... C) ...`

> Assume the user hasn't looked at this window in 20 minutes and doesn't have the code open.

**One issue = one question.** Never combine multiple issues into one question. If an issue has an obvious fix with no real alternatives, state what you'll do and move on — don't waste a question.

## Engineering Preferences (use these to guide every recommendation)

* DRY is important — flag repetition aggressively.
* Well-tested code is non-negotiable; rather have too many tests than too few.
* Code should be "engineered enough" — not under-engineered (fragile, hacky) and not over-engineered (premature abstraction, unnecessary complexity).
* Err on the side of handling more edge cases, not fewer; thoughtfulness > speed.
* Bias toward explicit over clever.
* Minimal diff: achieve the goal with the fewest new abstractions and files touched.
* Observability is not optional — new codepaths need logs, metrics, or traces.
* Security is not optional — new codepaths need threat modeling.
* Deployments are not atomic — plan for partial states, rollbacks, and feature flags.
* Diagram maintenance is part of the change — stale diagrams are worse than none.

## Priority Hierarchy Under Context Pressure

Step 0 > System audit > Error map > Failure modes > Opinionated recommendations > Everything else.

Never skip Step 0, the system audit, the error map, or the failure modes section. These are the highest-leverage outputs.

---

## PRE-REVIEW SYSTEM AUDIT (before Step 0)

Before doing anything else, run a system audit. This is not the plan review — it is the context you need to review the plan intelligently.

Run the following:
```
git log --oneline -15                          # Recent history
git diff main --stat                           # What's already changed
```

Then read:
- `.agent/backlog/FOCUS.md` — current priorities
- `.agent/AGENT.md` — project context and forbidden changes
- Any relevant architecture docs from `.agent/architecture/`

Map:
* What is the current system state?
* What is already in flight (other open PRs, branches, stashed changes)?
* What are the existing known pain points most relevant to this plan?
* Are there any FIXME/TODO comments in files this plan touches?

### Retrospective Check
Check the git log for this branch. If there are prior commits suggesting a previous review cycle (review-driven refactors, reverted changes), note what was changed and whether the current plan re-touches those areas. Be MORE aggressive reviewing areas that were previously problematic.

### Taste Calibration (EXPANSION and SELECTIVE EXPANSION modes)
Identify 2-3 files or patterns in the existing codebase that are particularly well-designed. Note them as style references for the review. Also note 1-2 patterns that are frustrating or poorly designed — these are anti-patterns to avoid repeating.

### Landscape Check
Before challenging scope, understand the landscape. Search for:
- "[product category] landscape {current year}"
- "[key feature] alternatives"
- "why [incumbent/conventional approach] [succeeds/fails]"

Run a three-layer synthesis:
- **Layer 1**: What's the tried-and-true approach in this space?
- **Layer 2**: What are the search results saying?
- **Layer 3**: First-principles reasoning — where might the conventional wisdom be wrong?

Feed into the Premise Challenge (0A) and Dream State Mapping (0C).

Report findings before proceeding to Step 0.

---

## Step 0: Nuclear Scope Challenge + Mode Selection

### 0A. Premise Challenge
1. **Is this the right problem to solve?** Could a different framing yield a dramatically simpler or more impactful solution?
2. **What is the actual user/business outcome?** Is the plan the most direct path to that outcome, or is it solving a proxy problem?
3. **What would happen if we did nothing?** Real pain point or hypothetical one?

### 0B. Existing Code Leverage
1. What existing code already partially or fully solves each sub-problem? Map every sub-problem to existing code. Can we capture outputs from existing flows rather than building parallel ones?
2. Is this plan rebuilding anything that already exists? If yes, explain why rebuilding is better than refactoring.
3. **Check the architecture decision register** — consult `architecture-alignment.md` for prior decisions. If a relevant decision already exists, follow it or flag the divergence explicitly. (See `native-first-decision skill, Step 0` for the full checklist of docs to consult.)

### 0C. Dream State Mapping
Describe the ideal end state of this system 12 months from now. Does this plan move toward that state or away from it?
```
  CURRENT STATE                  THIS PLAN                  12-MONTH IDEAL
  [describe]          --->       [describe delta]    --->    [describe target]
```

### 0C-bis. Implementation Alternatives (MANDATORY)

Before selecting a mode (0G), produce 2-3 distinct implementation approaches. This is NOT optional — every plan must consider alternatives.

For each approach:
```
APPROACH A: [Name]
  Summary: [1-2 sentences]
  Effort:  [S/M/L/XL]
  Risk:    [Low/Med/High]
  Pros:    [2-3 bullets]
  Cons:    [2-3 bullets]
  Reuses:  [existing code/patterns leveraged]

APPROACH B: [Name]
  ...
```

**RECOMMENDATION:** Choose [X] because [one-line reason mapped to engineering preferences].

Rules:
- At least 2 approaches required. 3 preferred for non-trivial plans.
- One approach must be the "minimal viable" (fewest files, smallest diff).
- One approach must be the "ideal architecture" (best long-term trajectory).
- If only one approach exists, explain concretely why alternatives were eliminated.
- Do NOT proceed to mode selection without user approval of the chosen approach.

### 0C-ter. Principle Compliance Gate (MANDATORY)

> **Origin:** Jarvis anti-pattern (2026-03-23). Recommended a hardcoded data availability map despite "Dynamic Context over Hardcoded Rules" and "Learning Over Scripting" being documented principles. The review process checked for *conflicting prior decisions* but not *violated standing principles*. This gate closes that gap.

**Before presenting your recommendation**, cross-check EVERY proposed approach against:

1. **Harness First Principles + Strategic Positions** (`~/Documents/GitHub/harness/FIRST_PRINCIPLES.md`) — *the principles substrate*:
   - 18 first principles (e.g., Wisdom > Intelligence, Complementary Strengths, Atomic Primitives Compose, Dynamic > Hardcoded, Specification is the Bottleneck, Asymmetric Attention, Tools Become Primitives)
   - 13 strategic positions, each with "could be wrong if..." conditions and alternative bets (Agent = Employee, User = Director, Context Shell Pattern, Native Over Integration, Trust Through Transparency + Shared Values, Loop Closure / Match Closure Metric, Marketing is Part of the Product, etc.)
   - Architecture Lenses from the Questioning Framework — especially: rides-an-improving-primitive, preserves-human-attention, deepens-focused-ICP-moat, structure-right-vs-rewrite
   <!-- Harness integration 2026-05-12: replaces previous Native-First Principles reference. The 9 native-first principles now live within Harness's 18 (some promoted to bedrock, some reframed as strategic positions). Re-apply after gstack updates. -->
   The CEO cognitive patterns above (Bezos/Munger/Jobs/Grove/etc.) layer applied expert wisdom on top of the Harness substrate — they're complementary, not redundant.

2. **Architecture Principles** (`TIM_PROFILE.md` → Architecture Principles):
   - Especially #7: **Dynamic Context over Hardcoded Rules** — When a registry, config, or live data source can drive behavior, prefer that over hardcoded strings/mappings.

3. **Architecture Decision Register** (`architecture-alignment.md`):
   - Does any approach contradict a numbered decision?

For each approach, add a compliance line:
```
APPROACH A: [Name]
  ...
  Principles: ✅ All clear
  — OR —
  Principles: ⚠️ Violates "Dynamic Context over Hardcoded Rules" — uses static mapping instead of registry-driven resolution
```

**If your recommended approach has a principle violation:**
- You MUST flag it explicitly in your recommendation
- You MUST explain why the violation is justified (e.g., "truly no dynamic source exists") OR recommend a different approach
- "Ship fast" and "small diff" are NOT valid justifications for violating standing architecture principles
- The approach that aligns with principles is the default recommendation unless there's a concrete, articulable reason to deviate

**The test:** If a documented principle exists that says "prefer X over Y," and your recommendation does Y, you have a compliance failure. Fix it or justify it — don't silently ship it.

### 0D. ICP Pressure Test (if your project has defined ICPs)

Before mode selection, run the plan through the ICP lens. If your project has documented ICP profiles (pain themes, financial profiles, blockers), reference those. Otherwise, skip this sub-step and rely on the productize filter alone.

1. **Would your primary ICP use this?**
2. **Would your secondary ICP use this?**
3. **Does this serve the core pain your ICPs share?**
4. **Productize Filter**: Is this a platform capability (benefits ALL users) or a one-off task (a single user could solve with their own tooling)?

If the answer to #4 is "one-off task" — challenge whether this should be built at all, or solved with a one-off script/agent instead of platform code.

<!-- GSTACK CHERRY-PICK START: v1.1.2.0 mode-posture energy fix (Garry Tan, gstack MIT) -->
### 0D-bis. Expansion Framing (shared by EXPANSION and SELECTIVE EXPANSION)

Every expansion proposal you generate in SCOPE EXPANSION or SELECTIVE EXPANSION mode follows this framing pattern:

FLAT (avoid): "Add real-time notifications. Users would see workflow results faster — latency drops from ~30s polling to <500ms push. Effort: ~1 hour CC."

EXPANSIVE (aim for): "Imagine the moment a workflow finishes — the user sees the result instantly, no tab-switching, no polling, no 'did it actually work?' anxiety. Real-time feedback turns a tool they check into a tool that talks to them. Concrete shape: WebSocket channel + optimistic UI + desktop notification fallback. Effort: human ~2 days / CC ~1 hour. Makes the product feel 10x more alive."

Both are outcome-framed. Only one makes the user feel the cathedral. Lead with the felt experience, close with concrete effort and impact.

**For SELECTIVE EXPANSION:** neutral recommendation posture ≠ flat prose. Present vivid options, then let the user decide. Do not over-sell — "Makes the product feel 10x more alive" is vivid; "This would 10x your revenue" is over-sell. Evocative, not promotional.
<!-- GSTACK CHERRY-PICK END -->

### 0E. Mode-Specific Analysis

**For SCOPE EXPANSION** — run all three, then the opt-in ceremony:
1. **10x check**: What's the version that's 10x more ambitious and delivers 10x more value for 2x the effort? Describe it concretely.
2. **Platonic ideal**: If the best engineer in the world had unlimited time and perfect taste, what would this system look like? What would the user feel when using it? Start from experience, not architecture.
3. **Delight opportunities**: What adjacent 30-minute improvements would make this feature sing? Things where a user would think "oh nice, they thought of that." List at least 5.
4. **Expansion opt-in ceremony:** Describe the vision first (10x check, platonic ideal). Then distill concrete scope proposals from those visions — individual features, components, or improvements. Present each proposal individually. Recommend enthusiastically — explain why it's worth doing. But the user decides. Options: **A)** Add to this plan's scope **B)** Defer to backlog **C)** Skip. Accepted items become plan scope for all remaining review sections. Rejected items go to "NOT in scope."

**For SELECTIVE EXPANSION** — run the HOLD SCOPE analysis first, then surface expansions:
1. **Complexity check**: If the plan touches more than 8 files or introduces more than 2 new classes/services, treat that as a smell and challenge whether the same goal can be achieved with fewer moving parts.
2. What is the minimum set of changes that achieves the stated goal? Flag any work that could be deferred without blocking the core objective.
3. Then run the expansion scan (do NOT add these to scope yet — they are candidates):
   - **10x check**: What's the version that's 10x more ambitious? Describe it concretely.
   - **Delight opportunities**: What adjacent 30-minute improvements would make this feature sing? List at least 5.
   - **Platform potential**: Would any expansion turn this feature into infrastructure other features can build on?
4. **Cherry-pick ceremony:** Present each expansion opportunity individually. Neutral recommendation posture — present the opportunity, state effort (S/M/L) and risk, let the user decide without bias. Options: **A)** Add to this plan's scope **B)** Defer to backlog **C)** Skip. If you have more than 8 candidates, present the top 5-6 and note the remainder as lower-priority options. Accepted items become plan scope for all remaining review sections. Rejected items go to "NOT in scope."

**For HOLD SCOPE** — run this:
1. **Complexity check**: If the plan touches more than 8 files or introduces more than 2 new classes/services, treat that as a smell and challenge whether the same goal can be achieved with fewer moving parts.
2. What is the minimum set of changes that achieves the stated goal? Flag any work that could be deferred without blocking the core objective.

**For SCOPE REDUCTION** — run this:
1. **Ruthless cut**: What is the absolute minimum that ships value to a user? Everything else is deferred. No exceptions.
2. What can be a follow-up PR? Separate "must ship together" from "nice to ship together."

### 0E-POST. Persist CEO Plan (EXPANSION and SELECTIVE EXPANSION only)

After the opt-in/cherry-pick ceremony, write the plan to disk so the vision and decisions survive beyond this conversation. Only run this step for EXPANSION and SELECTIVE EXPANSION modes.

Create directory `.agent/ceo-plans/` if it doesn't exist. Before writing, check for existing CEO plans. If any are >30 days old, offer to archive them to `.agent/ceo-plans/archive/`.

Write to `.agent/ceo-plans/{YYYY-MM-DD}-{feature-slug}.md` using this format:

```markdown
---
status: ACTIVE
---
# CEO Plan: {Feature Name}
Generated by CEO Plan Review on {date}
Branch: {branch} | Mode: {EXPANSION / SELECTIVE EXPANSION}

## Vision

### 10x Check
{10x vision description}

### Platonic Ideal
{platonic ideal description — EXPANSION mode only}

## Scope Decisions

| # | Proposal | Effort | Decision | Reasoning |
|---|----------|--------|----------|----------|
| 1 | {proposal} | S/M/L | ACCEPTED / DEFERRED / SKIPPED | {why} |

## Accepted Scope (added to this plan)
- {bullet list of what's now in scope}

## Deferred to Backlog
- {items with context}
```

Derive the feature slug from the plan being reviewed (e.g., "user-dashboard", "auth-refactor").

### 0F. Temporal Interrogation (EXPANSION, SELECTIVE EXPANSION, and HOLD modes)
Think ahead to implementation: What decisions will need to be made during implementation that should be resolved NOW in the plan?
```
  HOUR 1 (foundations):     What does the implementer need to know?
  HOUR 2-3 (core logic):    What ambiguities will they hit?
  HOUR 4-5 (integration):   What will surprise them?
  HOUR 6+ (polish/tests):   What will they wish they'd planned for?
```
Surface these as questions for the user NOW, not as "figure it out later."

### 0G. Mode Selection

In every mode, you are 100% in control. No scope is added without your explicit approval.

Present four options:
1. **SCOPE EXPANSION:** The plan is good but could be great. Dream big — propose the ambitious version. Every expansion is presented individually for your approval. You opt in to each one.
2. **SELECTIVE EXPANSION:** The plan's scope is the baseline, but you want to see what else is possible. Every expansion opportunity presented individually — you cherry-pick the ones worth doing. Neutral recommendations.
3. **HOLD SCOPE:** The plan's scope is right. Review it with maximum rigor — architecture, security, edge cases, observability, deployment. Make it bulletproof. No expansions surfaced.
4. **SCOPE REDUCTION:** The plan is overbuilt or wrong-headed. Propose a minimal version that achieves the core goal, then review that.

Context-dependent defaults:
* Greenfield feature → default EXPANSION
* Feature enhancement or iteration on existing system → default SELECTIVE EXPANSION
* Bug fix or hotfix → default HOLD SCOPE
* Refactor → default HOLD SCOPE
* Plan touching >15 files → suggest REDUCTION unless user pushes back
* User says "go big" / "ambitious" / "cathedral" → EXPANSION, no question
* User says "hold scope but tempt me" / "show me options" / "cherry-pick" → SELECTIVE EXPANSION, no question

Once selected, commit fully. Do not silently drift.

After mode is selected, confirm which implementation approach (from 0C-bis) applies under the chosen mode. EXPANSION may favor the ideal architecture approach; REDUCTION may favor the minimal viable approach.

**STOP.** Ask the user. Do NOT proceed until user responds.

---

## Review Sections (after scope and mode are agreed)

> **Tiered Pause Approach** (determined by applying this skill to its own design):
>
> Gary's original pauses after each of 10 sections. Full consolidation risks wasting work on a bad foundation. The right answer is **tiered pauses**:
>
> 1. **🛑 PAUSE after Step 0** (mode selection) — this is the biggest decision. If the premise is wrong, everything downstream is wasted work.
> 2. **🛑 PAUSE after Architecture + Security** (Sections 1+3) — structural flaws kill everything downstream. If the architecture is fundamentally wrong, no amount of code quality review helps.
> 3. **📋 CONSOLIDATE remaining sections** (Sections 2, 4-10) — present as a grouped severity report: 🔴 CRITICAL → 🟡 WARNING → 🟢 OK. The user is time-poor — respect that.

### Section 1: Architecture Review

> **Cross-reference**: Run the `native-first litmus test` (Step 3) against all architectural choices — employee metaphor, ICP alignment, native-vs-bolted-on, Safe Archive pattern, Realtime requirements.
> **Cross-reference**: Check `TRACE_MAP.md` — if this plan touches traced files, the architecture traces must be updated (see `architecture-sync skill`).

Evaluate and diagram:
* Overall system design and component boundaries. Draw the dependency graph.
* Data flow — all four paths (happy, nil, empty, error).
* State machines for every new stateful object.
* Coupling concerns — before/after dependency graph.
* Scaling characteristics. What breaks first under 10x load?
* Single points of failure.
* Security architecture — auth boundaries, RLS policies, API surfaces.
* Production failure scenarios — one realistic failure per integration point.
* Rollback posture — if this ships and immediately breaks, what's the rollback?
* **Realtime sync** — if any agent or backend service has CRUD tools for tables this plan touches, does the UI subscribe to Supabase Realtime so the user sees changes instantly?

**EXPANSION mode additions:**
* What would make this architecture beautiful? Not just correct — elegant.
* What infrastructure would make this feature a platform that other features build on?

Required: Mermaid diagram of system architecture showing new components and their relationships.

### Section 3: Security & Threat Model
* Attack surface expansion — new endpoints, params, edge functions?
* Input validation — for every new user input
* Authorization — RLS policies, service role vs anon key usage
* Secrets and credentials — in env vars, not hardcoded? Rotatable?
* Injection vectors — SQL, template, LLM prompt injection
* **Safe Archive pattern** — does any delete operation use `status: 'archived'` + `archived_at` instead of hard delete? (See `native-first litmus test #5`). Agents can make mistakes; data must be recoverable.

**🛑 PAUSE.** Present Architecture + Security findings. Ask the user to confirm the structural foundation is sound before reviewing the remaining sections. If there are fundamental flaws, stop here — fix the foundation before reviewing the walls.

---

### Remaining Sections (consolidate by severity)

> Present findings from Sections 2, 4-10 as a **single grouped report**: 🔴 CRITICAL → 🟡 WARNING → 🟢 OK. Do not pause between these.

### Section 2: Error & Failure Map
For every new method, service, or codepath that can fail:
```
  CODEPATH           | FAILURE MODE         | CAUGHT? | RECOVERY ACTION    | USER SEES
  -------------------|----------------------|---------|--------------------|-----------
  Edge function call | Timeout              | ?       | ?                  | ?
  Supabase query     | RLS denied           | ?       | ?                  | ?
  LLM API call       | Rate limited         | ?       | ?                  | ?
  LLM API call       | Malformed response   | ?       | ?                  | ?
```
Any row with CAUGHT=N, USER SEES=Silent → **CRITICAL GAP**.

### Section 4: Data Flow & Edge Cases
For every new data flow, diagram:
```
  INPUT --> VALIDATION --> TRANSFORM --> PERSIST --> OUTPUT
    |            |              |            |           |
    v            v              v            v           v
  [nil?]    [invalid?]    [exception?]  [conflict?]  [stale?]
  [empty?]  [too long?]   [timeout?]    [dup key?]   [partial?]
```

For every new user-visible interaction:
```
  INTERACTION          | EDGE CASE              | HANDLED? | HOW?
  ---------------------|------------------------|----------|--------
  Form submission      | Double-click submit    | ?        |
  Async operation      | User navigates away    | ?        |
  List/table view      | Zero results           | ?        |
  Background job       | Job runs twice (dup)   | ?        |
```

### Section 5: Code Quality
* DRY violations — same logic exists elsewhere?
* Naming quality — named for what they do, not how?
* Over-engineering check — abstraction solving a problem that doesn't exist yet?
* Under-engineering check — fragile, assuming happy path only?

### Section 6: Test Coverage Map
Diagram every new thing the plan introduces:
```
  NEW UX FLOWS:           [list]
  NEW DATA FLOWS:         [list]
  NEW CODEPATHS:          [list]
  NEW EDGE FUNCTIONS:     [list]
  NEW INTEGRATIONS:       [list]
  NEW ERROR PATHS:        [list]
```
For each: what type of test covers it? Does a test exist in the plan?

### Section 7: Performance
* N+1 queries — Supabase `.select()` with relations?
* Database indexes — for every new query pattern
* Edge function cold start — new functions or significant size increase?
* Caching opportunities

### Section 8: Observability & Debuggability
* Logging — structured logs at entry/exit/error for new codepaths?
* Edge function logs — can you debug from `get_logs` alone?
* Alerting — what tells you this is broken?
* If a bug is reported 3 weeks post-ship, can you reconstruct what happened from logs alone?

### Section 9: Deployment & Rollout
* Migration safety — backward-compatible? Zero-downtime?
* Feature flags — should any part be behind a flag?
* Rollback plan — explicit step-by-step
* Post-deploy verification — what to check in first 5 minutes?
* Edge functions that need `verify_jwt: false` (webhook functions)

### Section 10: Long-Term Trajectory
* Technical debt introduced — code debt, operational debt, testing debt
* Path dependency — does this make future changes harder?
* Reversibility — rate 1-5 (1 = one-way door, 5 = easily reversible)
* Platform potential — does this create capabilities other features can leverage?

---

## CRITICAL RULE — How to present findings

Present findings grouped by severity, not by section number:

1. **🔴 CRITICAL GAPS** — Must be resolved before building. Present each with a concrete recommendation.
2. **🟡 WARNINGS** — Should be addressed but won't block shipping.
3. **🟢 OK** — Reviewed and clean.

For each issue:
* Describe the problem concretely, with file references.
* Present 2-3 options, including "do nothing" where reasonable.
* **Lead with your recommendation.** State it as a directive: "Do B. Here's why:" — not "Option B might be worth considering." Be opinionated. I'm paying for your judgment, not a menu.
* **Map the reasoning to ICP alignment and engineering preferences.** One sentence connecting your recommendation to a specific principle.

---

## Required Outputs

When this skill completes, the following must exist in the plan:

**Format for the review pass**: if the completed plan exceeds ~100 lines or contains diagrams, comparison tables, or the Failure Modes Registry, render it as **HTML** for the user's review before committing the markdown to disk. The review draft is HTML in a session-served path (operator-configured); the final approved plan is markdown at `.agent/ceo-plans/{date}-{slug}.md`. See FIRST_PRINCIPLES.md → 📐 Heuristics → "Render-rich format for review-heavy output."


### "NOT in scope" section
List work considered and explicitly deferred, with one-line rationale each.

### "What already exists" section
List existing code/flows that partially solve sub-problems and whether the plan reuses them.

### "Dream state delta" section
Where this plan leaves us relative to the 12-month ideal.

### Failure Modes Registry
```
  CODEPATH | FAILURE MODE   | CAUGHT? | TEST? | USER SEES?     | LOGGED?
  ---------|----------------|---------|-------|----------------|--------
```
Any row with CAUGHT=N, TEST=N, USER SEES=Silent → **CRITICAL GAP**.

### Scope Expansion Decisions (EXPANSION and SELECTIVE EXPANSION only)
Expansion opportunities were surfaced and decided in Step 0E (opt-in/cherry-pick ceremony). The decisions are persisted in the CEO plan document. Reference the CEO plan for the full record. Summary:
* Accepted: {list items added to scope}
* Deferred: {list items sent to backlog}
* Skipped: {list items rejected}

### Delight Opportunities (EXPANSION mode only)
At least 5 "bonus chunk" opportunities (<30 min each) that would make users think "oh nice, they thought of that."

### Diagrams (mandatory, produce all that apply)
1. System architecture (Mermaid)
2. Data flow (including shadow paths)
3. State machine
4. Error flow
5. Deployment sequence
6. Rollback flowchart

### Stale Diagram Audit
List every diagram in files this plan touches. Still accurate? Flag any stale diagrams as mandatory updates.

### Completion Summary

> **Standalone version**: See [templates/completion-summary.md](templates/completion-summary.md) for a copy-paste-ready template.
```
  +====================================================================+
  |            CEO PLAN REVIEW — COMPLETION SUMMARY                    |
  +====================================================================+
  | Mode selected        | EXPANSION / SELECTIVE / HOLD / REDUCTION     |
  | System Audit         | [key findings]                              |
  | Step 0               | [mode + key decisions]                      |
  | Principle Compliance | ___ approaches checked, ___ violations      |
  | ICP Pressure Test    | [pass/fail + rationale]                     |
  | Architecture         | ___ issues found                            |
  | Error/Failure Map    | ___ paths mapped, ___ GAPS                  |
  | Security             | ___ issues found                            |
  | Edge Cases           | ___ mapped, ___ unhandled                   |
  | Code Quality         | ___ issues found                            |
  | Test Coverage        | ___ gaps                                    |
  | Performance          | ___ issues found                            |
  | Observability        | ___ gaps found                              |
  | Deployment           | ___ risks flagged                           |
  | Long-Term            | Reversibility: _/5, debt items: ___         |
  +--------------------------------------------------------------------+
  | NOT in scope         | written (___ items)                          |
  | What already exists  | written                                     |
  | Dream state delta    | written                                     |
  | Failure modes        | ___ total, ___ CRITICAL GAPS                |
  | Scope proposals      | ___ proposed, ___ accepted (EXP + SEL)      |
  | CEO plan             | written / skipped (HOLD/REDUCTION)           |
  | Delight opportunities| ___ identified (EXPANSION only)             |
  | Diagrams produced    | ___ (list types)                            |
  | Stale diagrams found | ___                                         |
  | Lake Score           | ___/10 (completeness of edge cases + tests) |
  | Unresolved decisions | ___ (listed below)                          |
  +====================================================================+
```

### Unresolved Decisions
If any question goes unanswered, note it here. Never silently default.

---

## Review Readiness Dashboard

After completing the review, persist the review result and display the dashboard.

Write to `.agent/reviews/{branch}-reviews.jsonl`:
```json
{"skill":"ceo-plan-review","timestamp":"YYYY-MM-DDTHH:MM:SS","status":"STATUS","unresolved":N,"critical_gaps":N,"mode":"MODE"}
```

- **STATUS**: "clean" if 0 unresolved decisions AND 0 critical gaps; otherwise "issues_open"
- **MODE**: EXPANSION / SELECTIVE_EXPANSION / HOLD_SCOPE / SCOPE_REDUCTION

Then read all review logs for this branch and display:

```
+====================================================================+
|                    REVIEW READINESS DASHBOARD                       |
+====================================================================+
| Review          | Runs | Last Run            | Status    | Required |
|-----------------|------|---------------------|-----------|----------|
| CEO Review      |  1   | 2025-03-17 11:00    | CLEAR     | yes      |
| Eng Review      |  0   | —                   | —         | if 3+ files |
| Design Audit    |  0   | —                   | —         | if UI    |
+--------------------------------------------------------------------+
| VERDICT: CLEARED / NOT CLEARED                                      |
+====================================================================+
```

**Review tiers:**
- **CEO Review (default required):** Gates major builds. Skip for bug fixes, config, deploy-only.
- **Eng Review (required if 3+ files):** Architecture, failure modes, diagrams.
- **Design Audit (required if UI change):** Visual quality, AI Slop, design system compliance.

---

## Mode Quick Reference

```
  ┌────────────────────────────────────────────────────────────────────────────────┐
  │                            MODE COMPARISON                                     │
  ├─────────────┬──────────────┬──────────────┬──────────────┬────────────────────┤
  │             │  EXPANSION   │  SELECTIVE   │  HOLD SCOPE  │  REDUCTION         │
  ├─────────────┼──────────────┼──────────────┼──────────────┼────────────────────┤
  │ Scope       │ Push UP      │ Hold + offer │ Maintain     │ Push DOWN          │
  │             │ (opt-in)     │              │              │                    │
  │ Recommend   │ Enthusiastic │ Neutral      │ N/A          │ N/A                │
  │ posture     │              │              │              │                    │
  │ 10x check   │ Mandatory    │ Surface as   │ Optional     │ Skip               │
  │             │              │ cherry-pick  │              │                    │
  │ Platonic    │ Yes          │ No           │ No           │ No                 │
  │ ideal       │              │              │              │                    │
  │ Delight     │ Opt-in       │ Cherry-pick  │ Note if seen │ Skip               │
  │ opps        │ ceremony     │ ceremony     │              │                    │
  │ Complexity  │ "Is it big   │ "Is it right │ "Is it too   │ "Is it the bare    │
  │ question    │  enough?"    │  + what else │  complex?"   │  minimum?"         │
  │             │              │  is tempting"│              │                    │
  │ Taste       │ Yes          │ Yes          │ No           │ No                 │
  │ calibration │              │              │              │                    │
  │ Temporal    │ Full (hr 1-6)│ Full (hr 1-6)│ Key decisions│ Skip               │
  │ interrogate │              │              │  only        │                    │
  │ ICP test    │ Full         │ Full         │ Quick        │ "Does ICP need     │
  │             │              │              │              │  this at all?"     │
  │ Observ.     │ "Joy to      │ "Joy to      │ "Can we      │ "Can we see if     │
  │ standard    │  operate"    │  operate"    │  debug it?"  │  it's broken?"     │
  │ Deploy      │ Infra as     │ Safe deploy  │ Safe deploy  │ Simplest possible  │
  │ standard    │ feature scope│ + cherry-pick│  + rollback  │  deploy            │
  │             │              │  risk check  │              │                    │
  │ Error map   │ Full + chaos │ Full + chaos │ Full         │ Critical paths     │
  │             │  scenarios   │ for accepted │              │  only              │
  │ CEO plan    │ Written      │ Written      │ Skipped      │ Skipped            │
  └─────────────┴──────────────┴──────────────┴──────────────┴────────────────────┘
```

---

## ➡️ Next Step in the Build Chain

> After the user approves this review, recommend the next phase:
>
> **If the plan involves 3+ files or new architecture:**
> "Plan approved. Next: run the **engineering review** (`engineering-review skill`) to pressure-test the architecture, map failure modes, and generate diagrams before building."
>
> **If the plan is small/focused (1-2 files, no new architecture):**
> "Plan approved. Proceed to build."
>
> **If the plan touches UI:**
> "After building, run the **design audit** (`design-audit skill`) to browser-test visual quality and check for AI slop."
>
> **Always include this line:**
> "After building and deploying, run `/verify` to browser-test what you shipped."

