---
name: deslop
description: Strip AI slop out of a diff before it becomes a commit. Use for /deslop, "deslop it", "clean up this diff", before each commit, and before opening a PR.
---

# Deslop

**A hygiene pass over the diff you are about to commit.** Run it per commit, not per branch: the unit is what this commit adds. With no target, read the current diff (`git diff` plus staged, or against the merge base for a branch). With named files, read only those.

You are cutting what the change does not need. You are not fixing bugs, not refactoring, and not changing behavior.

## What comes out

- **Narrating comments.** A comment that restates the line under it, announces a step (`// now validate the input`), or explains the diff to a reviewer instead of the code to a reader. Comments that carry a real reason — a workaround, a non-obvious constraint, a cited invariant — stay.
- **Unsupported defensive guards.** A null check, `try`/`catch`, fallback branch, or `any` cast added on speculation. A guard ships only when the diff can cite the evidence for it: an observed failure, a documented contract, a caller that really passes that shape. Belt-and-suspenders that "might help" is a hypothesis, not a fix, and hypotheses do not ship.
- **Dead compatibility paths.** Shims for callers that no longer exist, both-shapes handling where only one shape is ever produced, version branches for versions the repo does not support. Migrate callers, then delete (the **principle-migrate-callers-then-delete-legacy-apis** skill).
- **Unrelated edits.** Reformatting, drive-by renames, and stray files the change did not need. Split them out or drop them; they cost the reviewer more than they save.

## The rule that binds the pass

**Never change behavior.** Every cut must be provably inert: the guard was unreachable, the comment was prose, the path had no caller. When a cut would change what the code does, or when you find a real bug while reading, **flag it, do not fix it**. It goes in the report as a finding for the author, and the commit stays behaviorally identical.

If the same thing is true of a "cut" you are unsure about, keep it and flag it. An uncertain cut is not a hygiene fix.

## Report

One line per cut: what came out, where, and why it was inert.

```
- src/api/users.ts:41 — dropped `if (!user) return null`; the caller already narrows, no path reaches it
- src/api/users.ts:58 — dropped narrating comment restating the map below
- FLAG src/api/users.ts:72 — the retry swallows a 429 without backoff; behavior change, not mine to make
```

Then one sentence on what the diff looks like now. No exposition, no summary of the underlying change.
