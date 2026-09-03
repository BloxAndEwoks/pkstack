---
name: simplify
description: "The quality pass after building and before the sweep: review the changed code for reuse, simplification, efficiency, and altitude cleanups, then apply what survives adjudication. Quality only — it does not hunt for bugs; that is the verification steps' job. MANDATORY TRIGGERS: 'simplify this', 'run simplify', 'simplify pass', 'four-lens review'. Runs AFTER building and BEFORE verification — and over any substantial remediation diff (an external reviewer's --fix diff included, where a repo runs one) before it is committed. Do NOT trigger as a bug hunt or on an empty diff."
---

# Simplify

`/simplify → 4 cleanup lenses in parallel → adjudicate → apply what survives`

You are improving the quality of the changed code, not hunting for bugs. Review it for reuse,
simplification, efficiency, and altitude issues, then fix what survives adjudication. Do not look
for correctness bugs — that is what the router's verification steps are for.

This file is self-contained on purpose: in Claude Code, `/simplify` also exists as a built-in;
in any other environment (Cursor, Codex, a bare agent loop) this file IS the pass — follow it
directly.

## Phase 0 — Gather the diff

Run `git diff @{upstream}...HEAD` (or `git diff main...HEAD` / `git diff HEAD~1` if there's no
upstream) to get the unified diff under review. If there are uncommitted changes, or the range
diff is empty, also run `git diff HEAD` and include the working-tree changes in scope — the
review often runs before the commit. If a PR number, branch name, commit range, or file path was
passed as an argument, review that target instead. Treat this diff as the review scope.

## Phase 1 — Review (4 lenses, one agent each, in parallel)

Launch **4 independent review agents** (general-purpose subagents, never depth-capped search
agents), all in a single message so they run concurrently. Pass each agent the diff and one of
the four lenses below. Each returns its findings with `file`, `line`, a one-line `summary`, and
the concrete cost (what is duplicated, wasted, or harder to maintain).

**No-subagent fallback:** in an environment with no parallel fan-out, run the four lenses as
four SEQUENTIAL focused passes over the diff — one lens at a time, each producing its own
findings list before the next begins. Never collapse them into one combined pass: the lenses
compete for attention, and a combined pass reliably under-reports the later ones.

### Reuse

Flag new code that re-implements something the codebase already has — search shared/utility
modules and files adjacent to the change, and name the existing helper to call instead.

### Simplification

Flag unnecessary complexity the diff adds: redundant or derivable state, copy-paste with slight
variation, deep nesting, dead code left behind. Name the simpler form that does the same job.

### Efficiency

Flag wasted work the diff introduces: redundant computation or repeated I/O, independent
operations run sequentially, blocking work added to startup or hot paths. Also flag long-lived
objects built from closures or captured environments — they keep the entire enclosing scope
alive for the object's lifetime (a memory leak when that scope holds large values); prefer a
class/struct that copies only the fields it needs. Name the cheaper alternative.

### Altitude

Check that each change is implemented at the right depth, not as a fragile bandaid. Special
cases layered on shared infrastructure are a sign the fix isn't deep enough — prefer
generalizing the underlying mechanism over adding special cases.

## Phase 2 — Adjudicate, then apply

Wait for all four lenses to complete, dedup findings that point at the same line or mechanism,
and adjudicate each remaining one — the DRIVER holds this judgment, never the lens agents. Then
fix each survivor directly. Skip any finding whose fix would change intended behavior, require
changes well outside the reviewed diff, or that you judge to be a false positive — note the skip
rather than arguing with it. A worthwhile finding whose fix is genuinely out of scope for this
sitting is DEFERRED WITH A NAMED TRIGGER (recorded in the unit's probe or the repo's register
convention), never silently dropped.

Finish with a brief summary of what was fixed, what was skipped, and what was deferred with its
trigger (or confirm the code was already clean).

## Flow notes

- Remediation is new work the earlier steps never saw: a substantial fix batch (including an
  external reviewer's `--fix` diff, where a repo runs one) gets this pass before commit, exactly
  as first-build code does.
- A batch that accumulated across several checkpoints without a simplify pass gets one
  retroactively over the whole range — better late than layered.
