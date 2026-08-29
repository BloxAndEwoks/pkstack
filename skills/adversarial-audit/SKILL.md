---
name: adversarial-audit
description: "Audit a checkpoint's guarantees by trying to FALSIFY them end-to-end, not confirm them — then lock what survives with composed full-flow tests and a durable executed-counterexample record. STANDALONE verification for repos whose procedure file does not define its own per-unit verification step; where one exists (e.g. a ledger-driven /verify-sweep), the procedure file wins and this skill defers to it. MANDATORY TRIGGERS: 'adversarial audit', 'adversarially audit', 'audit the suite', 'attack the guarantees', 'try to break this', 'break each guarantee', 'red-team the tests', 'is the suite actually proving this'. STRONG TRIGGERS: 'are these tests real', 'would this survive a real review', 'harden the tests', 'prove it end to end'. Do NOT trigger for a normal test-writing request or a factual question."
---

# Adversarial Audit

A green suite is not evidence until someone has genuinely tried to falsify it. This skill's job is
the opposite of a normal test run: spawn agents whose task is to find a reproducible counterexample
to each guarantee, compose the whole flow the guarantee lives in, and only then trust it.

**Precedence:** the repo's procedure file (AGENTS.md or equivalent) owns the build cadence — where
it defines its own per-unit verification step (e.g. a finding-ledger-driven `/verify-sweep`), THAT
step is the default and this skill is not run in its place. This skill is the standalone deep audit
for repos without one. Where this skill runs at all, use the neutral falsify/verify register in all
prose and subagent prompts — same depth, and it keeps the driving session on its intended model.

**The pre-registered commitment:** before the first falsifier is spawned, write down that this
audit will not touch the instruments it attacks with — no harness edits, no regenerated baselines,
no assertion loosened, no subject restructured so a check goes green. When the oracle (a fixture, a
golden file, an expected-value table, a recorded baseline) and the product DISAGREE, that is a
fork, not an edit: stop and surface it as a finding for triage to adjudicate. The commitment is
pre-registered because tampering is invisible after the fact — a green result looks identical
either way — and an audit that quietly adjusts its own ruler has recorded nothing except its own
compliance.

The failure mode it exists to catch (a real reckoning, preserved below as anonymized worked
examples): the audits were **component-level**
— a core function called directly plus a DB assertion — and passed while the **composed flow** was
broken. A flag that raised correctly but never cleared and wedged `close`. A server action whose
copyable result was silently discarded by a wrapper. A quote and a submit that disagreed in a
no-coverage district. A margin recomputed on a different basis than the frozen price. Each had a green
component test. None had a test that drove the flow end to end.

---

## The two enforceable rules

Everything below serves these two rules. If a checkpoint satisfies both, the audit is real.

### Rule 1 — Compose the flow, don't just call the verb

At least one audit test per guarantee must drive it **end to end**, through every layer it actually
touches in production:

> rendered surface / server action → the server boundary → subsequent state transitions →
> operational queues + side-effects → the lifecycle outcome

Not the core function in isolation. The seams between layers are where the found defects lived:

- **The wrapper that eats the result.** `toActionResult` returns a bare `{ ok: true }` and discards
  whatever the thunk returned — so an action that "returns" a copyable link surfaced nothing. Only a
  test that asserts the *action's actual return shape* (not that the verb ran) catches it.
- **The flag that raises but never clears.** The raise had a test. The lifecycle — raise → confirm →
  clear → the gate the flag blocks is now open — did not. Drive to the outcome (`close` is possible),
  not the intermediate write.
- **The quote/submit disagreement.** Two entry points to "the same" guarantee priced in different
  orders. Test BOTH paths on the SAME input, especially the unhappy input (no coverage, empty basket).
- **The UI-only guarantee.** `required`, a disabled field, a caption — the browser enforces it, a
  crafted POST does not. The audit RE-POSTS crafted FormData at the server boundary. The UI is never
  the trust boundary.

Ask of every finding: *which layer boundary does this cross, and does a test cross it too?*

### Rule 2 — Record the executed attack, not just the plan

The probe (`docs/050-probes/NNN`) must carry, per finding, a **"validated, attacked, fixed, locked"**
record: the concrete attack that was run and what actually broke — not a premortem list of what might
break. A probe with a premortem and a test list but no executed attacks is an **incomplete audit**.
This record is what makes a green suite auditable by a human (or an independent external reviewer)
instead of merely asserted.

---

## How a session runs

### Step 0 — Scope the guarantees

List the guarantees this checkpoint claims (from the PRD/probe/commit). For each, name the LAYERS it
crosses in production and the OUTCOME that proves it (an order can close; a customer is called; a
figure reconciles with the frozen price). This list is the audit's target set.

### Step 1 — Fan out falsifiers (general-purpose agents, in parallel)

Spawn one agent per guarantee (or per layer-boundary), all in one message. Each is told to FALSIFY
its guarantee, not confirm it. The prompt template:

```
You are a verification executor. Your job is to FALSIFY this guarantee — find a reproducible
counterexample — not to confirm it.

GUARANTEE: [the claim]
LAYERS IT CROSSES: [rendered surface → action → transitions → queues → outcome]
CODE: [entry points + the verbs/reads involved]

Find a concrete input or sequence where the COMPOSED flow produces the wrong outcome even though
the component works: a result discarded at a layer boundary; a side-effect that never fires or
never clears; two entry points that disagree on the same input; a UI-enforced rule a crafted
request slips past at the server boundary; a figure recomputed on a different basis than the
stored one. Ground every claim against the live database where it's about the database — run the
query, show the row. Report each as: the exact input/state sequence, the observed wrong outcome
(actual vs expected), and the file:line. If you cannot falsify it after a genuine attempt, say so
and state what you tried.
```

Do NOT use Explore agents (they cap depth/scope). Use general-purpose agents.

### Step 2 — Validate every finding against the real code

Before fixing anything, reproduce each finding against the actual code (read the lines, run the
query). Discard false positives explicitly. Keep proportionality: on a pre-revenue system, log a
genuinely rare/unreachable finding rather than forcing a risky change into critical money code — but a
lifecycle wedge, a silent data loss, or a customer-visible disagreement is not "rare".

### Step 3 — Fix each real finding with a COMPOSED test (Rule 1)

Write the test at the layer the break lived in, driving to the outcome. The test must fail before the
fix and pass after. Prefer the outcome assertion (`the order can close`, `the enquiry reaches the
queue`) over an intermediate-write assertion.

### Step 4 — Write the durable record (Rule 2)

Update the probe with the "validated, attacked, fixed, locked" record per finding. This is not
optional; it is the deliverable that makes the audit auditable.

### Step 5 — Re-run the gates

Typecheck, the full test suite, lint, and the browser smoke if any UI or its wiring changed. What
happens after the audit (commit, further gates) is the repo's cadence, not this skill's.

---

## Notes

- This is the sibling of `/premortem` (imagines failure BEFORE building) and `/simplify` (cleans up
  AFTER building). Adversarial audit ATTACKS what was built. Different mechanism, different output.
- Scale the fan-out to the surface: a small checkpoint needs a few attackers; "audit this thoroughly"
  or a money/lifecycle surface warrants one attacker per guarantee plus a completeness critic ("what
  guarantee did we NOT attack? what layer boundary has no test crossing it?").
- The point is not more tests. It is tests that cross the boundaries where component-level coverage
  goes blind, plus a written record of the attacks that justifies calling the suite evidence.

---

## What counts as a finding (the discriminator)

Not every gap is a defect. An external review sharpened this and it must be codified:

- **Missing coverage ≠ a defect.** An untested flow that actually WORKS is a coverage gap (log it,
  lower priority). An untested flow that is actually BROKEN is a defect (fix it, top priority). Every
  finding states which it is. Reproduce the break before calling it a defect — a suspected gap is a
  hypothesis until a failing public-flow test confirms it. Crying "defect" on every missing test
  destroys the audit's credibility.
- **Attack the CLAIMS, not just the code.** A promise in a comment, a docstring, or a commit message
  ("this clears when the line is scheduled", "idempotent", "admin-only") is a guarantee — hunt for the
  ones with **no implementation path**. The most dangerous finding of the reckoning was a comment that
  described behaviour the code never performed. Grep the comments/docs for behavioural promises and
  verify each against the code.
- **Verify external FACTS against authoritative sources, not repo prose.** A constant or assumption
  about the outside world — a third-party fee (Stripe 1.5% + 20p), an API's behaviour, a legal rate, a
  rounding rule — is a factual claim. Check it against the official source (web, vendor docs), never
  against the commit message that introduced it. The repo can be internally consistent and externally
  wrong.

## The seam catalogue — attack classes proven to land

Order matters: devise YOUR OWN attack plan from the design and code FIRST — the guarantees, the layers
they cross, where you'd bet money it breaks. The catalogue is the FLOOR, not the search strategy:
sweep it AFTER your own hunt as a completeness check, so it catches what you missed without narrowing
what you look for. (This is the same independence-first rule we impose on the external reviewer —
prescribed categories cap exploration for us exactly as they would for it.)

Each class below found a real defect (the parentheticals are those episodes, anonymized); they
generalize far beyond the bugs that taught them:

1. **Enumerate ALL writers of the state, not just the chokepoint.** An invariant enforced at one write
   path is broken at every other write path. Grep every write to the column/state — the normal
   transition, the admin override/escape hatch, the cancel cascade, the webhook, the cron, AND the
   GRANT surface (a table the runtime role can UPDATE **or INSERT** is a writer: a row's BIRTH
   establishes state exactly as an update does, and an UPDATE-only revoke or monitor certifies a
   narrower boundary than the claim) — and prove the invariant rides
   each. (A backstop resolution rode 1 of 3 status writers; override and cancel bypassed it. A
   runtime role held an unrestricted UPDATE on a liveness table no ceremony had revoked. An
   UPDATE revoke plus `UPDATE OF` trigger floors left raw INSERT free to forge both money books
   at birth.)
2. **Attack the torn multi-transaction seam, and demand that retry REPAIRS.** Any operation that
   commits across two transactions (insert order → advance state; create → open session) has a crash
   seam between them. Simulate the tear, retry with the same idempotency key, and assert recovery for
   EVERY outcome class — a retry that returns "idempotent: true" while leaving broken state is worse
   than an error. Every fact the provider call used (routing / account scope) must be
   DURABLY admitted BEFORE the call so a retry cannot re-derive it from a mutated registry.
   (Retry recovery existed only for the payable outcomes; a torn mint re-stamped ownership
   because a null check re-derived a fact from a since-mutated registry.)
3. **A lock-recheck must re-verify ALL candidate predicates.** When a TOCTOU fix re-reads under the
   lock, list every predicate that qualified the candidate and re-check each — status, lease/claim
   freshness, age, AND a generation fence — as ONE shared predicate used at selection and at act
   time, under a row lock, so the next qualifier cannot drift between the two sites. (A sweep's
   requalification checked status but not the delivery date — a moved date still raised a stale
   backstop. An undo sweep re-checked liveness only, so a legitimately reclaimed attempt was
   still alarmed as stranded.)
4. **Fallback and special-case paths inherit the main path's guards.** Diff the guard list: every
   ceiling, validation, flag, and rail compare the primary path enforces must be proven on the bypass
   / early-dispatch path too. (A no-coverage fallback skipped the quantity ceiling; a charge
   fired before the settlement-rail check.)
5. **Trace the result through every wrapper.** A generic wrapper that normalizes returns can silently
   discard data (`toActionResult` → bare `{ok:true}` ate the copyable link). Assert the caller-visible
   shape at the boundary, not that the inner verb ran. A thin/notification event that names a CHANGE
   is a doorbell, not the resulting state — fetch the resource; never parse status from an event-type
   substring. Work that must run after ingest is born as named handled-work in the queue lifecycle
   (terminal `ignored` before the consumer runs is a silent drop). An adapter that fills a missing or
   unobservable source with a default (zero, empty) has discarded the FACT OF ABSENCE — unavailable
   is a named state, never a number (a renamed watched relation read as healthy 0-byte storage).
6. **One fact, many surfaces.** When a stated fact changes (a fee constant, a rate, a limit), grep for
   BOTH the old and new value across code, UI captions, ADRs, and probes — the code being right while
   the rendered caption lies is still a defect. (20p in code, "30p" in the caption + two docs.)
7. **Two entry points to one guarantee must agree on the same input** — especially the unhappy input
   (no coverage, empty basket, expired state). (Quote said "we'll call you"; submit threw.) Sharing
   one derived FACT is not sharing one POLICY: if each consumer may still choose its own projection
   of the shared fact, the disagreement has only moved into the projection choice — one named policy
   function, every producer of the outcome routed through it. (Ordinary cancel and override-cancel
   consumed one exposure fact through different projections.)

### The perf floor — the eight cost families

A performance guarantee ("this stays under X", "this scales with Y") is falsified by MEASUREMENT,
never by reading. Where a checkpoint claims one, capture a baseline trace first, then sweep the
eight strategy families from `skills/poteto-mode/playbooks/perf-issue.md` as the completeness floor
for where the cost hides:

- **Elimination** — work that need not run at all: a computation nobody consumes, an always-off
  gate, a redundant mirror, a legacy path kept "just in case". The odd family out on evidence: a
  trace shows what is slow, never that it is deletable, so this one earns its attempt from the
  design read rather than the profile — and it beats every other family where it applies.
- **Divide and conquer** — the dominant cost scales with input size: chunk, shard, prune the
  search space, or run independent pieces in parallel.
- **Caching** — the same computation or fetch repeats on identical inputs. Name what invalidates
  it before claiming the win.
- **Indirection** — the hot path does expensive work a cheaper intermediate could absorb (an index
  instead of a scan, a queue off the interactive thread). A layer that sits on the hot path
  without removing work from it is pure cost.
- **Batching** — many small operations each pay a fixed overhead (RPC, query, syscall, draw call);
  coalesce so the overhead is paid once per batch.
- **Redundancy** — the wait hangs on one slow instance or attempt: hedge, replicate, speculate, and
  take the fastest. Earns an attempt only where the trace shows the tail dominates AND the system
  has headroom; without both, duplication only adds load.
- **Lazy evaluation** — cost lands on results never used or not needed yet (eager init on the boot
  path, offscreen rendering); defer to first use.
- **Scheduling** — the work must happen, but not in the interactive moment: idle callbacks, a
  background warmup, precompute before the user arrives, cleanup after the frame commits. The win
  is perceived latency, so measure the interactive path, not total work done.

The same evidence gate governs these as governs the classes above: **a family earns an attempt only
when a trace or a measurement shows the signal it names**, and a focused fix for the DOMINANT cost
beats applying all eight. They are hypothesis generators, not a checklist — and a perf verdict
carrying no before/after number on the same surface is a coverage gap, not an upheld guarantee.

## Prove races deterministically (never sleep, never a sequential stand-in)

A "race test" that runs the two operations sequentially proves nothing. Use lock-staging (Postgres
shown; adapt to the repo's database): a blocker
connection takes the contended row lock (`BEGIN; SELECT … FOR UPDATE`), the racers are queued and
verified blocked (poll `pg_locks`/`pg_stat_activity` for waiters on the blocker's pid), then the
blocker commits and the assertions run on the now-deterministic interleaving. Always
`Promise.allSettled` the queued work in a `finally` so a failed assertion can't leak an open
transaction into the next test.

## Hold a cross-cutting track yourself

When you fan out per-guarantee (or per-commit) agents, they each see a SLICE. Someone has to see the
WHOLE. The orchestrator keeps one **end-to-end track personally** — the flow that spans the domains the
agents split — so the final judgment is about end-to-end behaviour, not a union of isolated diffs. The
seam bugs live precisely between the slices, where no single agent was looking.

## Establish a clean baseline first

Run the COMPLETE suite (not just the changed files) before auditing, so you have a green baseline. Then
the audit focuses on guarantees the existing tests never STATE — not on chasing pre-existing failures
or environment noise. A green full suite is the starting line of the audit, not its finish line.

## Re-verify the fix

A remediation can be incomplete or introduce a new break. After fixing, run the reuse/efficiency/
altitude lenses over it AND have a fresh agent try to falsify the FIXED result — the fix is a new
guarantee that has not yet been verified. Do not close the audit on the strength of the change you
just made.

## Output: a verdict per guarantee

Close with a per-guarantee verdict — **upheld** (attacked, survived) or **denied** (attacked, broke,
here is the failing flow) — plus a concrete deeper-test plan for anything left as mere coverage. A
findings list without a verdict leaves the reader to guess what the audit concluded.

## After the audit

Whether, when, and how an INDEPENDENT external reviewer runs — and at what cadence and effort — is
the repo's procedure file's business, not this skill's. The audit's contribution to that decision is
its executed-counterexample record: it gives any later reviewer something concrete to verify instead
of re-deriving.
