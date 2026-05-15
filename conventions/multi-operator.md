# Multi-Operator Coordination

> **Scope**: when one repo is touched by multiple humans and/or multiple AI agents — co-founders, contractors, IDE-embedded agents, autonomous bots — the coordination layer has to scale past "I'll just remember." This doc is the substrate Harness offers.

The two scripts (`scripts/session-pr-digest.sh`, `scripts/dirty-state-ownership.sh`) do the mechanical work. This doc names the **conventions** they assume and the **discipline rule** they enforce, so any adopter can wire the same primitives into their own setup.

The aim: when you open your laptop, you know within 30 seconds what needs your attention from collaborators (human + agent), what's yours in flight, and what's noise — without investigating.

Anchored to Principle #17 (asymmetric attention is the leverage point) — the most expensive resource in the workshop is operator attention; the harness pre-processes raw git/GitHub state into human-grade signal.

---

## The two visibility problems

In any multi-operator repo, two failure modes recur:

1. **PR ownership and status are not surfaced proactively.** A raw `gh pr list` dump shows every open PR with no attribution and no review-state filter. The operator investigates *each* one to know "is this mine, are they asking for review, is this still drafting?"
2. **Dirty working-tree state has no ownership inference.** A raw `git status` shows modified/untracked files. The operator investigates "is this mine? is this a collaborator's in-flight work I'd clobber? is this a local-config artifact I can ignore?"

Both costs scale linearly with operator count. By two collaborators + two AI agents, the daily investigation tax is large enough to disrupt flow.

The Harness primitives below remove the investigation step.

---

## Primitive 1 — Author-aware PR digest

**Script**: `scripts/session-pr-digest.sh <owner/repo> [<owner/repo> ...]`

Renders open PRs across one or more repos, bucketed by what they mean to *the current GitHub user*:

| Bucket | Meaning |
|---|---|
| 🔴 NEEDS YOUR REVIEW | Others' open, non-draft PRs |
| ⚠️ Discipline mismatch | Others' DRAFT PRs whose body suggests they ARE ready ("Status: DONE", "ready for review", "needs your sign-off", etc.) — the author probably forgot to un-draft |
| 🟢 YOURS — ready to merge | Your open, non-draft PRs |
| 🟡 YOURS — drafting | Your open drafts |
| 👤 Others' drafts | Collapsed summary of others' in-progress work — not yet for you |

Identity is taken from `gh api user --jq .login`. No labels required — author identity is the primary signal. Labels are an opt-in refinement (see "Optional: WHO labels" below).

The script is defensive: fails silently on missing `gh`, missing `jq`, unauthenticated CLI, or 404 repos.

---

## Primitive 2 — Working-tree ownership inference

**Script**: `scripts/dirty-state-ownership.sh <repo-dir> [<repo-dir> ...]`

For each modified or untracked file in each repo, classifies into:

| Bucket | Meaning |
|---|---|
| 📁 local-config | Matches a known noise pattern (`.mcp.json`, `supabase/.temp/*`, `.claude/launch.json`, `.DS_Store`, IDE config, swap files, etc.). Override via `HARNESS_NOISE_PATTERNS`. |
| 👤 yours, recent | Last commit author matches `git config user.email` AND file mtime is within `HARNESS_DIRTY_STALE_HOURS` (default 24h) |
| ⏳ yours, stale | Yours but older than the stale window — likely something you started and never finished |
| 👥 *other-identity* | Last commit author email differs from yours — flagged with the identity bucket so you know whose work it is |
| ❓ untracked, no noise match | New file with no git history; ownership can't be inferred mechanically |

If everything in a repo classifies as noise, the digest collapses to *"all noise — zero code in flight."* That's the headline you want when nothing real is dirty.

---

## Discipline rule — un-draft when you want review

The digest treats `isDraft=true` as *"author is not yet asking for review"* and `isDraft=false` as *"author is asking for review."* This makes the GitHub primitive load-bearing.

**The rule**: when your PR is ready for someone to look at it, **un-draft it** (`gh pr ready <N>` or the GitHub UI). Writing *"Status: DONE"* or *"needs your review"* in the body is not enough — the digest flags those as discipline-mismatch (the `⚠️` bucket), but the cleanest practice is to un-draft.

This costs nothing and turns `gh pr list --draft=false` into a reliable "ready for review" filter forever.

---

## Optional — `who:*` labels

For repos where author identity is insufficient — e.g., where one human drives several agents whose commits all land under the human's identity, but you want to distinguish autonomous-bot PRs from human-driven ones — add `who:*` labels:

- `who:human` / `who:<operator-handle>` / `who:<colleague-handle>`
- `who:autonomous-agent` / `who:<your-bot-name>` / `who:dependabot`
- `who:bot` (Lovable, Renovate, CI app PRs)

A label-aware version of `session-pr-digest.sh` is straightforward to fork — query `--json labels` and bucket by label when present, fall back to author when not. The current canonical script keeps it simple (author only) because the marginal value of labels is small unless author identity is genuinely ambiguous.

**Don't introduce labels speculatively.** If author identity reliably tells you whose work a PR is, labels are friction that erodes over time. Add them when a real ambiguity case surfaces.

---

## Installing the hooks

Add to `~/.claude/settings.json` (or wherever your shell/IDE/agent expects session-start hooks):

```json
{
  "hooks": {
    "SessionStart": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "~/Documents/GitHub/harness/scripts/session-pr-digest.sh YOUR_ORG/repo1 YOUR_ORG/repo2"
          },
          {
            "type": "command",
            "command": "~/Documents/GitHub/harness/scripts/dirty-state-ownership.sh ~/Documents/GitHub/repo1 ~/Documents/GitHub/repo2"
          }
        ]
      }
    ]
  }
}
```

Both scripts are intentionally CLI-only and shell-portable — they work from any tool that can invoke a command on session start (Claude Code, your shell rc, an IDE hook, a cron, a tmux session-init script).

---

## What this convention deliberately is NOT

- **Not a project-management system.** This is a coordination *visibility* layer, not a tracker. Linear / Jira / GitHub Projects can sit alongside; this convention doesn't replace them.
- **Not real-time presence detection.** It doesn't tell you who's at the keyboard *right now*. The Phase 2 extension (per-agent heartbeats) is the layer for that — wait until visibility gaps from this convention prove that step is necessary.
- **Not enforcement.** No CI gate blocks a PR without `isDraft=false` discipline. The convention is a *help*; the digest's mismatch flag is what makes the discipline self-correcting (you see the gap, you fix it next time).

---

## Falsifiability

A multi-operator team running these primitives should observe, within 30 days:

- Investigating dirty working-tree state ≤ 1× / week
- Asking "whose PR is that?" effectively zero times — the digest answers proactively
- Asking "where's *<collaborator>*?" ≤ 1× / week
- Cross-operator branch conflicts ≤ 1× total

If 2+ of those fail, the gap is real — graduate to the per-agent heartbeat layer (heartbeats track *who's actively driving an agent right now*, not just *who authored the last commit*). The lighter primitives here can't solve presence; they only solve attribution.

---

## Origin

This convention was extracted from a real coordination failure on 2026-05-15 — a co-founder + contractor + three AI agents repo where the operator couldn't tell at a glance whose work was sitting in the working tree and whose PRs needed his attention. The investigation tax exceeded the build value. Conventions that look like "common sense" only become common sense when the tooling makes the right behavior the easy behavior.
