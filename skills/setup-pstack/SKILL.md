---
name: setup-pstack
description: Configure which models pstack uses per role. Detects your available models and writes a note that overrides the skill defaults. Use for /setup-pstack, "configure pstack models", or changing pstack's model choices.
---

# Setup pstack

Write `~/.claude/pkstack-models.md`, a plain markdown note that sets pstack's model per role. Claude Code has no always-applied rule file, so this is a note the skills read when it is present; a role with no line falls back to that skill's inline default. Override layer, not a requirement.

## Steps

### 1. Detect available models

The dependable source is the set of model slugs the `Agent` tool accepts in this session: `opus`, `sonnet`, `haiku`, and `fable`. Confirm them against the tool schema rather than assuming; never write a slug you have not confirmed. The aliases `inherit-parent` and `auto` are always valid even though they are not detected slugs.

### 2. Load current state

The default role-to-model mapping is the shape shown in step 5 below. If `~/.claude/pkstack-models.md` already exists, read it and treat its values as the current choices. Otherwise start from those defaults.

### 3. Map and confirm

Show every role with its current model, marking any real slug not in the detected set as needing a choice. Ask whether to accept as-is or change specific roles, offering the detected models plus `inherit-parent` and `auto` (both mean: this role runs on the parent chat model) as the options. Prefer AskQuestion over free text. For panel roles (how critics, arena runners, architect runners, interrogate reviewers) the value is a list, and one subagent runs per entry, alias entries included, so the list length sets the count. `arena cross-judge pool` is also a list, but Arena selects one value from it whose model family differs from the parent's when possible. `swarm workers` is the default model for every worker unless a race or comparison assigns another model per arm. `close-unit sampler` roles are the three process-review lenses close-unit fans out at a unit close.

### 4. Validate

Every real slug written must be in the detected set; `inherit-parent` and `auto` always pass. If a chosen real slug is not available, stop and ask again. A note pointing at a model the user cannot use breaks every delegation that reads it.

### 5. Write the note

Write `~/.claude/pkstack-models.md` with one line per role, using the same labels poteto-mode uses. Overwrite the whole file so re-runs stay idempotent. Shape:

```
# pkstack model configuration. One line per role. Delete a line to fall back to the skill default.
# `inherit-parent` or `auto` as a value: the role runs on the parent chat model (omit Task `model`). Alias entries in a panel list still count toward its fan-out.
feature, refactoring: opus
bug-fix: opus
perf-issue: opus
hillclimb: opus
judgment and prose: fable
hardest tasks: fable
how explorer: sonnet
how critics: fable, opus, sonnet
why investigators: sonnet
why synthesizer: fable
close-unit sampler judgment, divergent: fable
close-unit sampler tooling: opus
arena runners: fable, opus, sonnet
arena cross-judge pool: fable, opus, sonnet
swarm workers: sonnet
architect runners: fable, opus, sonnet
interrogate reviewers: fable, opus, sonnet
```

### 6. Confirm

Tell the user the note was written and that it applies to new sessions. Re-running this skill updates it.

### 7. Offer a verification skill (optional)

Check whether the project has a way to drive the real app for proof (a `verify-*` skill, or an existing harness). If not, offer once: "want a project-local verification skill, so agents can drive the app the way a user does and prove changes work? I can generate one with /create-verification-skill." On yes, invoke `/create-verification-skill` (resolves wherever pstack is installed — workspace, user, or plugin). On no, move on without pushing.
