# The kstack philosophy

Everything in kstack follows from one observed failure and one paper. The failure: a rigorous
team that ran every unit through an independent external review kept getting DENIED — round
after round, with the findings recurring in the same *shapes* — because each finding was fixed
as itself: one guard per finding. Guards written that way are maximally specific hypotheses
with single-member extensions, and the next round reliably lands in the gaps BETWEEN them. The
paper: Bennett, *The Optimal Choice of Hypothesis Is the Weakest, Not the Shortest*
(arXiv:2301.12987). Its principle — **explanations should be no more specific than
necessary** — is the selection rule that replaces taste everywhere kstack turns findings into
process. Where the razor meets the build it collapses to one law: **every shipped line traces to
evidence** — a fix to its runtime repro, a lesson to its cited members — and breadth with neither
is belt-and-suspenders, which does not ship.

## Two nested loops

**The inner loop builds a unit** (a unit = the work behind one PR, answering one named goal,
usually one to five commits). It is the router's playbook walked end to end: understand the
subsystem, premortem then architect the design, plan the fan-out, delegate the code, verify on
the matching surface with the ledger sweep inside that step, rebase, interrogate a contested
design, open the PR, collect the PR's non-author verdict. It is deliberately boring and always
the same. Proportionality lives in the size of each step, never in a skipped step: the premortem
scales to a probe note and the sweep's fan-out scales to the diff, but no unit skips the walk,
the drive, or the verifier.

**The outer loop improves the process itself**, and it has exactly ONE step: the unit close
(`/close-unit`), run after the PR's verifier posts its verdict and before the owner merges, on
any unit whose sweep or verifier landed findings. One step, placed there, because that is when
the finding sample is largest; because it must sit outside remediation (a mid-fix reflection is
contaminated by deadline pressure); and because it must not live inside the verifier itself (the
verifier is the loop's unbiased sampler, and instrumenting it changes what it samples). A process
whose improvement step fires "whenever someone gets around to editing the procedure file" does
not have an outer loop; it has accumulated pain.

The outer loop also attacks itself: every close runs a mechanical self-check (anchoring, the
ratio confound, overdue registers, medium rot — see `/close-unit`), and any newly discovered
loop-level failure mode is added to that checklist in the sitting it is found.

## The ledger is the outer loop's memory

A **lesson** is a hypothesis generalising from the findings you observed (the child task) to
the defect class they sample (the parent). The optimal hypothesis is the **weakest one still
sufficient** to decide every observed member — weakest measured by extension (what it covers),
not by sentence length. The razor as stated governs PROHIBITIONS, whose extension is the defects
they forbid; a permission-shaped statement — a skip rule, a dismissal rule, an allow-list —
inverts, because its extension is what it LETS THROUGH: narrowest sufficient, not weakest. A
lesson therefore has three mandatory parts: the **statement**, its **extension** (the recorded
findings it decides — cited, checkable), and its **medium** (where it is enforced).

The **sufficiency walk** keeps this from being taste: for every finding in a claimed
extension, one sentence — "applied at build time, this forbids that defect because …". A
member you cannot write the sentence for is not in the extension.

When a later round regenerates a finding a lesson should have prevented, there are exactly two
diagnoses, demanding **opposite** responses:

- **Covered but unenforced** — the statement already decides the new member. The statement was
  right; its MEDIUM failed. Promote the medium one rung. Do not write a more specific rule.
- **Not covered** — the statement is TOO STRONG (too specific) to claim the new member. Weaken
  it until the member falls inside, then re-run the sufficiency walk over ALL members. A
  statement that cannot be weakened without losing a member must be split.

The anti-pattern both forks forbid is the original failure: responding to every finding with a
new, narrower rule.

## Why the ledger ships empty

kstack carries the ledger's **mechanism** — the razor, the walk, the forks, the media ranking,
the loop-health instrumentation — and **no lesson statements**. A repo's lessons are minted at
its own unit closes, from its own findings. This is a considered rule, not modesty:

- **A lesson's authority IS its extension.** A statement with no local members is doctrine
  wearing no proof: the sufficiency walk is unrunnable on it, and both regeneration forks are
  undefined — you cannot honestly weaken a statement against members it does not have, and
  promoting the medium of a rule that has never bitten locally is gold-plating by definition.
- **A foreign statement imports a foreign base rate.** Sweeping a class another codebase
  sampled spends verification budget where this repo has no evidence of leakage — and anchors
  its premortems and sweeps to another architecture's failure distribution.
- **The generalizable part already travels at the right altitude.** What deserves to cross
  repos is method-level doctrine — requiredness, enforcement tiers, compose-the-flow — in the
  generated AGENTS.md. The ledger's job is precisely the part that must be local: which classes
  THIS repo actually samples, with what evidence, enforced where.

**An empty or young ledger** does not shrink verification to nothing. It means the sweep's
executors hunt from their own plan over the diff, independence first, and the ledger fills from
what lands. A lesson is never seeded from another repo, and a generic catalogue is such a seed.
The seam catalogue at `skills/verify-sweep/references/seam-catalogue.md` survives as optional
reading a driver may consult, never as a step and never as a work breakdown.

## Enforcement media, ranked by quantification force

`DB constraint/trigger` > `registry walk / compile-forced Record` > `lint rule / executable gate` > `required
design-artifact field` > `gate-rubric line` > `prose (with written reason)`.

The ranking is not bureaucratic — it is the razor applied to enforcement. A mechanized medium
can only express universally-quantified statements ("EVERY member of the family…"), which is a
weak hypothesis whose extension includes members that do not exist yet. That is why
structurally-closed guarantees hold under re-attack and convention-closed ones regenerate as
sibling defects. The tier law follows: what must hold for every writer holds in the DATABASE;
the type system is ergonomics for the writers the compiler can see; a comment is a record, not
an enforcement. A lesson that lands only as prose should be treated as un-landed until it has
a written reason.

## The division of verification labor

Three verification instruments, deliberately asymmetric:

- **The sweep (every unit)** applies the repo's KNOWN classes to the diff — cheap, parallel,
  exhaustive over the ledger. Run in a neutral falsify/verify register with bounded per-lesson
  executor specs; judgment (scope, triage, verdict) stays with the driver.
- **The non-author verifier (the default independence rung)** is a fresh agent that did NOT write
  the code, in its own worktree, driving the real surface parent-vs-head, with its verdict posted
  where it outlives the chat. It buys the one property the sweep's executors are denied by
  design — independence from the build — and it samples what a builder's own falsification
  structurally cannot: the assumption the author never knew they were making. This is the rung
  the playbooks route to, unconditionally: on a composed-on checkpoint inside a unit, and on
  EVERY PR before the owner merges. It is still in-family, which is a stated limit rather than a
  hidden one.
- **The external gate** is an INDEPENDENT model hunting NOVEL classes — the builder's blind
  spots, which no amount of in-family review samples. It is TOOLBOX, not flow: it runs when a
  repo's procedure file names it, on the surfaces that repo judges worth the cost, and never as
  an ambient step. A clean sweep is its precondition wherever it runs, so the expensive reviewer
  never spends its budget re-discovering the ledger.

Feeding a reviewer the ledger (as its floor, never its ceiling) risks **anchoring** — a fed
reviewer can satisfice on known classes and under-sample novel ones — and whether that is
happening must be MEASURED, never remembered. Every FOURTH verifier therefore runs as a
blind control, and the driver schedules it by counting the `·fed` rows standing since the last
`·blind` row in the ledger's loop-health table. No script keeps that count. The novel-vs-resampled
ratio alone is confounded (an anchored reviewer and genuinely exhausted classes look the
same); only the blind control discriminates. Nothing about loop health lives in ambient human
memory — the row the close appends IS the counter's state.

## The last layer: drive the product as its consumer

Every instrument above stops at a boundary the consumer never sees: composed tests cross the
server boundary, the sweep falsifies code classes, a review round reads. The one verifier below
that plane is a human — unless the repo has a **verification skill** (`verify-<project>`,
generated by `/create-verification-skill`): a maintained **feature map** of how a consumer
reaches and drives every consumer-facing surface (browser UI, public API, CLI, token links,
outbound messages), plus a driver that operates the product exactly that way against a
hermetic stack, handing back replayable evidence. Its standards are the loop's, restated
at the surface: the surface is never the trust boundary (a proof composes surface → action →
state → side-effect read → a second view), and the hermetic stack is non-negotiable — a
verification skill pointed at production is refused, not accommodated.

Two rules keep the map honest. **A skill never executed is a draft**: creation closes with a
live end-to-end proof of novel coverage, and what the proof teaches is fed back into the map
in the same sitting — a map written purely from source reading always contains at least one
confident falsehood. And **a map/product disagreement is a fork, never an edit**: working
product with a dead recipe → fix the recipe and re-drive it; broken product → a product gap
reported into triage — the map is never edited to match a breakage. (Note the symmetry with
the ledger's forks: both artifacts are claims about a moving system, both have exactly one
writer — the ledger's close, the map's MAINTAIN mode — and both forbid quietly bending the
record to fit the defect.) The map's enforcement tier is procedure, with the written reason
that it is prose about a moving product: its verification medium is execution, not the
compiler.

## Triage: mechanism before remedy

Findings arrive as flat lists; fixed as flat lists they become the original failure. Before
any fix: cluster by shared mechanism, then classify each cluster — **wrong MODEL** (every guard
resting on it is load-bearing on a falsehood), **missing FACT** (the code is inferring what it
could be told), or **missing GUARD** (model right, one path forgot a check).

**Mechanism first, and it alone picks the remedy.** A wrong MODEL is fixed NOW by redesign
regardless of who can reach it, because deferring it multiplies through every checkpoint that
composes on it; it is never a note, and more guards make it worse. A missing FACT is fixed by
carrying the fact at the layer that first has it, never by a local conditional. A missing GUARD
is the one mechanism where a local fix is correct. Answering a missing-fact problem with a guard
is the spiral, every time. Guard density is the leading indicator — a third conditional on one
path means redesign the path now, not after two more rounds prove it.

**Reachability second**, and only for missing GUARD and missing FACT: the `reachable` value
(real user today, crafted client, raw writer, operator, not today), evidenced at rung 4 or higher
of the blast-radius ladder, decides whether the fix lands in this unit or becomes a NOTE with a
named trigger.

**The verdict words are PASS, PASS+NOTES, FAIL.** A FAIL is a wrong MODEL, or a real user
reaching a false statement today, reproduced on the surface. Every NOTE carries a named trigger.
A unit is done when no FAIL is open.

**Fixed by class** means the ledger's promotion into structure — a constraint, a compile-forced
table, a lint, a registry walk — never the instance patch. And bound it: a single isolated
finding on a sound model gets the local fix and nothing more, with the judgement recorded either
way.

## Size laws

Growth is routed, never ambient. The procedure file (AGENTS.md) stays a fixed size: lessons
and evidence accrete in the LEDGER; when a lesson is fully mechanized, its procedure-file
prose is cut to a one-line pointer. A review rubric consolidates rather than appends — an
entry that turns out to be an instance of an existing class sharpens that entry; two entries
that share a deeper principle merge. A rubric nobody can hold in attention guides nothing;
its value is inversely related to its length.

## Self-containment

kstack relies on nothing outside this repository: every skill it names, it ships; every
convention it references (the docs spine, the probe pattern, the ledger path), its init
generates; worked examples inside skills are anonymized stories, complete in themselves. A
reference a kstack reader cannot chase from a fresh checkout is a defect in kstack — treat it
as one.
