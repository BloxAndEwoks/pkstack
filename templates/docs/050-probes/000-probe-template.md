# NNN — <unit name>

<!-- Seeded by kstack-init. To open a unit: copy this file to the band's next number
     (`docs/050-probes/NNN-<slug>.md`) and fill it AS THE UNIT RUNS — the probe is the unit's
     durable record, written in the same change as the work, never reconstructed after. The
     sections mirror the cadence; an ungated unit strikes the 4b and 5b/close sections rather
     than deleting them (the strike-through is the record that they were consciously skipped). -->

Date: YYYY-MM-DD · Status: OPEN | EXECUTED | CLOSED · Gated: yes | no (why)

**Goal:** <!-- the ONE named goal this unit answers — a unit with two goals is two units. -->

## 1. Premortem (cadence step 1)

<!-- The raw failure scenarios, then the CLASSES they cluster into — each class named by the
     razor: the LEAST specific statement that still decides every scenario in it. The classes,
     not the scenarios, are the test-first targets. -->

### Facts-before-verbs

<!-- One row per NEW fact the design introduces. A tier of "convention" needs a written
     reason in the row. -->

| Fact | Occurrence or state | Writer set | Required at (boundaries) | Enforcement tier (+reason if convention) |
| --- | --- | --- | --- | --- |

## 2. Build record

<!-- Checkpoints as they land: what changed and why, commit refs, deviations from the design
     and their reasons. Working scratch stays out — this is the record, not the diary. -->

## 3. Verification sweep (4a)

<!-- Lessons swept (or, on a young ledger, the generic falsification classes used) · findings
     BY LESSON · per finding the EXECUTED counterexample — the concrete inputs/state, the
     observed wrong outcome, file:line — not the plan to find one. Close the section with:
     clean-to-ledger yes/no. Per remediated finding, the four-part record: validated, attacked,
     fixed, locked (the composed test that now holds it). -->

## 4. External gate (4b — gated units)

<!-- One block per round (cap: one round + at most one re-gate): scope reviewed, per-guarantee
     verdicts (upheld/denied), and the feed mode from the script's own log line
     (`[external-review] ledger feed: fed|blind`) — the close step needs it. -->

## 5. Triage

<!-- Findings from 4a and 4b, clustered by MECHANISM (not by symptom). Per cluster: members ·
     missing GUARD / missing FACT / wrong MODEL · the disposition — fix the class, local fix
     (with the recorded judgement why local was enough), or register with a NAMED trigger. -->

## 6. Close of unit (5b — gated units)

<!-- Per cluster: ledger lookup → fork (covered-but-unenforced ⇒ medium promotion queued /
     not-covered ⇒ statement weakened + sufficiency re-walk / unclaimed ⇒ lesson minted) →
     action taken. Headline: novel n/m. Then the loop self-check results: anchoring, ratio
     confound, overdue triggers, medium rot. The Loop-health row goes in the LEDGER, not here. -->

## Registers

<!-- Residues deliberately not fixed in this unit. Every entry carries a NAMED trigger — a
     register without one is a dodge, and an overdue trigger is surfaced loudly at the next
     close. -->

- <residue> — trigger: <the concrete event that reopens this>
