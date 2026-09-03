# NNN — <unit name>

<!-- Seeded by kstack-init. To open a unit: copy this file to the band's next number
     (`docs/050-probes/NNN-<slug>.md`) and fill it AS THE UNIT RUNS — the probe is the unit's
     durable record, written in the same change as the work, never reconstructed after. A
     section that did not apply is struck through rather than deleted, so the strike-through is
     the record that it was consciously skipped. -->

Date: YYYY-MM-DD · Status: OPEN | EXECUTED | CLOSED

**Goal:** <!-- the ONE named goal this unit answers — a unit with two goals is two units. -->

**BASE:** <!-- the SHA the unit starts from, captured at unit start and restated at PR open. -->

**Close trigger:** <!-- the named event that closes this unit, recorded at PR open. -->

## 1. Design package

<!-- Written by the premortem, BEFORE the build. The raw failure scenarios, then the CLASSES
     they cluster into — each class named by the razor: the LEAST specific statement that still
     decides every scenario in it. The classes, not the scenarios, are the test-first targets. -->

### Facts-before-verbs

<!-- One row per NEW fact the design introduces. A tier of "convention" needs a written
     reason in the row. -->

| Fact | Occurrence or state | Writer set | Required at (boundaries) | Enforcement tier (+reason if convention) |
| --- | --- | --- | --- | --- |

### Implicated lessons

<!-- The premortem's ledger walk. Per class, the finding-ledger lessons it implicates and what
     each demands of THIS design. This map is the sweep's work breakdown and the delegate
     brief's verbatim payload, so a delegate never re-walks the ledger itself. -->

| Class | Lesson(s) implicated | What it demands here | Locking test |
| --- | --- | --- | --- |

## 2. Checkpoints

<!-- Checkpoints as they land: what changed and why, commit refs, deviations from the design
     and their reasons. Working scratch stays out — this is the record, not the diary. -->

## 3. Review rounds

<!-- One block per fresh-context NON-AUTHOR round: what it reviewed, per-guarantee verdicts
     (upheld/denied), and its mode (`<model id>·fed|blind`). The rounds that run: a COMPOSED-ON
     checkpoint inside the unit (a migration, a boundary value type, a served contract, or a
     state transition a later checkpoint writes or reads), and the PR's non-author VERIFIER,
     which runs on every PR and returns PASS | PASS+NOTES | FAIL on the real surface at the PR
     head. Delegates never spawn review rounds; the driver does. Every fourth verifier runs
     ledger-blind as the anchoring control, counted by the driver from the ledger's loop-health
     rows. -->

## Review manifest

<!-- Written by the sweep under this exact heading; the PR's verifier reads it AFTER forming its
     own plan, instead of re-deriving scope. Unit name · base..head SHAs · the swept tree's
     `git patch-id --stable` · the named guarantees · the known-class checks the sweep executed ·
     registered residues with their triggers · suite/typecheck/lint evidence · the runtime
     surfaces needing live attack. A blind verifier is given neither this nor the ledger, so
     section 1 must state the unit's guarantees in its own right. -->

## 4. Verification sweep

<!-- Lessons swept (or, on an empty or young ledger, the executors' own plans over the diff) ·
     findings BY LESSON · findings by mechanism and by `reachable` value · per finding the
     EXECUTED counterexample — the concrete inputs/state, the observed wrong outcome, file:line —
     not the plan to find one. Close the section with: clean-to-ledger yes/no, and the verdict.
     Per remediated finding, the four-part record: validated, attacked, fixed, locked (the
     composed test that now holds it). -->

## 5. Triage

<!-- Findings from the sweep and the review rounds, clustered by MECHANISM, not by symptom.
     MECHANISM FIRST: every cluster is WRONG MODEL, MISSING FACT, or MISSING GUARD before any
     remedy is chosen. A WRONG MODEL is fixed now by redesign regardless of who can reach it,
     because deferring it multiplies through every checkpoint that composes on it; it is never a
     note. A MISSING FACT is fixed by carrying the fact at the layer that first has it, never by
     a local conditional. A MISSING GUARD is the one mechanism where a local fix is correct.
     REACHABILITY SECOND, and only for MISSING GUARD and MISSING FACT: `reachable` is one of
     `real user today` / `crafted client` / `raw writer` / `operator` / `not today`, and it is
     EVIDENCE, not an opinion — `rung` is the blast-radius evidence ladder (4 = ran it against the
     real code, 5 = reproduced it in the running app). Below rung 4 the reachability is unproven
     and the row says so. The value decides whether the fix lands in this unit or becomes a NOTE
     with a named trigger. The verdict words are PASS / PASS+NOTES / FAIL: a FAIL is a WRONG
     MODEL, or a real user reaching a false statement today, reproduced on the surface. The unit
     is done when no FAIL is open. -->

| Cluster | Members | mechanism | reachable | rung | Disposition |
| --- | --- | --- | --- | --- | --- |

<!-- mechanism: WRONG MODEL · MISSING FACT · MISSING GUARD.
     reachable/rung: left blank for a WRONG MODEL, which carries no reachability question.
     Disposition: fixed now — by class, the promotion into structure (a constraint, a
     compile-forced table, a lint, a registry walk), never the instance patch — or a local fix
     (with the recorded judgement why local was enough), or a NOTE with a named trigger. -->

## 6. Close of unit

<!-- Runs AFTER the PR's verifier posts its verdict and BEFORE the owner merges, on any unit
     whose sweep or verifier landed findings; the promotions land as a commit on the PR branch.
     Per cluster: ledger lookup → fork (covered-but-unenforced ⇒ medium promotion queued /
     not-covered ⇒ statement weakened + sufficiency re-walk / unclaimed ⇒ lesson minted) → action
     taken. Headline: novel n/m. Then the loop self-check results: anchoring, ratio confound,
     overdue triggers, medium rot. The product-health line goes here: "of N findings, m wrong
     MODEL (all redesigned), k fixed now, p notes with named triggers; verdict PASS+NOTES;
     journeys driven green". The Loop-health row goes in the LEDGER, not here. -->

## 7. Consumer drive (Feature step 5)

<!-- For units that touched a shipped surface: the mapped features driven through the repo's
     `verify-<project>` skill, proved/refused per feature, and the artifact run names (the
     evidence itself stays in the skill's gitignored artifacts). A map found wrong runs the
     skill's MAINTAIN mode in the same sitting — record that it ran. Where no verification
     skill exists yet, record whether its register trigger has now fired. -->

## Registers

<!-- UNIT-scoped residues deliberately not fixed in this unit — product-scope deferrals no
     unit owns go in current-state's deferral register instead. Every entry carries a NAMED
     trigger — a register without one is a dodge, and an overdue trigger is surfaced loudly
     at the next close. -->

- <residue> — reachable: <value> — trigger: <the concrete event that reopens this>
