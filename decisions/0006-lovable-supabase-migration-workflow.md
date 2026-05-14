# 0006 — Lovable + Supabase Migration Workflow

**Date**: 2026-05-14
**Status**: Decided; v1 build in progress
**Decided by**: Tim
**Audience**: Anyone using Lovable + Supabase CLI together. Solo founders especially.

## The decision

How do humans author Supabase migrations when **Lovable owns `supabase/migrations/`** as its private audit log?

The collision is structural: Lovable writes migration files into the repo *and* applies them via its own internal pipeline. The Supabase CLI also reads that folder and expects strict ownership. Humans who try to write SQL alongside Lovable find the CLI rejects their pushes because of accumulated sediment.

## Options considered

- **A) Quarantine + filename guard.** Move malformed files to archive, add pre-commit hook, keep status quo workflow. Low effort, low compound. Patches the symptom; sediment regrows on the next Lovable era-change.
- **B) Squash baseline + namespace split.** `db pull` to a single baseline + two folders (Lovable-owned vs human-owned). Clean ownership, but two mental models for newcomers to learn.
- **C) Squash baseline + single folder + automation harness.** One folder, one baseline; discipline lives in tooling (filename generator, pre-commit hook, data-migration sidecar). Medium upfront, extremely high compound. **Chosen.**
- **D) Status quo.** Negative compound. Every contributor pays the tax.

## Principles Engaged

- **Principle #7** (Complexity compounds non-linearly) — option B's two folders add surface area. Option C's tooling absorbs the complexity without forcing humans to internalize it.
- **Principle #8** (Feedback loops compound) — Option C is designed to accumulate signal. A v2 drift-detect cron becomes a feedback machine that teaches us Lovable's behavior over time.
- **Principle #10** (Tools become primitives) — Supabase CLI and Lovable both improve on independent curves. Don't bake today's awkward interaction into a permanent folder split.
- **Principle #15** (Wisdom directs, intelligence executes) — A human's wisdom is *what schema change to make*. Filename format / version offsets / repair commands are intelligence work. Automation absorbs that layer.
- **Principle #17** (Asymmetric attention is the leverage point) — every minute spent on "why is db push failing" is leverage stolen from real work.
- **Heuristic: Simplification trajectory** — option C makes the architecture *cleaner over time* as Lovable's own emission improves. A and B leave us at the same complexity forever.
- **Anti-fallacy: rewrite ≠ preservation** — Deleting hundreds of duplicate sediment files feels destructive but is structurally cheaper than patching around them. `git log` preserves filenames; remote `schema_migrations` and the actual schema preserve the SQL.

## Recommendation: Option C, V1 minimal

**One-time cleanup** (per affected project):

1. Snapshot the remote `supabase_migrations.schema_migrations` table as recovery insurance.
2. Move existing migration files to an out-of-CLI-scope backup folder.
3. Preserve any data migrations (INSERT/UPDATE/DELETE) to `scripts/data-migrations/<date>_description.sql` — `db pull` only captures schema.
4. `supabase migration repair --status reverted <all remote versions>` — resets the tracking table.
5. `supabase db pull --linked` — generates a single baseline file representing current schema.
6. Verify `supabase db push --linked --dry-run` is clean (no pending migrations).
7. Apply any preserved data migrations separately.

**Ongoing tooling** (committed to the repo):

- **`scripts/migration-new.sh <description>`** — the sole authoring entry point for human-written migrations. Generates `YYYYMMDDHHMMSS_lowercase_snake.sql` with a template header. Validates the description matches `^[a-z][a-z0-9_]*$` before creating the file. Generates UTC timestamps to match Lovable's convention.
- **`.githooks/pre-commit`** — rejects newly-added files in `supabase/migrations/` whose names don't match `^[0-9]{14}_[a-z][a-z0-9_]*\.sql$`. Scoped to `--diff-filter=A` (added files only) so it doesn't re-check the baseline or Lovable's older history. Enabled once per clone via `git config core.hooksPath .githooks`.
- **`scripts/data-migrations/`** — folder for non-schema SQL (INSERT/UPDATE/DELETE) that must be applied manually outside the migrations pipeline.

**Deferred to V2** (build only with real signal of need):

- `scripts/migration-sync.sh` wrapper (raw `supabase db pull` is one line; the wrapper adds nothing yet).
- Weekly drift-detection cron via scheduled-tasks MCP.
- `docs/migrations.md` (script `--help` output + this decision file are sufficient initial documentation).

## Worked example: a Lovable + Supabase project, 2026-05-14

State before:
- 501 files in `supabase/migrations/` — 147 malformed (`YYYYMMDDHHMMSS-uuid.sql` legacy Lovable format + `YYYYMMDDHHMMSS-.sql` empty-name AI-Edit format) + ~353 properly-named files that were duplicates of remote migrations (Lovable wrote local files with a 2–4 second UTC offset from the apply time) + 1 genuinely-pending data migration.
- 591 rows in remote `supabase_migrations.schema_migrations`.
- `supabase db push --linked` failed with "Remote migration versions not found in local migrations directory" listing all 591 versions.

State after:
- 1 baseline file in `supabase/migrations/`.
- 1 baseline row in remote `schema_migrations`.
- May 14 data migration in `scripts/data-migrations/`, applied separately.
- `supabase db push --linked --dry-run` clean.
- Pre-commit hook active. `scripts/migration-new.sh` is the authoring entry point.

## Could be wrong if

- **Lovable changes its emission model** to no longer write files into `supabase/migrations/` (e.g., uses an internal API only). The file-sync problem dissolves and the tooling becomes unused. Cost: writing one decision-deprecation note.
- **Supabase CLI adds first-class "shared folder" support** that distinguishes bot-written vs human-written migrations natively. The hook becomes redundant. Same minor cost.
- **A future Lovable era-change introduces a different malformed-filename pattern.** The pre-commit regex needs updating. Mitigated by `--diff-filter=A` scope — only NEW commits are blocked, existing files stay; the v2 drift-detect cron would surface the new pattern early.

## Alternative bets not taken

- **Bet that Lovable will fix its own emission and we just need to wait.** Plausible — Lovable's modern format is already correct. But the *historical* sediment is permanent, and any future era-change repeats the problem. Tooling that's portable across eras compounds more than waiting.
- **Bet that humans will rarely write Supabase migrations.** Possibly true for solo Lovable users. But for any team or any project where security / RLS / cron / specialized SQL is needed (FreedomOS, PCAI), human-authored migrations are recurring. The tooling earns its keep on the first manual fix.

## Adoption note for harness users

This pattern applies to **any** project where Lovable (or any similar AI builder that writes migration files behind the scenes) coexists with Supabase CLI usage. To adopt:

1. Copy `scripts/migration-new.sh` and `.githooks/pre-commit` from a project that's adopted this pattern (adapt the regex if your team uses different filename conventions).
2. `git config core.hooksPath .githooks` once per clone.
3. Run the one-time cleanup if your project has accumulated sediment.

The one-time cleanup writes to remote `supabase_migrations.schema_migrations`. **Snapshot that table first** as recovery insurance. The actual database schema is never touched by the cleanup — only the tracking table.

## Reference implementation

The V1 build of the scripts, hook, and worked cleanup lives in a private project repo. Adopters: implement the V1 minimal recipe (3 items) directly in your project rather than depending on a reference.
