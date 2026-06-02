#!/usr/bin/env bash
# gstack-skill-guard.sh — self-heal broken gstack skill symlinks at session start.
#
# Failure mode this prevents: the gstack repo moves (e.g. the 2026-06-01 iCloud
# Documents→~/GitHub relocation) → the ~/.claude/skills/gstack MASTER symlink
# dangles → every gstack-* skill link (which routes through the master) breaks →
# Harness/gstack review skills silently fail to load mid-run.
# See memory: icloud-documents-repo-relocation / reference: gstack-relink.
#
# Strategy (cheap, runs every SessionStart):
#   1. If the master symlink dangles (repo moved), re-point it to the first known
#      gstack checkout. In the via-master link form this alone heals every link.
#   2. If any gstack link is still dangling (rare per-skill breakage), run the
#      blessed gstack-relink to rebuild them.
# Silent when healthy. Only prints when it actually had to heal something.
set -u

SK="$HOME/.claude/skills"
MASTER="$SK/gstack"

# gstack not installed here → nothing to guard.
[ -L "$MASTER" ] || exit 0

acted=""

# 1. Master dangling (repo moved)? Re-point to the first existing gstack checkout.
if [ ! -e "$MASTER" ]; then
  for cand in "$HOME/GitHub/gstack" "$HOME/Documents/GitHub/gstack" "$HOME/gstack" "$HOME/PCAI/gstack"; do
    if [ -f "$cand/SKILL.md" ]; then
      ln -sfn "$cand" "$MASTER"
      acted="re-pointed master → $cand"
      break
    fi
  done
fi

# 2. Any gstack skill link still dangling (master OK, per-skill breakage)? Relink.
if [ -e "$MASTER" ] && find "$SK" -maxdepth 2 -type l ! -exec test -e {} \; -print -quit 2>/dev/null | grep -q .; then
  if "$MASTER/bin/gstack-relink" >/dev/null 2>&1; then
    acted="${acted:+$acted; }ran gstack-relink"
  fi
fi

# Report only when we acted, and verify the outcome honestly.
if [ -n "$acted" ]; then
  if find "$SK" -maxdepth 2 -type l ! -exec test -e {} \; -print -quit 2>/dev/null | grep -q .; then
    echo "⚠️ gstack skill links broken and auto-heal INCOMPLETE ($acted). Inspect ~/.claude/skills and the gstack checkout location."
  else
    echo "🔧 gstack skill links were broken — auto-healed ($acted)."
  fi
fi

exit 0
