---
name: verify-sweep
description: "Build-cadence step 4a: the per-unit LEDGER-DRIVEN verification sweep — the repo's adversarial-depth audit run in a neutral falsify/verify register (same depth, no safeguard vocabulary), driver-led with executor subagents on bounded per-lesson specs. Runs on EVERY unit, gated or not (the fan-out scales to the diff; the ledger walk itself is never skipped), and BEFORE any external certification, so the external reviewer's budget goes to novel classes, not re-discovering the ledger. MANDATORY TRIGGERS: 'run the sweep', 'verification sweep', 'verify the unit', 'sweep the diff'. Do NOT trigger for single-file spot checks (a spot check is not a unit)."
---

# Verification sweep

The per-unit verification pass: apply every lesson in the repo's finding ledger to the unit's
diff, systematically, in parallel. This is the audit's known-class half — the external certifier
is reserved for classes nobody has named yet, so this sweep must be exhaustive over the ledger
or the certifier's budget gets spent re-finding it.

**Register discipline (load-bearing):** all prose and every subagent prompt uses neutral QA
vocabulary — *verify, falsify, counterexample, reachable, refuse* — never combative framing.
Code inspection uses native Read/Grep. Same depth, different register; this is what keeps the
driver session on its intended model.

## Inputs

1. The unit's diff (an explicit commit range — state it in every executor prompt).
2. The repo's finding ledger — resolve its path from the repo's procedure file (AGENTS.md);
   kstack repos keep it at `docs/070-quality/004-finding-ledger.md`. The lesson list IS the work
   breakdown. **Young-ledger bootstrap:** while the ledger has no (or few) lessons, the work
   breakdown falls back to the generic falsification classes in `/adversarial-audit`'s seam
   catalogue, run under this same protocol and register; as lessons are minted they take over,
   with the generic catalogue remaining the completeness floor beneath them.
3. The unit's probe + registers, so registered residues read as disclosures, not findings.

## Protocol (driver/executor)

The DRIVER (the main session) holds judgment: scope, triage, and the verdict. EXECUTOR
subagents (general-purpose agents) each get one bounded spec — a lesson group, the diff range,
and the falsification question. Bounded specs are what make executors safe; open-ended judgment
stays with the driver.

**Scale the fan-out to the diff, never the walk to zero**: a large or gated unit gets the full
~5–6-executor fan-out below; a small ungated unit may collapse to a driver-level pass — the driver
walks every ledger lesson against the diff personally — but no unit ships without the walk,
because the walk is what makes a "small" unit provably small.

For the fan-out form, group the ledger's lessons into ~5–6 executor specs (pairing related
lessons), each prompt carrying:

- The commit range and the lesson statements verbatim (with their one-line extensions as worked
  examples of the class, where the ledger has them).
- The falsification question, e.g. for an invariant lesson: *"for every invariant this diff
  introduces or touches, enumerate the complete writer set of the facts it relates; report any
  writer that can reach a consumer without the invariant holding, with file:line and the
  concrete input/state sequence."*
- The composition rule: verify the COMPOSED flow (surface/action → verb → state → queues), not
  the verb in isolation; where a UI enforces something, check the server boundary accepts a
  crafted request or refuses it.
- The reporting bar: only REPRODUCIBLE falsifications — a concrete counterexample (inputs/state
  → wrong outcome) with file:line — plus a separate short list of "suspected, needs live
  ground-truth" items the driver will verify against the live database. No style notes, no
  praise.

**Machine constraints:** honour the repo's recorded machine constraints (AGENTS.md) — in
particular, executors do NOT run the test suite in repos where the suite is single-process
machine-wide (a shared database or fixed ports make parallel runs corrupt each other); the
driver runs any needed suite once, after triage. Live-DB ground-truthing is the driver's, via
the suite or a scratch container.

## After the fan-out

1. Driver reproduces each reported falsification before accepting it (an executor report is a
   claim).
2. Confirmed findings enter the cadence's triage step exactly as gate findings do: ledger lookup →
   covered-but-unenforced vs not-covered fork → fix the class or register with a named trigger.
3. The sweep's result line goes in the unit's probe: lessons swept, findings by lesson,
   clean-to-ledger or not. A clean sweep is a PRECONDITION for requesting external
   certification, not a substitute for it.
