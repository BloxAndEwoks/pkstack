#!/usr/bin/env bash
# external-review.sh — drive Codex (an INDEPENDENT model) as the external certification gate.
#
# The build cadence's own verification step (the ledger-driven sweep, or the verify-sweep seam catalogue where no
# ledger exists) is OUR audit — it applies every KNOWN defect class to the unit's diff before this
# gate runs. This is the backstop that CERTIFIES the unit: an independent reviewer that does not
# share our blind spots or our incentive to confirm our own work, whose budget goes to NOVEL classes
# and composed-flow depth, never to re-discovering the ledger. It exists to catch the composed-flow
# defects a green suite hides; this makes running it a one-command ritual instead of an ad-hoc call.
# ONE run = ONE gate = ONE consolidated verdict — never run two of these concurrently (they share
# the repo's suite, its live database, and any fixed-port smoke stack).
#
# Codex CLI must be installed (`brew install codex`) and logged in (`codex login`). It runs headless
# via `codex exec` using ~/.codex/config.toml (model, sandbox, approvals); give that config whatever
# access the repo's suite needs (e.g. Docker + a live database) so Codex can ground-truth claims and
# run tests itself.
#
# Usage:
#   scripts/external-review.sh                 # REVIEW this branch vs main (read-only, a verdict)
#   scripts/external-review.sh --base <branch> # review vs a different base
#   scripts/external-review.sh --commits <N>   # review the last N commits
#   scripts/external-review.sh --probe 068     # focus on a probe's guarantees (repeatable hint)
#   scripts/external-review.sh --fix           # REVIEW **and** implement the fixes + composed tests,
#                                              #   leaving changes UNCOMMITTED for review (never commits)
#   scripts/external-review.sh --fast          # PRIORITY service tier: faster INFERENCE at the same
#                                              #   model + effort (speed, not depth — the two axes are
#                                              #   independent; combine with the default ultra effort)
#   scripts/external-review.sh --effort <lvl>  # override Codex's reasoning effort for THIS run
#                                              #   (minimal|low|medium|high|xhigh|ultra; default = the
#                                              #   ~/.codex/config.toml setting)
#   scripts/external-review.sh --with-ledger   # force the finding-ledger feed ON for this run
#   scripts/external-review.sh --no-ledger     # force a BLIND control round (feed withheld)
#
# The canonical per-unit invocation: certify exactly the unit's range, never the accumulated
# branch — the premortem records the unit's base SHA in the probe header at unit start:
#   scripts/external-review.sh --base <unit-start-sha> --probe <NNN>
#
# Two independent knobs. --fast = HOW QUICKLY tokens are served (service_tier="priority"); --effort =
# HOW HARD the model thinks. The adversarial hunt should keep deep effort (a shallow adversary is a
# false sense of security) — --fast is the right way to speed it up. Down-dial --effort only for
# mechanical work: a --fix batch of pre-validated findings, a scoped doc/caption sweep, a re-check.
#
# Modes. Default is review-only. `--fix` lets Codex spend ITS subscription on the token-heavy work
# (drafting fixes + tests), then STOPS before committing — the driving model reviews the working-tree
# diff, re-runs the gates, and owns the commit. This keeps independence: whoever writes a change is
# never its sole reviewer. Prefer --fix for substantial remediation sweeps; a tiny surgical fix is
# cheaper to do inline than to round-trip.
#
# Output: a verdict / change summary is written to a timestamped file (path printed at the end) AND
# echoed. Run it in the background (it can take several minutes) and read the file when it completes.
set -euo pipefail

BASE="main"
COMMITS=""
PROBE=""
MODE="review"
EFFORT=""
FAST=0
LEDGER_MODE=""   # "" = auto (self-scheduled from the ledger's Loop-health table); fed | blind
# A value-taking flag with no value must refuse with a usage error (exit 2), never die on set -u's
# unbound $2 (exit 1 with a bash stack line).
need_value() {
  if [[ $# -lt 2 ]]; then echo "$1 requires a value" >&2; exit 2; fi
}
while [[ $# -gt 0 ]]; do
  case "$1" in
    --base) need_value "$@"; BASE="$2"; shift 2 ;;
    --commits) need_value "$@"; COMMITS="$2"; shift 2 ;;
    --probe) need_value "$@"; PROBE="$2"; shift 2 ;;
    --fix) MODE="fix"; shift ;;
    --effort) need_value "$@"; EFFORT="$2"; shift 2 ;;
    --fast) FAST=1; shift ;;
    --no-ledger) LEDGER_MODE="blind"; shift ;;
    --with-ledger) LEDGER_MODE="fed"; shift ;;
    *) echo "unknown arg: $1" >&2; exit 2 ;;
  esac
done
if [[ -n "$EFFORT" ]]; then
  case "$EFFORT" in
    minimal|low|medium|high|xhigh|ultra) ;;
    *) echo "invalid --effort '$EFFORT' (minimal|low|medium|high|xhigh|ultra)" >&2; exit 2 ;;
  esac
fi

command -v codex >/dev/null || { echo "codex CLI not found — 'brew install codex' then 'codex login'" >&2; exit 127; }
codex login status >/dev/null 2>&1 || { echo "codex is not logged in — run 'codex login'" >&2; exit 1; }

REPO_ROOT="$(git rev-parse --show-toplevel)"
cd "$REPO_ROOT"
REPO_NAME="$(basename "$REPO_ROOT")"

# The scope line the reviewer is told to attack. VALIDATE the refs first: `git diff --quiet
# <malformed-range>` exits 128 *inside the if*, which reads as "not empty" and sails a garbage range
# into a review-length Codex session. A bad scope must cost seconds.
if [[ -n "$COMMITS" ]]; then
  [[ "$COMMITS" =~ ^[1-9][0-9]*$ ]] || { echo "[external-review] --commits must be a positive integer, got '${COMMITS}'" >&2; exit 2; }
  git rev-parse --verify --quiet "HEAD~${COMMITS}" >/dev/null || { echo "[external-review] HEAD~${COMMITS} does not exist (history has fewer commits)" >&2; exit 2; }
  SCOPE="the last ${COMMITS} commits (git diff HEAD~${COMMITS}...HEAD)"
  RANGE="HEAD~${COMMITS}...HEAD"
else
  git rev-parse --verify --quiet "${BASE}^{commit}" >/dev/null || { echo "[external-review] --base '${BASE}' is not a commit this repo knows" >&2; exit 2; }
  SCOPE="this branch's changes against ${BASE} (git diff ${BASE}...HEAD)"
  RANGE="${BASE}...HEAD"
fi

# FAIL FAST on an empty review range: sitting ON a pushed `main` makes `main...HEAD` empty — a scope
# mistake should cost seconds, not a review-length session. (`--base <sha>` reviews an exact
# checkpoint range regardless of push state — the long-horizon invocation.)
if git diff --quiet "$RANGE" 2>/dev/null; then
  echo "[external-review] the review range is EMPTY: git diff ${RANGE} has no changes." >&2
  echo "                  On a pushed main, use --commits N (last N commits) or --base <sha> (a" >&2
  echo "                  checkpoint-start snapshot: git rev-parse HEAD before the work)." >&2
  exit 2
fi
PROBE_HINT=""
[[ -n "$PROBE" ]] && PROBE_HINT="Focus on the guarantees claimed by docs/050-probes/${PROBE}*."

# In --fix mode the working tree MUST be clean, so the diff to review afterwards is ONLY Codex's work.
if [[ "$MODE" == "fix" && -n "$(git status --porcelain)" ]]; then
  echo "[external-review] --fix needs a clean working tree (so the review diff is only Codex's changes)." >&2
  echo "                  commit or stash your changes first." >&2
  exit 1
fi

# The mode-specific tail: review-only asks for a verdict and forbids edits; --fix adds the
# implementation discipline and the hard "do not commit" guardrail.
if [[ "$MODE" == "fix" ]]; then
  MODE_TAIL='TASK: for each guarantee you DENY that is a real behaviour DEFECT (not mere missing coverage),
IMPLEMENT the fix at the correct layer AND add a COMPOSED full-flow test that fails before your change
and passes after. Match the repo conventions (AGENTS.md, the probe pattern, the surrounding comment
density). Update the relevant docs/050-probes/* with a "validated, attacked, fixed, locked" record per
finding. Run the gates the repo records in AGENTS.md (typecheck, the affected test files, lint) and
report their result. HARD RULES: do NOT git commit and do NOT git push — leave every change in the
working tree for human + driver review. Do NOT weaken or delete an existing test to make something
pass. If a finding is only missing coverage (the flow works), add the test but say so; do not invent
a defect.
OUTPUT: a per-guarantee verdict (UPHELD / DENIED), then exactly what you changed and why, file by file.'
else
  MODE_TAIL='OUTPUT, in two parts.

PART 1 — a per-guarantee VERDICT: UPHELD (attacked, survived) or DENIED (attacked, broke — give the
exact failing flow: inputs -> observed vs expected -> file:line). Then a short prioritised list
separating real defects from mere coverage gaps.

PART 2 — ROOT-CAUSE SYNTHESIS (mandatory; the most valuable part of your report, do not skip it or
compress it to a sentence). Findings reported as a flat list get fixed as a flat list — one guard per
finding — and the guards then accumulate into the next round of gaps. Prevent that:
  (a) CLUSTER the denials by shared MECHANISM. Two findings on different rails, different files, or
      different symptoms may be one defect wearing two costumes. State each cluster and its members
      explicitly. If several denials are genuinely independent, say that too — do not manufacture a
      pattern that is not there.
  (b) For EACH cluster name the root cause and classify it:
        MISSING GUARD  — the model is right, one path forgot to check something. A local fix is correct.
        MISSING FACT   — the code is INFERRING something it could be TOLD (liveness inferred from
                         existence; ordering inferred from arrival; identity inferred from one nullable
                         key). The fix is to carry the fact, at the layer that first has it.
        WRONG MODEL    — the invariant itself is mis-stated, so every guard built on it is load-bearing
                         on a falsehood. The fix is a redesign, and MORE guards will make it worse.
  (c) Name the ONE change that would close each cluster, and say which layer it belongs at (adapter /
      ledger primitive / consumer / surface). Prefer the deepest layer that still fits the guarantee.
  (d) CALL OUT GUARD ACCUMULATION explicitly: if the obvious local fix for a finding would add another
      conditional to a path that already carries several, say so and say what the path is really
      missing. Guard-stacking is the known spiral; you are the check on it.

Be concrete and terse in Part 1; be structural in Part 2. Do NOT modify files.'
fi

# ── Ledger feed mode (loop self-scheduling) ────────────────────────────────────────────────────
# Feeding the reviewer our finding ledger risks ANCHORING: a fed reviewer can satisfice on our
# known classes and under-sample novel ones — and whether that is happening must be MEASURED,
# never remembered. Every 4th gated round therefore runs BLIND (the feed stripped) as a control,
# scheduled BY THIS SCRIPT from the ledger's own Loop-health table — no human keeps the count.
# The discriminator: if blind rounds keep finding what fed rounds stopped finding, the feed is
# anchoring (drop the hunt clause, keep the disclosure rule); if both converge on the same
# shrinking set, the feed is innocent and the classes are genuinely being exhausted.
# --with-ledger / --no-ledger override one run explicitly; close-unit records which mode ran.
# kstack's conventional ledger path. When kstack-init seeds this script into a repo whose
# ledger lives elsewhere, it points this at the actual path.
LEDGER_DOC="docs/070-quality/004-finding-ledger.md"
LEDGER_AUTO=""
if [[ -z "$LEDGER_MODE" ]]; then
  LEDGER_AUTO=1
  if [[ -f "$LEDGER_DOC" ]]; then
    fed_since_blind=$(awk '/mode: .*blind/{n=0; next} /mode: .*fed/{n++} END{print n+0}' "$LEDGER_DOC")
    if [[ "$fed_since_blind" -ge 3 ]]; then LEDGER_MODE="blind"; else LEDGER_MODE="fed"; fi
  else
    LEDGER_MODE="fed" # no ledger in this repo — the feed line degrades to nothing below
  fi
fi
# The feed is SPLIT by position in the prompt (plan-before-feed): the BLIND prohibition must land
# EARLY (before the reviewer starts reading files), while the FED feed must land LATE (after the
# reviewer has recorded its own plan), or the feed frames the search it was only meant to floor.
# The blind arm also withholds the probe's Review manifest (formerly Gate manifest) — its known-class and residue lines are
# ledger content by proxy — and binds every spawned subagent.
LEDGER_EARLY=""
LEDGER_FLOOR=""
SWEEP_LINE=""
if [[ -f "$LEDGER_DOC" ]]; then
  SWEEP_LINE="CONTEXT: the repo's own ledger-driven verification sweep has ALREADY applied every known defect class to this diff before you were invoked (its record is in the unit's probe). Your budget is the certification the sweep cannot give: NOVEL classes, composed-flow depth, and an honest check that the discipline was actually followed. Re-deriving the ledger's known classes is the one way to waste this round."
  if [[ "$LEDGER_MODE" == "blind" ]]; then
    LEDGER_EARLY="CONTROL ROUND: this repo keeps a finding ledger of its known defect classes at ${LEDGER_DOC}. Neither you nor any subagent you spawn may open it this round — it is deliberately withheld so your search is an unanchored control sample (the feed itself is being tested for anchoring). The probe section titled 'Review manifest' is withheld with it (its known-class and residue lines are ledger content by proxy) — take your scope from the diff range and the probe's design sections. Hunt entirely from your own plan; re-denying something the repo registered elsewhere is acceptable this round."
  else
    LEDGER_FLOOR="COMPLETENESS FLOOR — read only NOW, with your own plan already recorded. (1) The ledger, ${LEDGER_DOC}: its lessons are your MINIMUM defect classes (hunt their extensions in the new code), and a finding whose remediation is REGISTERED there or in the probes with a named trigger is a DISCLOSURE to verify honestly stated, not a denial to re-litigate. (2) The unit probe's 'Review manifest' section (where present): unit, base..head, named guarantees, the known-class checks the sweep executed, registered residues with triggers, suite evidence, and the runtime surfaces needing live attack. Use both to verify your plan covers every guarantee — never as your search strategy."
  fi
fi
echo "[external-review] ledger feed: ${LEDGER_MODE}${LEDGER_AUTO:+ (auto — 4th-unit control rule)}"

OUT_DIR="${TMPDIR:-/tmp}/${REPO_NAME}-external-review"
mkdir -p "$OUT_DIR"
STAMP="$(date +%Y%m%d-%H%M%S)"
VERDICT="${OUT_DIR}/verdict-${STAMP}.md"
LOG="${OUT_DIR}/session-${STAMP}.log"

# The coordinator/lanes design: the wall-clock cost of the gate was one serial reviewer
# re-performing every review discipline; the fix is concurrent read-only lanes under ONE coordinator
# holding ONE verdict — never a second gate process. Resource ownership keeps the repo's recorded
# single-process machine constraints intact inside Codex's own parallelism. The block degrades
# gracefully where subagents are unavailable (the lanes run as sequential passes).
read -r -d '' LANES_BLOCK <<'LANES_EOF' || true
PARALLEL LANES: after recording your plan (and reading the floor, where fed), spawn up to three
concurrent READ-ONLY review subagents with isolated, self-contained briefs derived from THIS unit's
diff — where your environment supports spawning subagents; otherwise run the same lanes yourself as
sequential passes. The default lenses:
  L1 JOURNEYS — end-to-end composition and fact reachability: rendered surface / server action ->
     server boundary -> state -> queues -> outcome; crafted requests wherever a UI enforces a rule;
     every fact the diff introduces reaching every consumer that must act on it; what each external
     party was TOLD vs what is true.
  L2 DATA AUTHORITY — the writer inventory (UPDATE, INSERT, and the GRANT surface), row-level
     security and custody doors, constraints and triggers, migration behaviour against live data.
  L3 TEMPORAL / OPERATIONAL — locks and re-qualification at act time, generation fences, retries and
     torn seams, idempotence, queue lifecycle and dead letters, recovery paths, provider truth.
Spawn only the lanes this diff actually implicates — never a lane to fill a slot, and never split
one causal chain across two lanes (composition is the point).
RESOURCE OWNERSHIP (hard rules): YOU, the coordinator, run the repo's full test suite at most ONCE,
and any UI smoke — never a subagent: honour the machine constraints the repo's procedure file
(AGENTS.md) records; single-process suites, shared databases, and fixed-port stacks corrupt under
concurrent runs. At most ONE agent — you, or one designated executor — may mutate the live
database; every other lane returns EXECUTABLE counterexample recipes (exact commands, queries,
crafted requests) for you to run serially. No agent edits files, commits, pushes, or starts another
review run. The suite baseline may run WHILE the read-only lanes inspect code.
Each lane reports, per guarantee examined: the exact path traced; the counterexample (proposed or
executed); expected vs observed; file:line evidence; a verdict (defect / coverage gap / upheld); any
suspected shared mechanism, without implementing a fix. A lane report is a CLAIM — a denial is
invalid until YOU have reproduced it. You own the consolidated verdict: deduplicate across lanes,
reconcile, and synthesize.
LANES_EOF

# The rubric IS the review: attack composed flows, not the green suite; distinguish missing coverage
# from an actual defect; ground-truth DB claims against a live database; verify external facts against
# their source; give ONE consolidated per-guarantee verdict. It speaks the same language as the
# repo's own verification discipline, so the sweep and the gate hold the work to one standard.
read -r -d '' PROMPT <<PROMPT_EOF || true
You are an INDEPENDENT adversarial reviewer and the ROOT CERTIFICATION COORDINATOR for one gated
unit of work. Your job is to DENY this work's claims, not confirm them. Do not trust the green test
suite — attack the implemented flows. This is ONE gate producing ONE consolidated verdict.

SCOPE: audit ${SCOPE}. ${PROBE_HINT}
First read AGENTS.md and the relevant docs/050-probes/* so you audit against the repo's OWN documented
guarantees, which are stricter than "the suite passed". ${LEDGER_EARLY}

INDEPENDENCE FIRST: before reading the finding ledger, any Gate-manifest section, or the rules below,
inspect the scoped diff and the claimed guarantees and RECORD YOUR OWN ATTACK PLAN — your independent
search strategy is the reason you are being run; do not limit yourself to our categories. The rules
are the repo's MINIMUM bar (the floor, not the ceiling): after executing your own plan, verify you
have also covered each of them.

${SWEEP_LINE}

${LEDGER_FLOOR}

${LANES_BLOCK}

RULES (the repo's own audit discipline — hold the work to at least this):
1. Compose the flow, don't just call the verb. For each guarantee, drive it END TO END — rendered
   surface / server action -> server boundary -> state transitions -> operational queues -> lifecycle
   outcome. Where the UI enforces a rule (required / disabled / a caption), a crafted request must be
   re-posted at the server boundary; the UI is NOT the trust boundary. Many new tests call core verbs
   directly while the real browser/server-action flow adds behaviour those tests never exercise —
   check those seams explicitly.
2. Distinguish MISSING COVERAGE from an actual BEHAVIOUR DEFECT. An untested flow that works is a
   coverage gap; an untested flow that is broken is a defect. Reproduce the break before calling it a
   defect.
3. Attack the CLAIMS, not just the code: a promise in a comment / docstring / commit message
   ("clears when scheduled", "idempotent", "admin-only") is a guarantee — find the ones with no
   implementation path.
4. Ground-truth DB claims against a LIVE database (run the query, show the row). Run the full suite
   for a clean baseline, then focus on guarantees the tests never state. Exercise UI wiring for real.
5. Verify EXTERNAL FACTS (third-party fees, API behaviour, rates) against the authoritative source, not
   the commit prose.
6. Run the SEAM CATALOGUE against every guarantee (each class has landed a real defect before):
   (a) enumerate ALL writers of a state — overrides, cancel cascades, webhooks, crons, AND the GRANT
   surface (a table the runtime role can UPDATE **or INSERT** is a writer: a row's BIRTH establishes
   state exactly as an update does, and an UPDATE-only revoke or monitor certifies a narrower
   boundary than the claim) — an invariant enforced at one write path
   is broken at every other; (b) attack torn multi-transaction seams and demand the idempotent retry
   REPAIRS the torn state for EVERY outcome class — and that every fact the provider call used
   (routing / account scope) was DURABLY admitted BEFORE the call so a retry cannot re-derive it
   from a mutated registry; (c) a lock-recheck must re-verify ALL the predicates that qualified the
   candidate — status, lease/claim freshness, age, AND a generation fence — under a row lock at ACT
   time, not only at selection; (d) fallback/special-case/early-dispatch paths must inherit every
   guard of the main path (ceilings, whitelists, flags, rail compares) — diff the guard lists;
   (e) trace results through generic wrappers that can discard them — and an adapter that fills a
   missing or unobservable source with a default (zero, empty) has discarded the FACT OF ABSENCE:
   unavailable is a named state, never a number; (f) one fact, many
   surfaces — grep old AND new values across code, captions, ADRs, probes; (g) two entry points to
   one guarantee must agree on the same input, especially unhappy inputs — and sharing one derived
   FACT is not sharing one POLICY: if each consumer may still choose its own projection of the
   shared fact, the disagreement has only moved into the projection choice; (h) a pre-read snapshot is
   DEAD once the transition's lock is taken — every policy gate AND every side-effect input (a
   session to expire, a flag scope) must be re-derived from the locked row; (i) an untouched form
   control must never post a silent choice (a required select needs a blocking placeholder), and a
   config-readiness gate must check SEMANTIC validity, not just presence; (j) a thin/notification
   event that names a CHANGE is a doorbell, not the resulting state — fetch the resource (never parse
   status from an event-type substring), and any work that must run after ingest is born as named
   handled-work in the queue lifecycle (terminal ignored-before-work is a silent drop).

${MODE_TAIL}
PROMPT_EOF

echo "[external-review] mode: ${MODE}"
echo "[external-review] scope: ${SCOPE}"
echo "[external-review] effort: ${EFFORT:-config default} · fast(priority tier): $([[ $FAST -eq 1 ]] && echo on || echo off)"
echo "[external-review] driving Codex (headless, ~/.codex/config.toml)… this can take a few minutes."
# The two independent per-run knobs: --effort → model_reasoning_effort (depth); --fast →
# service_tier="priority" (inference speed, same model + effort). Empty = the config.toml defaults. The
# expansion below uses the ${arr[@]+...} idiom — macOS ships bash 3.2, where "${arr[@]}" on an EMPTY
# array is an unbound-variable error under `set -u`, and the ":-" workaround would inject an empty
# positional arg that codex would read as the prompt.
EFFORT_ARGS=()
[[ -n "$EFFORT" ]] && EFFORT_ARGS+=(-c "model_reasoning_effort=\"$EFFORT\"")
[[ $FAST -eq 1 ]] && EFFORT_ARGS+=(-c 'service_tier="priority"')
# ENFORCE "never commits" (not just ask): snapshot HEAD before, and if Codex committed anyway, soft-
# reset back so its changes land UNCOMMITTED in the tree for review. A prompt instruction is not a
# guarantee — this makes it one.
HEAD_BEFORE="$(git rev-parse HEAD)"
# -o writes Codex's FINAL message (the verdict) to $VERDICT; full session streams to $LOG.
codex exec --skip-git-repo-check ${EFFORT_ARGS[@]+"${EFFORT_ARGS[@]}"} -o "$VERDICT" - <<<"$PROMPT" >"$LOG" 2>&1 || {
  echo "[external-review] codex exec exited non-zero — see $LOG" >&2
  tail -20 "$LOG" >&2 || true
  exit 1
}
HEAD_AFTER="$(git rev-parse HEAD)"
if [[ "$HEAD_AFTER" != "$HEAD_BEFORE" ]]; then
  echo "[external-review] Codex committed despite the no-commit rule — soft-resetting to ${HEAD_BEFORE:0:8}" >&2
  echo "                  (its changes are preserved UNCOMMITTED for review)." >&2
  git reset --soft "$HEAD_BEFORE"
fi

echo ""
echo "===================== CODEX VERDICT ====================="
cat "$VERDICT"
echo "========================================================"
echo ""
echo "[external-review] verdict: $VERDICT"
echo "[external-review] full session log: $LOG"
