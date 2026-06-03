#!/usr/bin/env bash
#
# Primary-checkout tidy — keeps a shared "primary" clone parked on a clean, current
# main so nobody has to babysit it. Feature work belongs in worktrees; the primary is
# only ever a home base. Wired into SessionStart (see ~/.claude/settings.json), it
# replaces the old "⚠️ you are N behind — run these commands" nag, which (a) made the
# human do the chore and (b) couldn't even run when the tree was dirty.
#
# NEVER destructive — it only acts when there is nothing to lose:
#   • on main, clean, behind        → fast-forward to origin/main
#   • on main, uncommitted work     → leave it (that's normal in-progress editing)
#   • on a FEATURE branch, clean    → return to main + fast-forward (branch ref kept)
#   • on a FEATURE branch, dirty    → DO NOT TOUCH (may be a live session). Back the
#                                     tracked changes up to a recoverable snapshot ref
#                                     and address the note to the agent, not the human.
#
# The "stuck" condition the old nag was really about is *parked on a non-main branch*.
# Being on main with some uncommitted files is fine and gets no nag.
#
# Arg: path to the primary checkout (default ~/GitHub/freedom-ai). Fails soft (exit 0)
# on any error so it never stalls or noises up a session start.

set -u
P="${1:-$HOME/GitHub/freedom-ai}"

command -v git >/dev/null 2>&1 || exit 0
[ -d "$P/.git" ] || exit 0

git -C "$P" fetch --quiet origin main 2>/dev/null || true
BR="$(git -C "$P" rev-parse --abbrev-ref HEAD 2>/dev/null || echo '?')"
BEHIND="$(git -C "$P" rev-list --count HEAD..origin/main 2>/dev/null || echo 0)"
DIRTY="$(git -C "$P" status --porcelain 2>/dev/null | wc -l | tr -d ' ')"

echo "🧭 Primary checkout:"

# On main = home base. Fast-forward when clean+behind; never nag about uncommitted work.
if [ "$BR" = "main" ]; then
  if [ "${DIRTY:-0}" -gt 0 ]; then
    echo "  ✅ on main ($DIRTY uncommitted — normal working state, left as-is)."
  elif [ "${BEHIND:-0}" -gt 0 ]; then
    git -C "$P" merge --ff-only origin/main >/dev/null 2>&1 \
      && echo "  ✅ fast-forwarded to origin/main ($BEHIND new)." \
      || echo "  ℹ️  on main but couldn't fast-forward (diverged) — agent will check."
  else
    echo "  ✅ on main, current."
  fi
  exit 0
fi

# On a feature branch = the stuck case. Clean → auto-return; dirty → snapshot + note.
if [ "${DIRTY:-0}" -eq 0 ]; then
  if git -C "$P" checkout main >/dev/null 2>&1 && git -C "$P" merge --ff-only origin/main >/dev/null 2>&1; then
    echo "  ✅ auto-returned to clean main (was parked on '$BR' — that branch is kept, just not checked out here)."
  else
    echo "  ℹ️  on '$BR' (clean) but couldn't auto-return — agent will tidy."
  fi
else
  SNAP="$(git -C "$P" stash create "primary-tidy auto-backup ($BR)" 2>/dev/null || true)"
  if [ -n "$SNAP" ]; then
    git -C "$P" update-ref "refs/wip-backups/primary-latest" "$SNAP" 2>/dev/null || true
    BK=" (tracked changes backed up → refs/wip-backups/primary-latest)"
  else
    BK=""
  fi
  echo "  ℹ️  parked on feature branch '$BR' with $DIRTY uncommitted file(s)$BK."
  echo "      Agent: land it / move it to a worktree, then return the primary to main —"
  echo "      not touching it while dirty, it may be an active session."
fi
exit 0
