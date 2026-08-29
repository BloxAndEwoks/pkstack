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

### p1-maintain-verify-path — skills/maintain-verification-skill/SKILL.md
why: project-local verification skills live under `.claude/skills/`.
grep: .claude/skills/verify-*/

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
why: the unit-classification trigger (GATED test + BASE capture + prototype carve-out + re-route rule + one-time kstack-init offer), the close trigger for a registered gated unit, and the ledger-promotion line closing the Principles index.
grep: Classify the unit in the same breath.

### p2-architect-lessons-map — skills/architect/SKILL.md
why: the driver instantiates the ledger against the synthesized package between Phase B and Phase C, with the runners' ledger-blindness stated as a deliberate omission; the package commits as the unit's probe.
grep: Then instantiate the ledger against it.

### p2-rationale-base-header — skills/architect/references/rationale-template.md
why: required BASE-SHA and gated/ungated header line, and the Shape note now requires per-decision lesson annotations in the design's own nouns.
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
why: a gated unit is REGISTERED at PR open (BASE, classification, clusters so far) with a named close trigger; the Verification section names the ledger walk.
grep: A registered unit that never closes surfaces as an overdue register

### p2-shipping-close — skills/poteto-mode/playbooks/shipping.md
why: the ceiling step is the stack's close point (close-unit over the accumulated verdicts and clusters, tree pinned by patch-id); verdict lines carry the surface · mechanism · class schema and persist to the probe.
grep: The close runs here for the stack's gated units

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
why: the resume note carries the lessons-map path, the open triage clusters, and the gated classification with BASE and named close trigger.
grep: Those last three are what a pickup agent cannot cheaply re-derive

### p2-pickup-reconstruct — skills/poteto-mode/playbooks/session-pickup.md
why: the reconstruct list gains the lessons-map path, the open triage clusters, and the gated classification with BASE and named close trigger.
grep: Those last three are the artifacts a pickup cannot cheaply re-derive

### p2-fio-gated-classification — skills/figure-it-out/SKILL.md
why: the designed phase list carries each unit's gated classification and close point, bespoke playbooks inherit map production and the close, and Phase E's encoding lands as a ledger entry with a cited extension.
grep: gated or ungated classification (unsure means gated) and its close point
### p2-router-close-trigger — skills/poteto-mode/SKILL.md
why: close routing for gated units (supplemental per-addition guard)
grep: A GATED unit reaching its registered close point

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
