# Decisions

Cross-cutting architectural decisions, numbered chronologically. Each decision uses the Harness Decision Template (see `../FIRST_PRINCIPLES.md` → "The Questioning Framework"):

- **Options** considered
- **Principles Engaged** — which entries from the canonical were load-bearing
- **Recommendation** with reasoning derived from those layers
- **Alternative bets not taken**
- **Falsifiability** — signals that would change the decision

## What belongs here

- Cross-project architectural decisions (location of canonical artifacts, naming, identity)
- Bets that span multiple businesses (which LLM tier, which integration pattern, build vs buy)
- Structural moves that the framework itself produced

## What doesn't belong here

- Project-specific operational decisions → belong in that project's `.agent/` directory
- Live business state (OKRs, KRs, finances) → belong in the FreedomOS Supabase
- Tactical implementation choices → belong in the codebase or its decision register

## Index

| # | Title | Date | Status |
|---|---|---|---|
| 0001 | [Portability of the canonical](0001-portability-of-the-canonical.md) | 2026-05-11 | Decided |
| 0002 | [Gstack sync, May 2026](0002-gstack-sync-may-2026.md) | 2026-05-12 | Decided |
