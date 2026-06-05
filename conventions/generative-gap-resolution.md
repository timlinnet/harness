# Convention: Generative Gap Resolution — refuse the empty layer, resolve by rung

The detailed mechanics of the *Generative Gap Resolution* Strategic Position. When a driver — operator or agent — hits a **capability gap**, the substrate's job is to **recognize it loudly and generate the right-rung resolver on demand**, never to pre-build every capability.

## The two halves

### 1. Refuse an empty foundational layer; surface it (loud recognition)

A *foundational layer* is context that downstream work silently assumes: the ICP, the brand, the customer-journey stage, the wisdom/values layer. When it is **empty or undefined**, the failure mode is *silent default* — the work proceeds on a confident wrong guess.

Worked failure: an ICP consult (`challenge_as_customer`) given no customer-journey stage assumed "cold prospect," scored an in-app settings page as if it were a marketing landing page, and prescribed warmth that a committed power-user reads as *noise*. The same page scored differently the moment the stage was supplied. The bug was the silent default, not the page.

The fix is structural, not a reminder (*Guarantee by construction, not by vigilance*): a **gate** that refuses to proceed on an empty foundational layer and surfaces the emptiness. FreedomOS already ships one instance — the **wisdom-gate** ("refuse autonomous OKR-authoring on an empty wisdom layer + emit `wisdom_gate_blocked`"). Generalize it: *any* empty foundational layer (journey, brand, ICP) → refuse-to-assume + surface.

**Adopter funnel.** The gate lives in the substrate, so it fires for a Harness adopter who is **not** a customer of any context-holding product. For them, the noise *is* the value reveal: it shows exactly where a product like FreedomOS earns its place — the thing that holds and resolves that context so the gap stops recurring. The substrate enforces the discipline for everyone; the product makes resolving it effortless.

#### Three states — and *proposal-from-evidence ≠ authorship* (refinement 2026-06-05)

A foundational layer is not binary. It has **three** states:

| State | Meaning | Resolver |
|---|---|---|
| `done` | set + meaningful | — |
| `empty` | no signal anywhere — genuinely blank | **author from blank** (the guided next-action ladder) |
| `unsynthesized` | exists in the driver's world (their site, revenue, words, connected docs) but was never *pulled together* | **synthesize a grounded draft → human ratifies/edits** |

The trap the third state fixes: an established driver hits a blank field for something they *do* have (in their head, in their artifacts), and either (a) feels re-interrogated and bounces, or (b) types a hollow placeholder (`"we help people"`) that clears a naive non-null check and poisons everything downstream (the wisdom-gate's `WisdomLayerHollow` failure). **Both naive fixes — push the form, or accept the self-declaration — land in a named hole.**

The resolver for `unsynthesized` is **harvest → reflect a draft → sharpen by disagreement**:
1. **Harvest before asking** — read the signal the driver already produced (their site, their top customers by revenue, connected docs). Arrive already understanding the business; the driver feels *seen*, not interrogated.
2. **Reflect a grounded draft** — present each tenet as a strawman *with its evidence shown beside it* (*Trust Through Transparency*: distinguish data from interpretation, so ratification is informed, not a rubber-stamp).
3. **Sharpen by disagreement** — corrections are the high-signal, low-effort input. **Recognition over recall**: judgment on a draft beats authorship from a void.

**The authorship boundary (the knife-edge).** Synthesizing a draft does **not** breach *"agents don't author the wisdom layer"* (#15 / *User = Director*) under two conditions, both required:
- **Grounded, not invented** — the draft is synthesized from the driver's *own* signal. The agent is a mirror, not an author. (Inventing numbers from nothing is the forbidden act — the Javier failure.)
- **Ratified, not committed** — nothing enters the layer until the human confirms or edits. `authored_by` stays the human.

The line: *an agent may propose a grounded strawman; the human authors by ratifying.* This is the structural defeat of the hollow-layer failure — an evidence-grounded, human-edited tenet **cannot** be the placeholder a `length > 10` check only hopes to catch (*Guarantee by construction, not by vigilance*). And because the synthesis routinely surfaces a gap the driver didn't know they had (*"your site sells segment A, but 70% of revenue is segment B"*), **the friction-reducer and the day-one value delivery are the same move** — onboarding flips from a tax into a payoff.

**It scales with available signal, it isn't two discrete modes.** Rich signal (established owner, site + financials) → confident draft, mostly confirmation. Thin signal (clean slate, one landing page or a sentence in chat) → tentative draft, more co-creation. No signal at all → the degenerate case → fall back to authoring-from-blank. Signal-availability is derived live (#12), so the surface picks the path itself.

### 2. Resolve by the cheapest rung; graduate up as the need recurs or scales

There is no fixed line between "note it" and "build a primitive" — there is a **ladder**. Climb only as far as the need justifies (Patience over code, #7 — complexity must earn its place). The disambiguating question is *what kind of gap is it?*

| The gap is really… | Resolve it as | Generated, on demand, by |
|---|---|---|
| knowledge the LLM already has | inline — reason it out | (nothing persists) |
| context/state for this user | a **note / markdown** (→ primitive only if universal) | the driver writes it; an agent keeps it current |
| a **method that recurs** | a generated **skill** | `skill-creator` / gstack skill-gen |
| **sustained ownership + judgment** | **hire an agent** (PhD-level expert) | the hire **interview** reverse-engineers the ideal employee |
| a missing **action / integration** | an **MCP / tool** | Connector Hierarchy (tier 0–4) |
| **core + universal** across all businesses | a **platform primitive** (like CRM) | built into the product, through the chain |

Each rung's resolver is **generated when the gap is hit** — Self-discovery (#13) raised from *tools* to *resolution forms*. Nothing is pre-built; the system generates the right-rung resolver the moment a driver needs it.

**A single need stacks rungs.** Don't pick one. A customer journey is *context* (note/store it) → *owned* by a Growth agent (sustained judgment) → who may pull an *MCP* (richer journey tooling) → *graduates* to a primitive if it proves universal. The climb is the design, not a contradiction. Start at the cheapest rung that resolves the immediate need; graduate only when the need recurs (a skill earns its place after the 2nd–3rd repeat) or scales (a primitive earns its place only when it is core across users — #7: complexity must earn it).

## The resolver-router

Something has to (a) recognize the gap, (b) pick the starting rung, (c) recognize when to graduate. That is the **resolver-router**, and it lives in two places in lockstep:

- **Substrate (this convention).** Any driver — operator or agent — self-routes a gap by walking the ladder above. Portable; works with or without any product. This is the *Clarity Over Gates* "every tool gap unlocked by an agent feeds back" made into a standing method.
- **Runtime (a Chief-of-Staff persona).** A product-side persona that recognizes gaps in conversation and routes to hire / skill / MCP / primitive — the thing that decides "it's time to hire a Growth agent for this." In FreedomOS this is the Chief of Staff (Linnet); it is the runtime embodiment that *rides* this convention.

## Worked example — customer-journey-stage awareness

The instance that surfaced this convention, sequenced down the ladder:

1. **Loud recognition first** — the ICP consult must declare/require the customer-journey stage; on an empty journey, refuse-to-assume and surface it (extend the wisdom-gate). See `conventions/icp-consult.md`.
2. **Cheapest rung — note it** — the consult takes journey-stage as an explicit input (the surface knows its own stage); a journey doc/markdown holds the map. No primitive yet.
3. **Ownership rung — an agent** — a Growth/Marketing agent owns the customer value journey, keeps the map current, and makes surfaces stage-aware. For a user without that agent, the Chief of Staff surfaces "define your journey, or hire an agent to own it."
4. **Primitive rung — later, only if universal** — a customer-journey-stage primitive (CRM-shaped) graduates into the platform *only* once it proves core across users. Premature today (Patience over code).

## FreedomOS runtime implementation (downstream, through the chain)

The substrate is this convention. The product-side implementation — generalizing the wisdom-gate to all foundational layers, and building the Chief-of-Staff resolver-router — touches the agent pipeline and a trust surface, so it goes through the full chain (office-hours → ceo-plan-review → engineering-review → /cso → build), tracked as its own loop. Not autonomous.

The `unsynthesized`-state resolver (synthesize-then-ratify) has its own FreedomOS instance — **extraction-by-synthesis onboarding**, which composes over the loud-setup-state surface to turn empty tenets into evidence-grounded drafts the operator confirms. Same chain, tracked as its own design (`.agent/design-docs/2026-06-05-extraction-by-synthesis-onboarding.md`).

---

*Origin: 2026-06-05 — surfaced while making a FreedomOS surface stage-aware; the customer-journey gap exposed the general pattern (recognize → route → generate). Routed to Harness because gap-resolution discipline helps every operator and adopter, not one project. Catalyst + taxonomy rationale: CHANGELOG v29.*
