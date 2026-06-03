---
name: publish-harness
description: Proactively fire when work on the harness repo reaches a publishable state. Detect committed-but-unpushed commits on main, OR a substantive set of uncommitted edits that touch FIRST_PRINCIPLES.md, skills/, CHANGELOG.md, INSTALL.md, or README.md. Ask once before publishing — never push silently. SKIP firing when: changes are typo-only, work is mid-draft (no completion signal), the user hasn't stopped editing, or no harness content has changed. Cwd must be inside ~/GitHub/harness. Triggers on completion signals while in the repo ("done", "looks good", "ship it", "publish", "push it", "ready"), at session end with unpushed work, or after a substantive edit chain to harness content. The pre-push hook is the safety net — let it run, surface its output if blocked.
---

# Publish Harness — Proactive Publish Gate

You are the gatekeeper between Tim's local harness work and the public `timlinnet/harness` repo. Fire when there's something ready to ship; stay quiet otherwise. Your job is precision *and* recall — don't miss real publishes, don't fire on noise.

## When you fire

**Cwd check first.** Resolve `pwd`. If not under `~/GitHub/harness`, exit silently. This skill is repo-scoped.

**Detection — what counts as "something to publish":**

Run these checks. If ANY is true, you have a candidate:

1. **Unpushed commits on main**: `git rev-list --count origin/main..main` returns ≥ 1
2. **Substantive uncommitted edits**: `git diff --shortstat HEAD` shows ≥ 10 lines changed across content files (`*.md`, `*.sh`, `skills/**`, `decisions/**`)
3. **Staged-but-uncommitted edits** to harness content files

**Skip when ANY of these is true** (precision filter):

- Only file changed is `.DS_Store`, `.gitignore`, or a single-line typo
- Working tree shows `<` 5 lines added AND no file is FIRST_PRINCIPLES.md, a SKILL.md, or CHANGELOG.md
- The user's most recent message is exploratory ("what if", "thinking about", "draft") — wait for a completion signal
- A previous publish in this same session already shipped — don't re-prompt unless there's NEW unpushed work since
- A push attempt this session was blocked by the security hook and not yet resolved

## When to surface the proposal

Trigger naturally — don't shoehorn:

- **End of a substantive edit chain** — after writing a new principle, refining a skill, bumping the CHANGELOG version. The completion is the signal.
- **Explicit user signal** while in the repo: "looks good", "ship it", "push it", "publish", "ready", "done", "ok let's send it"
- **Session winding down** with unpushed work — surface before the user walks away

Don't fire when the user just asked a question, just read a file, or is mid-paragraph.

## The publish flow

When fired, do this — no extra ceremony:

### 1. Stage the right things

Look at `git status --short`. Stage what's clearly part of the in-flight change. Skip:
- Backup/swap files (`*~`, `.swp`)
- `.DS_Store`
- Anything in `.gitignore`

Don't blindly `git add -A`. Be specific. If anything looks like accidental scope, ask before staging.

### 2. Propose a commit message

Read the diff. Draft a message in the repo's established style — short imperative subject line, then body explaining why (catalyst, what surfaced this, what it changes). Mirror the v5/v6 CHANGELOG voice. Show Tim the proposed message and a one-line diff summary; let him approve or rewrite.

### 3. Commit, then push through the hook

```
git commit -m "<approved message>"
# Auth handling: if remote owner ≠ active gh account, switch:
remote_owner=$(git config remote.origin.url | sed -E 's|.*github\.com[:/]([^/]+)/.*|\1|')
active=$(gh api user --jq .login)
if [ "$remote_owner" != "$active" ]; then
  prior_active="$active"
  gh auth switch -u "$remote_owner" -h github.com
fi

git push origin main

# Restore the prior active account if it was switched
if [ -n "$prior_active" ]; then
  gh auth switch -u "$prior_active" -h github.com
fi
```

The `.githooks/pre-push` security scan runs automatically during `git push`.

### 4. Handle hook block

If the scan blocks:
- Surface the line-by-line hits to Tim verbatim
- Don't auto-override (`HARNESS_SECURITY_SKIP=1`). Ever. That's a deliberate, manual decision.
- Help Tim fix the flagged content, then re-stage and retry

### 5. Confirm + summarize

Report: commit SHA, files touched, lines changed, and the public URL (`github.com/<owner>/<repo>/commit/<sha>`). One paragraph. Then return to whatever Tim was doing.

## What this skill is NOT

- **Not a substitute for taste.** You're not deciding *whether* the content is good — Tim is. You're handling the mechanical ceremony around publishing once he's signaled (explicitly or implicitly) that it's ready.
- **Not a force-push or history-rewriter.** Never amend, force, or rebase published commits without explicit instruction.
- **Not for the private overlay.** This fires only for the public `timlinnet/harness` repo. If the cwd is a private overlay repo, exit silently.
- **Not a CHANGELOG generator.** If the change is large enough to warrant a CHANGELOG entry but Tim hasn't written one, surface that as a question — don't write the entry yourself.

## Self-correction

If you fire and Tim says "not yet" or "I'm not done", record that this skill mis-fired in this session and raise your bar for the next trigger (require an explicit completion signal). If you DON'T fire and Tim says "why didn't you publish?", note the trigger you missed for next time.

The framework Harness itself shapes this skill — Principle #8 (the framework is itself a feedback machine). This skill's recall/precision should improve with each session's evidence.
