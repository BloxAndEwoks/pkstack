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
