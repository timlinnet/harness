#!/usr/bin/env bash
# Harness version-check — featherweight staleness notifier.
#
# Quietly fetches origin and tells you if your local Harness clone has fallen
# behind the shared canonical. The update itself stays a one-command `git pull`
# — this script only converts silent drift into a visible nudge at session start.
#
# Zero dependencies beyond git. Fails SOFT: any error (no git, not a repo, no
# network, no upstream, already current) produces no output and exits 0, so it
# never stalls or noises up a session start.
#
# Wire into your SessionStart hook (see INSTALL.md). It is the authorship-side
# companion to the multi-operator visibility scripts: those answer "whose work is
# this?", this answers "am I still on the latest shared principles?".
#
# Env:
#   HARNESS_DIR        repo location (default: ~/Documents/GitHub/harness)
#   HARNESS_AUTO_PULL  set to 1 to auto-pull when the working tree is CLEAN
#                      (never clobbers uncommitted work; falls back to a nudge)

set -u

HARNESS_DIR="${HARNESS_DIR:-$HOME/Documents/GitHub/harness}"

# Bail silently unless we have git and a real clone.
command -v git >/dev/null 2>&1 || exit 0
[ -d "$HARNESS_DIR/.git" ] || exit 0

# Quiet fetch, guarded so a slow/absent network aborts fast instead of stalling
# the session (drop the connection after ~5s of <1KB/s; offline fails instantly).
git -c http.lowSpeedLimit=1000 -c http.lowSpeedTime=5 \
    -C "$HARNESS_DIR" fetch --quiet origin 2>/dev/null || exit 0

# Need an upstream to compare against.
UPSTREAM="$(git -C "$HARNESS_DIR" rev-parse --abbrev-ref --symbolic-full-name '@{u}' 2>/dev/null)" || exit 0
[ -n "$UPSTREAM" ] || exit 0

# How many commits is local behind upstream? (Ahead-only — e.g. the author with
# unpushed work — counts 0 here and stays silent.)
BEHIND="$(git -C "$HARNESS_DIR" rev-list --count 'HEAD..@{u}' 2>/dev/null || echo 0)"
{ [ "$BEHIND" -gt 0 ]; } 2>/dev/null || exit 0   # current (or non-numeric) → silent

# Best-effort friendly version labels from the CHANGELOG (local vs remote).
LOCAL_VER="$(git -C "$HARNESS_DIR" show 'HEAD:CHANGELOG.md' 2>/dev/null | grep -m1 -oE '^## v[0-9]+' | grep -oE 'v[0-9]+')"
REMOTE_VER="$(git -C "$HARNESS_DIR" show "$UPSTREAM:CHANGELOG.md" 2>/dev/null | grep -m1 -oE '^## v[0-9]+' | grep -oE 'v[0-9]+')"
if [ -n "$LOCAL_VER" ] && [ -n "$REMOTE_VER" ]; then
  VER_MSG="$LOCAL_VER → $REMOTE_VER"
else
  VER_MSG="$BEHIND commit(s) behind"
fi

# Opt-in auto-pull — only when the tree is clean, so WIP is never clobbered.
if [ "${HARNESS_AUTO_PULL:-}" = "1" ] && [ -z "$(git -C "$HARNESS_DIR" status --porcelain 2>/dev/null)" ]; then
  if git -C "$HARNESS_DIR" pull --quiet --ff-only 2>/dev/null; then
    echo "⬆️  Harness auto-updated ($VER_MSG). Re-run ./install.sh if any skill changed."
    exit 0
  fi
fi

echo "⬆️  Harness update available ($VER_MSG). Run:  (cd \"$HARNESS_DIR\" && git pull)  — see CHANGELOG.md. Re-run ./install.sh if any skill changed."
exit 0
