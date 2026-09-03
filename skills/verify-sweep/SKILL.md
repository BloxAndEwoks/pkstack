---
name: verify-sweep
description: "Feature step 5a: the per-unit LEDGER-DRIVEN verification sweep — the repo's adversarial-depth audit run in a neutral falsify/verify register (same depth, no safeguard vocabulary), driver-led with executor subagents on bounded per-lesson specs. This IS the unit's verification and it runs on EVERY unit (the fan-out scales to the diff; the ledger walk itself is never skipped). The PR's non-author verifier reads the manifest this sweep leaves behind, after forming its own plan. MANDATORY TRIGGERS: 'run the sweep', 'verification sweep', 'verify the unit', 'sweep the diff'. Do NOT trigger for single-file spot checks (a spot check is not a unit)."
---

# Verification sweep

The per-unit verification pass: apply every lesson in the repo's finding ledger to the unit's
diff, systematically, in parallel. This IS the unit's verification, and it runs on every unit. It
must be exhaustive over the ledger, because a later review round's budget belongs to the classes
nobody has named yet, not to re-finding what the ledger already records.

**Register discipline (load-bearing):** all prose and every subagent prompt uses neutral QA
vocabulary — *verify, falsify, counterexample, reachable, refuse* — never combative framing.
Code inspection uses native Read/Grep. Same depth, different register; this is what keeps the
driver session on its intended model.

**The pre-registered commitment (written into the probe BEFORE the first executor is spawned):**
this sweep does not modify the instrument it measures with. No harness edits, no regenerated
baselines, no loosened assertion, no restructuring of the subject so a check goes green. Where the
sweep's own oracle — a fixture, a golden file, an expected-value table, a characterization pin —
DISAGREES with the product, that is a FORK, not an edit: stop, surface it as a finding, and let
triage decide which side is wrong. The commitment is pre-registered rather than asserted afterwards
because an oracle edited mid-run cannot falsify anything and the edit is invisible in the result:
a green sweep looks the same either way.

## Inputs

1. The unit's diff (an explicit commit range — state it in every executor prompt). The range's
   base is the SHA the premortem recorded in the probe header at unit start (`git rev-parse
   HEAD` before the first checkpoint) — never reconstructed from memory afterwards.
2. The repo's finding ledger — resolve its path from the repo's procedure file (AGENTS.md);
   kstack repos keep it at `docs/070-quality/004-finding-ledger.md`. The lesson list IS the work
   breakdown. **An empty or young ledger** means the executors hunt from their own plan over the
   diff, independence first, and the ledger fills from what lands. A lesson is never seeded from
   another repo, and a generic catalogue is such a seed.
3. The unit's probe + registers, so registered residues read as disclosures, not findings.

## Protocol (driver/executor)

The DRIVER (the main session) holds judgment: scope, triage, and the verdict. EXECUTOR
subagents (general-purpose agents) each get one bounded spec — a lesson group, the diff range,
and the falsification question. Bounded specs are what make executors safe; open-ended judgment
stays with the driver.

**Scale the fan-out to the diff, never the walk to zero**: a large unit gets the full
~5–6-executor fan-out below; a small unit may collapse to a driver-level pass — the driver
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
2. **Mechanism first.** Every confirmed finding is CLASSIFIED as WRONG MODEL, MISSING FACT, or
   MISSING GUARD before any remedy is chosen. A WRONG MODEL finding is fixed now by redesign
   regardless of who can reach it, because deferring it multiplies through every checkpoint that
   composes on it; it is never a note. A MISSING FACT is fixed by carrying the fact at the layer
   that first has it, never by a local conditional. A MISSING GUARD is the one mechanism where a
   local fix is correct.
3. **Reachability second**, and only for MISSING GUARD and MISSING FACT. Record the `reachable`
   value — one of `real user today`, `crafted client`, `raw writer`, `operator`, `not today` — and
   the evidence rung that value stands on: rung 4 or higher of the ladder in
   `skills/blast-radius/SKILL.md` (you ran it, or you reproduced it in the running app). A
   reachability argued from reading is not recorded. The value decides whether the fix lands in
   this unit or becomes a NOTE with a named trigger. Findings then enter the ledger fork:
   covered-but-unenforced vs not-covered. Fixing BY CLASS means the ledger's promotion into
   structure — a constraint, a compile-forced table, a lint, a registry walk — never the instance
   patch.
4. **The verdict words are PASS, PASS+NOTES, and FAIL.** A FAIL is a WRONG MODEL, or a real user
   reaching a false statement today, reproduced on the surface. Every NOTE carries a named
   trigger, which is a disposition and not a dodge. **The unit is done when no FAIL is open.** The
   sweep's result line goes in the unit's probe: lessons swept, findings by lesson, findings by
   mechanism and by `reachable` value, and the verdict. A clean sweep is a PRECONDITION for the
   PR's non-author verifier, not a substitute for it.
5. **Close the sweep by writing the REVIEW MANIFEST into the unit's probe** — a
   short section titled exactly `## Review manifest`, holding: unit name · base..head SHAs · the
   swept tree's `git patch-id` (`git diff base..head | git patch-id --stable`) · the named
   guarantees · the known-class checks this sweep executed · registered residues with their named
   triggers · suite/typecheck/lint evidence · the runtime surfaces needing live attack. The
   patch-id is not decoration: a rebase, an amend, or a squash silently invalidates every
   SHA-pinned verdict while the swept CONTENT is unchanged, and the patch-id survives the
   rewrite — it is what lets a later reader tell "the head moved" from "the work changed".
   The manifest's consumer is the PR's non-author verifier (Shipping step 1), which reads it only
   AFTER forming its own plan, as a completeness floor rather than a search strategy; the manifest
   is what stops that verifier re-deriving scope from thousands of lines of history.
6. **The blind control.** Every FOURTH verifier runs ledger-blind, counted by the driver from the
   ledger's loop-health rows — the fed rows standing since the last blind row. A blind verifier is
   given neither the ledger nor the review manifest, so the probe's design sections must state the
   unit's guarantees in their own right. The verifier's mode goes in the loop-health row
   `/close-unit` appends.
