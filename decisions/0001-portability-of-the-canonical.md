# 0001 — Portability of the canonical

**Date**: 2026-05-11
**Status**: Decided
**Decided by**: Tim Linnet, with Harness framework applied as the gate

## The decision

Where does "First Principles for the AI Age" live?

## Options considered

- **A)** Stay in `freedom-ai/docs/` (project-scoped, original location)
- **B)** Shared git repo (`timlinnet/harness`) — cross-project, version-controlled, collaborative
- **C)** `~/.claude/` only — portable for Tim's Claude Code, local to one machine
- **D)** FreedomOS Supabase table — queryable via MCP
- **E)** MCP server exposing principles via tools — most sophisticated

## Principles Engaged

- **#6 Atomic primitives compose** → one canonical source > duplicated copies that drift
- **#7 Complexity compounds non-linearly** → fewer moving parts is the default
- **#8 Feedback loops compound** → location must support auto-research review with audit trail
- **#10 Tools become primitives** → use durable primitives (git + markdown) until friction earns the upgrade
- **#12 Dynamic > hardcoded** → infrastructure paths can be stable; user state cannot
- **#14 Complementary strengths** → location must serve Tim *and* Lonnie *and* future operators *and* agents
- **#16 Specification is the bottleneck** → this *is* the spec; it must be the most accessible, most-protected document in the company
- **#17 Asymmetric attention** → agents should pull relevant chunks, not bulk-load all 18 principles every session
- **Position — Context Shell Pattern** → FreedomOS holds *business state*; meta-architecture is not business state. Mixing them violates the position itself
- **Position — Agents as first-class citizens** → must be agent-readable from any project, any session
- **Heuristic — Simplification Trajectory** → architecture should get cleaner as primitives improve. Don't over-engineer now

## How each option fared

| Option | Verdict | Eliminated by |
|---|---|---|
| **A** Stay in `freedom-ai/` | ❌ | #6 (forces duplication for PCAI/other projects), #14 (Lonnie's PCAI work can't access cleanly), Context Shell Pattern (meta lives in project code) |
| **C** `~/.claude/` only | ❌ | #14 (Lonnie can't access machine-local path), #8 (no version control = no audit trail) |
| **D** Supabase table | ❌ | Context Shell Pattern (meta-architecture in business state DB), #7 (database for what is fundamentally a document), Simplification Trajectory |
| **E** MCP server now | ⚠️ Premature | Simplification Trajectory (build the abstraction before the source-of-truth proves stable). *Right answer eventually, wrong answer now.* |
| **B** Shared `timlinnet/harness` repo | ✅ | Honors all engaged principles. Only one that survives every test. |

## Recommendation

**Phase 1 (now)**: Option B — shared `timlinnet/harness` git repo.

Structure:
```
harness/
  FIRST_PRINCIPLES.md          ← the canonical doc
  CHANGELOG.md                  ← version history of the framework
  decisions/                    ← cross-cutting decision register (this file lives here)
  README.md                     ← orientation + how to reference from any project
```

Tim and any future operators clone to a stable path (`~/Documents/GitHub/harness/`). Each project's `CLAUDE.md` or `.agent/AGENT.md` references the absolute path. The `harness` skill (in `~/.claude/skills/harness/`) is portable across projects and loads from the canonical.

**Phase 2 (when friction shows up)**: wrap in MCP.

When one of these signals appears — agents loading the full 18-principle file when only 2-3 are relevant; needing principle retrieval from tools that don't read filesystem; auto-research loop wanting structured query — build an MCP server (`mcp__harness__*`) that wraps the markdown. Markdown stays canonical; MCP becomes the access layer.

This honors **Simplification Trajectory**: start with the simplest thing that works, promote to sophisticated primitives when friction earns it. It honors **Tools Become Primitives**: don't fight the future, but don't build for it prematurely either.

## Alternative bets not taken

- **MCP-first (E)**: betting markdown + git is sufficient for now. Could be wrong if agents start bulk-loading principles immediately.
- **Project-scoped (A)**: betting the framework is genuinely cross-project. Could be wrong if Lonnie's work stays 95% in FreedomOS.
- **`~/.claude/` only (C)**: betting multi-operator access matters. Could be wrong if Lonnie doesn't need direct edit rights.

## Falsifiability — signals to watch

- Agents loading the entire principles file when only 2-3 principles are relevant → time to promote to MCP (Phase 2)
- Lonnie hitting git friction that blocks edits → location may need simpler than git
- Need to reference principles from a tool that doesn't support filesystem access → MCP signal
- Multiple projects start diverging on which version of principles they reference → enforcement gap, need stricter sync

## Note on meta-significance

This decision is itself the proof we wanted of the framework: applying the principles to "where should this document live" produced a clean answer with named alternatives and explicit falsifiability. If the framework can reason about its own home, it can reason about anything that touches the bridge.
