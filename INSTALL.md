# Install Guide

## Quick start

```bash
git clone https://github.com/timlinnet/harness.git ~/Documents/GitHub/harness
cd ~/Documents/GitHub/harness
./install.sh
```

That gets you:
- `~/.claude/skills/harness/` — the portable trigger skill (auto-fires on architectural/product/business decisions, loads Harness principles)
- `~/.claude/skills/{ceo-plan-review, engineering-review, office-hours, autoplan}/` — Tim's lean adaptations of Garry Tan's gstack skills with HARNESS INTEGRATION markers wired in (Garry's MIT-licensed work; this is the redistributable lean version)

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
            "command": "echo \"📋 Open PRs across your repos:\"; for repo in YOUR_ORG/repo1 YOUR_ORG/repo2; do gh pr list --repo \"$repo\" --state open 2>/dev/null | sed \"s|^|  [$repo] |\"; done; echo \"\""
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

Replace `YOUR_ORG/repo1` etc with your actual repos. The OPEN_LOOPS scanner finds any `OPEN_LOOPS.md` files in your `~/Documents/GitHub` directory and shows entries marked `← YOU ARE HERE`.

## Optional: set up your own private overlay

Public Harness gives you universal framework + adapted gstack skills. **Your specific worked decisions, project layers, business context** belong in a private overlay you maintain alongside.

```bash
git init ~/Documents/GitHub/your-harness-private
cd ~/Documents/GitHub/your-harness-private
mkdir -p decisions
```

When you make a non-trivial architectural decision, write it as a numbered file (`0001-{topic}.md`) using the Decision Template from `FIRST_PRINCIPLES.md` → "The Questioning Framework" section.

The pattern: principles are universal (public). Decisions are yours (private). Both compose at runtime.

See `decisions/README.md` in this repo for examples of decision shapes.

## Updating Harness

```bash
cd ~/Documents/GitHub/harness
git pull
./install.sh  # re-runs; will prompt on existing skills
```

Watch the `CHANGELOG.md` for what changed. Harness updates are intended to be additive — new principles, new strategic positions, refinements — rarely breaking.

## Troubleshooting

- **`gh` not found**: install GitHub CLI (`brew install gh` on Mac) for the SessionStart hook PR-listing to work.
- **Skills not firing**: check `~/.claude/skills/` contents and Claude Code's skill picker. Skills auto-fire based on description matching; the `harness` skill triggers on decision language ("should we build X", "let's add Y", "A or B?").
- **Conflicts with existing skills**: `install.sh` prompts on overwrite. If you have your own `ceo-plan-review` etc, decide per-skill whether to keep yours or adopt the Harness-adapted version.

## Background

- **Public Harness** — this repo. Universal first-principles framework, adapted gstack skills, install tooling.
- **Private overlay** — yours to maintain (or use Tim's template at `timlinnet/harness-private` if you have access).
- **gstack** — [Garry Tan's open-source skill suite](https://github.com/garrytan/gstack) (MIT licensed). The full unmodified gstack is more elaborate than this lean adaptation; you may want it for reference or to pull future updates.
- **FreedomOS** — Tim's product (the canonical for live business state). Out of scope for this install.

---

Questions: open an issue at github.com/timlinnet/harness/issues or reach out to Tim directly.
