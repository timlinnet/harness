# Decisions

Cross-cutting architectural decisions, captured with the Decision Template from [`../FIRST_PRINCIPLES.md`](../FIRST_PRINCIPLES.md) → "The Questioning Framework."

## The public/private split

Harness uses a **public base + private overlay** architecture for decisions:

| Goes in **this folder** (public) | Goes in your **private overlay** |
|---|---|
| Sanitized teaching decisions (`examples/`) | Your specific worked decisions on your real businesses |
| Generic patterns ("build vs integrate", "evaluating an open-source dependency") | References to specific projects, products, customers |
| Methodology demonstration, not proprietary application | Strategic bets that reveal competitive positioning |
| Reusable templates anyone can adapt | Team relationship details, comp shape, etc. |

Why split: per the framework's own *Complexity compounds non-linearly* principle, manually scrubbing every decision before publishing forces multiplicative cost. Two-folder separation is a one-time architectural cost (additive).

For Tim's specific architecture decision laying this out, see Tim's private overlay decision 0005 ("Harness Distribution Architecture"). For your own setup, follow [INSTALL.md](../INSTALL.md) → "Optional: set up your own private overlay."

## What a decision looks like

Each decision file uses this template (from `../FIRST_PRINCIPLES.md` → "The Questioning Framework"):

```markdown
# 000N — [Title]

**Date**: YYYY-MM-DD
**Status**: Decided / Designed; deferred build / Superseded by 000M
**Decided by**: [name]
**Audience**: [who reads this]

## The decision
[What question this answers]

## Options considered
- A) ...
- B) ...
- C) ...

## Principles Engaged
- Principle/Position X applies because [reasoning]
- Tradeoff Y at stake because [reasoning]
- Alternative bets not taken: [list]

## How each option fared
[Table: option / verdict / eliminated by what]

## Recommendation
[Chosen option] because [reasoning derived from layers]

## Alternative bets not taken
[Falsifiability conditions]

## Falsifiability — when to revisit
[Signals that would change this decision]
```

The pattern: when a decision is significant enough to want to remember *WHY* + *HOW* it was made, capture it here. Routine tactical calls don't earn this; cross-cutting architectural / product / strategic calls do.

## Examples

Sanitized teaching decisions live in [`examples/`](examples/). These demonstrate the template applied to generic situations any adopter might face — useful as templates when writing your own first decision.

*(Coming: at least one worked example. For now, `examples/` is a placeholder — see the Decision Template above or Tim's private overlay for real examples.)*

## When to write a decision

The signal: you're about to make a choice, and you want **future-you (or your team)** to be able to recover *why* later. Without that future-you read, the decision doesn't need to be captured — it's just a tactical call.

Strong write signals:
- Architectural choices (where infrastructure lives, what abstraction shape)
- Strategic bets (build vs integrate, ICP focus, pricing)
- Cross-project patterns (how skills compose, how data flows across systems)
- Resolution of named tensions (when the framework's lenses pointed in different directions)

Weak / skip signals:
- "What variable name should I use?" — refactor freely
- "Which library for X?" — only if it locks you in for a year+
- "Should I add tests for Y?" — heuristic, not a decision

## Maintaining decisions

- **Status** field gets updated as decisions land or get superseded
- **Date** stays the original decision date; if revisited, add a new decision that supersedes
- Don't edit decided decisions to "fix" them in hindsight — write a new decision that supersedes the old one, link both ways. The framework's history is the audit trail.
