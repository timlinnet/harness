#!/usr/bin/env bash
# Harness installer — sets up your Claude Code environment with the
# Harness first-principles substrate + agent role skills.
#
# Usage:  ./install.sh
# Run from the cloned harness repo root.

set -e

HARNESS_REPO="$(cd "$(dirname "$0")" && pwd)"
CLAUDE_SKILLS="$HOME/.claude/skills"

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

# Helper: install a single skill with confirmation if it already exists
install_skill() {
  local skill_name="$1"
  local description="$2"
  local src="$HARNESS_REPO/skills/$skill_name/SKILL.md"
  local dst_dir="$CLAUDE_SKILLS/$skill_name"
  local dst="$dst_dir/SKILL.md"

  if [ ! -f "$src" ]; then
    echo "    ⚠️  Source missing: $src — skipped"
    return
  fi

  if [ -f "$dst" ]; then
    echo "    ⚠️  $skill_name already exists at $dst"
    read -p "       Overwrite? (y/n) " yn
    case "$yn" in
      [Yy]*) cp "$src" "$dst"; echo "       ✅  Updated";;
      *) echo "       ⏭️  Skipped";;
    esac
  else
    mkdir -p "$dst_dir"
    cp "$src" "$dst"
    echo "    ✅  $skill_name installed — $description"
  fi
}

# 2. Install the portable harness skill (the principles substrate)
echo "  → Installing harness skill"
install_skill "harness" "auto-fires on architectural / product / business decisions; loads first principles"

# 3. Install the four agent role skills
echo ""
echo "  → Installing agent role skills"
install_skill "ceo-plan-review" "challenge premises, find the 10x version, ICP pressure test"
install_skill "engineering-review" "pressure-test architecture, map failure modes, generate diagrams"
install_skill "office-hours" "YC-style product diagnostic — name the actual human, smallest wedge"
install_skill "autoplan" "auto-run CEO + Eng review with auto-decisions; surface taste calls at the gate"

echo ""
echo "  ✅  Harness installed."
echo ""
echo "  Next steps:"
echo ""
echo "  1.  Point your project's CLAUDE.md or .agent/AGENT.md at the canonical:"
echo "      \"~/GitHub/harness/FIRST_PRINCIPLES.md\""
echo "      (Or wherever you cloned this repo.)"
echo ""
echo "  2.  (Optional) Add a SessionStart hook to surface your open PRs + OPEN_LOOPS"
echo "      markers at every session start — see INSTALL.md for the snippet."
echo ""
echo "  3.  Start using it. Invoke any \"should we build X?\" / \"A or B?\" decision and"
echo "      the harness skill auto-fires. The agent role skills load Harness principles"
echo "      as their substrate automatically."
echo ""
echo "  Reference: github.com/timlinnet/harness"
echo ""
