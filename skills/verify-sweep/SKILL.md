---
name: verify-sweep
description: "Feature step 5a: the per-unit LEDGER-DRIVEN verification sweep — the repo's adversarial-depth audit run in a neutral falsify/verify register (same depth, no safeguard vocabulary), driver-led with executor subagents on bounded per-lesson specs. This IS the unit's verification and it runs on EVERY unit, gated or not (the fan-out scales to the diff; the ledger walk itself is never skipped). On a gated unit, a fresh-context non-author review round over the whole unit diff follows it, before the PR opens. MANDATORY TRIGGERS: 'run the sweep', 'verification sweep', 'verify the unit', 'sweep the diff'. Do NOT trigger for single-file spot checks (a spot check is not a unit)."
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
   breakdown. **Young-ledger bootstrap:** while the ledger has no (or few) lessons, the work
   breakdown falls back to the generic falsification classes in
   [`references/seam-catalogue.md`](references/seam-catalogue.md), run under this same protocol
   and register; as lessons are minted they take over, with the catalogue remaining the
   completeness floor beneath them.
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
2. Every confirmed finding is RECORDED with a `reachable` value — one of `real user today`,
   `crafted client`, `raw writer`, `operator`, `not today` — and the evidence rung that value
   stands on: rung 4 or higher of the ladder in `skills/blast-radius/SKILL.md` (you ran it, or you
   reproduced it in the running app). A reachability argued from reading is not recorded.
3. Findings then enter the cadence's triage step: ledger lookup → covered-but-unenforced vs
   not-covered fork → the fix-or-register decision. Only `real user today` findings are FIXED BY
   CLASS before the PR opens. Every other reproduced finding is REGISTERED with a named trigger,
   which is a disposition and not a dodge. **The sweep is clean when no `real user today` finding
   is open, and that is the unit's done condition.**
4. The sweep's result line goes in the unit's probe: lessons swept, findings by lesson, findings
   by `reachable` value, clean-to-ledger or not. A clean sweep is a PRECONDITION for a gated
   unit's non-author round, not a substitute for it.
5. **On a gated unit, close the sweep by writing the REVIEW MANIFEST into the unit's probe** — a
   short section titled exactly `## Review manifest`, holding: unit name · base..head SHAs · the
   swept tree's `git patch-id` (`git diff base..head | git patch-id --stable`) · the named
   guarantees · the known-class checks this sweep executed · registered residues with their named
   triggers · suite/typecheck/lint evidence · the runtime surfaces needing live attack. The
   patch-id is not decoration: a rebase, an amend, or a squash silently invalidates every
   SHA-pinned verdict while the swept CONTENT is unchanged, and the patch-id survives the
   rewrite — it is what lets a later reader tell "the head moved" from "the work changed".
   The manifest's consumer is the gated unit's fresh-context NON-AUTHOR review round, fed the
   ledger, which runs over the whole unit diff before the PR opens; the manifest is what stops
   that round re-deriving scope from thousands of lines of history.
6. **The blind control.** Every FOURTH non-author round runs ledger-blind, counted by the driver
   from the ledger's loop-health rows — the fed rows standing since the last blind row. A blind
   round is given neither the ledger nor the review manifest, so the probe's design sections must
   state the unit's guarantees in their own right. The round's mode goes in the loop-health row
   `/close-unit` appends.
