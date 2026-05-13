# Changelog

The framework is itself a feedback machine (Principle #8). This log captures major structural shifts and additions.

## v7 — 2026-05-13

Silent-mode discipline codified in `harness` and `office-hours` skills.

**New section in `skills/harness/SKILL.md`**: "Silent mode is the default (read this first)". Three valid outcomes (silent terse / silent skipped / explicit invocation), two named failure modes ("Want me to run harness first?" forwarding the decision back, and silent skip from inattention), and a hard tripwire — 2+ constraints/forward-compat needs/anti-abuse requirements make the checklist mandatory. Auto mode is explicitly compatible: execute decisively on routine calls, but never override the product/architecture diagnostic.

**Parallel section in `skills/office-hours/SKILL.md`**: same three-outcomes structure, adapted for the YC-style diagnostic ("name the user, the wedge, the one premise that might be wrong" as the terse surface). The prior "When This Triggers" section renamed to "When Full Mode triggers" — silent-checklist runs always; full-design-doc mode triggers on the original mandatory list.

**Why this matters**: the prior phrasing had a soft default — agents would ask "want me to run harness first?" instead of running it silently and surfacing only what was substantive. That asks the user to make a decision they hired the framework to make. The new structure makes the silent checklist the default behavior, not an opt-in.

Catalyst: real use surfaced the failure mode repeatedly — without explicit "silent default" language, agents would either ask permission to think (annoying friction) or skip the diagnostic entirely on multi-constraint asks (silent quality loss). Codifying the rule with named failure modes makes it self-enforcing.

**For external adopters**: no install action required — `./install.sh` pulls the updated SKILL.md files on next run. Existing installs can `cp` the two files manually or re-run the installer.

## v6 — 2026-05-12

Skill-side directive added.

**New section in `skills/harness/SKILL.md`**: "Distribution sync (keep public harness aligned with local skill changes)". Codifies that user-level skill files in `~/.claude/skills/` are working copies; the same skills published here are distributable copies adopters get via `./install.sh`. Without explicit sync, working copies drift from distributable copies as Tim cherry-picks from gstack or refines prompts locally.

Directive: when you make a substantive change to a user-level skill (cherry-pick, HARNESS INTEGRATION marker, prompt refinement), also copy to `harness/skills/{skill}/` and ship a CHANGELOG entry. Skip for typos / personal-only customizations.

**Self-applying**: this v6 release itself follows the directive — the change was made to `~/.claude/skills/harness/SKILL.md` first, then synced to `skills/harness/SKILL.md` here, then this CHANGELOG entry written. First instance of the directive in action.

Catalyst: Tim spotted (2026-05-12) that the divergence risk between working copies and distributable copies was real and growing; needed an explicit directive in the canonical to prevent silent drift.

## v5 — 2026-05-12

Public release + distribution architecture.

**Repo restructured** for public adoption: `skills/harness/` (portable trigger skill) and `skills/gstack-adapted/` (4 lean adaptations of Garry Tan's gstack with HARNESS INTEGRATION markers) added; `install.sh` for one-command setup; detailed `INSTALL.md` for SessionStart hook + private-overlay pattern.

**Architecture decision**: public base + private overlay. Tim's specific worked decisions (0001–0005) moved to a private companion repo (`timlinnet/harness-private`). Public harness now holds universal framework + adapted skills + sanitized teaching decisions; private overlay holds Tim's specific calls and business context. Composition at runtime via the portable `harness` skill.

**Catalyst**: a FreedomOS customer (a vibe coder using Lovable) asked whether Tim's multi-role agent setup still works. Answering required a real public artifact — the customer pull-signal turned an internal todo into a customer-service moment + thought-leadership artifact simultaneously. *(Marketing is part of the product, Strategic Position #13, manifesting.)*

**For external adopters**: clone, run `./install.sh`, point your project's CLAUDE.md at `FIRST_PRINCIPLES.md`. Optional: set up your own private overlay for your worked decisions. See INSTALL.md.

## v4 — 2026-05-12

Trigger refinement, surfaced from real use.

**Added 1 heuristic**: *Fire on decision shape, not decision size.* Captures the lesson from the 2026-05-12 DOCX-upload retro — a 30-minute tactical task surfaced a materially better option (mammoth → HTML preserving tables) once Tim explicitly invoked Harness, that would have been missed on the prior size-based filter ("skip review for sub-1-hour fixes"). The corrected trigger is shape (real choice point yes/no), not size.

**Behavioral implication for agents**: proactively surface "harness this?" when decision-shape work appears, even without explicit invocation — promoted to a framework default, not a per-user preference. Any operator on the team benefits by default.

**Process note**: this content was sitting in Claude Code user-memory (where teammates wouldn't see it) — migrating it to the canonical reinforces the rule that *guidance about how to use Harness* belongs in the Harness repo, while *user-specific preferences* belong in memory. First instance of "active challenge produces a CHANGELOG entry" — the loop Harness's own "When Harness is not enough" section invites.

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
