# Changelog

The framework is itself a feedback machine (Principle #8). This log captures major structural shifts and additions.

## v22 — 2026-06-03

**A new 📐 Heuristic — *Fire on orchestration shape, not orchestration size* — plus the framework's first `UserPromptSubmit` wake-hook, so multi-agent fan-out actually surfaces at the moment it would accelerate the work.** The decision model for *when* to fan out already existed (a machine-local memory); what was missing was a canonical, adopter-shippable home for it **and** a firing surface — because context-resident rules under-fire (the sibling *Fire on decision shape* is on record going dormant: *"I never get challenged by those principles… which is concerning"*).

**What v22 adds**:
- **New 📐 Heuristic `Fire on orchestration shape, not orchestration size`** (`FIRST_PRINCIPLES.md`, sited as the deliberate sibling of *Fire on decision shape*): the 5-point fan-out test + the cost×reversibility disposition that reconciles "never ask permission" with the fact that orchestration is an expensive, weakly-reversible spend.
- **New `conventions/orchestration-shape.md`** — the human-facing contract: the fan-out test, the cheap-vs-expensive disposition table, the never-ask reconciliation, the "independence is the trap" canary rule, graceful absence, and background leverage.
- **New `scripts/workflow-shape-wake.sh`** — a `UserPromptSubmit` hook (the framework's first non-SessionStart/Stop hook event). A deliberately **low-bar recall-raiser**: it fires on a single fan-out verb OR breadth token (after a pure-execution exclusion), once per session, and injects ONE sentence pointing the agent at the fan-out test. It never decides — the agent's semantic 5-point test is the precision filter, so a text false-positive costs one discarded sentence, never operator attention.

**Why a heuristic + a wake-hook, not a skill or a tight resolver**: the recognizer — *"is this moment orchestration-shaped?"* — is a fuzzy LLM pattern-match (Principle #5, the flexible-reasoning side), so it can't be a deterministic decider; only the downstream cheap-vs-expensive disposition is rigid enough to be resolver-shaped, and it lives in the convention as a lookup table. A dedicated skill was rejected: it solves *precision*, which was never the broken axis — **recall** was — and a skill's firing depends on the same model attention a context rule does. An earlier "tight" four-AND lexical hook was rejected too: tested, it stayed silent on its own flagship case ("read every edge function…") because humans phrase fan-out work in the singular collective *before* they've framed it as many-units — exactly the recall gap. The fix is to invert: fire on a LOW bar into a cheap semantic filter. (A SessionStart echo was also rejected — wrong altitude; a once-at-open reminder has no pull on a fan-out-shaped prompt many turns later.)

**Soak before adopters** (graduate-autonomy applied to the mechanism itself): the `UserPromptSubmit` / `additionalContext` channel is unprecedented in the author's setup. The hook is wired into the author's own machine first and must pass a 1–2 week soak — does the injected line reliably reach the model and move behavior on true positives, *and* not induce wall-of-text tune-out — before the opt-in `INSTALL.md` snippet ships to adopters. If it fails the soak, the keystone (heuristic + convention) stays and the hook comes out. Codifying the rule does **not** by itself fix recall — that remains a measured, open gap until a fire is observed (baseline: 4 of 10 recent sessions ran 20–33 serial reads across independent files with zero fan-out).

**Catalyst**: 2026-06-03. A multi-agent workflow mined recent sessions, measured the missed lift above, and ran the candidate designs through an adversarial panel. The `harness` skill ran the classification: the recognizer is flexible-reasoning (#5) → a Heuristic, not a script; the firing gap is real and undated → don't wait on model improvement ("Patience over code" licenses waiting only for an *imminent* fix).

**For external adopters**: pull the latest clone (`git pull`). The new heuristic lands right after *Fire on decision shape*; the new `conventions/orchestration-shape.md` is the contract. The `UserPromptSubmit` hook is **opt-in and gated behind a soak** — its `INSTALL.md` snippet ships only once it's proven. Everything is inert on a host with no fan-out primitive; no existing skills changed.

## v21 — 2026-06-01

**The ICP consult graduates to a native MCP tool — the bash helper, the per-operator config file, and the shared-secret call path all retire.** v20 wired the ICP Pressure Test through a portable helper (`harness-icp-consult.sh`) that curled an ICP scorer with a shared secret read from `~/.config/harness/icp.json`. The scorer has since grown a real front door — per-operator bearer tokens + per-tenant access — so the wrapper became the *parallel bypass*, not the primitive. v21 deletes it and points the skill at the scorer's **native `challenge_as_customer` MCP tool**, called directly.

**What v21 changes**:
- **`skills/ceo-plan-review` ICP Pressure Test (0D)** — calls the native `challenge_as_customer` MCP tool directly when one is wired (contract: `{ companyId, deliverable, deliverable_type }` → `{ verdict, score, icp_name, specific_feedback }`). Same first-class-input / never-gates posture; same graceful fallback when no scorer is wired.
- **Retired `scripts/harness-icp-consult.sh`** — the bash wrapper, the `~/.config/harness/icp.json` schema, and the `X-Internal-Secret` shared-secret call path are gone. The native MCP client is the integration surface now.
- **`conventions/icp-consult.md` rewritten** — from "wire a bash helper + secret file" to "register your ICP scorer as an MCP server" (`claude mcp add --transport http …`). FreedomOS operators get a per-operator token from the in-app Connect page; adopters point at any backend honoring the contract.

**Why** — *Native over Integration*, and *prefer the vendor primitive over a parallel bypass*: a shell script that curls an endpoint with a shared secret was scaffolding for a scorer that couldn't yet authenticate a caller. Now it can — per-operator bearer token (SHA-256-hashed, revocable) + per-tenant `company_roles` enforcement, server-side — so the agent calls the tool natively and the scaffolding comes down. The shared secret was also the last "secret-holder can score any company" hole; retiring it (the scorer's `MCP_EVAL_SECRET` transition bypass, removed the same day on the FreedomOS side) makes per-tenant isolation true by construction.

**Public pattern, private instance** (unchanged): the skill and convention name only the *contract* (`challenge_as_customer`); every instance value — scorer URL, per-operator token — lives in the operator's local MCP config, never in any repo. The pre-push scanner still enforces it.

**Catalyst**: 2026-06-01, the graduate step of the FreedomOS Scoring-MCP-Bridge loop — the scorer reworked to per-operator tokens + per-tenant access + native MCP transport (verified live), so the v20 interim helper retires and the consult goes native.

## v20 — 2026-05-29

**The first real bridge from Harness to FreedomOS — the real ICP, in the room, for customer-shaped decisions.** Until now the `ceo-plan-review` ICP Pressure Test reasoned about the customer from the operator's memory. v20 lets a skill consult the *real* ICP, loaded fresh from an ICP scorer, and treat the result as a first-class decision input.

**What v20 adds**:
- **New Strategic Position — *Context-Grounded Consumer Simulation*** (`FIRST_PRINCIPLES.md`): LLMs predict consumer behavior well *when given a specific persona* (the platform supplies the persona per #11; the LLM supplies the prediction per #15), so a context-grounded ICP simulation, consulted fresh, is a reliable enough signal to wire into customer-shaped decisions — fired on decision *shape*, not as a special occasion. Carries its `could be wrong if` (biased predictors / stale-ICP-in) and alternatives.
- **`scripts/harness-icp-consult.sh`** — a portable, secret-free helper that reads a PRIVATE per-operator `~/.config/harness/icp.json`, resolves the current repo → a company's ICP, and scores an artifact via an MCP `challenge_as_customer` call. Exits 3 + falls back when unconfigured.
- **`conventions/icp-consult.md`** — the wiring pattern + config schema + "connect your scorer" onboarding, so any operator points Harness at their own FreedomOS without sharing anything private.
- **`skills/ceo-plan-review` ICP Pressure Test (0D)** — now consults the real ICP when a scorer is configured; falls back to documented-profile reasoning otherwise. (office-hours demand-premise + the harness Five Questions are same-pattern fast-follows.)

**Public pattern, private instance**: the skills, helper, convention, and Position are generic and public. Every instance value — scorer URL, shared secret, company ids — lives only in `~/.config/harness/icp.json`, never in any repo; the pre-push scanner enforces it. This is what lets one framework serve multiple operators each pointed at their own FreedomOS.

**Why a Strategic Position, not a 19th First Principle**: run the layer-litmus — *if this claim were wrong, does everything downstream re-derive?* No: the ICP consult dies, but Context Shell, Model Diversification, and the atomic-primitive bets do not. "True" was never the bar for bedrock; irreducibility is. Filing a contingent capability-bet as a Principle would dress a bet as a principle (the rigidity failure mode the Epistemic Stance warns against). It's a Position — real, important, and explicitly hedged.

**Catalyst**: 2026-05-29, the graduation step of the FreedomOS Scoring-MCP-Bridge work. The scorer (`mcp-eval`) shipped + verified the same day; v20 is the consumer side — Harness gaining its first FreedomOS connector. The `harness` skill ran the classification decision via the layer-litmus above.

**For external adopters**: the ICP consult is opt-in and degrades gracefully — without `~/.config/harness/icp.json`, `ceo-plan-review` behaves exactly as before. To turn it on, see `conventions/icp-consult.md`; you need an ICP scorer that speaks the `challenge_as_customer` MCP contract (FreedomOS ships one; the contract is documented so any backend works).

## v19 — 2026-05-29

**A featherweight staleness notifier — Harness now tells you when your clone has fallen behind, without becoming a build system.** Updating stays a one-command `git pull`; what was missing was knowing you *need* to.

**What v19 adds**:
- `scripts/harness-version-check.sh` — a SessionStart hook that does a quiet `git fetch` and, only when your local clone is behind origin, prints a one-line nudge (`⬆️ Harness update available (v18 → v19) — git pull`). Zero dependencies beyond git; fails soft (no network / no upstream / already-current → no output); silent for the author who is *ahead* with unpushed work. Opt-in `HARNESS_AUTO_PULL=1` pulls for you, but only when the working tree is clean (never clobbers WIP).
- `INSTALL.md` — the hook is wired into the SessionStart snippet, plus a "Stay current automatically (optional)" section under Updating Harness.

**Why a notifier, not an auto-installer**: the question that prompted this was "does Harness auto-update like gstack?" It didn't — update was manual `git pull` + `./install.sh` with no signal that a new version existed, so a cloned copy (a second operator, a second machine) could sit silently on stale principles. gstack solves this with a version-check binary + config + migrations + an upgrade flow — it can afford that because it already ships a `./setup` build step and compiled binaries. Harness ships plain markdown: no build, no binary, no on-disk state to migrate, so a `git pull` *is* the whole update. Porting gstack's machinery would have been the largest complexity addition in Harness's history and would have broken its defining bet (zero-dependency portability, v17). The right-sized answer is a shell nudge.

**The decomposition (Posture 1)**: "auto-update" bundles detect-new-version / fetch / re-install / migrate. Harness needs only the first — the rest collapse to one `git pull` (plus `./install.sh` if a skill file changed). So the build is just the detector.

**Catalyst**: 2026-05-29, immediately after v18. The same multi-operator world v18's governance opened is the one where silent drift bites — a second operator's clone stops matching the shared canonical and nobody is told. The `harness` skill ran the decision: Five-Questions #3 (simplify to the minimum that delivers the value) plus the v12 precedent (a version-check is "render state I already have" → a script/hook, not a skill, and certainly not a binary) pointed at the notifier. Posture 5 (sharpen-or-delete-not-add) rejected porting gstack's updater wholesale.

**For external adopters**: pull the latest clone (`git pull`). Add `scripts/harness-version-check.sh` to your SessionStart hook (see INSTALL.md → "Stay current automatically") and you'll get a one-line heads-up whenever you've drifted behind — instead of finding out weeks later. No principles changed; no skills changed.

## v18 — 2026-05-29

**Multi-operator authorship governance written down — the companion to v12's coordination primitives.** The framework already *implied* who-may-change-what (the four-layer model + the public/private overlay); v18 states it, so a second operator's *"can I modify the principles?"* has an answer in the repo instead of one re-derived each time.

**What v18 adds**:
- `FIRST_PRINCIPLES.md` → "Updating this doc" expanded to "**Updating & personalizing this doc**" with a per-layer authorship rule: 🪨 Principles — challenge, never personally fork (true-for-all or wrong-for-all); 🎯 Positions — personalize in your overlay (contingent on your values + context); 📐 Heuristics — add your own / opt out freely, challenge centrally only what's *generally* wrong; 🔧 Tactics — yours, no ceremony. Plus the three governance scopes: single owner / operator-with-overlay / independent MIT fork.
- `conventions/multi-operator.md` → new section "**Authorship & personalization — who may change which layer**": the operator/teammate/agent driver taxonomy applied to authorship, and the note that the seams were already present (per-driver profile, the decision template's `Decided by` field, identity-routing by git email) — v18 supplies the rule they were waiting for.

**Why**: v12 solved the *visibility* half of multi-operator ("whose work is this?"). The *authorship* half ("who may change which layer?") stayed unwritten — `multi-operator.md` was silent on it and "Updating this doc" assumed a single owner. The gap was invisible until a second operator asked directly. No new layers and no new tooling: the answer is the existing four-layer model + overlay architecture, made explicit.

**The core distinction**: the more universal the layer, the less it's personally modifiable and the more a disagreement belongs upstream as a shared challenge; the more situational, the more personal variation is expected, with a designated home. A *personal principle* is incoherent within the framework's own ontology — a preference wearing a principle's clothes. So "modify the principles" decomposes (Posture 1): you don't fork principles, you challenge them; you personalize positions/heuristics/tactics in your overlay.

**Catalyst**: 2026-05-29. An operator who runs Harness with his own personalization asked whether he could modify the principles. The question surfaced that the allowance existed in spirit but had never been written as a rule — and that "the principles" bundled four layers with four different answers. The overlay model was chosen (operator personalizes their own instance and challenges the shared base upstream) over co-ownership-of-canonical (a later graduation) and independent fork (forfeits shared compounding, Principle #8).

**Self-applying**: the `harness` skill ran on the meta-question. Posture 1 (decompose the bundle) split "the principles" into four layers — which is the entire answer. Posture 5 (sharpen-or-delete-not-add) caught the impulse to build a "per-person principles" feature and deleted it: half category-error (principles), half already-solved (positions/heuristics via overlay). What remained was a documentation sharpening, not a build.

**For external adopters**: pull the latest clone (`git pull`). No principles changed; no skills changed; no install pattern changed. The portable take-away: when someone asks "can I change the framework?", ask *which layer* — principles you challenge upstream, everything else you personalize in your overlay.

## v17 — 2026-05-28

**Two conventions added + the Distribution-sync directive rewritten: Harness now documents how it interoperates with gstack when both are installed.**

**What v17 adds**:
- `conventions/output-artifacts.md` — the durable-output contract the review skills follow (`.agent/ceo-plans`, `test-plans`, `design-docs`) plus the render-rich-for-review heuristic, factored out of the individual skills so it's defined once and referenced everywhere.
- `conventions/gstack-interop.md` — the "complement, not fork" stance toward [gstack](https://github.com/garrytan/gstack), the two-variant pattern (self-contained default vs. opt-in delegating shim when gstack is also installed), the precedence rule that resolves the trigger collision, and the signal-driven sync approach.
- Rewrote the `harness` skill's "Distribution sync" section: from "keep working copies aligned with distributable copies" to the **two-variant model** — self-contained skills are canonical for distribution; delegating shims are a local opt-in and must **never** be pushed to `skills/` (they'd break portability for adopters who don't run gstack).

**Why**: installing gstack alongside Harness registers `gstack-*` skills that trigger on the same intents as the Harness review skills — a collision. The naive resolution (retire the Harness skills, lean on gstack) silently loses the Harness seam (principle compliance, conflict rule, Decision Template, loop maintenance) and the output contracts — none of which gstack carries. The principled resolution: keep the Harness skills as the precedence-winning layer; where gstack is installed, thin them to shims that delegate gstack's *process* while preserving the seam; keep the published skills self-contained for adopters who don't run gstack. None of the skill copies is "wrong" — they split cleanly by whether gstack is present in the environment.

**No principles changed; the published review skills in `skills/` are untouched** (self-contained, as before). This is additive documentation plus one directive rewrite in the `harness` skill.

**Catalyst**: 2026-05-28. An operator who runs both Harness and gstack installed the full gstack runtime (for its security and breadth skills) and hit the trigger collision against the four Harness review skills. Working it through the Harness framework produced the decomposition above — the adapted skills aren't redundant with gstack; they carry a seam gstack lacks. The fix is precedence + optional delegation, not retirement. The pattern generalized into the two conventions above. Posture applied: *decompose the bundle* (keep the irreducible atom, delegate the rest) and *sharpen-or-delete-not-add* (thin the skills; don't accrete).

**For external adopters**: pull the latest clone (`git pull`). If you don't run gstack, nothing changes — the skills work exactly as before. If you do, see `conventions/gstack-interop.md` for the optional delegating-shim pattern that lets you ride gstack's process while keeping the Harness seam on top.

## v16 — 2026-05-27

**Strategic Position added: Clarity Over Gates.** The wiring layer's primary job is to provide clarity for autonomous drivers (operator, teammate, or agent) — not to gate decisions. Empowering a teammate or agent looks like sharpening the substrate they decide from, not approving each decision they make.

**What v16 adds**: one Strategic Position to `FIRST_PRINCIPLES.md` between "Integrity Gate on agent-produced output" and "Business-Native communication." No principles changed; no skills changed; no install pattern changed.

**Operating model in one sentence**: three driver types (operator + teammate + agent) are all first-class users of the same six Clarity Surfaces (profile, domain map, recovery surfaces, visibility surfaces, decision template, worked decisions); escalation happens only on conflicting principles or genuinely new concepts.

**Why a Strategic Position, not a Principle**: the bet is contingent on driver-side and substrate-side prereqs — drivers can internalize the substrate; recovery + visibility surfaces stay cheap; compounding investment continues; drivers bring alignable unique value. Each is falsifiable; explicit *could be wrong if...* conditions named. Principles are irreducible — this is a bet about how the existing principles compose in a multi-driver world.

**Why a Strategic Position, not a Heuristic**: this fires on the operating model itself, not on situational decisions. The choice between "wiring layer as clarity-provider" vs "wiring layer as decision-gate" is a structural bet about what the wiring layer is FOR — not a rule-of-thumb that applies in some contexts and not others. Heuristics drift; Strategic Positions carry their alternatives forward as named bets and re-examine on world-signal.

**The killer scenario this Position is designed to pass**: hand the substrate (the framework + any overlay + a domain map + recovery/visibility surfaces) to an autonomous agent, and that agent should operate for hours → days → weeks autonomously, escalating only on conflicting principles or genuinely new concepts. A Position that only worked for human teammates would fail that test. This one scales to agent fleets because the substrate is driver-type-agnostic — the framing of "driver" is what carries it.

**Operationally consequential rotation**: under the prior implicit operating model, the operator's daily move was "approve teammate decisions." Under Clarity Over Gates, the operator's daily move is "sharpen Clarity Surfaces" — the questions, the worked decisions, the recovery + visibility surfaces. Same outcome (teammates and agents make good decisions) via a different mechanism (substrate-sharpening over decision-gating). When a driver hits friction, the answer is to **sharpen a Clarity Surface, not to gate the decision**.

**The compounding investment**: substrate gets sharper through use, not maintenance. Every conflict a driver resolves, every tool gap an agent unlocks, every refinement to a profile feeds back. Anchored to Principle #8 (Feedback loops compound) — not a separate mechanism, an instance of an existing principle made operational at the substrate level. The Position survives only if the labor continues.

**Catalyst**: 2026-05-27. An operator preparing a scope-authorization conversation with a recent hire ran the harness questioning framework on the meta-question — *how should harness function for empowering teammates?* The interview surfaced that the existing operator-centric framing (Director / Employee / Transparency / Integrity) didn't quite carry the load when extended to multi-driver scenarios spanning operators, human teammates, and autonomous agents. Distinct surface, distinct bet, new Position. The agent-CEO killer scenario was the falsifiability test that proved the Position's shape: any Position that only worked for human teammates would fail at agent scale.

**Posture caught**: a first draft tried to sharpen "User = Director" to extend to plural drivers. Tested — too much stretch (the Director frame doesn't carry the substrate-as-clarity-engine angle without distortion). New Position earned its place. Sharpen-or-delete-not-add applied: existing positions stay tight; new content gets its own Position cleanly.

**For external adopters**: pull the latest clone (`git pull`). The new SP is in `FIRST_PRINCIPLES.md` under Strategic Positions, between "Integrity Gate on agent-produced output" and "Business-Native communication." No skill behavior changes; no install pattern changes. The most portable take-away: when delegating to a teammate or agent, ask *"what Clarity Surface is missing for them to drive autonomously?"* before asking *"should I approve this decision?"* — that's the operating-model rotation Clarity Over Gates names.

## v15 — 2026-05-27

**Two heuristics and one Strategic Position added** — surfaced from a reconciliation pass over four March CEO plans whose underlying work shipped, parked, or was superseded but produced durable agent-design patterns worth carrying into the framework.

**What v15 adds**:

- **Heuristic: Graduate agent autonomy in trust tiers** — Watcher → Builder → Cofounder, with tier transitions earned by measured branch-acceptance rate over time windows. Origin: a Tier-1 Watcher heartbeat shipped in March under the codename "Jarvis," rebranded as the platform's autonomous-developer agent ("OpenClaw"), accumulated real branch-acceptance data, then was strategically parked in favor of an internal Agent-CEO pattern. The *tier graduation pattern itself* outlasted the host agent and re-emerged as the framing on the next agent build.
- **Heuristic: Consult oracles in a fresh context window** — when running review frameworks (ceo-plan-review, eng-review, design-audit) and hitting user-shaped questions, query the relevant profile in a fresh window so the answer isn't anchored by the calling context. Origin: the "ICP predictive oracle" pattern from the same March agent build, generalized.
- **Strategic Position: Integrity Gate on agent-produced output** — every public-surface agent output passes accuracy + compliance + values checks before ship. Bet: the cost of one ungated misrepresentation exceeds the cumulative cost of the gate. Positioned next to Trust Through Transparency + Shared Values (transparency is what you show; integrity is what you don't ship). Origin: the integrity-gate pattern from the same March agent build, where the team's named values commitments lived alongside FTC compliance + accuracy checks on all public-facing agent output.

**Why heuristics not principles for the first two**: they're situational rules of thumb. The trust tier ratio (acceptance %) and window size (weeks) are contingent on context — not bedrock truths about LLMs. Anchored to "Agent = Employee" (already a Strategic Position) and Principle #14 (Complementary Strengths) respectively.

**Why a Strategic Position not a principle for Integrity Gate**: it's a bet that the cost of misrepresentation outweighs the cost of latency, with explicit *could be wrong if...* falsifiability — could be wrong if frontier models become self-policing at inference, or if the gate becomes over-cautious filtering. Honest framing: contingent, not derivable from physics.

**Catalyst**: 2026-05-27 — running ceo-plan-review on a new agent routing-context primitive surfaced four March CEO plans that had aged past 30 days. A reconciliation pass over those plans showed three patterns that survived the work parking: graduated trust, fresh-context oracle queries, and the integrity gate on agent output. The pattern surfacing was itself an application of "feedback loops compound" (Principle #8) — the parked work paid forward into the framework.

**For external adopters**: pull the latest clone (`git pull`). The two new heuristics land under 📐 Heuristics; the Strategic Position lands under 🎯 Strategic Positions between "Trust Through Transparency + Shared Values" and "Business-Native communication." No skill behavior changes; no install pattern changes.

## v14 — 2026-05-16

**Strategic Position added: Connector Hierarchy.** Codifies the tier-based default for every external-service decision: native LLM primitive → vendor MCP → vendor SDK → community wrapper → hand-wired REST. Stop at the first tier that fits. Includes a sub-heuristic ("Own utility, federate identity") that governs OWN-vs-BYO within the vendor-MCP tier.

**What v14 does**: adds one Strategic Position to `FIRST_PRINCIPLES.md` between "Native Over Integration" (the position it most directly extends) and "Match closure metric to goal". No principles changed; no skills changed; no install pattern changed. The SP is a context-typed hierarchy — cloud variant (edge functions / serverless) ranks `primitive → MCP → SDK → community → REST`; local variant (IDE / dev tooling) elevates CLI above SDK. The sub-heuristic resolves the OWN-vs-BYO question by user-data presence: user-data services federate (user connects their own account), utility services own (platform-owned key), LLM providers own by default with BYO as a power-user option.

**Why a Strategic Position, not a Principle**: the hierarchy is derivable from Principles #6 (atomic primitives compose), #10 (tools become primitives — design for deletability), and #12 (dynamic > hardcoded). It's a bet that the MCP ecosystem matures fast enough to make the tier-1 default load-bearing, not a derivation from physics. Naming it as a contingent SP — with explicit *"could be wrong if..."* falsifiability conditions — keeps the framework honest about the bet's contingency.

**Why a Strategic Position, not a Heuristic**: heuristics are situational; this fires on every external-service decision. The hierarchy is a default, not a guideline. Heuristics drift; Strategic Positions carry their alternatives forward as named bets and re-examine on world-signal.

**Not in tension with Native Over Integration**: consuming a vendor MCP doesn't make the builder a wrapper of that vendor — the wrapper line is crossed when MCPs are re-exposed as proprietary tools with proprietary schemas. The Connector Hierarchy adopter stays a substrate by composing many vendor MCPs into the agent layer without re-wrapping them.

**Catalyst**: 2026-05-15 conversation. A vendor that the operator's platform had hand-wired via REST shipped an official MCP server. The operator framed it as *"a harness bet — when possible, use MCPs over REST so vendor changes stop being rewiring tax."* Office-hours surfaced the bigger move: the bet isn't "MCP everywhere," it's "integration is itself a fallback — reach for the highest tier the job allows." Primitive-first emerged as the cross-cut: when a frontier LLM absorbs a capability, the right answer is to delete the integration, not migrate it. Across one office-hours → ceo-plan-review → engineering-review chain, the framework produced the SP that now lands in v14. First concrete deletion under the SP shipped same week (one obsolete pre-cleaning vendor removed from a single call site after frontier-model HTML parsing proved good enough).

**Self-applying**: the SP itself was produced by the framework's own questioning gates. Office-hours challenged the polished version of the bet ("MCP everywhere") and surfaced the three-bet shape (principle-first opportunistic adoption / migration plan first / build a gateway). The principle walk in ceo-plan-review ran all 18 first principles + 13 existing SPs against the candidate; six principles aligned, zero opposed, the SP earned its position. Engineering-review pressure-tested the file-level shape and added the brittleness conditions to the falsifiability gate.

**Posture 5 caught**: a first draft tried to elevate "Connector Hierarchy" to a First Principle. Sharpened — it's derivable from #6 + #10 + #12, so it's a bet, not bedrock. Putting it in the SP layer with explicit *could be wrong if...* conditions is the more honest framing.

**For external adopters**: pull the latest clone (`git pull`). The new SP is in `FIRST_PRINCIPLES.md` under Strategic Positions, between "Native Over Integration" and "Match closure metric to goal". No skill behavior changes. The sub-heuristic ("Own utility, federate identity") is the most portable take-away: when adding any vendor integration, the OWN-vs-BYO question is answered by user-data presence — not by what feels easier to build.

## v13 — 2026-05-15

**Public/private boundary audit.** Removed business-specific content from public Harness; tightened the discipline that keeps it out going forward. The framework remains public; only the instance-level specifics moved.

**What v13 does**:

- **Two Strategic Positions moved to the private overlay** (`timlinnet/harness-private/positions/business-specific-strategic-positions.md`): one tied to a values-aligned product surface for one specific business, one to an autonomous-CEO-agent sandbox-company. Both explicitly named one specific business in their public form. The *patterns* (values-aligned surface, autonomous-R&D-sandbox-company) remain reusable by any adopter; the *instances* live with the framework owner.
- **Business-name scrubs across public framework content**: `FIRST_PRINCIPLES.md` (User = Director's "Linnet is the CFO/COO/CMO" → "The agent is the CFO/COO/CMO"; Context Shell alternatives; Match closure metric examples; Model Diversification example with a named public figure; Tactics' "if Linnet can write" → "if an agent can write"; "What lives elsewhere" section). `skills/harness/SKILL.md` Step 1 and Step 4. `decisions/0006-lovable-supabase-migration-workflow.md` Alternative bets. `README.md` Related section. Where the name was the leak, replaced with generic phrasing; where the position was the leak, the entire section moved to the private overlay.
- **CHANGELOG catalysts sanitized** (v5, v9, v11) to remove specific product names and personal-goal quotes while preserving the "real-use" attribution. The catalyst pattern is essential to Principle #8 (feedback loops compound); the business specifics aren't.
- **`scripts/security-scan.sh` extended** with two new pattern groups (`tim-business-name` and `private-position-name`) that block business-name leaks and re-introduction of the two position titles just removed. See the scanner file itself for the exact blocklist.
- **`CLAUDE.md` "Public vs private" section** sharpened with explicit examples of what crosses the boundary.

**Why a boundary audit, not a deprecation**: the framework remains public and continues to compound through external use (Principle #8 — v5's catalyst was a customer pull-signal; v8 was retro from real use). Going fully private would have reversed the *Marketing is part of the product* Strategic Position. The audit addresses the real concern surgically — about an hour of edits + scanner update — without dismantling the bet.

**Posture 5 caught**: a first draft proposed adding a dozen new scanner patterns including every product name. Sharpened — added only patterns that map to leaks actually found, plus the two position titles we just removed. Don't over-instrument; let discipline carry the rest.

**Self-applying**: the audit was itself a Harness-shaped decision. Public-vs-private was framed as a false binary (*Posture 1: Decompose every bundle*); the real choice was *what specifically belongs in each*. Five options surfaced via Decision Template; B (tighten boundary, keep public) chosen — falsifiability gate: no competitor explicit clone-and-outcompete in 12 months. The framework defended itself through the framework.

**Catalyst**: 2026-05-15 conversation. The framework owner raised a strategic concern about exposure as Harness accumulates more substance: *"Harness feels like it's going to continue to get more of our business bets and strategies. I'm wondering if that exposes us..."* Diagnosis surfaced three tiers of content: universal (no-leak), reusable patterns (low-leak), and instance-level specifics (Tier 3 — the actual leak). Tier 3 was leaking through Strategic Positions, catalysts, and prose mentions. The audit + scanner update closes those paths.

**For external adopters**: pull the latest clone. The public framework reads slightly more universal (less name-dropping of one business owner's projects). No skills changed in behavior — only description prose.

## v12 — 2026-05-15

**Multi-operator coordination primitives added.** Two scripts (`scripts/session-pr-digest.sh`, `scripts/dirty-state-ownership.sh`) + one convention doc (`conventions/multi-operator.md`). Solves the "I can't tell whose PR / whose dirty file" problem in any repo with more than one human operator and/or multiple AI agents.

**What v12 does**:

- `scripts/session-pr-digest.sh <owner/repo> ...` — author-aware filtered PR digest. Five buckets: **NEEDS YOUR REVIEW** (others, non-draft) → **discipline mismatch** (others' drafts whose body suggests "ready" — author forgot to un-draft) → **yours, ready** → **yours, drafting** → **others' drafts** (collapsed). Identity inferred from `gh api user --jq .login`; no labels required.
- `scripts/dirty-state-ownership.sh <repo-dir> ...` — classifies each modified/untracked file as **local-config noise** (`.mcp.json`, `supabase/.temp/*`, `.claude/launch.json`, IDE/swap files; configurable) / **yours, recent** / **yours, stale** / ***other-identity*** (bucketed by email) / **untracked**. Collapses to *"all noise — zero code in flight"* when applicable.
- `conventions/multi-operator.md` — names the discipline rule (**un-draft when you want review**) that makes the GitHub `isDraft` flag load-bearing, plus optional `who:*` label scheme for repos where author identity is genuinely ambiguous (don't introduce speculatively).

**Why scripts + convention, not skill**: this is operational infrastructure, not decision-shape work. Scripts fire on every session start through the host's hook mechanism; the convention doc is read once, internalized, then enforced by the scripts' output (the discipline-mismatch flag self-corrects the un-draft habit). A `harness`-style skill would add an LLM hop between the operator and the data — wrong tier of tool for "render the state I already have."

**Defensive design**: both scripts fail soft. Missing `gh` / `jq` / unauthenticated CLI / 404 repos all silent-skip rather than break the SessionStart pipeline. This matters because hooks fire on every session — one noisy failure becomes constant friction.

**Catalyst**: 2026-05-15 — a real coordination failure surfaced in a co-founder + contractor + three-agent repo. The operator couldn't tell at a glance whose work was sitting in the working tree (an existing memory rule patched one agent's behavior, but the rule wasn't infrastructure — every new operator and every new agent would have to learn it independently). The conversation that surfaced the gap also framed the fix: *"this could be a harness update that supports working with more than one person."* The primitives are public because every multi-operator team will hit this; the specific PR numbers and operator names belong in private overlays.

**For external adopters**: pull the latest harness clone (`git pull`). The new scripts live at `scripts/session-pr-digest.sh` and `scripts/dirty-state-ownership.sh` — wire into `~/.claude/settings.json` (or wherever you trigger session-start work). See `INSTALL.md` → "Multi-operator visibility" section for the snippet. No `install.sh` change yet — the scripts are invoked directly from the host's hook by absolute path, which keeps installation a single `git clone` step.

**Self-applying**: this v12 release was itself shaped by the framework. The 2026-05-15 conversation surfaced the gap → office-hours diagnosis named the two visibility problems → ceo-plan-review produced a 3-option decision (GitHub primitives, Linear, Harness extension) → A-with-C-deferred chosen (Phase 2 gates on falsifiability evidence). Posture 5 ("sharpen or delete, not add") caught a first draft that wanted three primitives + labels mandatory — sharpened to two scripts, labels optional, convention doc names the discipline rule that the scripts already enforce mechanically.

## v11 — 2026-05-14

**Parallel Launchpad added to the `harness` skill** as a new Step 6, firing at the end of response generation.

**What v11 does**: adds a "Parallel Launchpad" section to `skills/harness/SKILL.md`. When producing a deep response, the agent scans three candidate pools (in-thread, adjacent topics, portfolio-wide OPEN_LOOPS at `← YOU ARE HERE`) for a chunk of work that can be launched in a parallel Claude Code session while the operator continues reading. If a candidate passes all 5 gates (decided, self-contained, >5min agent work, non-conflicting, launchable as-is), it surfaces as a paste-ready prompt at the *top* of the response. Calibration: **false-positive bias** — when uncertain, include. An ignored launchpad costs seconds; a missed launch costs an entire wisdom-window.

**Why this matters**: the operative principle is *wisdom is the limited resource; everything else parallelizes* (Principle #15 + #17). Throughput in a Claude Code session is gated by operator decision time, not by agent execution time. Every minute the operator spends reading a deep response is a minute that could also be paying out deterministic work-in-flight — checks, verification, builds, drafts — if the surface area for parallel launches is one paste away. The Launchpad collapses the extract-and-reframe friction.

**Why a section in `harness`, not a new skill**: the directive fires every time the framework produces a Decision Template — i.e., at the end of harness's own flow. Adding it to `harness` puts it at the moment of fire. Carrier skills (`next`, `autoplan`, `office-hours`, `ceo-plan-review`, `engineering-review`) inherit by routing through harness. Posture #5 ("sharpen or delete, not add") caught a first draft that wanted to spawn a "parallel-launchpad" skill — sharpened into "Step 6 of harness" instead.

**10x challenge addressed**: the 10x version of "produce paste-ready prompts" is "spawn agents autonomously while the operator reads." We explicitly rejected that move — wisdom-directing / intelligence-executing means the launch decision stays with the operator. Autonomous spawning crosses the trust boundary and breaks the Architecture Lens "wisdom and intelligence in the right places." The semi-automated version (operator launches, agent executes) is the correct shape.

**Adopter universality**: gates are universal (no Tim-specific calibration). Any operator using Claude Code with an OPEN_LOOPS-style backlog + multi-session workflow benefits. Adopters without a portfolio backlog see launchpads from pool 1 (in-thread) only. SessionStart hook that prefetches OPEN_LOOPS is adopter-configurable.

**Catalyst**: 2026-05-14 conversation. The framework owner observed that during deep architecture/theory threads, read-and-understand time was the binding constraint on throughput — decisions sequential, deterministic work blocked on single-threaded comprehension. Reframe: *user wisdom is the limited resource; everything else parallelizes*.

**Self-applying**: this v11 release was itself shaped by the false-positive-bias calibration it codifies. The Forcing Question ("which bias?") was the load-bearing call; once Tim answered, the design locked. Posture #5 caught a first draft that proposed a new skill (additive). Sharpened to "Step 6 inside harness." Framework self-correcting through real use — Principle #8 in action.

**For external adopters**: `./install.sh` pulls the updated `skills/harness/SKILL.md` on next run. Behavior change: agents surface a top-of-response Parallel Launchpad when a candidate passes the 5 gates. To opt out, state in your project's CLAUDE.md that Parallel Launchpads should not be surfaced.

## v10 — 2026-05-14

**Heuristic added: render-rich format for review-heavy output.** New entry in `FIRST_PRINCIPLES.md → 📐 Heuristics`. One-line pointers added to the Output sections of `engineering-review`, `ceo-plan-review`, and `office-hours`.

**The rule**: when producing review-heavy artifacts (audits, plans, eng-reviews, design docs — anything >~100 lines with diffs, tables, mermaid diagrams, or comparative structure), default to **HTML** for the review pass. Markdown in chat scrollback fragments visual structure — diffs lose syntax highlighting, tables get squished, mermaid blocks don't render. Two-phase: HTML for the review draft (in a session-served path, operator-configured), markdown for the final committed artifact in the codebase.

**Why this is a heuristic, not a principle**: it's an operative craft rule, not a substrate truth. It follows from Principle #17 (asymmetric attention is the leverage point) — review time is the user's most expensive resource, and format-fidelity is part of preserving it. Heuristics belong with other tactics-adjacent rules.

**Why a one-line pointer in three skills, not full duplication**: the rule lives in one place (FIRST_PRINCIPLES.md). The skills get a brief reference at the moment of fire — Output section in `engineering-review` and `ceo-plan-review`, Phase 5 in `office-hours`. Posture 5 ("sharpen or delete, not add") caught the first draft, which proposed duplicating the full rule into each skill.

**Catalyst**: 2026-05-14 retro. A harness audit produced a ~400-line markdown file that the user couldn't open from chat (link-resolution edge case across multiple GitHub identities). The friction cost them the ability to push back on the audit before forwarding it onward. The Tim-specific routing issue was the catalyst, but the rule generalizes: render-rich is strictly higher fidelity for review-heavy output regardless of why a particular markdown link fails for a particular user. The friction case made the universal benefit visible.

**For external adopters**: `./install.sh` pulls the updated FIRST_PRINCIPLES.md and SKILL.md files on next run. Behavior change: agents running the review skills will produce HTML for review-heavy output before writing the markdown artifact to disk. Session-folder path is environment-specific — configure in your project's CLAUDE.md or memory layer (e.g. `/tmp/<session-id>/` or whatever path your chat UI can reliably serve).

**Self-applying**: this v10 release surfaced the heuristic from real use (audit friction), passed it through the framework (CEO Plan Review reframed "add HTML output" → "render-rich for review-heavy output as a universal heuristic"; Eng Review confirmed non-Tim adopters benefit; Posture 5 caught the duplication), and shipped one rule referenced from three locations rather than three near-copies. Principle #8 in action.

## v9 — 2026-05-13

**Decision Postures added to the `harness` skill** as a new Step 1, firing before principle-loading and the questioning framework.

**What v9 does**: adds 5 operative postures to `skills/harness/SKILL.md`:

1. Decompose every bundle. Reason in atoms.
2. Doubt the inherited boundary.
3. Make the requirement less dumb — especially your own.
4. Start from atoms and dollars, not analogy.
5. The default move is sharpen or delete, not add.

These don't replace the five questions (delete/simplify/accelerate/automate); they precede them. Postures shape *what you reach for*; questions shape *what you choose*. Postures = shape of thinking, questions = shape of solution.

**Why postures in the skill, not FIRST_PRINCIPLES.md**: the doc is bedrock context — read once at session start. The skill fires every decision. Operative directives belong at the moment of fire, not in background context. This location decision was itself made through the framework — running the principles produced "skill, not doc" as the answer.

**Catalyst**: 2026-05-13 conversation. The framework owner noticed the agent generated new heuristics during a build-vs-buy decision rather than deriving from existing principles. Diagnosis surfaced a real gap: the principles are *descriptive* ("X is true; therefore Y") and require derivation work at decision time. Elon-style postures are *operative* — pre-derived directives that fire as the decision arises. The existing five questions covered solution-shape; the postures cover thinking-shape. Both belong, in that order.

**Self-applying**: this v9 release was itself made through the postures it adds. The first proposal was "add a new section to FIRST_PRINCIPLES.md" — additive. Posture 5 ("sharpen or delete, not add") caught it. The corrected move was "put them in the skill where they fire." Framework self-correcting through real use, again — Principle #8 in action.

**For external adopters**: `./install.sh` pulls the updated SKILL.md on next run. Behavior change: agents will run a posture pass before loading principles for any decision-shaped work. The postures are universal (not Tim-specific) and travel with the public skill.

## v8 — 2026-05-13

Retro: v7's "Silent mode is the default" framing was wrong. Rolled back.

**What v7 did**: codified "silent mental checklist + terse 3-5 line surface" as the default for `harness` and `office-hours`. Intent was to prevent agents from asking "want me to run X?" — a real friction pattern in v6 and earlier.

**Why v7 was wrong**: the same framing also muted the framework's own visibility. Agents stopped emitting Decision Templates, stopped asking Forcing Questions one at a time, stopped naming Principles in their recommendations. They surfaced only conclusions. Users could no longer audit the reasoning, catch missed Strategic Positions, or push back on weighting. From the harness skill itself: *"Active challenge is the practice that keeps the framework alive. Silence is the failure mode."* v7 codified the silence.

**What v8 does**: replaces the "Silent mode is the default" sections in `skills/harness/SKILL.md` and `skills/office-hours/SKILL.md` with **"Run as designed (the default)"**. New framing:

- The framework already calibrates its own readability — Five Questions are short, Architecture Lenses ask the operator to pick the few that apply (not dump all ten), Decision Templates name principles by number rather than re-deriving them, Forcing Questions are asked one at a time. Trust the skill to be readable.
- "Active challenge is the visible practice" — when the operator can see which principles were applied and which alternatives were considered, they can push back. The framework's job is to BE VISIBLE.
- The two preserved rules from v7 (never ask "want me to run X?"; never silently skip from inattention) stay — they were correct.
- A "Distraction signal (contextual collapse, not default)" clause: if the operator explicitly signals overwhelm in the moment, collapse to terse for that thread, then resume the visible framework on the next decision. The default doesn't change.

The `When Full Mode triggers` section in office-hours was renamed back to **`When to run / when to skip`** — v7's Silent/Full dichotomy was an artifact of the muted-default framing and no longer fits.

**Catalyst**: Tim's retro 2026-05-13 — *"I never get challenged by those principles or by G-Stack, which is concerning. It's almost like maybe I need to remove that restriction from you so that way you can start communicating about G-Stack the way that it is defined or the way that it was intended."* A user-memory file (`feedback_wall_of_text.md`) written on a tired/distracted day had bolted "terse default" onto the framework. v7 then propagated the same pattern into the canonical skills. Both rolled back the same day. **Lesson: the framework already knows how to be readable; don't add rules that strip the work.**

This v8 retro is itself an instance of Principle #8 (Feedback loops compound) — the framework correcting itself through real use.

**For external adopters**: `./install.sh` pulls the updated SKILL.md files on next run. Existing installs can `cp` the two files manually or re-run the installer. Behavior change: the agent will emit more visible reasoning trail by default. If that's too much for your environment, your own CLAUDE.md or memory layer is the right place to calibrate down — not the canonical.

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

**Catalyst**: a customer asked whether the framework owner's multi-role agent setup still works. Answering required a real public artifact — the customer pull-signal turned an internal todo into a customer-service moment + thought-leadership artifact simultaneously. *(Marketing is part of the product manifesting.)*

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
