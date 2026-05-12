# 0002 — Gstack sync, May 2026

**Date**: 2026-05-12
**Status**: Decided
**Decided by**: Tim Linnet, with Harness framework applied as the gate
**Audience**: Tim, Lonnie, any future operator working in this codebase

## The decision

How do we sync with `garrytan/gstack` upstream after an 8-week gap (Mar 17 → May 12)?

## Context — what changed in gstack

- **268 commits** since Tim's last sync.
- **Versions jumped from v0.5.4 → v1.33.2.0** (gstack reached v1.0.0.0 with a "simpler prompts + real LOC receipts" rebrand).
- **Three thematic shifts**:
  1. **G-Brain integration** (v1.12 through v1.33) — gbrain is gstack's cross-session memory system, with skills like `setup-gbrain`, `sync-gbrain`, gbrain manifests, transcript ingest.
  2. **Skill restructure** — top-level skill dirs (not nested under `.agent/skills/`); naming standardized to `plan-ceo-review`, `plan-eng-review`, `plan-design-review`.
  3. **~30+ new skills** added: `skillify`, `make-pdf`, `codex`, `pair-agent`, `learn`, `cso`, `health`, `canary`, `careful`, `guard`, `freeze`/`unfreeze`, `landing-report`, `setup-deploy`, `land-and-deploy`, `context-save`/`context-restore`, plus all the gbrain skills.

## The size-divergence finding

Tim's installed skills are **3-7× smaller** than upstream's current versions:

| Skill (Tim's name) | Tim's lines | Upstream lines (gstack name) | Ratio |
|---|---|---|---|
| ceo-plan-review | 664 | 2128 (`plan-ceo-review`) | 3.2× |
| engineering-review | 250 | 1655 (`plan-eng-review`) | 6.6× |
| office-hours | 348 | 2094 (`office-hours`) | 6.0× |
| autoplan | 345 | 1733 (`autoplan`) | 5.0× |

The expansion is mostly **gstack-internal scaffolding** — testing harnesses, gbrain wiring, AskUserQuestion floors, preamble tuning, validation gates, voice patterns. Much of it doesn't apply to Tim's Claude Code workflow.

## Options considered

- **(A)** Full sync — pull upstream HEAD into each skill. **Verdict: rejected.** 3-7× skill bloat violates the Simplification Trajectory heuristic and burns context budget every session for scaffolding Tim doesn't use.
- **(B)** Selective cherry-pick — identify upstream additions that match Tim's workflow, pull only those; preserve Tim's lean adaptations + Harness integrations. **Verdict: chosen.**
- **(C)** Skip the sync entirely — stay on Mar 17 baseline indefinitely. **Verdict: rejected.** Leaves real improvements unclaimed (Opus 4.7 tuning, long-skill drift fix, mode-posture fix).
- **(D)** Re-fork — start over from upstream HEAD and re-apply Tim's adaptations + Harness integrations. **Verdict: rejected.** High effort, throws away Tim's accumulated taste.

## Principles Engaged

- **Heuristic — Simplification Trajectory** → architecture should get cleaner as primitives improve. 3-7× skill bloat goes the wrong direction.
- **Principle #17 — Asymmetric attention is the leverage point** → loading 2000-line skills every session burns context Tim's agents need for actual work.
- **Heuristic — Patience over code** → gstack itself is moving fast; tight sync today is rework tomorrow. Loose alignment is better.
- **Principle #14 — Complementary strengths** → Garry's expansion is for gstack's internal use cases (testing harnesses, gbrain, multi-harness portability). Tim's strengths lie in lean Claude-Code-specific adaptations.
- **Principle #10 — Tools become primitives** → many upstream gbrain skills will be absorbed into Claude Code primitives over time. Building hard dependencies on gbrain now is premature.
- **Strategic Position — Native Over Integration** → Tim is committed to Claude Code; deep gbrain integration would be a wrapper-around-a-different-harness, exactly the failure mode this position protects against.

## Recommendation

**Selective cherry-pick. Three tiers:**

### Tier 1 — pull now (high signal, low cost)

| Item | Source | Why | Effort |
|---|---|---|---|
| Long-skill drift fix (task-shaped learnings + mid-flow refresh) | v1.33.1.0 | `investigate`, `qa`, `ship` were drifting from starting context over multi-phase flows. If Tim's investigate suffers the same, the fix is worth the ~20 lines. | S |
| Mode-posture energy fix | v1.1.2.0 | Fixes `plan-ceo-review` and `office-hours` "scope drift" — when EXPANSION silently slides into HOLD or vice versa. Tim's installed versions are pre-v1.1.2.0. | S |
| Opus 4.7 model overlay | v1.5.2.0 | Tim's primary model. Garry shipped voice/routing tuning specific to Opus 4.7. Worth pulling. | S-M |
| AskUserQuestion cadence improvements | v1.10.0.0, v1.25.0.0, v1.25.1.0 | Reduces redundant user-prompting in long skills. Aligns with Principle #17 (preserve human attention). | M |

### Tier 2 — evaluate when relevant (medium signal, scoped cost)

| Item | Source | When relevant |
|---|---|---|
| `make-pdf` skill | v1.4.0.0 | When Tim needs to produce a polished PDF report (e.g., a Conduit pitch, Linnet Biopharm filings). |
| `skillify` skill | (post-v1.0) | When Tim wants to *create* a new skill — meta-tool for skill authoring. |
| `pair-agent` skill | (post-v1.0) | When Tim wants two agents collaborating on a single task. Relevant to Linnet Labs autonomous R&D. |
| `context-save`/`context-restore` | v1.0.1.0 (was `/checkpoint`) | When Tim's sessions get long and he wants to checkpoint state. |
| `learn` skill | v1.3.0.0 | Cross-session learnings capture. Relevant to Harness's auto-research loop. |
| `cso` skill | (post-v1.0) | Chief Security Officer mode — useful before exposing Conduit to real customers. |

### Tier 3 — skip (low fit for current setup)

| Item | Why skip |
|---|---|
| `setup-gbrain` + all gbrain skills | Tim is staying in Claude Code. gbrain is a different harness model. Per Native Over Integration: don't build dependencies on a competing substrate. |
| `codex` skill | Codex-specific (different model + harness). Tim uses Opus 4.7 + Claude Code. |
| `openclaw/skills/*` | OpenClaw-specific variants. Same reasoning. |
| Conductor worktree fix (v1.33.2.0) | Tim doesn't use Conductor worktrees. Niche fix. |
| Most testing-harness additions | gstack-internal, not user-facing skill behavior. |
| Browser sidebar / browser-skills | gstack has its own browser stack; Tim uses Claude in Chrome + Claude Preview MCPs. |

## What's already protected by our Round 3 integration

The 4 integration edits we made (`harness` skill, ceo-plan-review 0C-ter fix, engineering-review Step 0.5, office-hours Phase 1 ambient load, autoplan Phase 0.5 Harness load) use `<!-- HARNESS INTEGRATION START/END -->` markers. When pulling Tier 1/Tier 2 items, the pattern is:

1. Diff upstream change against Tim's current file
2. Apply the upstream change *outside* Harness integration markers
3. Re-verify Harness integration block is intact
4. Test by invoking the skill on a real decision

## Naming reconciliation (for future syncs)

Tim's installed names → upstream gstack names:

| Tim | Upstream |
|---|---|
| `ceo-plan-review` | `plan-ceo-review` |
| `engineering-review` | `plan-eng-review` |
| `design-audit` | `plan-design-review` (or `qa-design-review` — needs verification) |
| `design-consultation` | `design-consultation` ✓ |
| `office-hours` | `office-hours` ✓ |
| `investigate` | `investigate` ✓ |
| `autoplan` | `autoplan` ✓ |

For sync scripts in the future, build a name-map alias file rather than renaming skills (renaming breaks Tim's CLAUDE.md and workflow references).

## Falsifiability — when to revisit this decision

- **If gstack stabilizes** (months without major restructure) → consider a tighter sync model.
- **If Garry deprecates the gbrain bet** → re-evaluate the skip-gbrain decision.
- **If Tim's installed skills feel insufficient** (decision quality drops; Harness lenses aren't catching things) → audit which upstream additions might fill the gap.
- **If a Tim-specific lean fork becomes maintenance-heavy** → consider a "Linnet gstack lite" fork that just maintains the lean adaptations.

## For Lonnie

If you're reading this fresh: gstack is Garry Tan's open-source skill suite (github.com/garrytan/gstack, MIT licensed). Tim's installed versions in `~/.claude/skills/` are *lean adaptations* of older gstack — most of them are 3-7× smaller than the current upstream. We are intentionally not doing a full sync. The lean versions are doing real work; the upstream expansion is mostly scaffolding for gstack's own use cases (testing, gbrain, multi-harness).

When you make architectural or product decisions: invoke the `harness` skill (it auto-loads from `~/Documents/GitHub/harness/FIRST_PRINCIPLES.md`). When you make code-shaped decisions, the chain is: `harness → ceo-plan-review → engineering-review → build → qa-testing → deploy`. The `harness` skill is the principles substrate; ceo-plan-review and engineering-review apply expert wisdom (Bezos/Munger/Brooks/Fowler etc.) and produce review artifacts (mermaid diagrams, lake score, decision audit trail).

If you have questions about whether something should be pulled from gstack, the framework's answer is: does it pass Principles #17 (preserve attention), Simplification Trajectory (cleaner over time), and Native Over Integration (don't build wrappers around competing harnesses)? If yes → pull. If no → skip.

## Cadence going forward

- **Quarterly review** of gstack changelog — Tim or Lonnie scans, opens decision entry like this one if there's anything Tier-1-worthy.
- **No automatic sync** — selective cherry-pick is the standing pattern until gstack stabilizes.
- **Harness integration markers must survive** any pull — re-verify them post-merge.

## Note on G-Brain

G-Brain is Garry's competing harness/memory model. It's interesting and well-engineered. We are explicitly not pursuing G-Brain integration because:

1. Tim is committed to Claude Code as primary harness.
2. Native Over Integration says: don't build dependencies on a competing substrate.
3. Tools Become Primitives (#10) says: cross-session memory will likely land natively in Claude Code (or via a Tim-built MCP layered on Supabase). Building on gbrain now is premature.

If G-Brain becomes a clear winner in the harness market over the next year, revisit this decision.
