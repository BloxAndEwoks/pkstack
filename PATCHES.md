# PATCHES.md — the permanent merge-tax ledger

Every edit to a vendored (pstack-origin) file is registered here. This list is the complete
merge-conflict forecast for every future `git merge vendor`, and the wire-check's input: each
entry carries a `grep:` pattern that must hit after any vendor merge, or the wire is dead even
though the merge was textually clean.

Discipline: additive files are never listed (they cannot conflict). An entry is added in the
same commit as its patch. The wire-check (`scripts/wire-check.sh`) greps every pattern and
fails loudly on a miss.

Refresh procedure:
```
cd <cursor-plugins clone> && git subtree split --prefix=pstack -b pstack-split
cd ~/Documents/pkstack && git fetch <clone> pstack-split:vendor-new
git checkout vendor && git merge --ff-only vendor-new && git checkout main
git merge vendor && scripts/wire-check.sh
```

## P0 — merge-time resolutions (not wires; recorded for the next merge)

| file | resolution |
|---|---|
| `.cursor-plugin/plugin.json` | ours (pkstack manifest) |
| `README.md` | ours (pkstack README) |
| `skills/create-verification-skill/**` | ours — kstack v0.3 superset; pstack's create/maintain interview already folded in |
| `skills/reflect/**` | deleted — its three reviewer prompts moved to `skills/close-unit/references/` and rewired to return process findings; `synthesizer.md` dropped, close-unit's own procedure is the synthesizer. A vendor merge resurrects this directory; delete it again. |
| `skills/maintain-verification-skill/**` | deleted — every generated verify-<project> carries its own MAINTAIN mode; this stale duplicate delivered by "one PR" and drifted from the generator. A vendor merge resurrects this directory; delete it again. |

## Wires (P1/P2 entries appended as they land)

<!-- entry format:
### <wire-id> — <file>
why: <one line>
grep: <pattern that must hit post-merge>
-->

### p1-poteto-agent-slug — agents/poteto-agent.md
why: the agent-type slug is Claude Code's `general-purpose`, not Cursor's `generalPurpose`.
grep: Substituting `general-purpose`

### p1-guide-install — docs/guide/01-setup.md
why: install flow, models-note path, and verify-skill path retargeted to Claude Code.
grep: ~/.claude/pkstack-models.md

### p1-guide-deslop — docs/guide/05-build-and-clean.md
why: `/deslop` is pkstack's own skill now, not a cursor-team-kit dependency.
grep: ../../skills/deslop/SKILL.md

### p1-guide-verify-path — docs/guide/06-verify-and-ship.md
why: generated verification skills live under `.claude/skills/`.
grep: .claude/skills/verify-<app>/

### p1-guide-loop — docs/guide/07-overnight.md
why: `/loop` is Claude Code's wake mechanism, not Cursor's.
grep: Claude Code's own wake mechanism

### p1-guide-close-unit — docs/guide/09-make-it-yours.md
why: reflect is excised; the lessons loop is close-unit into the repo ledger.
grep: /close-unit

### p1-arena-models — skills/arena/SKILL.md
why: per-role model config moved from a Cursor rule to a Claude Code note.
grep: ~/.claude/pkstack-models.md

### p1-automate-me-host — skills/automate-me/SKILL.md
why: transcript store, skill paths, and the authoring route are Claude Code's.
grep: ~/.claude/projects/

### p1-how-subagent — skills/how/SKILL.md
why: Task-call shape uses Claude Code's `general-purpose` agent type.
grep: "general-purpose"

### p1-interrogate-subagent — skills/interrogate/SKILL.md
why: Task-call shape plus the models-note path retargeted to Claude Code.
grep: "general-purpose"

### p1-poteto-router — skills/poteto-mode/SKILL.md
why: the control-skill trigger now names the repo's verify-<project> skill; reflect → close-unit; deslop is ours.
grep: verify-<project>

### p1-authoring-skill — skills/poteto-mode/playbooks/authoring-a-skill.md
why: no host `create-skill` skill exists in Claude Code; the playbook drafts the SKILL.md itself.
grep: Draft the `SKILL.md` here

### p1-autonomous-loop — skills/poteto-mode/playbooks/autonomous-run.md
why: `/loop` is Claude Code's own skill.
grep: Claude Code's own, not a pstack skill

### p1-autopilot-full-verify — skills/poteto-mode/playbooks/autopilot-full.md
why: live lane drives the repo's verification skill; owners are remote subagents; deslop is ours.
grep: verify-<project>

### p1-autopilot-stack-remote — skills/poteto-mode/playbooks/autopilot-stack.md
why: per-PR owners are background subagents with remote isolation, not Cursor cloud agents.
grep: isolation: "remote"

### p1-babysit-host — skills/poteto-mode/playbooks/babysit.md
why: the de-conflict is against any host-provided babysit skill, not Cursor's specifically.
grep: any host-provided babysit skill

### p1-bugfix-loop — skills/poteto-mode/playbooks/bug-fix.md
why: `/loop` is a Claude Code skill.
grep: the `/loop` skill

### p1-eval-transcripts — skills/poteto-mode/playbooks/eval.md
why: candidate transcripts live under `~/.claude/projects/`.
grep: ~/.claude/projects/

### p1-multiphase-verify — skills/poteto-mode/playbooks/multi-phase-plan.md
why: the control skill is the repo's verify-<project>; live lanes run with remote isolation.
grep: verify-<project>

### p1-pr-verify — skills/poteto-mode/playbooks/opening-a-pr.md
why: the Verification section names verify-<project>; `/deslop` is pkstack's own.
grep: verify-<project>

### p1-orchestrate-isolation — skills/poteto-mode/playbooks/orchestrate.md
why: `environment: "cloud"` is Cursor's Task schema; Claude Code uses `isolation: "remote"`.
grep: isolation: "remote"

### p1-pause-host — skills/poteto-mode/playbooks/pause-safely.md
why: the trigger phrase names the Claude Code host.
grep: restart Claude Code

### p1-pickup-transcripts — skills/poteto-mode/playbooks/session-pickup.md
why: prior trails live under `~/.claude/projects/`, not a Cursor agent-transcripts dir.
grep: ~/.claude/projects/

### p1-shipping-verify — skills/poteto-mode/playbooks/shipping.md
why: per-PR verifiers are remote subagents driving the repo's verification skill.
grep: verify-<project>

### p1-worktree-paths — skills/poteto-mode/playbooks/worktree-cleanup.md
why: hidden worktrees live under `.claude/`; the editor cache entry is host-neutral now.
grep: .claude/worktrees/

### p1-recall-transcripts — skills/recall/SKILL.md
why: Claude Code's transcript layout, slug rule, and the memory/ exclusion.
grep: ~/.claude/projects/<slug>/*.jsonl

### p1-setup-models — skills/setup-pstack/SKILL.md
why: writes a plain note at `~/.claude/pkstack-models.md`; Claude Code model slugs; close-unit sampler roles replace reflect's.
grep: ~/.claude/pkstack-models.md

### p1-smyw-transcripts — skills/show-me-your-work/SKILL.md
why: the truth check reads this workspace's transcripts under `~/.claude/projects/`.
grep: ~/.claude/projects/

### p1-swarm-fanout — skills/swarm/SKILL.md
why: fan-out uses `general-purpose` + `isolation: "remote"`; no `cloud_base_branch` in Claude Code.
grep: isolation: "remote"

### p1-why-subagent — skills/why/SKILL.md
why: Task-call shape plus MCP discovery described the Cursor environment.
grep: "general-purpose"

### p1-reviewer-judgment — skills/close-unit/references/judgment-reviewer.md
why: pstack-origin reflect reviewer, moved and rewired to return process findings to close-unit.
grep: close-unit driver

### p1-reviewer-tooling — skills/close-unit/references/tooling-reviewer.md
why: pstack-origin reflect reviewer, moved and rewired to return process findings to close-unit.
grep: close-unit driver

### p1-reviewer-divergent — skills/close-unit/references/divergent-reviewer.md
why: pstack-origin reflect reviewer, moved and rewired to return process findings to close-unit.
grep: close-unit driver
### p2-router-gating — skills/poteto-mode/SKILL.md
why: the BASE-capture trigger (BASE at task start, the prototype carve-out, the same-BASE re-route rule, the one-time kstack-init offer); there is no unit classification.
grep: Capture BASE in the same breath.

### p2-architect-lessons-map — skills/architect/SKILL.md
why: the driver instantiates the ledger against the synthesized package between Phase B and Phase C, with the runners' ledger-blindness stated as a deliberate omission; the package commits as the unit's probe.
grep: Then instantiate the ledger against it.

### p2-rationale-base-header — skills/architect/references/rationale-template.md
why: required BASE-SHA header line, and the Shape note now requires per-decision lesson annotations in the design's own nouns.
grep: **Required header line.** The document's first line, above Problem

### p2-feature-sweep — skills/poteto-mode/playbooks/feature.md
why: the delegate brief carries the implicated-lessons annotations, step 5 adds one named verification lane per implicated lesson, and step 5a runs the ledger sweep over BASE..head.
grep: **5a.** Sweep the unit's diff

### p2-bugfix-ledger — skills/poteto-mode/playbooks/bug-fix.md
why: the lesson the fix teaches is a separate object with the opposite evidence; step 2a looks the confirmed mechanism up in the ledger; step 5 prefers a quantifying check over sibling enumeration.
grep: **2a.** Look the confirmed mechanism up in the repo's finding ledger

### p2-tdd-quantify — skills/tdd/SKILL.md
why: the sibling-coverage guardrail now names the class and prefers one quantifying check; the focused test is the lesson's evidence, not its enforcement.
grep: prefer ONE check that quantifies over its members

### p2-laziness-scope — skills/principle-laziness-protocol/SKILL.md
why: scope note separating the fix and the diff (smallest change) from the lesson or mechanism it teaches (weakest sufficient statement over cited members).
grep: **Scope.** This protocol governs the fix and the diff.

### p2-hillclimb-pinned-log — skills/poteto-mode/playbooks/hillclimb.md
why: the decision log is pinned outside any worktree at `.audit/<task-slug>.tsv`; both `decision.tsv` occurrences corrected to `decisions.tsv`.
grep: Pin it outside any worktree, at

### p2-autonomous-third-fix — skills/poteto-mode/playbooks/autonomous-run.md
why: the third speculative fix on one path is a wrong-model tell, so re-frame the path instead of adding a fourth.
grep: The third speculative fix on one path is a wrong-model tell.

### p2-investigation-premortem — skills/poteto-mode/playbooks/investigation.md
why: a high-cost decision fork no experiment can settle routes through the premortem skill, folded into the tradeoffs table.
grep: route through the **premortem** skill before writing the recommendation

### p2-eval-promotion-frame — skills/poteto-mode/playbooks/eval.md
why: an eval on a promoted process lesson frames on the lesson ID and the finding class it must prevent; required at router level, queueable with a named trigger.
grep: the frame also cites the lesson ID and the finding class

### p2-authoring-findings-shape — skills/poteto-mode/playbooks/authoring-a-skill.md
why: a skill whose outputs include findings, verdicts, or a synthesis declares their shape and their consumer; most answer neither and skip it.
grep: If its outputs include findings, verdicts, or a synthesis

### p2-worktree-pinned-input — skills/poteto-mode/playbooks/worktree-cleanup.md
why: the pinned and active set is passed into the audit lever as an input so `safe` is unemittable for a pinned tree; the hand cross-check shrinks to a pointer.
grep: is unemittable for a pinned tree
### p2-pr-register — skills/poteto-mode/playbooks/opening-a-pr.md
why: every unit is REGISTERED at PR open (BASE, clusters so far) with a named close trigger; the Verification section names the ledger walk.
grep: A registered unit that never closes surfaces as an overdue register

### p2-shipping-close — skills/poteto-mode/playbooks/shipping.md
why: the ceiling step is the stack's close point, unconditional on any unit whose sweep or verifier landed findings; verdict lines carry the surface · mechanism · class schema.
grep: The close runs here for the stack's units whose sweep or verifier landed findings

### p2-babysit-emit-only — skills/poteto-mode/playbooks/babysit.md
why: the mid-run sweep is cut to EMIT-only — triage decisions become findings in the unit's probe; lessons and rubric edits wait for the close.
grep: Minting a lesson or editing the shared rubric

### p2-triage-mint-at-close — skills/poteto-mode/references/bugbot-triage.md
why: candidate learnings are appended at a unit's close, not mid-babysit; the confidence ladder is untouched.
grep: Append new candidate learnings here at a unit's close, never mid-babysit

### p2-swarm-blind-clusters — skills/swarm/SKILL.md
why: every arm declares its role and BLIND is the default (only build/coverage arms get the lessons map); Phase C aggregates into mechanism clusters with GUARD/FACT/MODEL tags.
grep: BLIND is the default: verification and exploration arms

### p2-interrogate-clusters — skills/interrogate/SKILL.md
why: synthesis clusters by mechanism and classifies GUARD/FACT/MODEL, carries Location and Severity into Act On, persists the verdict (Dismissed included) to the docs spine, and holds reviewers ledger-blind.
grep: **Classify each cluster** as missing GUARD, missing FACT, or wrong MODEL

### p2-arena-decision-record — skills/arena/SKILL.md
why: the synthesis note commits as the decision record in a repo with a docs spine, explicitly NOT as a ledger extension; runners stay ledger-blind.
grep: design rejections are decision-record material, never ledger extensions

### p2-orchestrate-close — skills/poteto-mode/playbooks/orchestrate.md
why: closes run at the drain/wave boundary with one ledger writer; briefs gain LESSONS (builders only) and REPORT gains mechanism-tagged FINDINGS; the store's verdict log is renamed ledger.tsv → verdicts.tsv to clear the collision with the repo's lesson ledger.
grep: Closes run at the wave boundary, over that wave's clustered findings

### p2-autopilot-full-close — skills/poteto-mode/playbooks/autopilot-full.md
why: the batch retro pass IS the close, run by the root over the batch's clustered swarm findings with the loop-health row; verdict lines carry the surface · mechanism · class schema.
grep: That retro pass is the close

### p2-autopilot-stack-close — skills/poteto-mode/playbooks/autopilot-stack.md
why: the close runs at chain delivery, the last moment the root holds the whole sample; verdict lines carry the surface · mechanism · class schema.
grep: chain delivery is the last moment the root holds the whole sample

### p2-pause-resume-fields — skills/poteto-mode/playbooks/pause-safely.md
why: the resume note carries the lessons-map path, the open triage clusters, and BASE and the named close trigger.
grep: Those last three are what a pickup agent cannot cheaply re-derive

### p2-pickup-reconstruct — skills/poteto-mode/playbooks/session-pickup.md
why: the reconstruct list gains the lessons-map path, the open triage clusters, and BASE and the named close trigger.
grep: Those last three are the artifacts a pickup cannot cheaply re-derive

### p2-fio-gated-classification — skills/figure-it-out/SKILL.md
why: the phase list carries the unit's BASE and close point, not a classification.
grep: the unit's BASE and its close point
### p2-router-close-trigger — skills/poteto-mode/SKILL.md
why: close routing: after the PR verifier's verdict, before the owner merges.
grep: the **close-unit** skill, before the owner merges

### p2-router-promotion — skills/poteto-mode/SKILL.md
why: process-lesson promotion rule in the Principles index (supplemental)
grep: A process lesson in the repo's finding ledger whose extension spans

### p2-feature-brief-map — skills/poteto-mode/playbooks/feature.md
why: delegate brief carries the map (supplemental)
grep: The brief carries the design package's implicated-lessons annotations

### p2-feature-lanes — skills/poteto-mode/playbooks/feature.md
why: one locking lane per implicated lesson (supplemental)
grep: gets its own named verification lane

### p2-bugfix-minimality — skills/poteto-mode/playbooks/bug-fix.md
why: two-razor scope clause (supplemental)
grep: The minimality rule governs the fix.

### p2-bugfix-quantify — skills/poteto-mode/playbooks/bug-fix.md
why: one quantifying check over sibling enumeration (supplemental)
grep: prefer one check that quantifies over the class

### p2-rationale-annotations — skills/architect/references/rationale-template.md
why: required lesson annotations on Shape decisions (supplemental)
grep: annotate every load-bearing decision

### p2-orch-store-rename — skills/poteto-mode/scripts/orch/store.ts
why: verdict log renamed verdicts.tsv in code, not just prose (A2 flagged drift)
grep: verdicts.tsv

### p2-orch-test-rename — skills/poteto-mode/scripts/orch/orch.test.ts
why: test follows the store rename
grep: verdicts.tsv
### p3-lever-pinned-input — skills/poteto-mode/scripts/worktree-audit.sh
why: M4 promotion — pinned set is a lever input; safe unemittable for a pinned tree
grep: pinned-list-file

### p3-lever-cc-transcripts — skills/poteto-mode/scripts/worktree-audit.sh
why: L1 member 3 — transcript path retargeted to Claude Code (missed by the *.md sweep)
grep: .claude/projects
### p4-router-model-invocable — skills/poteto-mode/SKILL.md
why: probe 002 — CC has no mode system; disable-model-invocation left the router dead unless the user typed it every task
grep: Invoke at the START of any multi-step engineering task

### p5-router-gating-source — skills/poteto-mode/SKILL.md
why: a delegate never captures BASE; BASE and the lessons map arrive in its brief.
grep: A delegate never captures BASE.

### p5-router-delegate-contract — skills/poteto-mode/SKILL.md
why: delegates are bound by agents/poteto-agent.md and never re-enter classification, review rounds, close-unit, or Opening a PR.
grep: bound by the delegate contract in `agents/poteto-agent.md`

### p5-feature-premortem-step2 — skills/poteto-mode/playbooks/feature.md
why: step 2 opens with the premortem whose ledger walk leaves the implicated-lessons map in the probe, then architect.
grep: Premortem the design package with the **premortem** skill

### p5-feature-composed-on — skills/poteto-mode/playbooks/feature.md
why: the delegate owns the diff and never spawns a review round; composed-on checkpoints take one non-author round before the next builds on them.
grep: A checkpoint is composed-on when it lands a migration

### p5-feature-verify-skill — skills/poteto-mode/playbooks/feature.md
why: step 5 drives the unit's changed mapped features through verify-<project>; MAINTAIN in the same sitting on a wrong map.
grep: drive the unit's changed mapped features as their consumer meets them

### p5-feature-reachable — skills/poteto-mode/playbooks/feature.md
why: 5a is mechanism-first; reachability decides timing only for a missing guard or a missing fact.
grep: Reachability comes second, and only for MISSING GUARD and MISSING FACT

### p5-pr-verification-ledger-line — skills/poteto-mode/playbooks/opening-a-pr.md
why: the Verification section's real path is the verify-<project> drives, and the ledger line carries the mechanism split.
grep: model/fact/guard a/b/c · j fixed now

### p5-pr-no-delegate-pr — skills/poteto-mode/playbooks/opening-a-pr.md
why: a delegate never opens a PR; the driver does, after its own deslop and no-comments.
grep: A delegate never opens a PR

### p5-refactor-verify-floor — skills/poteto-mode/playbooks/refactoring.md
why: the smoke through verify-<project> is the floor on a shipped surface; the equivalence check is additive.
grep: an equivalence check runs in addition to that smoke and never instead of it

### p5-autopilot-close-hedge — skills/poteto-mode/playbooks/autopilot-full.md
why: the batch close runs at the ceiling over every unit's clustered findings.
grep: the batch's clustered swarm findings, ending with the loop-health row appended

### p5-autopilot-stack-close-hedge — skills/poteto-mode/playbooks/autopilot-stack.md
why: the chain close runs at the ceiling over every unit's clustered findings.
grep: the chain's clustered swarm findings and append the loop-health row

### p5-poteto-agent-delegate — agents/poteto-agent.md
why: the agent file is the delegate contract, with the never-list the driver depends on.
grep: You never capture BASE, spawn a review subagent

### p5-smyw-driver-round — skills/show-me-your-work/SKILL.md
why: the cross-model trail review is the driver's step, never a delegate's.
grep: never spawned by a delegate

### p5-interrogate-cap-trigger — skills/interrogate/SKILL.md
why: one round per unit, fired by a contested design.
grep: One round per unit is the cap

### p5-interrogate-ledger-per-round — skills/interrogate/SKILL.md
why: interrogate reviewers are ledger-blind samplers; the PR verifier, not interrogate, reads the ledger as a floor.
grep: The reviewers stay ledger-blind.

### p5-interrogate-reachable — skills/interrogate/SKILL.md
why: findings carry a reachable value at rung 4 or higher, and the four buckets key on it.
grep: The `reachable` value picks the bucket

### p5-swarm-reachable — skills/swarm/SKILL.md
why: the cluster tag carries reachable alongside GUARD/FACT/MODEL.
grep: and a `reachable` value of `real user today`

### p5-create-verify-feature-seats — skills/create-verification-skill/SKILL.md
why: the verification seats are Feature steps 1 and 5 in the poteto-mode flow, and no step depends on an external gate.
grep: after building (Feature step 5

### p5-readme-router-pr-flow — README.md
why: the intro describes the router-and-PR flow with the ledger loop at its chokepoints, not a cadence.
grep: the unit is the work behind one PR

### p5-guide-maintain-mode — docs/guide/06-verify-and-ship.md
why: maintain-verification-skill is deleted; MAINTAIN is a mode inside the generated verify skill.
grep: run verify-<app> in maintain mode

### p5-guide-verify-generator — docs/guide/09-make-it-yours.md
why: the maintain-verification-skill link is dead; only create-verification-skill remains, and the close runs before the PR opens.
grep: The generated skill carries its own MAINTAIN mode

### p6-feature-mechanism-first — skills/poteto-mode/playbooks/feature.md
why: 5a classifies every finding by mechanism before any remedy is chosen.
grep: Classify each one WRONG MODEL, MISSING FACT, or MISSING GUARD

### p6-feature-close-after-pr — skills/poteto-mode/playbooks/feature.md
why: the close moved after the PR opens and its verifier verdict lands; the owner merges after.
grep: **8a.** After the PR opens and its non-author verifier verdict lands

### p6-pr-register-every-unit — skills/poteto-mode/playbooks/opening-a-pr.md
why: registration is unconditional now that gating is gone.
grep: Every unit is registered here, at PR open.

### p6-pr-verifier-before-merge — skills/poteto-mode/playbooks/opening-a-pr.md
why: the solo flow runs shipping step 1 right after PR open; independence-first, every fourth verifier blind.
grep: **The verdict before the merge.**

### p6-shipping-verifier-unconditional — skills/poteto-mode/playbooks/shipping.md
why: step 1 runs on every PR, a solo PR included, and the verifier is independence-first.
grep: This step is unconditional: every PR takes one

### p6-interrogate-mechanism-first — skills/interrogate/SKILL.md
why: mechanism picks the remedy before reachability is asked.
grep: Mechanism decides the remedy, and it is decided first.

### p6-swarm-model-no-reachability — skills/swarm/SKILL.md
why: a wrong MODEL cluster is fixed by redesign, so it carries no reachability value.
grep: A wrong MODEL cluster carries no reachability

### p6-smyw-not-the-verifier — skills/show-me-your-work/SKILL.md
why: the cross-model trail review is not the PR's non-author verifier.
grep: it is not the PR's non-author verifier

### p6-readme-mechanism-first — README.md
why: the intro states mechanism-first triage and the per-PR non-author verdict.
grep: Every finding is classified by mechanism

### p6-guide-close-after-verdict — docs/guide/09-make-it-yours.md
why: /close-unit runs after the PR's verdict and before the merge.
grep: once the PR's non-author verdict is in and before you merge

### p6-why-feature-flagged — skills/why/SKILL.md
why: "flag-gated" retired with the gating vocabulary.
grep: Strongest for feature-flagged code

### p6-triage-errno-keyed — skills/poteto-mode/references/bugbot-triage.md
why: "gated on ENOENT" retired with the gating vocabulary.
grep: keyed on `ENOENT`

### p6-multiphase-review-gate — skills/poteto-mode/playbooks/multi-phase-plan.md
why: "review-gated" retired; the operator's review gate is named directly.
grep: takes the operator's review gate

### p6-worktree-human-decision — skills/poteto-mode/scripts/worktree-audit.sh
why: "human-gated step" retired with the gating vocabulary.
grep: deletion stays a human decision in the playbook

### p7-simplify-cadence-notes — skills/simplify/SKILL.md
why: the vocabulary sweep retires "cadence" here too — the verification-steps reference and the
"Cadence notes" heading are rewritten in the router's words.
grep: ## Flow notes

### p8-feature-delegate-model — skills/poteto-mode/playbooks/feature.md
why: the step-4 delegate default was pstack's Cursor-side `grok-4.6-fast-xhigh`; in Claude Code the delegate runs on Opus, with Sonnet only after an Opus server error.
grep: the delegate runs on Opus, the Agent tool's `opus` model

### p8-refactor-delegate-model — skills/poteto-mode/playbooks/refactoring.md
why: same rule for the mechanical-edit delegate in step 5.
grep: using your configured refactoring model (the delegate runs on Opus

### p8-router-code-model — skills/poteto-mode/SKILL.md
why: the Task-call defaults named grok as the code model; the code default is `opus`, and the tiering line now points at that default instead of a "fast code model".
grep: defaults the Agent tool's `opus` for code

### p8-swarm-worker-model — skills/swarm/SKILL.md
why: the Phase A worker fallback named grok; unset config falls back to `opus`.
grep: Otherwise use the Agent tool's `opus`

### p8-why-investigator-model — skills/why/SKILL.md
why: the investigator subagent default named grok.
grep: why-investigators model (default the Agent tool's `opus`

### p8-how-explorer-model — skills/how/SKILL.md
why: the explorer subagent default named grok.
grep: how-explorer model (default the Agent tool's `opus`

### p8-multiphase-lane-model — skills/poteto-mode/playbooks/multi-phase-plan.md
why: the live-verification lane model named grok in both the rule and the boot recipe.
grep: Ten lanes on `opus` at the PR head drive the real surface

### p8-checkplan-lane-model — skills/poteto-mode/scripts/check-plan.mjs
why: the plan checker asserts the lane sentence verbatim, so it moves with the playbook.
grep: const LANES = "Ten lanes on `opus` at the PR head";

### p9-architect-panel — skills/architect/SKILL.md
why: the runner panel named two vendors the Agent tool cannot dispatch; Claude Code has no cross-provider diversity, so the seats are `opus` with one `sonnet` and independence comes from roles and fresh contexts.
grep: Use your configured architect runners (defaults four runners, three on `opus` and one on `sonnet`)

### p9-arena-runners-panel — skills/arena/SKILL.md
why: same retarget for the Phase A runner defaults.
grep: Otherwise default to four runners, three on `opus` and one on `sonnet`.

### p9-arena-cross-judge — skills/arena/SKILL.md
why: the Phase C cross-judge pool was a vendor list and "a different model family from the parent's" is unreachable in Claude Code; the judge is `opus` in a fresh context.
grep: not from a different model family

### p9-how-critics-panel — skills/how/SKILL.md
why: the critics panel retargets to Claude models, and "one critic per model" becomes "per entry" now that entries repeat.
grep: spawn one architectural critic per entry in your configured how-critics list

### p9-interrogate-reviewers-panel — skills/interrogate/SKILL.md
why: the reviewer table's four vendor slugs become three `opus` seats and one `sonnet`, with the provider-diversity note under the table.
grep: | Reviewer C | `sonnet` |

### p10-router-subagent-namespace — skills/poteto-mode/SKILL.md
why: the delegate `subagent_type` must be the plugin-namespaced `pkstack:poteto-agent`; an unrecognized value does not error in Claude Code, it silently starts a `general-purpose` agent, which is the drift the line exists to prevent.
grep: **Use `subagent_type: "pkstack:poteto-agent"` for any subagent you spawn inside a playbook step**

### p10-router-dispatchable-models — skills/poteto-mode/SKILL.md
why: the prose/judgment default and the difficulty-tiering both named slugs the Agent tool cannot dispatch; tiering is now by brief, not by vendor.
grep: The Agent tool dispatches `opus`, `sonnet`, `haiku`, and `fable` and nothing else

### p11-bugfix-delegate-model — skills/poteto-mode/playbooks/bug-fix.md
why: the step-3 code delegate defaulted to `gpt-5.6-sol-max`, which the Agent tool cannot dispatch; same Opus form as feature.md.
grep: using your configured bug-fix model (the delegate runs on Opus

### p11-hillclimb-delegate-model — skills/poteto-mode/playbooks/hillclimb.md
why: same for the hypothesis-implementing delegate.
grep: using your configured hillclimb model (the delegate runs on Opus

### p11-perf-delegate-model — skills/poteto-mode/playbooks/perf-issue.md
why: same for the perf-fix delegate.
grep: using your configured perf-issue model (the delegate runs on Opus

### p11-how-explainer-model — skills/how/SKILL.md
why: both explainer seats defaulted to a fable slug the Agent tool cannot dispatch; the dispatchable name is `fable`.
grep: your configured how-explainer model (default `fable`)

### p11-why-synthesizer-model — skills/why/SKILL.md
why: the synthesizer seat defaulted to a fable slug the Agent tool cannot dispatch.
grep: your configured why-synthesizer model (default `fable`)

### p12-shipping-no-graphite — skills/poteto-mode/playbooks/shipping.md
why: `gt` is not installed for this plugin's users; the verifier step is Graphite-free and says so, and arming forks to the owner's `gh` merge where `gt` is absent.
grep: Otherwise nothing is armed and steps 5 through 8 do not apply.

### p12-autopilot-stack-no-graphite — skills/poteto-mode/playbooks/autopilot-stack.md
why: registration, append, topology, restack, and the deliverable each carry the `gh` path where `gt` is absent; a stack is then a sequence of PRs each based on the previous.
grep: otherwise the root opens each PR with `gh pr create --base` set to the previous PR's branch

### p12-router-graphite-optional — skills/poteto-mode/SKILL.md
why: the Shipping and Autopilot-stack index lines described Graphite as the only landing path.
grep: where `gt` is installed, and otherwise handing the owner the verified run to merge with `gh`

### p13-router-ask-tool-name — skills/poteto-mode/SKILL.md
why: the fork trigger named Cursor's `AskQuestion`; the Claude Code tool is `AskUserQuestion`.
grep: - About to `AskUserQuestion` on a
