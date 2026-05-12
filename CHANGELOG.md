# Changelog

The framework is itself a feedback machine (Principle #8). This log captures major structural shifts and additions.

## v5 — 2026-05-12

Public release + distribution architecture.

**Repo restructured** for public adoption: `skills/harness/` (portable trigger skill) and `skills/gstack-adapted/` (4 lean adaptations of Garry Tan's gstack with HARNESS INTEGRATION markers) added; `install.sh` for one-command setup; detailed `INSTALL.md` for SessionStart hook + private-overlay pattern.

**Architecture decision**: public base + private overlay. Tim's specific worked decisions (0001–0005) moved to a private companion repo (`timlinnet/harness-private`). Public harness now holds universal framework + adapted skills + sanitized teaching decisions; private overlay holds Tim's specific calls and business context. Composition at runtime via the portable `harness` skill.

**Catalyst**: a FreedomOS customer (Kendall, vibe coder using Lovable) asked whether Tim's multi-role agent setup still works. Answering required a real public artifact — the customer pull-signal turned an internal todo into a customer-service moment + thought-leadership artifact simultaneously. *(Marketing is part of the product, Strategic Position #13, manifesting.)*

**For external adopters**: clone, run `./install.sh`, point your project's CLAUDE.md at `FIRST_PRINCIPLES.md`. Optional: set up your own private overlay for your worked decisions. See INSTALL.md.

## v4 — 2026-05-12

Trigger refinement, surfaced from real use.

**Added 1 heuristic**: *Fire on decision shape, not decision size.* Captures the lesson from the 2026-05-12 DOCX-upload retro — a 30-minute tactical task surfaced a materially better option (mammoth → HTML preserving tables) once Tim explicitly invoked Harness, that would have been missed on the prior size-based filter ("skip review for sub-1-hour fixes"). The corrected trigger is shape (real choice point yes/no), not size.

**Behavioral implication for agents**: proactively surface "harness this?" when decision-shape work appears, even without explicit invocation — promoted to a framework default, not a per-user preference. Lonnie and any future operator benefit by default.

**Process note**: Tim spotted the gap that this content was sitting in Claude Code user-memory (where Lonnie wouldn't see it) and asked it be migrated to the canonical. Reinforces the rule that *guidance about how to use Harness* belongs in the Harness repo, while *user-specific preferences* belong in memory. This entry is the first instance of "active challenge produces a CHANGELOG entry" (the loop Harness's own "When Harness is not enough" section invites).

## v3 — 2026-05-11

Gap analysis + retitle.

**Renamed** from "Agent-Native Principles" to **"First Principles for the AI Age"** — broader scope, captures discipline + era + audience. The framework spans architecture, product, business, team, and personal operating decisions, not only agents.

**Added 4 principles**:

- **#15 — Intelligence is abundant; wisdom is scarce.** LLMs have intelligence; humans have wisdom. The gap is structural. Bedrock for "User = Director."
- **#16 — Specification is the bottleneck.** As intelligence becomes abundant, the rare skill is clearly specifying what to build. Justifies the spec-writing apparatus.
- **#17 — Asymmetric attention is the leverage point.** Humans have finite attention; AI doesn't. The harness transfers AI's infinite attention into human-grade signal.
- **#18 — Cost of intelligence collapses monotonically.** Parallel curve to capability gains (#2). Optimize for capability now; cost optimizations come naturally.

**Added 1 strategic position**: Marketing is part of the product (corrective to feature-creep avoidance of distribution).

**Added 4 lenses** to the Questioning Framework (one per new principle, plus the marketing position).

## v2 — 2026-05-11

Editorial pass — Tim challenged assumptions, surfaced new concepts.

**Added**: "How we hold this framework" section (epistemic stance — humility, active challenge, comfort with named bets), Principle #14 (Complementary strengths > monolithic capability), Strategic Positions for Model Diversification and Meet users in their existing tools, "Alternative bets" map on every Strategic Position.

**Refined**: Trust Through Transparency expanded to include Shared Values. Loop Closure reframed as "Match closure metric to goal" (closure is contextual). Principle #4 split (heterogeneity = bedrock; no-single-winner = bet). Context Shell sharpened to focused-ICP framing. Principle #10 gained the gap-filler caveat.

**Consolidated**: Graceful Degradation and Workaround-First Mindset folded into Principle #10 (not strongly anchored as standalone heuristics).

## v1 — 2026-05-11

Initial consolidation.

**Replaced** three structurally inverted predecessors with one properly-layered canonical doc:
- `freedom-ai/docs/AGENT_PHILOSOPHY.md` (true principles hidden in a "builder only" section)
- The principles portion of `freedom-ai/.agent/skills/native-first-decision/SKILL.md` (framework mixed with a specific decision and implementation detail)
- The principles-relevant portions of `freedom-ai/.agent/backlog/architecture-alignment.md` (decisions sometimes promoted to bedrock when they were really decisions)

**Structure**: four layers (First Principles → Strategic Positions → Heuristics → Tactics). 13 first principles, 10 strategic positions, 6 heuristics, 7 tactics, plus the Canyon Model, Questioning Framework, and Decision Template.

**Key restructuring**: the "Native-First Operating Principles" section turned out to be mostly strategic positions when honestly sorted — true principles had been hidden in "🏗️ Builder Context" labeled "agents don't read this." Inversion corrected.
