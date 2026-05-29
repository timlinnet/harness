# Convention: ICP Consult — wiring a real ICP into customer-shaped decisions

The first Harness → FreedomOS bridge. Implements the *Context-Grounded Consumer Simulation* Strategic Position: at customer-shaped checkpoints (the `ceo-plan-review` ICP Pressure Test today; office-hours demand-premise and the `harness` Five Questions next), score the work against the **real** ICP loaded fresh from an ICP scorer — instead of the operator's remembered guess of the customer.

## How it works

`scripts/harness-icp-consult.sh` reads a **private per-operator config** and calls your ICP scorer over MCP JSON-RPC. No URLs, secrets, company ids, or business names live in Harness — only in your private config, which is never committed (the pre-push scanner blocks those from the public repo).

```
scripts/harness-icp-consult.sh [--project NAME] [--type TYPE] "<deliverable text>"
```

Returns the scorer's `{ verdict, score, icp_name, specific_feedback, ... }` as that customer. The skill treats it as a first-class **input** — it informs the decision, it never auto-gates (per *Clarity Over Gates*).

## Wire your own (one-time, per operator / per machine)

1. **Stand up or get access to an ICP scorer** that speaks the contract: MCP JSON-RPC `tools/call` for tool `challenge_as_customer` with arguments `{ companyId, deliverable, deliverable_type }`, returning `{ verdict, score, icp_name, specific_feedback, ... }`. FreedomOS ships one (`mcp-eval`); any endpoint honoring that contract works.
2. **Store the shared secret** in a file readable only by you (e.g. `~/.config/<your-tool>/secret`, mode `600`).
3. **Create `~/.config/harness/icp.json`**:

   ```json
   {
     "scorer":   { "url": "<your scorer endpoint>", "secretFile": "<path to the secret file>" },
     "projects": { "<repo-name>": "<id of the company whose ICP to load>" }
   }
   ```

   - `scorer.url` — your scorer endpoint. `scorer.secretFile` — path to the secret file (sent as the `X-Internal-Secret` header). `~` is expanded.
   - `projects` — maps a repo (the basename of the git toplevel) to the company whose ICP applies when you work there. Add entries as projects come online.
4. **Test** from inside a mapped repo: `scripts/harness-icp-consult.sh --type strategy "a one-line plan"`.

## Graceful absence

No `~/.config/harness/icp.json`, or the current repo isn't mapped → the helper exits `3` and the calling skill falls back to reasoning through documented ICP profiles (or the productize filter alone). **Harness works without a scorer; it just gets sharper with one.** The ICP consult is fully opt-in.

## Multi-operator

Each operator wires their own config pointing at their own scorer + company ids. Nothing private is shared or committed — the *pattern* is public (this file, the helper, the Position, the skill step); the *instance* is yours (your `~/.config/harness/icp.json` + secret file). A second or third operator integrates by creating their own config, nothing more.

## Security

The helper and this convention contain no secrets, URLs, company ids, or business names. The pre-push scanner (`scripts/security-scan.sh`) blocks those from the public repo. Keep every instance value in `~/.config/harness/icp.json` and the secret file — both outside any repo.
