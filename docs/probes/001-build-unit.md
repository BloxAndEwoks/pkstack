# Probe 001 — the pkstack build unit (P0–P3)

**Unit.** Fork kstack into pkstack, vendor pstack 0.14.5, land the CC compatibility patch set
(P1) and the loop graft (P2), dogfood the loop (P3). BASE `213171b` (kstack v0.4.1, pre-fork).
**Classification.** Gated by fiat for the trial (the unit is the plugin every future gated unit
runs on; unsure ⇒ gated). Close trigger: end of P3 (named at registration; this file is the
register). Route: bespoke (figure-it-out shape) — no re-routing occurred.

## Triage clusters

**C1 — readers of a changed literal found by memory or type-filtered sweep, not by grep.**
Class: missing GUARD. Members (all confirmed):
1. `external-review.sh:184` — loop-health `mode:` format changed (P2-B); the blind-control awk
   counter read the old literals and would have silently counted 0, disarming the scheduler.
   Found by the non-author reviewer (P2-B report); fixed in `b908ef6`.
2. `orch/store.ts` + `orch.test.ts` — playbook renamed `ledger.tsv`→`verdicts.tsv`; the code
   still wrote `ledger.tsv`. Found by P2-A2; fixed in `b908ef6`.
3. `worktree-audit.sh:27` — P1's Cursor sweep ran `--include='*.md'`; the shell script kept
   `~/.cursor/projects/.../agent-transcripts`. Found at P3 lever review; fixed this commit.

**C2 — ordered-list insertion breaks numeric cross-references.**
Class: missing GUARD. Members (confirmed): feature step 5a and bug-fix step 2a would have
renumbered steps cited elsewhere by number ("Feature step 3", "Bug fix step 1"). Caught at
authoring time by P2-A1; landed as continuations of the parent items.

**C3 — a rule restated per playbook instead of defined once (process cluster).**
Class: missing GUARD (process). Members (confirmed, from the playbook audit): `/deslop`
restated at 5 sites; `control-ui`/`control-cli` at 6 sites. Fixed in P1 by single-definition
landing (deslop = one skill; control = one router definition). This cluster is the process
ladder's first executed trial: the promotion rule decided both members cleanly.

**C4 — path equality by raw string compare under symlink variance.** One member: the M4
lever's pin comparison missed `/tmp` vs `/private/tmp` (found by this close's executed
counterexample, below; fixed by canonicalization). No historical siblings found in the probes;
a one-member lesson is maximally specific, so NO lesson is minted — the finding stands
recorded and waits for a second member.

## Close of unit

- C1 → no standing lesson claims it → **mint L1**.
- C2 → no standing lesson → **mint L2**.
- C3 → no standing lesson → **mint L3** (process; medium = router trigger, already landed).
- C4 → recorded, not minted (single member; razor).
- **M4 demonstration (covered-but-unenforced, executed):** the worktree playbook's
  hand-cross-check prose was the failed MEDIUM for a correct statement ("a pinned tree is
  never safe"). Promotion landed: the pinned set is now a lever INPUT and `safe` is
  structurally unemittable for a pinned tree. First counterexample run FAILED (C4), was
  fixed, and re-ran green in both directions (pinned-via-symlink ⇒ `pinned`; unpinned
  control ⇒ `safe`).

Headline ratio: novel 3/6 (three lessons minted over six confirmed members; no re-samplings —
expected for a first close on an empty ledger).

## The loop self-check

- **Extension audit:** every member above resolves to a commit, report, or executed run named
  in its entry. No aspirational members.
- **Non-members:** the `how explainer` model role was dropped with a written reason (P1
  report) — recorded so no future walk claims it.
- **Medium rot:** wire-check green at this close (71 wires).
- **Overdue registers:** none; the only queued promotion (M4 lever) landed at this close.
- **Anchoring / ratio confound:** n/a — first loop-health row; no fed history to anchor on.
- **Ceremony:** ~3.5h wall for the full build; six delegate runs; driver-side close overhead
  ~20 min. Not heavy; no offload needed yet.
