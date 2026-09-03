---
name: interrogate
description: "Use for \"interrogate\", \"adversarial review\", \"multi-model review\", \"challenge this\", \"stress test this code\", \"find blind spots\", or \"tear this apart\". Multiple LLM reviewers challenge changes from independent angles."
disable-model-invocation: true
---

# Interrogate

Spawn one reviewer per configured model to adversarially review code changes. Each model gets the same prompt and rubric. The adversarial signal comes from model diversity, not assigned personas. Models differ in blind spots, priors, and reasoning patterns. Agreement across models is high-confidence signal; lone-model findings are worth reading but lower confidence.

The deliverable is a synthesized verdict. Do NOT auto-apply changes.

One round per unit is the cap. Two triggers fire it. A contested design, and a gated unit's non-author round over the whole unit diff before the PR opens.

## Step 1, Determine Scope

Identify what to review from context:

- If the user points at specific files or a diff, use that
- If on a feature branch, run `git diff main...HEAD` (or the appropriate base branch) for the full changeset
- If the user's message references recent work, gather the relevant files

Package the diff (or file contents) plus any surrounding context files the reviewers need to understand the code.

## Step 2, State the Intent

Before spawning reviewers, state the intent explicitly. What is this code trying to accomplish? Derive this from:

- The user's message
- Commit messages
- PR description if one exists
- The code itself

Write one clear paragraph. Reviewers challenge whether the work achieves the intent well, not whether the intent itself is correct. If you're unsure about the intent, ask the user before proceeding.

## Step 3, Spawn Reviewers

Launch all reviewers in a single message using the Task tool. Use the `interrogate reviewers` list from `~/.claude/pkstack-models.md` when present, one reviewer per entry, extending or shrinking the Reviewer A/B/C/D labels below to the configured entry count; otherwise use the table defaults.

| Subagent | Default model |
|----------|---------------|
| Reviewer A | `claude-fable-5-thinking-max` |
| Reviewer B | `gpt-5.6-sol-max` |
| Reviewer C | `grok-4.6-fast-xhigh` |
| Reviewer D | `claude-opus-5-thinking-xhigh` |

For each reviewer:
- `subagent_type`: `"general-purpose"`
- `model`: the configured `interrogate reviewers` entry, or the table default with no configured line
- `readonly`: `true`

If a model slug is rejected as unresolvable when you try to spawn the subagent, check the valid slugs in the Task tool's error message, pick the closest equivalent (prefer the highest-reasoning tier of the same family), spawn with the valid slug, and open a separate PR to update the configured value or default table. Do not block the review on the slug issue. If the configured value is `inherit-parent` or `auto`, omit `model` instead; never treat those aliases as broken slugs or enter this fallback for them.

Read `references/reviewer-prompt.md` and fill in the template with:
1. The stated intent
2. The diff or file contents
3. The review rubric from `references/rubric.md`
4. The code-quality lens from `references/code-quality-review.md`

The same filled template goes to all reviewers, so every model applies the code-quality lens.

Which round this is decides what the reviewers see. On a contested-design round they are samplers and stay ledger-blind, because the class you are hunting is one the ledger has not named yet. On a gated unit's non-author round they are fed the repo's finding ledger, because what that round buys is independence from the builder over known classes, not novelty.

Each reviewer produces structured findings as described in the prompt template.

## Step 4, Synthesize

As results come back, build a unified picture:

1. **Parse all findings** from the reviewers
2. **Identify consensus**. Findings raised by 2+ models independently are highest signal.
3. **Identify lone-model findings**. Still worth reading, but weight accordingly.
4. **Deduplicate**. Different models may describe the same issue differently. Merge these and note which models raised it.
5. **Note disagreements**. If one model flags something and another explicitly says the opposite, that's useful context for the verdict.
6. **Cluster by mechanism**. Group the surviving findings by the cause they share, not by the symptom they wear.
7. **Classify each cluster** as missing GUARD, missing FACT, or wrong MODEL.

Carry each finding's Location and Severity into the Act On entries. The reviewer prompt already produces both, and a finding that drops them is no longer citable.

Give every surviving finding a `reachable` value, one of `real user today`, `crafted client`, `raw writer`, `operator`, or `not today`. Evidence it at rung 4 or higher of the **blast-radius** evidence ladder, meaning you ran it or you reproduced it in the running app. A finding you could not reproduce gets no value and enters no bucket.

## Step 5, Lead Judgment

You are the lead reviewer, a pragmatic senior engineer, not a neutral aggregator.

Read `references/lead-judgment.md` for the full framework. Reviewers only see a slice of the codebase. You have the full context (the goal, the constraints, the timeline, which tradeoffs were already considered). Use that context aggressively.

Categorize every finding using these buckets. The `reachable` value picks the bucket, not the severity word the reviewer chose.

- **Act on**. `reachable: real user today`. Fixed by class before the PR opens. A finding at any other reachability lands here too when the design itself is wrong (a wrong MODEL cluster), because a named trigger cannot hold a broken model.
- **Consider**. Reproduced at `crafted client`, `raw writer`, or `operator`, and expensive to leave standing. Registered with a named trigger, and worth the user's attention now.
- **Noted**. Reproduced but `not today`, or reachable only past a boundary nothing crosses yet. Registered with a named trigger and left there.
- **Dismissed**. Wrong, nitpicky, or missing context. Brief explanation why.

For each finding, include:
- Which model(s) raised it
- Its `reachable` value and the ladder rung that evidenced it
- The category (act on / consider / noted / dismissed)
- A one-line rationale for the categorization

## Output Format

Present the verdict in this structure:

### Intent
> [The stated intent paragraph from Step 2]

### Reviewers
- Reviewer [label]: [model name], [N findings] (one bullet per reviewer)

### Act On
[Findings that should be addressed. For each: description, which models raised it, why it matters.]

### Consider
[Findings worth thinking about. For each: description, which models raised it, tradeoff involved.]

### Noted
[Valid but low-priority. Brief list.]

### Dismissed
[Rejected findings with brief rationale. This shows the user what was filtered out and why, so they can override your judgment if they disagree.]

### Agreement Map
[Where did models agree, where did they diverge, and what does the pattern of agreement/disagreement tell us?]

## Persist the Verdict

The synthesized verdict does not end in the chat. Write it to the repo's probe or docs spine, Dismissed bucket included. A dismissal is a recorded non-member, and it is what stops a later close from over-claiming a lesson's extension.
