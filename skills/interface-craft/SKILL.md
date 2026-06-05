---
name: Interface Craft
description: The craft authority for any UI work — vision-based, system-first. Render → see → critique → fix → re-score against the brand and the customer's journey stage. A surface must cohere with its app, not just look good alone. Promote the value, protect the faith. Based on Josh Puckett's Interface Craft + gstack design skills (MIT). Triggers on design, redesign, critique, polish, refine, audit, "does this look right", before-ship visual check, craft.
---

# Interface Craft — the craft authority (Harness)

> **Source**: the critique methodology is Josh Puckett's [Interface Craft](https://www.interfacecraft.dev) (Design Critique) + gstack design skills (MIT). This Harness skill promotes that vision-critique engine into the substrate and adds the Harness seam. Portable — any driver (operator / teammate / agent) inherits it.

The craft authority — **"is this well-made?"** — for any UI work. Distinct from *what* to build (office-hours / ceo-plan-review) and *would the ICP want it* (icp-consult). It is **vision-based and structural, not a remembered checklist**: the failure it kills is a quality bar that depends on someone *remembering* to apply it (*Guarantee by construction, not by vigilance*). You render the surface, **look** at it, critique, fix, and **re-score** — every time UI changes. When craft and brand-literalism conflict, **craft judgment wins** (the authority); the brand supplies the tokens, the craft says whether the result is good.

## 0. The non-negotiable first principle: system-coherence, not single-page

**A surface must cohere with the system it lives in — the nav, the header, the sibling pages — not just look good alone.** A beautifully crafted page dropped into an app with a different visual language is *more* disjointed, not less (the warm-island problem). So:

- **Always screenshot the surface IN CONTEXT** — with the surrounding chrome (sidebar, banner) visible — never the page cropped in isolation. Most coherence failures are invisible until you see the page sitting inside the app.
- **Ground color, card language, type scale, density, and warmth are SYSTEM decisions, not page tweaks.** Changing them on one page when the rest of the app differs is a coherence *regression* even if the page improves alone. A real system shift is a deliberate, coordinated pass across the app — often the *hire-a-design-agent* rung of *Generative Gap Resolution*, with a `DESIGN.md` / brand source updated first — not a one-page experiment.
- Josh Puckett's consistency lens ("does it feel like one designer made it?") is **elevated from within-page to whole-system.** First question of every critique: *does this look like it belongs to the same product as the screen next to it?*

## 1. Establish context (before looking)

- **What is this surface, and what is its job?** A settings/handoff page's job is a calm trustworthy handoff; a landing page's job is to show the dream; a dashboard's job is dense legibility. The job sets the bar.
- **What journey stage is the user at?** Pull it from the `icp-consult` (it's a required input there). A *cold prospect* wants feeling + proof; a *committed power-user mid-app* wants directness + concrete outcome and reads emotional copy as noise. **Match register to stage.** On an empty/undefined stage, refuse-to-assume and surface it (*Generative Gap Resolution*) — don't silently default to "cold."
- **What brand?** Load it dynamically: `get_brand_guidelines(companyId)` for company-scoped output; the app's design tokens / `DESIGN.md` for app chrome. Never invent a palette — palette drift is the single most common craft failure (an audit found ~9 surfaces importing off-brand purple/blue that the brand never defined).

## 2. See it (vision loop — render, screenshot, look)

Render the surface and screenshot it **in context**. *Look* — don't infer from code. Code review catches structure; only the rendered screenshot reveals the wall-of-gray-text, the off-brand color, the island. Then critique what you actually see. (Code-level pre-screen is fine for triage; the vision pass is what scores it.)

## 3. Critique (Josh Puckett's dimensions, Harness-weighted)

Go dimension by dimension; don't merge them. Be specific, decisive, quantitative — count elements, name colors, measure relative sizes. Severity order: **structural** (wrong mental model / missing function) > **behavioral** (flow, feedback, states) > **visual** (color, type, spacing). Dimensions:

- **System-coherence** (§0, weighted first) — belongs to the same product as its neighbors?
- **Color intentionality** — every color on-brand and purposeful? (the recurring failure: off-brand palette, too many competing accents — one focal accent per view.)
- **Typographic hierarchy** — scannable without reading? clear h1>h2>body? no sub-legibility type (the ~10px floor).
- **Visual weight vs. importance** — the heaviest element is the most important one? (the primary action should *be* primary.)
- **Focusing mechanism** — a clear visual entry point, or does everything compete?
- **Uncommon care / state coverage** — empty, loading, error, hover/focus, the micro-moments. This is where good becomes great.
- **Redundancy & density** — appropriate to the job; nothing repeated; progressive disclosure.

Output: Context · First Impressions · Visual · Interface · Consistency · User Context · **Top 3–5 Opportunities** (ranked by impact). Voice: a senior designer reviewing with a respected junior — specific, honest, no hedging, no praise-padding, every problem paired with a direction.

## 4. The 10/10 model — what the score actually means

- **Mechanical craft → ~8.** Brand tokens, kill slop, full state coverage, hierarchy, type floor, **system-coherence**. This is programmable — a skill can reliably take a surface 5 → 8.
- **8 → 10 is taste, and it is three things:** **resonance** (it *feels* the way this user, at this stage, wants), **proof** (it *shows* the dream-outcome, not just describes it — most relevant on cold/marketing surfaces), and **register matched to stage**. The last mile needs the rendered-screenshot loop + iteration + ideally a human eye. Do not claim push-button 10.
- **Score discipline:** use `challenge_as_customer` (the icp-consult) as a *feeling-score input*, always with the journey stage. It **informs; it never gates; and it never overrides a values guardrail** (§5). An ICP sim optimizing for a persona will keep pushing toward what that persona wants — that is exactly why the human-set guardrail outranks the number.

## 5. Promote the value, protect the faith (the hard guardrail)

From *Trust Through Transparency + Shared Values* (v30):

- **Promote the value, quietly.** Speak to what the ICP genuinely lives by — family, time, freedom, stewardship, integrity, honesty — and only where it truly serves their success. A quiet undertone (one or two light touches), never a billboard: stated loudly it reads performative and *backfires* with a discerning ICP.
- **Protect the faith. The AI never authors faith content.** Knowing how to *speak* of faith is wisdom, not knowledge (#15) — the deepest identifying value belongs to the human. If a critique or an ICP score tells you to add prayer / scripture / "kingdom" language to lift the number, **refuse**: that is monetizing faith and crossing the wisdom ceiling. Surface the option to the human to author; never write it yourself.

## 6. Fix → re-score (close the loop)

Apply the top opportunities, re-render, re-screenshot in context, re-critique. A surface isn't done at "the diff applied" — it's done when the rendered result, in context, holds the bar. Loops, by construction, beat one-shot checklists (#8).

## Nomenclature

- Drivers are **operator / teammate / agent** (the *Clarity Over Gates* taxonomy). Write for whichever is using the surface.
- For MCP-client surfaces, say **"your coding agent"** (it works with any — Claude Code, Cursor, etc.), with their logos — not one vendor's name. More accurate and more specific.
- **Business-native voice** (speak outcomes, not engineering activity).

## The Harness seam

- Consumes `icp-consult` (journey stage + the ICP feeling-score) and `Generative Gap Resolution` (refuse the empty brand/stage; the hire-a-design-agent rung for system-level work).
- Feeds the *Integrity Gate* — craft becomes a 4th values-adjacent check on agent-produced visual output (image, page, content), alongside accuracy / compliance / values.
- Pairs with *Clarity Over Gates*: the skill sharpens the driver's eye; it doesn't gate. The score informs; the human (or graduated agent) decides.

*Origin: 2026-06-05 — promoted from Josh Puckett's Interface Craft while taking a FreedomOS surface from a 5 to an 8 and learning, the hard way, that a beautiful page in a cool-gray app is an island (system-coherence), that register must match journey stage, and that an ICP score must never buy a faith line. Catalyst: CHANGELOG v31.*
