---
name: close-unit
description: "The self-improvement close of a unit of work. Runs AFTER the PR's non-author verifier posts its verdict and BEFORE the owner merges, consuming the unit's triage clusters and the repo's finding ledger. Distills lessons per Bennett's razor (weakest sufficient hypothesis), diagnoses regenerated findings as covered-but-unenforced vs not-covered, promotes lesson media, and records the run in the unit's probe. MANDATORY TRIGGERS: 'close the unit', 'run close-unit', 'distill this round', 'ledger run'. Runs on any unit whose sweep or verifier landed findings; a unit with a clean sweep and a PASS verdict records no row."
---

# Close the unit

The self-improvement step, run ONCE per unit, after the PR's non-author verifier posts its verdict
and before the owner merges. Its promotions land as a commit on the PR branch. It runs on any unit
whose sweep or verifier landed findings; a unit with a clean sweep and a PASS verdict has nothing
to distil and records no row. Its theory (recorded in the ledger's header): a lesson is a
hypothesis meant to generalise from the findings you observed (the child task) to the class they
sample (the parent). The optimal such hypothesis is the WEAKEST one still sufficient —
"explanations should be no more specific than necessary" (Bennett, arXiv:2301.12987) — and it
must land in a medium that can only express universally-quantified statements, because that is
what makes it apply to members that do not exist yet.

## Inputs

1. The unit's probe (the repo's probe convention — kstack repos: `docs/050-probes/`) with its
   triage clusters — every finding from every round of this unit, already clustered by mechanism
   (the triage step). Clusters are written into the probe AS THEY FORM, during the
   unit — never reconstructed at the close. The close reads the PROBE, never in-context memory: a
   compaction between the verifier's verdict and this step must not be able to empty the close's
   input.
2. The repo's finding ledger — resolve it from the repo's procedure file (AGENTS.md); kstack
   repos keep it at `docs/070-quality/004-finding-ledger.md`. If the repo has no ledger FILE,
   create one first (the mechanism header from kstack's `finding-ledger.template.md`); its
   first lessons are then minted below from this unit's clusters and the repo's probe history —
   local evidence only. An EMPTY ledger is a valid state for a young repo: every cluster simply
   takes the mint fork.
3. The unit's recorded DISMISSALS — every finding rejected with a standing reason (`/interrogate`'s
   Dismissed bucket; any review flow that dismisses with a written reason). They are read here as
   recorded NON-members, and they bound extensions from above: a sufficiency walk cannot claim a
   member that was dismissed with a reason still in force. Either the dismissal falls — say so, in
   the probe, with what changed — or the member is out of the extension.

## The process sampler

Optional at a close: the DRIVER may fan out the three reviewer prompts in `references/`
(judgment, tooling, divergent) over the unit's transcript or its `decisions.tsv` trail, one
subagent each, models per the `close-unit sampler` roles in `~/.claude/pkstack-models.md`
(defaults: judgment `fable`, tooling `opus`, divergent `fable`). A delegate never spawns the
sampler. What they return are PROCESS findings — how the agent worked, not what the code does.
Cluster them by mechanism alongside the unit's own clusters and run each through the same
per-cluster procedure below.

## The procedure

Clusters arrive from triage already classified by MECHANISM — WRONG MODEL, MISSING FACT, or
MISSING GUARD — because mechanism is decided before any remedy is chosen. A WRONG MODEL cluster
was fixed in the unit by redesign whatever its reachability; a MISSING FACT by carrying the fact
at the layer that first has it; a MISSING GUARD by the local check. Reachability was the second
question and only for the FACT and GUARD clusters: the `reachable` value decided whether the fix
landed in the unit or became a NOTE with a named trigger. Reachability does NOT change the ledger
decision — mint, weaken, or promote is about MECHANISM, and a `not today` finding samples its
class exactly as a `real user today` one does. "Fixed by class" here means the promotion into
structure — a constraint, a compile-forced table, a lint, a registry walk — never the instance
patch.

For EACH triage cluster, in order:

1. **Ledger lookup.** Does an existing lesson's extension decide this cluster's members? Write
   the one-sentence test for each member: "applied at build time, lesson LN forbids this
   because …". If the sentence writes cleanly for all members → the cluster is a re-sampling.
2. **Fork the diagnosis** (this is the step's whole value — the two forks demand opposite
   responses):
   - **Covered but unenforced** → the statement was right; its MEDIUM failed. Do NOT edit the
     statement. Queue (or perform, if cheap) a medium promotion, one rung up the ledger's
     ranking: prose → required design-artifact field → gate-rubric line → lint rule / executable
     gate → compile-forced Record / registry walk → DB constraint/trigger.
   - **Not covered** → the standing lesson is TOO STRONG. Weaken its statement until the new
     member falls inside, then RE-RUN the sufficiency walk over ALL its members (old and new).
     A lesson that cannot be weakened without losing a member must be SPLIT.
   - **Polarity guard.** The weaken fork assumes a PROHIBITION-lesson, whose extension is the
     defects it prevents — weakening admits more of them, which is safe. A PERMISSION-lesson (a
     skip rule, a dismissal rule, an allow-list) INVERTS: its extension is what it lets through, so
     a regenerated member means NARROW it, never weaken it. Weakest-sufficient for prohibitions,
     narrowest-sufficient for permissions; the ledger entry states which polarity it is on, because
     the two forks look identical until you know.
3. **Mint** where no lesson claims the cluster: draft the weakest statement sufficient over the
   cluster's members PLUS any historical findings it also decides (search the probes — a new
   lesson usually has older members nobody named). Land it at the highest medium that can
   express it; prose-only requires a written reason in the ledger entry.
4. **Guard against over-weakening**: a lesson weakened past sufficiency decides nothing ("be
   careful with facts"). The sufficiency walk is the floor — every claimed member gets its
   sentence, or it is not in the extension.

## Process lessons (the second media ranking)

Process findings — about how the AGENT works, not what the code does: what the sampler's reviewer
prompts in `references/` return, plus what triage of the owner's corrections surfaces — take the
SAME fork above (lookup → covered-but-unenforced vs not-covered → mint), against their own media
ranking, ordered by the same quantification force:

`mechanism (lint rule / script / eval)` > `principle leaf skill` > `router trigger` > `playbook
step` > `prose`.

- **Promotion rule (the size law, applied to process).** An extension spanning 3+ playbooks has
  left playbook altitude: it belongs at principle altitude, and it lands by SHARPENING an existing
  principle entry, not by appending a new one. Two entries that share a deeper principle merge; a
  principle set nobody can hold in attention guides nothing.
- **A promotion that edits a plugin file is an EXPORT, not an edit.** A process lesson whose medium
  is a skill, a router trigger, or a playbook step goes to the ledger's export queue with its
  `repo:probe` provenance and is consumed at a pkstack maintenance close, on the owner's
  approval — never automatically, and never as a side effect of a repo's unit close.
- **Router-level promotions carry a queued EVAL as their completion criterion.** A trigger line
  changed without an eval that separates the two variants is an untested behaviour change to every
  future session; the Eval playbook (`skills/poteto-mode/playbooks/eval.md`) is the instrument, and
  the promotion is not done until it has run.

## Outputs (all five, same sitting)

1. **The ledger updated** — extensions grown, statements weakened/minted, promotions queued
   with NAMED triggers.
2. **The run recorded in the unit's probe** as a "Close of unit" section: per-cluster lookup →
   fork → action, plus the headline ratio (new lessons vs re-sampled extensions — the ratio is
   the loop's health metric: mostly re-samplings means the problem is media, not doctrine).
3. **The Loop-health row appended** to the ledger's table: `- <date> · probe <n> · novel <n/m> ·
   mode: <verifier model id>·<fed|blind>` where the PR's non-author verifier ran, and `mode: self`
   where only the sweep did. The model id goes in VERBATIM — `mode: claude-opus-5 (verifier)·blind`,
   `mode: gpt-5-codex·fed`, `mode: self` — never an internal/external binary, which flattens
   exactly the case that matters (cross-family but internal). The DRIVER sets the fed|blind flag,
   from whether that verifier was given the ledger, and the driver also schedules the
   control by COUNTING these rows: every FOURTH verifier runs blind (count the fed rows
   standing since the last blind one). The row IS the counter's state; skipping it silently
   disables the anchoring control. Optionally add `ceremony: <wall-clock or context share>` — what
   the loop's own paperwork cost this unit. Housekeeping is WANTED here, and measured so it stays
   lean: a ceremony figure that keeps growing means move the paperwork to subagents, never that
   the step gets dropped.
4. **The rubric fed** — landed findings into the LEDGER, which is the only feed. A lesson that
   does not reach the ledger reaches nothing.
5. **The product-health line**, for the PR and for the owner: "of N findings, m wrong MODEL (all
   redesigned), k fixed now, p notes with named triggers; verdict PASS+NOTES; the changed journeys
   driven green through verify-<project>". The PR's Verification section cites it alongside the
   loop-health row.

## The loop self-check (final step — the loop attacks ITSELF)

The process's own known failure modes, checked mechanically at every close. A newly discovered
loop-level failure mode is added to this list in the same sitting it is found.

- **Anchoring** — if the driver's count put this unit's verifier on the blind arm, compare its
  findings against the recent fed verifiers: did the blind one find classes the fed ones stopped
  finding? If yes, the feed is anchoring: demote it (drop the hunt clause, keep only the
  disclosure rule).
- **Ratio confound** — never read a falling novel ratio as success on its own; only the
  driver-counted blind control distinguishes an anchored reviewer from genuinely exhausted
  classes. A run of closes that never schedules one has no reading at all.
- **Register abuse / overdue triggers** — walk ALL THREE register homes (the ledger's
  mechanization queue, the probes' Registers sections, and current-state's deferral
  register): has any NAMED TRIGGER since fired without the work being done? An overdue
  register is a dodge, not a disposition — surface it in the probe, loudly.
- **Medium rot** — for each lesson marked mechanized, confirm the mechanism still exists and
  still bites (the walk test runs, the lint is enabled, the trigger is applied in prod).
- **Extension audit** — every extension member newly cited at this close must resolve to a REAL
  recorded finding: walk the probe and the `decisions.tsv` trail until you land on the entry. Cut
  the aspirational members ("this would also have caught…") — they are the cheapest thing in the
  world to write and they inflate exactly the quantity the razor reads. A lesson's entire authority
  is its extension, so an uncitable member is a lesson claiming proof it does not have.

## Size law

Lessons and evidence accrete in the LEDGER, never in the procedure file (AGENTS.md). When a
lesson becomes fully mechanized, cut its AGENTS.md prose (if any) to a one-line pointer. This
step must never grow the procedure file.
