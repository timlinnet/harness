# Output Artifacts

> **Scope**: where the review/planning skills persist their durable outputs, and the format rule for review-heavy content. Generic conventions — any adopter can wire the same paths into their own `.agent/` directory.

Anchored to Principle #1 (context is finite and ordered) and #8 (feedback loops compound): a review is only worth its artifact if the artifact survives the conversation and is discoverable by the next skill or session.

## The artifact paths

Skills write to a project-local `.agent/` directory:

| Artifact | Path | Written by | Read by |
|---|---|---|---|
| CEO plan (vision + scope decisions) | `.agent/ceo-plans/{YYYY-MM-DD}-{slug}.md` | `ceo-plan-review` (EXPANSION / SELECTIVE modes) | downstream reviews, future sessions |
| Engineering review | appended to `implementation_plan.md` → `## Engineering Review` | `engineering-review` | the build |
| Test plan | `.agent/test-plans/{slug}.md` | `engineering-review` | your QA / verification step, before it generates its own scope |
| Design doc | `.agent/design-docs/{YYYY-MM-DD}-{slug}.md` | `office-hours` | `ceo-plan-review`, `engineering-review` |

Rules:
- One artifact per review; date-and-slug the filename so history accretes rather than overwrites.
- Downstream skills check `.agent/{ceo-plans,design-docs,test-plans}/` during their pre-review audit — so an upstream doc is picked up automatically. This is the loop-closure mechanism *between* skills.
- Adapt the root (`.agent/`) to your project's convention; keep the relative shape.

## Render-rich format for review-heavy output

When a review output exceeds ~100 lines, or contains diagrams / comparison tables / failure-mode matrices, render it as **HTML for the review pass** before committing the markdown artifact. Markdown-in-chat scrollback fragments mermaid diagrams and wide tables; HTML preserves them for a clean read. The final on-disk artifact stays **markdown** (diffable, greppable); the HTML is only the review surface.

(This is the 📐 Heuristic *"Render-rich format for review-heavy output"* from `FIRST_PRINCIPLES.md`, stated as a concrete contract the skills follow.)
