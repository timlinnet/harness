# 0004 — The PR Review Loop

**Date**: 2026-05-12
**Status**: Designed; deferred build
**Decided by**: Tim Linnet
**Audience**: Tim, Lonnie, future operator or agent that implements this

## The trust model this loop operationalizes

Tim articulated the team-trust shape during this session:

> *"As long as Lonnie knows he's responsible for his PRs working and being tested and not breaking things and not causing security issues and being aligned with our ICP, harness and gstack — then I'm good. His process should surface questions to me. I shouldn't have to babysit when he's completed his process and something is working."*

This loop is the operationalization of that trust model. Without it, Tim is in the loop on every PR; with it, Tim is in the loop on **the PRs that genuinely need his judgment**.

This is the same meta-pattern as decision 0003 (auto-research loop), the PostHog Auto-Fix Loop (in `freedom-ai/.agent/backlog/OPEN_LOOPS.md`), and the SessionStart hook. Form follows pattern: **the system runs itself; humans get attention only on genuine judgment calls.**

## Architecture

Three layers: trigger → agent-mediated review → surface.

### Trigger

Any PR opened or pushed on:
- `linnetlegacies/*` (freedom-ai, compounding-confidence, openclaw-linnet, pharmcompound-ai, future)
- `797tracker/*` (Conduit, Agent-Gaming, future personal repos)
- `timlinnet/*` (harness, future personal-brand repos)

Implementation options for the trigger:
- **GitHub webhook → edge function** (fastest, real-time)
- **Scheduled poll** (every 15–30 min via `mcp__scheduled-tasks__create_scheduled_task`) — simpler MVP
- **Manual invocation** (`/review-pr <number>`) — interim bridge

Pick poll for MVP; promote to webhook when latency matters.

### Agent-mediated review

When a PR is detected, an agent runs the relevant gstack skill chain output, applies the Harness lens, and produces a structured review. **Concretely**:

1. **Identify scope** — read the PR diff. Classify by what it touches:
   - UI-only → `design-audit` is mandatory; `engineering-review` if 3+ files
   - Backend/API → `engineering-review` always, `qa-testing` for test scenarios
   - Agent system / MCP / RLS / schema → full chain: `office-hours` (if architecture-shaped) + `ceo-plan-review` + `engineering-review`
   - Docs only → light pass (Harness lens only, no eng review)
   - Mixed → run all applicable

2. **Security check** — always:
   - No hardcoded secrets (pattern match for `sbp_`, `sk-`, `nvapi-`, hardcoded keys, password literals)
   - No `.env*` files in diff
   - No RLS bypass (service-role usage in user-context paths)
   - No PII in prompts or customer-visible surfaces

3. **ICP alignment** — read project's `.agent/AGENT.md` for ICP context. Ask: does this serve the ICP, or is it an internal-engineering optimization?

4. **Harness principles check** — apply the Architecture Lenses from the Questioning Framework:
   - Does it ride a primitive that's improving, or compete with it?
   - Preserves human attention?
   - Spec clear?
   - Honors complementary strengths?
   - Structure right vs. rewrite?
   - For decisions touching the bridge: does this deepen the moat?

5. **Surface the review** as a structured PR comment grouped by severity:
   - 🔴 **CRITICAL** (blocks merge — security, breaking change, principle violation)
   - 🟡 **WARNING** (should address — ICP miss, complexity creep, weak test coverage)
   - 🟢 **OK** (reviewed and clean)

### Decision tree

For each PR after review:

| Outcome | Action |
|---|---|
| All 🟢 + author marked "ready to merge" | **Auto-merge** (squash + delete branch by default) |
| Has 🟡 WARNINGS only | **Comment to Lonnie first**. He addresses, agent re-reviews, then auto-merge. Escalate to Tim only if Lonnie pushes back on a flagged warning. |
| Has 🔴 CRITICAL | **Comment to Lonnie first** with concrete fix. Re-review after fix. Escalate to Tim if Lonnie disputes the critical flag OR fix is non-trivial. |
| Genuine judgment call (e.g., ICP boundary, strategic position trade-off, harness principle interpretation) | **Escalate to Tim in Claude Code chat** (not GitHub) — surface the PR + the specific question + Lonnie's proposed answer if any |

The Lonnie-first pattern matches Tim's trust model: *"His process should surface questions to me."* The agent surfaces issues to Lonnie; Lonnie surfaces what Lonnie can't resolve to Tim.

### Surface

Three surfaces, ranked by Tim's preference:

1. **Claude Code chat** — when Tim starts a session, the SessionStart hook shows open PRs (already shipped 2026-05-12). When a PR needs Tim's judgment, a Claude Code notification fires (`agentPushNotifEnabled` + push notification MCP).
2. **FreedomOS Command Center card** — for cross-session visibility. Card type: "PR escalation." Created when agent escalates; cleared when Tim resolves.
3. **GitHub** — exists as the source of truth (Lovable still syncs from main; gh CLI still works) but Tim doesn't need to visit it for review flow. The agent comments on GitHub, but the *signal to Tim* lives in his preferred surface.

## Why this matters more than ad-hoc review

- **Compounds without Tim's attention** (Principle #17 — preserves human attention for what matters)
- **Operationalizes the trust model** — turns "Lonnie owns quality" from aspiration to enforced reality
- **Symmetric with how Tim wants to work** — same pattern as auto-research, same as PostHog auto-fix, same as the SessionStart hook
- **Surfaces only judgment calls** — Tim sees PRs that need *him* (ICP boundary, strategic position trade-off, genuine architecture question), not routine review work
- **Auditable** — every review lives as a PR comment with reasoning, signed by the agent. Future audits can read the agent's logic.
- **Lonnie sees the same feedback** — transparency Principle (Trust Through Transparency + Shared Values) applies symmetrically

## Why we're not building it today

Applying the framework to itself:
- **Conduit launch is still the active closure metric** (Match Closure Metric to Goal).
- Building this loop is meaningful infrastructure, not a 30-minute task — webhook routing, edge function, agent definition with scoped tools, comment-formatting templates, escalation surface integration. Decision 0003-shape effort.
- **Patience over code** — the manual-cherry-pick + ad-hoc review pattern works *well enough* for the current PR volume (3-5 PRs/week). Build when volume earns it.
- **Bridge already exists**: the SessionStart hook surfaces open PRs (shipped today). Adequate visibility for now without the full agent loop.

## What to do in the meantime (lightweight version)

Until the full loop exists, do this:

1. **SessionStart hook surfaces open PRs** — ✅ shipped 2026-05-12. Tim sees all open PRs across his repos at session start. No need to visit GitHub.
2. **Manual agent-mediated review on request** — Tim or Lonnie can say *"review PR #N"* and Claude Code runs the appropriate skill chain manually. Gets ~80% of the value with 0% of the infrastructure cost.
3. **Lonnie's standing process** (already in his profile) — security pre-flight (no-secrets rule), gstack skill chain for architecture-shaped work, surface to Tim on the documented escalation list.
4. **Auto-merge via the `harness` skill loop directive** — when an agent applies a Harness decision that completes a chain item, it updates OPEN_LOOPS automatically. Same pattern; same trust shape.

## Falsifiability — when to actually build this

Build the full PR Review Loop when at least two of these are true:

- Conduit is shipped and has paying users (primary closure satisfied).
- PR volume crosses ~10/week (manual review becomes the bottleneck).
- Tim catches himself reviewing PRs he shouldn't need to (visible friction proves Lonnie autonomy isn't fully realized yet).
- A bad PR ships because nobody flagged it (failure surfacing gap proves the need for systematic review).
- Lonnie asks for it (he sees the gap from his side).

## Implementation sketch (when ready)

- **Trigger**: scheduled task at 15-min cadence via `mcp__scheduled-tasks__create_scheduled_task` — calls `gh pr list --state open --json ...` for each repo, compares against last-seen hash, kicks off review for new/updated PRs.
- **Agent definition**: a `pr-reviewer` agent with tool access:
  - `gh` for PR read/comment/merge
  - Filesystem read on the relevant repo
  - Harness `FIRST_PRINCIPLES.md` read
  - Project `.agent/AGENT.md` read
  - Slack send (with author=agent, not Tim — so Lonnie sees "PR Reviewer" not "Tim")
- **Review template**: PR comment format with severity-grouped findings, Harness lens output, recommended action
- **Escalation surface**: write to FreedomOS `command_center_items` table with type `pr_escalation`, OR Claude Code push notification
- **Audit trail**: every review run logged to `harness/proposals/pr-reviews/{date}-{repo}-{number}.md`

## Relationship to other loops

This loop **composes** with three others:

- **Auto-research loop** (decision 0003): when the PR Review Loop catches a recurring issue, it can propose a Harness refinement → goes through the auto-research approval gate. Loop feeds loop.
- **PostHog Auto-Fix Loop** (in OPEN_LOOPS): PostHog generates auto-fix PRs → those PRs flow through the PR Review Loop for the same security/ICP/principles checks. Same downstream pipe.
- **SessionStart hook**: the surface for *visibility*. The PR Review Loop is the *action*. Hook says "here are the PRs"; Loop says "here's what happened with them."

## The bigger pattern

This is the third explicit instance (after decisions 0003 and the PostHog loop) of the **"agents do the work that compounds; humans get attention only on judgment calls"** meta-pattern. The pattern is the meta-architecture Tim is building toward across his entire stack:

- Auto-research keeps Harness honest
- PostHog Auto-Fix keeps code healthy
- PR Review keeps shipping safe
- timlinnet.com agent keeps brand-presence current
- *(future)* CRM auto-triage keeps relationships warm
- *(future)* Briefing auto-summarize keeps Tim oriented across companies

Each instance reinforces the pattern. Building one well makes the next one cheaper. Decision 0004 is one node in a graph; building it well is also building the meta-capability to build the others.
