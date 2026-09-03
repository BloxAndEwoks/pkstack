# Seam catalogue — optional reading

The attack classes, perf cost families, and race-proving recipe that each landed a real defect in
some codebase, kept generic. **This is OPTIONAL READING a driver may consult, never a work
breakdown and never a step.** No skill routes to it and no sweep owes it a walk. An empty or young
ledger means the sweep's executors hunt from their own plan over the diff, independence first, and
the ledger fills from what lands. A lesson is never seeded from another repo, and a generic
catalogue is such a seed.

## The seam catalogue — attack classes proven to land

Order matters: devise YOUR OWN attack plan from the design and code FIRST — the guarantees, the layers
they cross, where you'd bet money it breaks. Anything read here is read AFTER your own hunt, so it
cannot narrow what you look for. (This is the same independence-first rule we impose on the external
reviewer — prescribed categories cap exploration for us exactly as they would for it.)

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
