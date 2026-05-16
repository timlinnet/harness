# First Principles for the AI Age

> A framework for builders, founders, and pioneers making decisions in an era where intelligence is cheap, capability is expanding faster than we can map, and wisdom remains scarce. Lives at the wiring layer — between user context (the moat) and AI primitives (LLMs). This doc is the bridge.

> **Audiences**: Agents read 🤖 sections at runtime. Builders (the human team and any agent-CEO operators) read everything. Sections marked 🏗️ are builder-only context.

> **Status**: v5 (2026-05-12) — public release. The framework is itself a feedback machine — refinements expected as the world signals. See `CHANGELOG.md` for evolution history.

---

## How to read this doc

Entries are sorted by **layer**, because each layer changes at a different rate and demands different treatment:

1. **🪨 First Principles** — irreducible truths about LLMs/agents/users/builders that follow from physics, economics, or observed dynamics. Change rarely. If these shift, everything downstream re-derives.
2. **🎯 Strategic Positions** — *bets* that follow from principles + values + business context. Real and important, but contingent. Each carries a *"could be wrong if..."* condition and a map of *alternative bets* we are not making.
3. **📐 Heuristics** — rules of thumb. Generally true, situationally false. Tested against outcomes.
4. **🔧 Tactics** — specific implementation choices that follow from the above. Refactored constantly. 🏗️ Builder-only.

**Why this matters**: Mix the layers and you'll either treat tactics as sacred (rigidity) or treat principles as flexible (drift). Sorted, each layer gets the right respect.

**Anti-fallacy note** — *Incremental growth ≠ preserve everything.* Kaizen means continuous improvement, not "never rewrite." When structure is wrong, a clean rewrite that carries content forward is the cheapest improvement. Catch sunk-cost reasoning before it dresses up as a principle.

---

## How we hold this framework 🤖

This framework is a working hypothesis, not doctrine. Hold it accordingly.

- **Humility** — every entry below can be wrong. Especially the bets, possibly the principles. What looks like indecision is often the right posture: knowing we have more to learn. Don't confuse confident phrasing with proven truth.
- **Active challenge is the practice** — bring the framework to every decision, *and* bring every decision back to the framework. If the framework keeps producing answers that feel wrong, the framework is what's wrong. Re-examination isn't a quarterly ritual; it's continuous.
- **Comfort with named bets, discomfort with hidden assumptions** — bets aren't bad. Un-named bets are dangerous. Strategic Positions are explicitly contingent so you can diversify, hedge, or pivot. The failure mode is dressing a bet up as a principle (rigidity) or dressing a principle up as a bet (false uncertainty).
- **Sunk-cost vigilance** — when existing structure is wrong, rewrite is the cheapest improvement. Kaizen does not mean preservation.
- **Lean on principles, but don't fake it** — preferring first principles over bets is healthy, but forcing a bet into principle-clothing makes it more dangerous. Some decisions are *genuinely* bets. Name them and live with the contingency.

---

## The Canyon Model 🤖

Three regions, one bridge:

```
    USER CONTEXT                  WIRING HARNESS               AI PRIMITIVES
   ┌──────────────┐             ┌──────────────────┐          ┌─────────────┐
   │ Vision       │             │ Skills (logic)   │          │ Claude      │
   │ OKRs         │  ←━━━━━━━→  │ Tools (MCPs/CLI) │  ←━━━━→  │ Grok/xAI    │
   │ Finances     │             │ Principles (here)│          │ GPT/etc     │
   │ Team         │             │ Agents           │          │ Future      │
   └──────────────┘             └──────────────────┘          └─────────────┘
     "the moat"                    "where decisions             "what does
                                    are made"                    the reasoning"
```

- **Left ledge** — User context. The platform's job is to hold and protect this. Combined with trust, it is the durable moat.
- **Right ledge** — AI primitives. Improving on a curve we don't control. Our job is to ride, not compete.
- **The bridge** — Where our work lives. Business logic (skills), tools (MCPs/CLIs/custom), and these principles — the structure that decides how user context meets AI capability.

Every architectural and product decision lives on the bridge. The principles below gate those decisions.

---

## 🪨 First Principles

The bedrock. Follow from physics, economics, or observed dynamics. Re-derive everything if these shift.

### 1. Context is finite and ordered 🤖
Transformer context windows have edges; order matters; attention degrades with length. Even at 1M tokens, dumping everything is wasteful. **Therefore: progressive disclosure** — agents retrieve what they need when they need it, not by default. Self-discovery (Principle #13) is this same principle applied to capabilities.

### 2. Models improve monotonically 🤖
Capability has expanded every year for the past decade. Compute scaling, training improvements, and algorithmic gains compound. **Therefore: architecture must be a substrate, not a container** — don't bake current model limits into the design. Build harnesses that get *more* useful as models improve, not less relevant. (See also Principle #18: cost collapses on a parallel curve.)

### 3. Model capability is opaque and expanding 🤖
You cannot fully enumerate what a frontier model can do. The known surface is smaller than the actual surface, and the gap is growing. **Therefore: boil the ocean — within a defined focus.** Once the goal is set, lean into the full capability surface. Once unfocused, the same instinct becomes distraction. Focus is the constraint that makes "boil the ocean" productive instead of dilettante.

### 4. Models are heterogeneous in capability 🤖
Different training data, architecture, and post-training produce different strengths and outputs for the same query. Mechanical fact — follows from the diversity of LLM development paths. **Therefore: design interfaces (tools, prompts, harness) such that any frontier model can plug in.** The downstream bet that *no single LLM stays best durably* is contingent and lives as a Strategic Position (Model Diversification).

### 5. LLM reasoning is flexible; scripts are rigid 🤖
A model adapts to context a script cannot anticipate. The reverse is also true: a script gives deterministic guarantees a model cannot. **Therefore: deterministic when safety/correctness demands it; non-deterministic when adaptation outweighs guarantees.** Don't script what an LLM can do natively. Don't ask an LLM to do what a script must guarantee.

### 6. Atomic primitives compose; bundled features don't 🤖
A set of *n* atomic tools can produce 2^n behaviors through composition; *n* bundled features produce *n*. **Therefore: prefer atomic primitives, let capability emerge from composition.** New features = new compositions (or new prompts), not new code.

### 7. Complexity compounds non-linearly 🤖
Cognitive load, maintenance cost, and surface area scale super-linearly with system complexity. Adding a feature is rarely additive — it's multiplicative against everything it touches. **Therefore: simplicity is the default; complexity must earn its place.** Simplification is itself a feature, not a polish step. The architecture should get *cleaner* as LLMs improve, not more complex.

### 8. Feedback loops compound; one-shot improvements don't 🤖
A system with feedback that improves itself outperforms an equivalent system without feedback within finite cycles. Compound interest in code. **Therefore: build feedback machines, not just features.** Approval/denial cycles. Skill evolution. Score updates. Notes that compress over time. The whole system gets smarter through cycles, not rewrites. Kaizen is the human-scale version of this same principle.

### 9. Token economics favor planning 🤖
Correcting a wrong path costs more tokens than planning a right one (re-prompt + context replay vs. cheap analysis up front). **Therefore: plan before executing** for non-trivial work — for agents and humans alike. The quality of output is proportional to the quality of the plan. Strategy first, action second.

### 10. Tools become primitives 🤖
Today's tool (image gen, video gen, web browsing, code execution, voice synthesis) becomes tomorrow's native primitive of a frontier model. The absorption pattern is consistent. **Therefore: don't compete with the trajectory, ride it.** Build a harness that gets *more* useful as models absorb capabilities, not less relevant. Wrappers get squeezed; substrates compound.

**The gap-filler caveat**: a primitive that doesn't exist yet is a real gap, and the user's need supersedes our architectural purity. Integration code that bundles smaller tools to fill that gap is honest work — not a violation of "atomic primitives." Two failure modes to avoid: *(a)* refusing to build the gap-filler because it's "not pure" (user need unmet), and *(b)* refusing to refactor when the primitive lands (sunk cost). Design every gap-filler so it can be deleted cleanly when the primitive catches up. **Also**: when the user already has tools that work, port and connect rather than rip-and-replace — meet them where they are (see *Meet users in their existing tools* in Strategic Positions).

### 11. LLMs lack native user context 🤖
A frontier model trained on the internet does not know *this user's* business, OKRs, finances, team, calling, or history. That gap is structural — training data is shared, user state is private. **Therefore: user context is what only the platform can provide.** Whoever holds it well, paired with trust, owns durable value. This is the principle under the Context Shell strategic position.

### 12. Dynamic > hardcoded 🤖
Context drifts faster than code can be updated. A hardcoded value embedded in a prompt or tool description becomes stale within weeks. **Therefore: derive at runtime from source-of-truth** — user state, brand guidelines, connected tools, current OKRs — rather than embed. Prompts should be dynamic by user; tool descriptions should be dynamic by capability.

### 13. Self-discovery is progressive disclosure for capabilities 🤖
Principle #1 applied to tools, not just data. Agents should be able to discover *what's available* on demand, not have it all loaded at start. **Therefore: agents find and equip their own tools at need.** Search for capabilities, load schemas on demand, request access scoped to the task. The ToolSearch pattern (deferred-tool registry with schema-on-demand) is a working example.

### 14. Complementary strengths > monolithic capability 🤖
Different intelligence types — humans, LLMs, specialized tools — have different strengths and structural weaknesses. A single agent, human, or tool cannot dominate every task; combinations outperform monoliths in finite cycles. **Therefore: compose complementary strengths.** A founder hires a complementary operator for the strengths they lack (e.g., loop closure, marketing execution). The harness combines human judgment with LLM breadth. We use multiple LLMs because each is strong in different places. Don't fight a strength — partner with it; don't pretend to cover a weakness — pair around it. This principle gives the deepest case for both human teams and model diversification.

### 15. Intelligence is abundant; wisdom is scarce 🤖
LLMs have **intelligence** — knowledge, recall, pattern-matching, speed, breadth. LLMs do not have **wisdom** — lived experience, values, embodied judgment, moral compass, knowing what *matters* for *this* user in *this* moment. The gap is structural: training data captures what was written, not what was *learned through living*. **Therefore: design systems where wisdom directs and intelligence executes.** The wise human is the irreducible input; the LLM is the leverage. This is the bedrock under "User = Director" — founder agency matters because wisdom is what you bring that AI cannot. It is also why we don't let agents make consequential decisions alone, and why faith-aligned framing has structural backing, not just values backing.

### 16. Specification is the bottleneck 🤖
When intelligence is cheap and abundant, the rare skill becomes *clearly specifying what to build*. "Can it be built?" used to be the constraint; now the constraint is "do we know what we want?" Karpathy's "English is the new programming language" — but English alone isn't enough; *clear* English is. **Therefore: invest disproportionately in spec/planning/design tools; treat unclear specs as the actual blocker; protect the time of the spec-writers.** The office-hours → ceo-plan-review → engineering-review skill chain is not bureaucracy; it is the spec-writing apparatus. Design matters more in the AI era, not less.

### 17. Asymmetric attention is the leverage point 🤖
Humans have finite attention. AI has effectively infinite attention (within tokens) and never tires. **Therefore: AI pre-processes, triages, filters, summarizes; humans decide consequentially.** The harness is the conduit that transfers AI's infinite attention into human-grade signal. This is the deeper case for the Context Shell — the platform exists to preserve human attention for the decisions that need it. Briefing items, summaries, surfaced patterns, prioritized inboxes — all are forms of attention-asymmetry exploitation. The leverage of human+AI teams over either alone lives in this asymmetry.

### 18. The cost of intelligence collapses monotonically 🤖
Compute prices drop. Training costs drop. Inference costs drop. Structurally true for a decade and continuing. **Therefore: optimize for capability and correctness now; cost optimizations come naturally.** Don't build cost-saving workarounds for what will soon be cheap. Today's expensive inference is tomorrow's free primitive. This principle parallels Principle #2 (capability expands) — they are co-moving forces but separable: capability could expand while cost rises, or cost could fall while capability plateaus. Both compound in our favor.

---

## 🎯 Strategic Positions

Bets — real, important, contingent on principles + values + business context. Each carries *"could be wrong if..."* and *alternatives* (the bets we are *not* making). Re-examine when the world gives signal.

### Agent = Employee 🤖
We design agents as employees who earn trust over time, not as stateless chatbots or scripts. Memory. Learning. Judgment. A bet on continuous relationship over transactional exchange.

*Could be wrong if* model providers absorb persistent memory + reasoning natively at scale — then "employee" collapses into "platform feature."

*Alternatives*: agent = stateless tool (no identity, no memory); agent = expert-on-demand (specialist consulted, no persistent identity); agent = orchestrator (delegates but doesn't execute).

### User = Director 🤖
The user carries vision, mission, moral compass. The agent executes. The agent is the CFO/COO/CMO the user couldn't afford to hire. Bet rooted in founder agency + the reality (Principle #15) that LLMs have intelligence but not wisdom.

*Could be wrong if* users prefer to be served rather than direct (some founder personalities), or if agents become trustworthy enough to set direction themselves.

*Alternatives*: user = collaborator (equal partner with the agent); user = oracle (consulted only on key calls); user = customer (served, not directing).

### Agents as first-class citizens 🤖
Agents can accomplish anything in the UI that a user can accomplish through chat. Parity, not partial coverage. Bet on UI ↔ agent interchangeability as the durable interface model. Follows from Principle #6 (atomic primitives compose).

*Could be wrong if* the UI becomes secondary to chat entirely (then "parity" is wasted), or if some UI affordances genuinely can't be replicated agent-side (then partial parity is honest).

*Alternatives*: agents as power-user shortcuts (subset of features only); agents as back-of-house automation (not user-facing); UI-first with agents as supplement; no agents (better UI alone).

### Context Shell Pattern — focused-ICP edition 🤖
The moat is not "we hold user context" generically. The moat is: **willingness of a focused ICP to share their specific, unique context with a trusted harness over a generic LLM.** The "trusted" part comes from being narrow enough to deeply serve them. The "specific, unique" part is what no generic LLM can recreate from public training data. The bet is that focus + trust unlocks context-sharing that scales into durable value. **This is the single most load-bearing strategic position — if it's wrong, the company premise is wrong.**

*Could be wrong if* AI primitives absorb context management natively (users hand context to ChatGPT/Grok directly with no harness needed); or if the focused ICP is too small to scale; or if trust mechanisms commoditize.

*Alternatives*: broad horizontal context shell (any user, any context, less depth); single-vertical specialist (one focused domain, no portfolio); we-handle-context-but-not-execution (consultant model); we-build-the-LLM (vertical foundation model).

### Trust Through Transparency + Shared Values 🤖
Two distinct trust dimensions, both load-bearing:

1. **Transparency** — show reasoning, admit uncertainty, distinguish data from interpretation, never invent metrics. Trust as legibility.
2. **Shared Values** — communicate care about the same things the user cares about (their calling, their family, their stewardship). Trust as values-alignment, not just legibility.

Most products lean on one. We bet on both because the ICP cares about both — they want to see the work *and* feel that we get them.

*Could be wrong if* users prefer results over reasoning (trust = outcomes); or values-signaling backfires in mixed audiences; or trust commoditizes around brand instead.

*Alternatives*: trust through results only; trust through scale ("everyone uses it"); trust through credentials/brand; trust through community.

### Business-Native communication 🤖
Speak business, not technical. "Revenue grew 12%," not "the query returned." "Leads," not "Flow." Bet that non-technical founders are the durable market and that register-shifting is cheap for LLMs (Principle #5).

*Could be wrong if* the durable market is actually technical-savvy founders (different ICP) or if non-technical founders adopt technical language fast enough that the gap closes.

*Alternatives*: technical-native (assume engineering-savvy users); bilingual (toggle); task-native (ignore language entirely, focus on actions and outputs).

### Native Over Integration 🤖
Deep platform integration, not thin API wrapper. Follows from Principle #10 — we want to be *above* the absorption line, not below it. Wrappers get squeezed; substrates compound.

*Could be wrong if* integration-only platforms turn out to be more defensible (e.g., Zapier scale economics) or if "native" depth doesn't translate into the moat we think.

*Alternatives*: thin wrapper (just route to the LLM); best-of-breed integrator (deep partnerships with existing tools, no native opinion); agnostic platform (no opinions at all).

### Connector Hierarchy 🤖
When wiring an external service, work down a context-typed tier hierarchy and stop at the first tier that fits. The bet is that *integration is a fallback*, not a default — and that the right tier shrinks the maintenance surface, rides the right primitive, and survives vendor changes longer than ad-hoc choice does.

**Cloud-runtime variant** (edge functions, serverless, agent backends):

```
0. Native LLM primitive          (delete the integration; the model does it)
1. Vendor-maintained MCP server  (vendor ships and maintains the wrapper)
2. Vendor-maintained SDK         (typed library that absorbs auth + retry + schema drift)
3. Reputable community MCP/SDK   (third-party with visible maintenance)
4. Hand-wired REST               (last resort; design for deletability)
```

**Local-runtime variant** (IDE / dev tooling) elevates the vendor-maintained CLI above SDK, since shelling out is natural in that context and CLIs are typically vendor-maintained one tier deeper than SDKs.

**Sub-heuristic — "Own utility, federate identity"**: within tier 1 (vendor MCP), three buckets govern OWN-vs-BYO:
- **User-data services** (vendor holds the user's data or identity) → **BYO**. User connects their own account through the vendor's OAuth flow; the platform facilitates but doesn't custodian the credentials.
- **Utility services** (stateless API; no user account at the vendor matters) → **OWN**. Platform-owned key, optional credit markup. User has nothing to gain by owning.
- **LLM / AI provider services** → **OWN by default**, BYO as a power-user option for high-volume cost control.

The hierarchy operationalizes Principle #10 (tools become primitives — design for deletability) + Principle #6 (atomic primitives compose — vendor MCPs are atomic) + Principle #12 (dynamic > hardcoded — vendor MCP servers absorb schema drift the way our REST wrappers cannot). It is not in tension with *Native Over Integration*: consuming a vendor MCP does not make us a wrapper of that vendor; we stay above the wrapper line by composing many vendor MCPs into our agent layer. The position fires whenever a new external service decision lands — including the "should we even integrate?" question, which the tier-0 option forces.

*Could be wrong if* the MCP ecosystem fragments or stalls (fewer than ~50% of vendors a builder uses ship MCP servers within 12 months), OR vendor MCP servers prove materially less reliable than direct REST endpoints over 6+ months of real use, OR primitive absorption stalls and the tier-0 deletion bucket fails to materialize. In those worlds, the hierarchy demotes from a Strategic Position to a situational heuristic.

*Alternatives*: wrapper-of-everything (no hierarchy — every vendor gets a custom integration); SDK-first across the board (skip the MCP tier entirely); defer adoption until MCP standardizes further (let other platforms eat the early-adopter cost); build a gateway abstraction layer that hides the underlying transport (adds operational complexity that only earns its keep at high migration count).

### Match closure metric to goal 🤖
"Done" means different things in different operating modes. For internal compounding work (platform / agent infrastructure): a capability is "done" when it completes a full business-value cycle — closing loops prevents 90%-done work from accumulating as technical debt. For customer-facing product launches: shipping to customers is the loop; over-closing internally becomes its own distraction from external value delivery. The position is: *name the operating mode and choose the closure metric that fits.*

The underlying principle (Loop Closure as a universal) was too strong — for builder-types it's a corrective against feature-creep avoidance of marketing, which is exactly why pairing with a complementary operator helps. The honest framing is: closure is contextual.

*Could be wrong if* a universal "done" metric is achievable (we haven't seen evidence); or if mode-switching becomes cover for never closing anything.

*Alternatives*: always close every loop (Tim's natural temptation, ships nothing); always ship without closing (the opposite failure, accumulates debt); single metric for all modes (forces square peg into round hole).

### Marketing is part of the product 🤖
Distribution is not "what happens after we ship" — it is part of what we ship. A great product unshipped is worth zero; a great product shipped without marketing is worth almost zero. Bet that founders who treat marketing as core build durable companies; founders who treat it as separate build perfect, invisible ones.

This is the strategic correction to a specific failure mode: a builder's loop-closure temptation to add features instead of shipping marketing. A complementary operator may be hired exactly because this position needs enforcement. Naming it here makes the bet legible across all decisions, not just personal sprint planning.

*Could be wrong if* the product is so unusually good it markets itself (rare in practice — even great products had marketing).

*Alternatives*: marketing as separate department (handed off post-launch); product-led growth without explicit marketing; founder-led sales only (works at small scale, breaks down later); paid acquisition only (skip organic).

### Model Diversification 🤖
We design for interchangeability between LLMs — tool interfaces, prompts, and harness architecture all assume any frontier model can plug in. Bet *against* single-winner outcomes in LLMs. Tim's current preferences: Opus 4.7 for some workloads, xAI 4.3 for others — the harness supports both.

*Could be wrong if* one provider achieves persistent dominance (e.g., compute scale lets one pull decisively ahead; a single player wins infrastructure economics; or a single founder's organizational continuity becomes a single point of failure for one provider specifically) — then optionality becomes wasted cost.

*Alternatives*: best-of-breed bet on a single provider; bet on open-source frontier catching up; agnostic stance with provider-specific optimization layers.

### Meet users in their existing tools 🤖
Don't ask users to rip-and-replace their working stack. Port what they're already using; integrate with where their data already lives; let them choose what to migrate vs. what to bridge. Bet that adoption friction is the durable failure mode — products that win the existing-tool-respect battle win.

*Could be wrong if* users become so tool-agnostic that switching costs collapse, or if AI primitives absorb tool-switching entirely (the agent does the porting transparently).

*Alternatives*: opinionated rip-and-replace ("our system or none"); modular but uncomposable (each user assembles their own stack); we-build-everything-natively (no integrations).

---

## 📐 Heuristics

Rules of thumb. Generally true, situationally false. Test against outcomes; revise when reality disagrees.

### Safe archive, never hard-delete 🤖
`status: 'archived'` with timestamp, not `DELETE`. Agents make mistakes; users change minds. Recovery > finality. Only permanent deletion requires explicit user confirmation through the UI.

### Patience over code 🏗️
If a feature is 80% achievable today but a known model improvement makes it trivial in 3 months, consider waiting. Anti-pattern: shipping a wrapper for a capability that's about to land natively. (Strengthened by Principle #18 — cost will collapse too.)

### Simplification trajectory 🏗️
The architecture should get *cleaner* over time as LLMs improve. Workarounds get removed when models absorb the capability. If complexity is going up, something is wrong — and the right response may be a rewrite, not an extension (per the anti-fallacy note).

### Speak in business outcomes, not engineering activity 🤖
"We closed the loop on the lead-routing flow" beats "We deployed an edge function with realtime subscriptions." Especially in summaries to the user.

### Fire on decision shape, not decision size 🤖
The trigger for invoking Harness (and the wider review stack — `office-hours`, `ceo-plan-review`, `engineering-review`, `investigate`) is *whether the work contains a real choice point*, not how big the work is. Small decisions routinely hide the highest-leverage option surfaces — especially around format, friction, ICP fit, and false binaries. A 30-minute task with two viable approaches needs the framework just as much as a 3-day build; the analysis cost is 3–5 minutes either way and the upside is surfacing options the operator hadn't seen.

**Practical rule for any agent operating with Harness:** when you see decision-shape work (A vs B, include vs skip, build vs buy, do-it-the-obvious-way vs is-there-a-better-way), surface "harness this?" *before* executing — even if the user hasn't explicitly invoked the skill. One-line prompts, not gatekeeping. Skip only when the work is pure execution of an already-approved plan: typo fixes, applying a pre-approved migration, deploying a reviewed change. Origin: the 2026-05-12 DOCX-upload retro, where a "trivial" 30-minute decision surfaced a materially better third option (HTML extraction preserving tables vs raw-text dropping them) that would have been missed on size-based filtering.

### Render-rich format for review-heavy output 🤖
The reader's ability to read is part of the deliverable. If they can't take in what you produced, you haven't shipped — even if the file exists.

When producing output the user needs to *review* — audits, plans, eng-reviews, design docs, anything >~100 lines with diffs, tables, mermaid diagrams, or comparative structure — default to **HTML**. Markdown in chat scrollback fragments visual structure: diffs lose syntax highlighting, tables get squished, mermaid blocks don't render, sections that were supposed to carry meaning become a wall the reader scrolls past.

Short content inline in chat is fine. The rule fires for review-heavy long-form output:

- **Review draft → HTML**, in a path the chat UI can serve (session folder, `/tmp/<session>/`, environment-specific — let the operator's CLAUDE.md or memory layer pick the right path for their setup).
- **Final committed artifact → markdown**, in the codebase, after the user approves.

Two-phase: render-rich for the review pass, plain-text for the durable codebase artifact.

Anchored to Principle #17 (asymmetric attention is the leverage point) — review time is the user's most expensive resource. Format that maximizes signal per unit attention. Origin: 2026-05-14 retro — a harness audit produced a 400-line markdown file the user couldn't open in chat (link-resolution edge case); the friction cost them the ability to push back on the audit before forwarding it onward. Rule generalized: regardless of why a particular markdown link fails, render-rich is strictly higher fidelity for review-heavy output.

*(Note: previous heuristics "Graceful Degradation" and "Workaround-First Mindset" were consolidated into the gap-filler caveat on Principle #10.)*

---

## 🔧 Tactics 🏗️

Implementation choices that follow from the above. Refactored constantly. Builder-only.

- **Business logic = skills** in Claude Code (`.agent/skills/<name>/SKILL.md`). Could change if the harness shifts; the principle ("encode business logic in the harness's portable primitive") stays.
- **Tool access = MCPs, CLIs, custom edge functions.** Same caveat.
- **Realtime when agents have CRUD** — if an agent can write to a table, the UI must subscribe via realtime (Principle: agents-as-first-class-citizens demands UI ↔ agent parity).
- **`.agent/` directory convention** — file layout tactic, project-scoped.
- **Decision register pattern** — `architecture-alignment.md` tracks numbered architectural decisions with date, rationale, and status. Lives separately from this principles doc.
- **Skill chain for architecture-shaped work**: `office-hours → ceo-plan-review → engineering-review → build → qa-testing → deploy`. The spec-writing apparatus (Principle #16). Safety net for changes affecting MCP schemas, agent execution pipelines, RLS, the agent core, and similar load-bearing surfaces.
- **Identity routing by git email** — multi-operator file (founder + operators + future) uses `git config user.email` to load the right profile and FOCUS file.

---

## The Questioning Framework 🤖

When facing a decision (build / architecture / product / business / team / personal), apply this gate.

**The Five Questions** — delete is the strongest lever:

1. **Is this important?** Or is it a distraction dressed as opportunity?
2. **Can we delete it?** If yes, do.
3. **If we can't delete, can we simplify?** What's the minimum that delivers the value?
4. **Can we accelerate?** Same result in less time?
5. **Can we automate?** Same result without us?

**The Architecture Lenses** — for decisions that touch the bridge:

- Does this deepen the moat (focused-ICP context + trust)?
- Does this ride a primitive that's improving (capability + cost), or compete with it?
- Is it dynamic-by-user, or static?
- Does it close a loop, or open a new one — and is closure the right metric for this goal?
- Does it honor complementary strengths (use the right intelligence type for the work)?
- Does it preserve human attention for what matters (Principle #17)?
- Is the spec clear enough to be a real spec (Principle #16)?
- Are wisdom and intelligence in the right places (wisdom directing, intelligence executing)?
- Is shipping/distribution part of this plan, not after?
- Is the structure right — or is a rewrite cheaper than incremental refactor? *(Watch for sunk-cost dressed up as Kaizen.)*

**The Decision Template** — when documenting a decision:

```
## Options
A) [option]
B) [option]

## Principles Engaged
- Principle/Position X applies because [reasoning]
- Tradeoff Y at stake because [reasoning]
- Alternative bets not taken: [list]

## Recommendation
[Option] because [reasoning derived from the layers above]
```

---

## What lives elsewhere 🏗️

This doc covers principles, positions, heuristics, and tactics. The following live elsewhere by design:

- **Specific architectural decisions** (Multi-Step vs AI-First, Anti-Bottleneck phases, Skills v2, etc.) → `architecture-alignment.md` (decision register)
- **ICPs and target user profiles** → product/marketing docs (`.agent/icps/` or equivalent)
- **Project-specific operating insights** (per-project Strategic Posture, vertical specifics) → project-level `.agent/AGENT.md`
- **Skill definitions and runbooks** → `.agent/skills/<name>/SKILL.md`
- **Live business state** (OKRs, KRs, finances, team rosters) → your platform's source-of-truth datastore, queried via MCP — never embedded as markdown
- **Open dependency chains** → `OPEN_LOOPS.md`

---

## Updating this doc 🏗️

This document is itself a feedback machine (Principle #8). It updates by the same principles it encodes.

- **First Principles** change rarely. Treat changes here with high scrutiny — they cascade through everything downstream.
- **Strategic Positions** are re-examined whenever the world gives signal — model providers absorbing a capability we bet on, an ICP segment changing, faith/values evolving, a competitor proving an alternative bet. Not annually; *continuously*. Each position's *"could be wrong if..."* and *alternative bets* fields make signal recognition concrete.
- **Heuristics** are tested against outcomes. If a heuristic produces bad decisions repeatedly, sharpen or remove it.
- **Tactics** are refactored constantly without ceremony.

**Auto-research input**: new candidate principles surface from the operator's idea capture, their reading (X.com, papers), and team experience. A weekly scheduled review proposes additions or refinements; the framework owner approves before merge. (The mechanism for this loop is its own work item — see related skill design.)

**The framework decides about itself**: where this document lives, when it triggers, who edits it, are all questions answered *by* this framework. The portability decision (this doc lives in a shared portable location, not project-scoped) is the first worked example.
