---
name: external-review
description: "UNROUTED TOOLBOX: this gate runs only when the repo's procedure file names it, it is not part of the Feature flow, and it requires the Codex CLI installed and logged in. Run the adversarial EXTERNAL review gate: drive Codex (an independent model) over the current branch to DENY the work's claims, then remediate what it lands. The backstop on the repo's own verification step — it checks we followed the discipline honestly, with blind spots we don't share. MANDATORY TRIGGERS: 'external review', 'run codex', 'codex review', 'have codex check this', 'external review gate', 'independent review', 'get a second model on this'. STRONG TRIGGERS: 'is this actually shippable', 'red-team this externally', 'would codex deny this'. Trigger AFTER the repo's own verification pass (its ledger-driven sweep where one exists, else /adversarial-audit) plus /simplify, as a gate before calling a unit done — especially on money rails, the state machine/lifecycle, and customer-facing flows. Do NOT trigger for a trivial or docs-only change."
---

# External Review Gate

This skill is unrouted toolbox: it runs only when the repo's procedure file names it, no step of
the Feature flow depends on it, and it requires the Codex CLI installed and logged in.

This is the backstop on the build cadence, not a step in it. The repo's own verification pass (the
ledger-driven sweep, or the seam catalogue at `skills/verify-sweep/references/seam-catalogue.md` where no ledger exists) is where WE attack the
guarantees; this gate has an **independent model (Codex)** attack them — one that does not share our
blind spots or our incentive to confirm our own work. It exists because a green suite plus a self-run
audit still leave the builder's blind spots unsampled — an independent reviewer repeatedly lands
composed-flow defects both had passed. Making it a one-command ritual is what turns "we should get a
second opinion" into something that actually happens at every high-stakes unit.

## When to run it

- AFTER the repo's own verification pass + `/simplify`, as the certifying close of a gated unit. The
  repo's procedure file (AGENTS.md) owns the exact cadence seat — in kstack repos: a clean 4a sweep
  is the PRECONDITION for this gate, and the gate's budget goes to NOVEL classes, not re-discovering
  the ledger.
- On surfaces where being wrong is expensive: money rails, the state machine / lifecycle, customer-
  facing flows, custody, migrations. Skip it for docs-only or trivial mechanical changes — the
  token/latency cost isn't justified there.
- It is a BACKSTOP, never a substitute. Do not verify less rigorously because "Codex will catch it" —
  the gate checks a real audit happened; it doesn't replace one.
- Respect the repo's caps where recorded (kstack default: ONE round per gated unit, at most ONE
  re-gate; survivors go to triage where register-with-named-trigger is a legitimate disposition).

## How to run it

The gate works in ANY git repo on this machine. Script resolution order:
1. `scripts/external-review.sh` in the repo (the project-seeded copy — `kstack-init` no longer seeds one; a repo may vendor its own copy) —
   prefer it.
2. Otherwise the PROJECT-AGNOSTIC copy bundled with this skill: `external-review.sh` in this skill's
   base directory. Same flags, same rubric, same no-commit enforcement — it discovers the repo's own
   agent instructions, gates, and doc conventions instead of assuming any one project's. When a
   project earns a tuned copy, seed it from the bundled one and commit it to that repo.

Both drive `codex exec` headless with the same composed-flow rubric the repo's own audit uses. Codex
must be installed + logged in machine-globally (`brew install codex`, `codex login`,
`~/.codex/config.toml`); after that this needs no per-project setup.

It can take several minutes — run it in the BACKGROUND and read the verdict file when it finishes:

```bash
scripts/external-review.sh --base <unit-start-sha> --probe <NNN>   # THE canonical per-unit gate
scripts/external-review.sh                 # REVIEW this branch vs main (read-only verdict)
scripts/external-review.sh --commits 7     # the last N commits
scripts/external-review.sh --fix           # REVIEW **and** apply fixes+tests, left UNCOMMITTED
scripts/external-review.sh --fast          # priority service tier: faster INFERENCE, same effort
scripts/external-review.sh --effort <lvl>  # per-run reasoning effort (minimal…ultra)
scripts/external-review.sh --with-ledger   # force the ledger feed ON for this run
scripts/external-review.sh --no-ledger     # force a BLIND control round (feed withheld)
```

**Certify the unit's own range, not the accumulated branch.** The premortem records the unit's
base SHA in the probe header at unit start; pass it as `--base`. A `main...HEAD` default over a
range holding older work makes the reviewer re-certify history it never scoped — and on a pushed
main the range is simply empty.

Two INDEPENDENT knobs — do not conflate them. `--fast` is inference SPEED (`service_tier="priority"`,
same model + effort); `--effort` is thinking DEPTH (`model_reasoning_effort`). The adversarial hunt
should keep the deep config default (`ultra`) — a shallow adversary is a false sense of security —
and `--fast` is the right way to speed it up. Down-dial `--effort` only for mechanical work: a
`--fix` batch of pre-validated findings, a scoped caption/doc sweep, a quick re-check.

Run it via the Bash tool with `run_in_background: true`; when it completes it prints the
verdict/summary and writes it to a timestamped file (path in its output). Do NOT poll with short
sleeps — you're re-invoked when the background command exits.

**The branch belongs to the gate while one is in flight**: never commit (and never run the repo's
test suite, if Codex runs it too) while the review runs — the script soft-resets to the review's
starting commit on finish, orphaning any mid-review commit.

## Inside the run: one coordinator, parallel lanes, one verdict

The prompt makes Codex the ROOT CERTIFICATION COORDINATOR of one gate with one consolidated
verdict. After recording its own independent attack plan, it spawns up to three concurrent
READ-ONLY review subagents on lanes derived from the unit's diff (journeys/reachability · data
authority · temporal/operational) — only the lanes the diff implicates, never splitting one causal
chain. Resource ownership is enforced in the prompt: the coordinator alone runs the repo's full
suite (once) and any UI smoke; at most one agent mutates the live database; other lanes return
executable counterexample recipes the coordinator reproduces serially — a lane report is a claim,
not a finding. Where the Codex environment can't spawn subagents, the same lanes run as sequential
passes — the design degrades, the discipline doesn't. NEVER run two gate script processes
concurrently: that is how shared suites, fixed-port smoke stacks, and shared databases corrupt.

The gate certifies against a **manifest floor**: on gated units the verify-sweep closes by writing
a `## Review manifest` section (formerly `## Gate manifest`) into the unit's probe (unit · base..head · guarantees · known-class
checks executed · residues with triggers · suite evidence · runtime surfaces). The prompt has Codex
read it only AFTER forming its own plan — a completeness floor, never the search strategy.

## The ledger feed and the blind control

In a repo with a finding ledger (`docs/070-quality/004-finding-ledger.md`), the script FEEDS the
ledger's lessons to Codex as its minimum defect classes (the floor, never the ceiling — Independence
First still leads), and treats registered residues as disclosures, not denials to re-litigate.
Feeding risks ANCHORING, so the feed is positioned AFTER the prompt's independence-first plan step,
and the script self-schedules a BLIND control every 4th gated round by counting the ledger's
Loop-health rows — no human keeps the count, and the close-unit step records which mode ran. A
blind round withholds the ledger from the coordinator AND every subagent, and withholds the probe's
Gate-manifest section with it (its known-class and residue lines are ledger content by proxy). If
blind rounds keep finding what fed rounds stopped finding, the feed is anchoring: drop the hunt
clause, keep the disclosure rule. In a repo with no ledger, the feed degrades to nothing
automatically.

## Division of labor: who fixes (token efficiency without losing the check)

Codex runs on the owner's subscription, so let it spend ITS tokens on the heavy generation:

- **`--fix` mode** has Codex do the token-heavy work — draft the fixes AND the composed tests — then
  STOP before committing. It refuses to start unless the working tree is clean, so the resulting diff
  is only Codex's work. Prefer `--fix` for a SUBSTANTIAL remediation sweep; a tiny surgical fix is
  cheaper to do inline than to round-trip.
- **The driving model stays the judge**, whichever mode ran: review Codex's diff, reproduce each
  finding, run the full gates yourself, and OWN the commit. Reviewing a diff is a fraction of the
  tokens of authoring it — so the saving is real while an owned gate stays in place.
- **The one rule that keeps this honest: a model is never the sole reviewer of a change it wrote.**
  Codex reviewed our work → we review Codex's fixes. Do not rubber-stamp a `--fix` diff because
  "Codex is good" — that collapses the independence that made the gate worth running. Validate, gate,
  then commit; reject or refine what doesn't hold (style, altitude, over-reach, a weakened test).
- After landing Codex's fixes, the changes are now OURS — remediation is new work the earlier steps
  never saw. A fix on a high-value surface warrants one more review pass before "done".

## How to consume the verdict

1. **Separate real defects from coverage gaps.** The rubric asks Codex to distinguish "untested but
   works" (a coverage gap — log it) from "untested AND broken" (a defect — fix it). Treat DENIED
   verdicts with a concrete failing flow as defects; treat "no test crosses this" without a reproduced
   break as coverage to backfill.
2. **Reproduce before accepting.** Codex is independent, not infallible. Validate each denial against
   the real code (read the lines, run the query) exactly as you would your own finding. Discard false
   positives explicitly; weigh proportionately.
3. **Triage FIRST, then remediate.** Cluster denials by mechanism; classify missing GUARD / missing
   FACT / wrong MODEL; fix the class, not the members. Each accepted defect gets a COMPOSED full-flow
   test (fails before, passes after) at the layer the break lived in, and an entry in the unit's
   probe record.
3b. **Run `/simplify` over a substantial `--fix` diff before committing.** The cadence's "simplify
   after building" applies to Codex's building too. The diff is uncommitted at this point, which is
   exactly what /simplify reviews.
4. **Re-run the gates** (typecheck, full suite, lint, UI smoke if UI) and re-commit. If the fixes
   were substantial, it is legitimate to run the gate ONCE more on the remediation — a fix is a new
   guarantee. One re-gate is the convergence rule: anything still landing after it is triaged into
   the next unit, not looped again.
5. **Feed the lesson back — the round is not closed until you do.** In a kstack repo this is the
   `/close-unit` step: every landed finding goes through the ledger forks (covered-but-unenforced vs
   not-covered vs mint), and the ledger feed reaches the next gate automatically. Where the repo has
   no ledger, fold the lesson into the rubric in `scripts/external-review.sh` directly.
   **Consolidate, don't just append.** The rubric must not become a one-way ratchet that grows until
   attention dilutes. When folding a lesson in, first ask whether it is an instance of an existing
   class — sharpen that entry rather than adding one — and when two entries turn out to be one deeper
   principle, MERGE them. The catalogue's value is inversely related to its length.

## Notes

- Alternative wiring — **Codex as an MCP server** (`claude mcp add codex -- codex mcp-server`)
  exposes Codex as an ambient tool for ad-hoc queries. For a bounded REVIEW gate the `codex exec`
  script is the better fit: purpose-built, one-shot, with a verdict we control the prompt for.
- Keep the rubric in `scripts/external-review.sh` in sync with the repo's own verification
  discipline — the two must speak the same language, so our audit and the external gate hold the
  work to one standard.
