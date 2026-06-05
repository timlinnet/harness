# 0007 — `verify-on-deploy` PostToolUse hook (local interim → propose upstream to gstack)

> Status: PROPOSED upstream · local interim SHIPPED (soak) · 2026-06-04 · claude-tim

## Context

gstack enforces verification *inside* its deploy workflow — `land-and-deploy` runs canary checks (offer-revert on failure), `/canary` is a dedicated post-deploy verifier, `/verify` + `/qa` exist, and a `proactive` flag suggests `/qa`. That's solid. But verify is **invoke-triggered**: a deploy done *outside* the workflow — a raw `mcp__lovable__deploy_project` or `supabase functions deploy` (both permission-pre-authorized in this setup) — has **no firing surface**. Audited: gstack's only `PostToolUse` hooks are plan-tune's AskUserQuestion capture; there is no deploy/verify hook anywhere. So the bypass path ships with zero verify nudge; the only nets are the SessionStart reminder (decays over a session) and the agent remembering. This is the same recall gap v22 fixed for orchestration with a `UserPromptSubmit` wake-hook.

A separate Stop hook already covers the *ledger* half (warns on a code commit lacking a FOCUS/OPEN_LOOPS update) — so closure-tracking is by-construction. The missing half is **deploy → verify**.

## Proposal (upstream to gstack)

Ship a `PostToolUse` hook (the firing surface a context-rule can't be) matching deploy tools — `deploy_project`, `deploy_edge_function`, Bash `*functions deploy*`, and platform equivalents — that injects: *"production deploy detected, possibly outside the deploy workflow → run `/canary` or `/verify` before claiming done; report 'deployed + verified — evidence' or 'deployed, NOT verified'."* Recall-raiser, never blocks (never exit 2). Points AT the existing `canary`/`verify` skills — it triggers them, doesn't duplicate them. Same shape gstack already uses for plan-tune's PostToolUse + v22's UserPromptSubmit.

## Local interim (shipped, designed for deletion)

- `harness/scripts/verify-on-deploy-wake.sh` — modeled on `workflow-shape-wake.sh`; fail-soft; unit-tested (fires on Lovable publish + `supabase functions deploy`, silent on everything else).
- Registered via `gstack-settings-hook add-event --event PostToolUse --source verify-on-deploy`.
- **Remove when gstack ships the upstream version:** `gstack-settings-hook remove-source verify-on-deploy` + delete the script. The `--source` tag is the deletability mechanism.

## Soak caveat (the v22 lesson: codifying ≠ firing)

The hook's *logic* is tested, but whether `PostToolUse` `additionalContext` actually reaches the model in this Claude Code version is unproven until a real deploy fires it. Treat as in-soak — confirm it moves behavior on a live deploy before declaring it works or shipping the snippet to adopters. If `additionalContext` isn't honored for PostToolUse, fall back to exit-2 + stderr (more aggressive) or keep it as a Stop-hook check.

## Why upstream, not a permanent Harness fork

Deploy workflows are gstack's turf; a generic deploy→verify firing surface belongs there (Layer 1 — don't permanently reinvent). Harness carries it only as a source-tagged interim. Channel: the `gstack-sync` flow / a gstack issue with this script as the reference impl.
