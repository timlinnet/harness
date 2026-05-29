# Install Guide

## Quick start

```bash
git clone https://github.com/timlinnet/harness.git ~/Documents/GitHub/harness
cd ~/Documents/GitHub/harness
./install.sh
```

That's everything. Five skills install into your Claude Code environment:

- **`harness`** — portable trigger skill (auto-fires on architectural / product / business / agent / team decisions; loads first principles from `FIRST_PRINCIPLES.md` via progressive disclosure)
- **`ceo-plan-review`** — challenge premises, find the 10x version, ICP pressure test before any planning
- **`engineering-review`** — pressure-test architecture, map failure modes, generate Mermaid diagrams, produce a buildable technical spec
- **`office-hours`** — YC-style product diagnostic; outputs a design doc, never code
- **`autoplan`** — auto-runs CEO + Eng review with auto-decisions; surfaces taste calls at a single approval gate

No additional dependencies. No second install. Run `./install.sh`, you're done.

## Next-step: point your project at Harness

Add to your project's `CLAUDE.md` or `.agent/AGENT.md`:

```markdown
## Read order on session start

1. This file — orientation
2. `~/Documents/GitHub/harness/FIRST_PRINCIPLES.md` — the north star.
   18 first principles + 13 strategic positions + Questioning Framework.
   When you're at a design fork, Harness is the tiebreaker.
3. [your project-specific docs]
```

## SessionStart hook (recommended)

Add to `~/.claude/settings.json` to auto-surface your open PRs + OPEN_LOOPS markers at every session start:

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
          },
          {
            "type": "command",
            "command": "~/Documents/GitHub/harness/scripts/harness-version-check.sh"
          },
          {
            "type": "command",
            "command": "echo \"🔄 Open Loops scan:\"; for f in $(find ~/Documents/GitHub -maxdepth 4 -name \"OPEN_LOOPS.md\" 2>/dev/null); do echo \"\"; echo \"== $f ==\"; if grep -q \"YOU ARE HERE\" \"$f\" 2>/dev/null; then grep -B 2 -A 3 \"YOU ARE HERE\" \"$f\" 2>/dev/null; else echo \"(no YOU ARE HERE markers)\"; fi; done"
          }
        ]
      }
    ]
  }
}
```

Replace `YOUR_ORG/repo1` and the local paths with your actual repos. Both scripts ship with this clone — `git pull` to update them.

## Multi-operator visibility

Two of the SessionStart hooks above (`session-pr-digest.sh` and `dirty-state-ownership.sh`) are part of Harness's multi-operator coordination primitives — designed for repos touched by more than one human or more than one AI agent. They turn raw `gh pr list` / `git status` dumps into **author-attributed, status-filtered** views, so you can open your laptop and know within 30 seconds what needs your attention.

- **`session-pr-digest.sh`** buckets open PRs by what they mean to *you* (your `gh api user` login). Five buckets: needs-your-review, discipline-mismatch (others' drafts that READ as ready — author forgot to un-draft), yours-ready, yours-drafting, others-drafting (collapsed).
- **`dirty-state-ownership.sh`** classifies each modified/untracked file in your repos as local-config noise, yours (recent), yours (stale), or another operator's. Collapses to *"all noise — zero code in flight"* when applicable.

See [`conventions/multi-operator.md`](conventions/multi-operator.md) for the full convention — discipline rules, optional `who:*` label scheme, falsifiability gate for graduating to per-agent heartbeats if these primitives leave real gaps.

Both scripts are CLI-only and shell-portable — they work from any tool that can invoke a command on session start (Claude Code, your shell rc, an IDE hook, tmux init).

## Optional: set up your own private overlay

Public Harness gives you the universal framework + agent role skills. Your **specific worked decisions, project layers, business context** belong in a private overlay you maintain alongside.

```bash
git init ~/Documents/GitHub/your-harness-private
cd ~/Documents/GitHub/your-harness-private
mkdir -p decisions
```

When you make a non-trivial architectural / product / business decision, write it as a numbered file (`0001-{topic}.md`) using the Decision Template from `FIRST_PRINCIPLES.md` → "The Questioning Framework" section.

The pattern: principles are universal (public). Decisions are yours (private). Both compose at runtime.

See `decisions/README.md` for the template + when to write a decision vs. just making the call.

## Updating Harness

```bash
cd ~/Documents/GitHub/harness
git pull
./install.sh  # re-runs; prompts on existing skills before overwriting
```

Watch the `CHANGELOG.md` for what changed. Harness updates are intended to be additive — new principles, sharpened positions, refinements — rarely breaking.

### Stay current automatically (optional)

Updating is manual *by design* — Harness ships plain markdown with no build step, so there is no installer daemon to keep running. But a cloned copy can drift silently off the shared canonical: you don't notice v18 landed until you happen to `git pull`. The `harness-version-check.sh` hook closes that gap. At every session start it does a quiet `git fetch` and, **only if you're behind**, prints a one-line nudge:

```
⬆️  Harness update available (v17 → v18). Run:  (cd ~/Documents/GitHub/harness && git pull)  — see CHANGELOG.md.
```

It's already in the SessionStart snippet above. Zero dependencies beyond git, and it fails soft — no network, no upstream, or already-current all produce no output. It stays silent for the framework author too (being *ahead* with unpushed work counts as current).

**Hands-off variant**: set `HARNESS_AUTO_PULL=1` and the hook will `git pull` for you — but only when your working tree is clean, so it never clobbers uncommitted work. If a skill file changed in the pull, re-run `./install.sh`.

This is deliberately a *notifier*, not a full auto-installer. A tool that ships a build step and compiled binaries (e.g. gstack) can justify a version-check binary + migrations; Harness is text files, so a `git pull` is the entire update and a shell nudge is the entire mechanism it needs.

## Troubleshooting

- **`gh` not found**: install GitHub CLI (`brew install gh` on Mac) — only needed for the SessionStart hook's PR-listing.
- **Skills not firing**: check `~/.claude/skills/` contents and Claude Code's skill picker. The `harness` skill triggers on decision language ("should we build X", "let's add Y", "A or B?").
- **Conflicts with existing skills**: `install.sh` prompts on overwrite. If you have your own `ceo-plan-review` etc., decide per-skill whether to keep yours or adopt the Harness-adapted version.

## Background

The agent role skills are adapted from [Garry Tan's gstack](https://github.com/garrytan/gstack) (MIT licensed). Tim's adaptations are leaner — they trade gstack-runtime scaffolding for portability so they run in any Claude Code environment without additional dependencies. Attribution to gstack is preserved at the top of each adapted SKILL.md file.

---

Questions: open an issue at github.com/timlinnet/harness/issues or reach out to Tim directly.
