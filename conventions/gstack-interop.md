# gstack Interop

> **Scope**: how Harness relates to [gstack](https://github.com/garrytan/gstack) (Garry Tan's MIT-licensed developer framework), for adopters who run both. If you only run Harness, you can skip this — the published skills are self-contained and have no gstack dependency.

## Stance: complement, not fork

Harness and gstack do different jobs and are designed to **stack, not compete**:

- **🪨 Harness** — bedrock first principles + strategic positions, the Questioning Framework, the Decision Template, and the loop system (OPEN_LOOPS maintenance). The *why* and the *judgment substrate*.
- **🧠🔧 gstack** — applied expert cognitive patterns + the execution machinery for running a review (scope modes, forcing questions, diagrams, lake score, decision audit trail). The *how* of running a rigorous review at depth.

gstack is an improving primitive — it ships frequently. The Harness bet (Principles #2, #10, #18: ride primitives that improve; don't compete with them) is to **cherry-pick and delegate, never fork**. Forking a multi-thousand-line upstream skill means fighting an improving primitive and inheriting a maintenance treadmill. Harness instead keeps a thin layer where *its own* value lives, and lets gstack own the process.

## Two variants of the review skills

The review skills (`ceo-plan-review`, `engineering-review`, `office-hours`, plus `autoplan` as their orchestrator) can exist in two forms:

| Variant | When | Shape |
|---|---|---|
| **Self-contained** (published default) | You do **not** run gstack | Inlines the full review process. Zero dependency. This is what `install.sh` ships. |
| **Delegating shim** (opt-in) | You **also** run gstack | ~50 lines: load Harness substrate → **delegate the process to the installed `gstack-*` twin** → apply the Harness seam → emit the Decision Template → loop maintenance. |

The shim is the leverage move once gstack is installed: you stop maintaining a fork of gstack's methodology (it tracks upstream automatically) and maintain only the Harness seam — the part that is irreducibly yours.

### The shim shape

```
1. Load Harness substrate     — principles + project context
2. Run gstack methodology     — read & follow the installed gstack-<twin> at full depth
3. Apply the Harness seam     — compliance gate · conflict rule (Harness wins) · Decision Template
4. Output contracts           — see conventions/output-artifacts.md
5. Loop maintenance           — update OPEN_LOOPS on chain completion
```

### Precedence (resolving the trigger collision)

Installing gstack registers `gstack-*` skills that trigger on the same intents as the Harness review skills. Resolve it by **precedence, not deletion**:

- **The Harness skill wins** for its intent — it runs gstack's process *via delegation* and adds the layers gstack lacks. **Never invoke the raw `gstack-*` twin directly** for a project governed by Harness.
- **Keep gstack installed** — it's the source you delegate to, and the many other gstack skills with no Harness equivalent are pure value.
- **`autoplan` stays the orchestrator**: it runs the *Harness-wired* review skills, so the seam propagates through every stage. Don't point it at gstack's own autoplan — that would bypass the seam at each sub-review.

## The seam: what Harness adds that gstack does not

gstack carries no Harness substrate. The seam — preserved identically in both variants — is:

1. **Principle Compliance Gate** — cross-check every option against the Harness principles + strategic positions before recommending.
2. **Conflict rule** — when a gstack recommendation collides with a Harness principle, **Harness wins**; surface it as a challenge rather than silently following.
3. **Decision Template** — close in Options / Principles Engaged / Recommendation.
4. **Loop maintenance** — update OPEN_LOOPS on chain completion.
5. **Output contracts** — see `conventions/output-artifacts.md`.

## Maintenance

gstack ships frequently; you don't need to track every release. Sync on **signal, not calendar**:

- When gstack ships something you want: for self-contained skills, copy the methodology in; for shims, you get it automatically (you delegate to the installed copy).
- If gstack restructures a skill in a way that breaks the delegation contract, fall back to the self-contained variant for that skill and note the divergence.
- Keep a record of which skills are shims vs. self-contained in your setup, so the state is visible.

**Attribution**: gstack is MIT-licensed by Garry Tan. The self-contained skills preserve `Source: Adapted from gstack` headers; the shims name the twin they delegate to. Honor the license — name the origin.
