# NNN — <unit name>

<!-- Seeded by kstack-init. To open a unit: copy this file to the band's next number
     (`docs/050-probes/NNN-<slug>.md`) and fill it AS THE UNIT RUNS — the probe is the unit's
     durable record, written in the same change as the work, never reconstructed after. A
     section that did not apply is struck through rather than deleted, so the strike-through is
     the record that it was consciously skipped. A probe records this unit's facts, evidence and
     judgements; the procedure that produced them lives in AGENTS.md and the plugin's playbooks,
     and every rule below is cited from there rather than restated. -->

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
     (upheld/denied), and its mode (`<model id>·fed|blind`). Which rounds run, who spawns them,
     and when one is blind: AGENTS.md's "Checkpoint review and the PR verifier". -->

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
     The classification rule, the reachability rule, and the verdict words: AGENTS.md's
     "Mechanism first, reachability second". Fill the table; do not restate the rule. -->

| Cluster | Members | mechanism | reachable | rung | Disposition |
| --- | --- | --- | --- | --- | --- |

<!-- mechanism: WRONG MODEL · MISSING FACT · MISSING GUARD.
     reachable/rung: left blank for a WRONG MODEL, which carries no reachability question.
     Disposition: fixed now — by class, the promotion into structure (a constraint, a
     compile-forced table, a lint, a registry walk), never the instance patch — or a local fix
     (with the recorded judgement why local was enough), or a NOTE with a named trigger. -->

## 6. Close of unit

<!-- When the close runs and which fork each cluster takes: AGENTS.md's "The close". Record
     here what this unit's close produced — per cluster, the ledger lookup, the fork it took and
     the action taken; the headline novel n/m; the loop self-check results (anchoring, ratio
     confound, overdue triggers, medium rot); and the product-health line, "of N findings, m
     wrong MODEL (all redesigned), k fixed now, p notes with named triggers; verdict PASS+NOTES;
     journeys driven green". The loop-health row goes in the LEDGER, not here. -->

## 7. Consumer drive

<!-- The seats and the map/product fork: AGENTS.md's "Consumer verification". Record here, for a
     unit that touched a shipped surface, the mapped features driven through the repo's
     `verify-<project>` skill, proved/refused per feature, and the artifact run names (the
     evidence itself stays in the skill's gitignored artifacts); whether MAINTAIN ran; and,
     where no verification skill exists yet, whether its register trigger has now fired. -->

## Registers

<!-- UNIT-scoped residues deliberately not fixed in this unit — product-scope deferrals no
     unit owns go in current-state's deferral register instead. Every entry carries a NAMED
     trigger — a register without one is a dodge, and an overdue trigger is surfaced loudly
     at the next close. -->

- <residue> — reachable: <value> — trigger: <the concrete event that reopens this>
