---
name: close-unit
description: "Build-cadence step 5b: the self-improvement close of a GATED unit of work. Runs after the FINAL external-review round (the cadence cap), consuming the unit's triage clusters and the repo's finding ledger. Distills lessons per Bennett's razor (weakest sufficient hypothesis), diagnoses regenerated findings as covered-but-unenforced vs not-covered, promotes lesson media, and records the run in the unit's probe. MANDATORY TRIGGERS: 'close the unit', 'run close-unit', 'distill this round', 'ledger run'. Do NOT trigger on ungated/trivial units — they skip this step by design."
---

# Close the unit

The self-improvement step of the build cadence, run ONCE per gated unit, after the final gate
round. Its theory (recorded in the ledger's header): a lesson is a hypothesis meant to
generalise from the findings you observed (the child task) to the class they sample (the
parent). The optimal such hypothesis is the WEAKEST one still sufficient — "explanations should
be no more specific than necessary" (Bennett, arXiv:2301.12987) — and it must land in a medium
that can only express universally-quantified statements, because that is what makes it apply to
members that do not exist yet.

## Inputs

1. The unit's probe (the repo's probe convention — kstack repos: `docs/050-probes/`) with its
   triage clusters — every finding from every round of this unit, already clustered by mechanism
   (the cadence's triage step).
2. The repo's finding ledger — resolve it from the repo's procedure file (AGENTS.md); kstack
   repos keep it at `docs/070-quality/004-finding-ledger.md`. If the repo has no ledger FILE,
   create one first (the mechanism header from kstack's `finding-ledger.template.md`); its
   first lessons are then minted below from this unit's clusters and the repo's probe history —
   local evidence only. An EMPTY ledger is a valid state for a young repo: every cluster simply
   takes the mint fork.

## The procedure

For EACH triage cluster, in order:

1. **Ledger lookup.** Does an existing lesson's extension decide this cluster's members? Write
   the one-sentence test for each member: "applied at build time, lesson LN forbids this
   because …". If the sentence writes cleanly for all members → the cluster is a re-sampling.
2. **Fork the diagnosis** (this is the step's whole value — the two forks demand opposite
   responses):
   - **Covered but unenforced** → the statement was right; its MEDIUM failed. Do NOT edit the
     statement. Queue (or perform, if cheap) a medium promotion, one rung up the ledger's
     ranking: prose → required design-artifact field → gate-rubric line → lint rule →
     compile-forced Record / registry walk → DB constraint/trigger.
   - **Not covered** → the standing lesson is TOO STRONG. Weaken its statement until the new
     member falls inside, then RE-RUN the sufficiency walk over ALL its members (old and new).
     A lesson that cannot be weakened without losing a member must be SPLIT.
3. **Mint** where no lesson claims the cluster: draft the weakest statement sufficient over the
   cluster's members PLUS any historical findings it also decides (search the probes — a new
   lesson usually has older members nobody named). Land it at the highest medium that can
   express it; prose-only requires a written reason in the ledger entry.
4. **Guard against over-weakening**: a lesson weakened past sufficiency decides nothing ("be
   careful with facts"). The sufficiency walk is the floor — every claimed member gets its
   sentence, or it is not in the extension.

## Outputs (all four, same sitting)

1. **The ledger updated** — extensions grown, statements weakened/minted, promotions queued
   with NAMED triggers.
2. **The run recorded in the unit's probe** as a "Close of unit" section: per-cluster lookup →
   fork → action, plus the headline ratio (new lessons vs re-sampled extensions — the ratio is
   the loop's health metric: mostly re-samplings means the problem is media, not doctrine).
3. **The Loop-health row appended** to the ledger's table: `- <date> · probe <n> · novel <n/m> ·
   mode: <fed|blind>` (mode from the gate's own `[external-review] ledger feed:` log line). The
   gate script schedules its blind control rounds by COUNTING these rows — the row IS the
   scheduler's state; skipping it silently disables the anchoring control.
4. **The rubric fed** — landed findings into the external-review prompt/ledger feed, per the
   repo's build cadence.

## The loop self-check (final step — the loop attacks ITSELF)

The process's own known failure modes, checked mechanically at every close. A newly discovered
loop-level failure mode is added to this list in the same sitting it is found.

- **Anchoring** — if this unit ran blind, compare its findings against the recent fed rounds:
  did the blind reviewer find classes the fed rounds stopped finding? If yes, the feed is
  anchoring: demote it (drop the hunt clause, keep only the disclosure rule).
- **Ratio confound** — never read a falling novel ratio as success on its own; only the blind
  control distinguishes an anchored reviewer from genuinely exhausted classes.
- **Register abuse / overdue triggers** — walk ALL THREE register homes (the ledger's
  mechanization queue, the probes' Registers sections, and current-state's deferral
  register): has any NAMED TRIGGER since fired without the work being done? An overdue
  register is a dodge, not a disposition — surface it in the probe, loudly.
- **Medium rot** — for each lesson marked mechanized, confirm the mechanism still exists and
  still bites (the walk test runs, the lint is enabled, the trigger is applied in prod).

## Size law

Lessons and evidence accrete in the LEDGER, never in the procedure file (AGENTS.md). When a
lesson becomes fully mechanized, cut its AGENTS.md prose (if any) to a one-line pointer. This
step must never grow the procedure file.
