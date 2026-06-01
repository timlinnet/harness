# Convention: ICP Consult — wiring a real ICP scorer (native MCP)

The first Harness → FreedomOS bridge. Implements the *Context-Grounded Consumer Simulation* Strategic Position: at customer-shaped checkpoints (the `ceo-plan-review` ICP Pressure Test today; office-hours demand-premise and the `harness` Five Questions next), score the work against the **real** ICP — loaded fresh from an ICP scorer — instead of the operator's remembered guess of the customer.

## How it works

The scorer is a **native MCP tool** your agent calls directly. It honors one contract:

- Tool **`challenge_as_customer`**, arguments `{ companyId, deliverable, deliverable_type }`
- Returns `{ verdict, score, icp_name, specific_feedback, ... }` — scored *as that customer's ICP*.

`ceo-plan-review` (Step 0D) calls it when wired and treats the result as a first-class **input** — it informs the decision, it never auto-gates (*Clarity Over Gates*).

## Wire your own (one-time, per operator / per machine)

1. **Stand up or get access to an ICP scorer** that speaks the `challenge_as_customer` MCP contract over Streamable HTTP. FreedomOS ships one; any backend honoring the contract works.
2. **Get a per-operator token** for it. FreedomOS: the in-app *Connect Harness* page mints one, shows it once, and renders the exact command below — it is revocable and scoped to you.
3. **Register it as an MCP server** in your agent:

   ```
   claude mcp add --transport http <name> <scorer-url> --header "Authorization: Bearer <your-token>"
   ```

   The tool then appears natively (e.g. `mcp__<name>__challenge_as_customer`) and `ceo-plan-review` uses it automatically.

## Graceful absence

No ICP-scorer tool wired, or your project has no documented ICP → `ceo-plan-review` falls back to reasoning through documented ICP profiles (or the productize filter alone). **Harness works without a scorer; it just gets sharper with one.** The ICP consult is fully opt-in.

## Multi-operator

Each operator registers their own MCP server with their **own per-operator token**. Per-tenant access — which companies' ICPs you may score — is enforced by the scorer at call time: a token says "you are operator X"; membership says "X may score company Y". Nothing private is shared or committed — the *pattern* is public (this file, the contract, the Position, the skill step); the *instance* is your token + URL, held only in your local MCP config, never in any repo. A second or third operator integrates by registering their own server, nothing more.

## Security

No secrets, URLs, company ids, or business names live in Harness — only the contract. The token is per-operator and revocable; the scorer enforces per-tenant access server-side. The pre-push scanner (`scripts/security-scan.sh`) keeps instance values out of the public repo.
