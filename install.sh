#!/usr/bin/env bash
# Harness installer — sets up your local Claude Code environment to use Harness
# as the first-principles substrate alongside Garry Tan's gstack.
#
# Usage:  ./install.sh
# Run from the cloned harness repo root.

set -e

HARNESS_REPO="$(cd "$(dirname "$0")" && pwd)"
CLAUDE_SKILLS="$HOME/.claude/skills"
SETTINGS_JSON="$HOME/.claude/settings.json"

echo ""
echo "  Harness installer"
echo "  ─────────────────"
echo "  Repo:        $HARNESS_REPO"
echo "  Target dir:  $CLAUDE_SKILLS"
echo ""

# 1. Sanity check — Claude Code present?
if [ ! -d "$HOME/.claude" ]; then
  echo "  ❌  ~/.claude not found."
  echo "      Install Claude Code first: https://claude.com/claude-code"
  exit 1
fi

mkdir -p "$CLAUDE_SKILLS"

# 2. Install the portable harness skill (the auto-trigger for decisions)
echo "  → Installing harness skill (auto-fires on architectural / product / business decisions)"
mkdir -p "$CLAUDE_SKILLS/harness"
if [ -f "$CLAUDE_SKILLS/harness/SKILL.md" ]; then
  echo "    ⚠️  $CLAUDE_SKILLS/harness/SKILL.md already exists."
  read -p "       Overwrite? (y/n) " yn
  case "$yn" in
    [Yy]*) cp "$HARNESS_REPO/skills/harness/SKILL.md" "$CLAUDE_SKILLS/harness/SKILL.md"; echo "       ✅  Updated";;
    *) echo "       ⏭️  Skipped";;
  esac
else
  cp "$HARNESS_REPO/skills/harness/SKILL.md" "$CLAUDE_SKILLS/harness/SKILL.md"
  echo "    ✅  Installed"
fi

# 3. Install the four adapted gstack skills (lean versions with HARNESS INTEGRATION markers)
echo ""
echo "  → Installing adapted gstack skills (Garry Tan's gstack, MIT licensed,"
echo "    lean adaptations with HARNESS INTEGRATION markers wired in)"

for skill in ceo-plan-review engineering-review office-hours autoplan; do
  src="$HARNESS_REPO/skills/gstack-adapted/$skill/SKILL.md"
  dst_dir="$CLAUDE_SKILLS/$skill"
  dst="$dst_dir/SKILL.md"

  if [ ! -f "$src" ]; then
    echo "    ⚠️  Source missing: $src — skipped"
    continue
  fi

  if [ -f "$dst" ]; then
    echo "    ⚠️  $skill already exists at $dst"
    read -p "       Overwrite with Harness-adapted version? (y/n) " yn
    case "$yn" in
      [Yy]*) cp "$src" "$dst"; echo "       ✅  Updated";;
      *) echo "       ⏭️  Skipped";;
    esac
  else
    mkdir -p "$dst_dir"
    cp "$src" "$dst"
    echo "    ✅  $skill installed"
  fi
done

echo ""
echo "  ✅  Harness installed."
echo ""
echo "  Next steps:"
echo ""
echo "  1.  Point your project's CLAUDE.md or .agent/AGENT.md at the canonical:"
echo "      \"~/Documents/GitHub/harness/FIRST_PRINCIPLES.md\""
echo "      (Or wherever you cloned this repo.)"
echo ""
echo "  2.  (Optional) Add a SessionStart hook that surfaces open PRs + OPEN_LOOPS"
echo "      markers at every session start — see INSTALL.md for the snippet."
echo ""
echo "  3.  (Optional) Create your own private overlay for your worked decisions:"
echo "      git init ~/your-harness-private"
echo "      Use the Decision Template from FIRST_PRINCIPLES.md (Questioning Framework section)."
echo "      See decisions/README.md for the public/private architecture pattern."
echo ""
echo "  4.  Start using it: invoke any \"should I build X?\" decision and the harness"
echo "      skill auto-fires. The gstack-adapted skills load Harness as their"
echo "      principles substrate automatically."
echo ""
echo "  Reference: github.com/timlinnet/harness"
echo "  License:   See LICENSE (TBD — likely MIT for gstack-adapted code,"
echo "             CC-BY-SA for principles content)"
echo ""
