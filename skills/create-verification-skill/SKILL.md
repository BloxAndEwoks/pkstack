---
name: create-verification-skill
description: "Generate a repo's verification skill (verify-<project>): the feature map of every consumer-facing surface plus the driver that operates the product the way its consumer does — browser UI, public API, CLI, magic-link/token surfaces, outbound messages — against a hermetic stack, with replayable evidence. Creation ends with a live proof: a skill never executed is a draft. Maintenance is NOT a separate skill — every generated skill carries its own MAINTAIN mode. MANDATORY TRIGGERS: 'create the verification skill', 'build the feature map', 'generate verify-<project>', 'set up product verification'. Do NOT trigger to RUN an existing verification skill — invoke that skill directly."
---

# create-verification-skill

The verification tower ends one layer short of the consumer: unit and composed tests cross the
server boundary, the sweep falsifies code classes, the external gate reads, a smoke proves
surfaces render — but none of them *operates* the rendered product and hands back evidence a
human can replay. This skill generates the per-repo skill that closes that layer: a maintained
**feature map** of how a consumer reaches and drives every consumer-facing surface, plus the
**driver** discipline for proving behavior through those surfaces.

**Scope is every consumer surface, not just the browser:** rendered UI, public HTTP APIs, CLIs,
token/magic-link surfaces, outbound messages (email/SMS — driven as the recipient), and
webhooks partners consume. The generated skill drives whichever of these the product has, each
with the driver that operates it the way its consumer does (a browser driver for UI, a plain
HTTP client for APIs, a shell for CLIs, the rendered message for email).

## Precondition — the hermetic stack (refuse without it)

The generated skill drives a DISPOSABLE, PRODUCTION-ISOLATED instance: one launch command that
builds, boots a throwaway data store, migrates from zero, seeds deterministic fixtures and
logins, stands in for external services deterministically, and parks. If the repo has no such
launch, BUILD IT FIRST as its own unit — a verification skill pointed at production, a real
`.env`, or a shared mutable environment is refused, not accommodated. Two facts to record with
the launch: whether the stack is a machine-wide singleton (fixed ports, shared build dirs), and
what the one allowed mock is (the deterministic external-service stand-in — everything below it
must be real).

## The creation procedure

1. **Surface inventory.** Enumerate the consumer-facing surfaces and their personas (operator,
   customer, partner-on-a-token, message recipient …). The repo's AGENTS.md gated-scope map and
   its routing/entry points are the sources. Every surface gets a feature-map file; absence
   from the map must be a decision, never an oversight.
2. **The source wave.** One READ-ONLY executor per surface, all concurrent. Each returns:
   sub-features INCLUDING designed-empty/absence states and what is deliberately not present;
   consumer-POV routes (URL/navigation/role gates/redirects, or request shapes for an API);
   real selectors or request recipes with the OBSERVABLE that proves each action; gotchas with
   seeded-state ground truth; and one live recipe — all with file:line citations. Readers never
   drive and never edit; the driver (the main session) owns all judgment and all driving.
3. **Write the feature map** under the generated skill's `features/`:
   - A README carrying: the baseline preconditions every file assumes (launch state, fixture
     credentials, seeded coverage vs deliberate out-of-scope probes, the side-effect-read
     helper); the **four-H2 contract**; the **proof and skip rules**; and an index table
     (file · surface · personas).
   - One file per surface, carrying EXACTLY the four H2s: **Sub-features** · **How to get to
     it (consumer POV)** · **Driving it** (real selectors — roles/labels/documented test ids,
     never CSS classes or coordinates — or concrete request recipes, each with its observable)
     · **Gotchas**. Feature files never repeat the launch/doctor/evidence text — one home.
   - The seed is a starting point, not a constant: recipes assert against patterns, not
     literal counts, unless the file marks a number stable.
4. **Write the control skill** (`SKILL.md` of the generated skill) — the contract below, with
   this repo's concrete commands filled in.
5. **The live proof — a skill never executed is a draft.** Close creation by driving one
   journey with NOVEL coverage (a surface or unhappy path nothing else exercises) end to end,
   capturing full evidence. What the proof teaches — copy traps, wrong working models, dead
   recipes, missing tools — is fed back into the map IN THE SAME SITTING. A map written purely
   from source reading always contains at least one confident falsehood; the proof is where it
   dies.
6. **Record and register.** The creation is a unit: record it as a probe, including a
   facts-before-verbs row for the map itself (it is a new fact: writer = the generated skill's
   MAINTAIN mode only; required at = every step-6 drive and every EXPERIENCE pass; enforcement
   tier = procedure, with the written reason that the map is prose about a moving product —
   its verification medium is execution, not the compiler). Seat the skill in the repo's
   AGENTS.md steps 1 and 6.

## The generated skill's contract (every verify-<project> carries all of this)

**Hard rules, stated before anything else:**
- Hermetic launch ONLY — name the one command; name what must NEVER be run (any launch that
  can reach production data).
- Singleton discipline where the stack is one: doctor before driving; an already-parked
  instance is USED, and your residue cleaned — never the instance killed; never launch beside
  the repo's other single-process machine constraints.
- Neutral register in all prose and subagent prompts: verify, falsify, counterexample,
  reachable, refuse.
- The surface is never the trust boundary: a proof composes surface → action → state → side
  effects. A rendered success with no side-effect read is not a proof.
- Product breaks are reported, never papered: a map/product disagreement is either map drift
  (fix the map, MAINTAIN mode) or a product gap (report into the cadence's triage step) — it
  never becomes a map edit to match the breakage.
- Edit scope = the skill's own directory. Never product code, never the procedure file.

**Sections:** `Launch` (the command, readiness check, fixture credentials, teardown — kill
what YOU started, by pid) · `Doctor` (read-only checks, run before the first drive and after
every surprise; a dead stack you did not start is reported, never "repaired") · `Drive` (the
per-surface drivers; sessions minted once per serve; existing e2e specs as the floor; ad-hoc
drives as scratch specs through the skill's own config) · `Evidence` · `Cleanup` (evidence
stays, always; scratch dies; residue on a shared serve dies).

**Evidence standards:** every drive writes replayable artifacts to the skill's own gitignored
`artifacts/<run-name>/` — trace + video unconditionally for browser drives, full
request/response transcripts for API drives, terminal transcripts for CLI drives. Runs are
NAMED: a driver that wipes its output dir per run eats the previous run's evidence unless each
run names itself. Artifacts SURVIVE cleanup — a cleanup that eats the proof failed.

**Proof standards** (a drive without these is a visit, not a proof): the real consumer path,
never internal setters or test-only endpoints; the action AND the resulting state (the
observable the feature file names); a side-effect read per mutation; and a SECOND VIEW —
reopen the fact from another surface.

**Three modes:**
- **VERIFY** (default): prove one feature or unhappy path — pick the feature file, run its
  recipe or a scratch variant, capture evidence, report proved/refused with artifact paths.
- **EXPERIENCE**: the directional consumer-experience crawl — light on code, heavy on
  judgment. Pick a persona and a journey, drive it END TO END (outbound messages included —
  judge them as the recipient), and judge every screen against the product's OWN design
  principles (named in the generated skill from the repo's design canon as it accrues).
  Findings are written as triage input (cluster → guard/fact/model), never applied as ad-hoc
  patches. EXPERIENCE passes schedule as their own ungated units.
- **MAINTAIN** — the skill keeps itself honest (run when a unit's close finds map drift, or
  on demand): (1) index hygiene — README index vs the globbed files; (2) a read-only source
  wave, one reader per feature file, returning likely drift with citations; (3) reconcile —
  spot-check cited drift, sweep recent churn for unmapped consumer surfaces (a concrete
  source path required before calling one missing); (4) a MANDATORY live pass even when
  source looks clean — the driver drives every mapped feature at least once, serially, on one
  parked stack; `verified-unreachable` is legitimate ONLY with the concrete prerequisite
  named and the route attempted recorded — an omitted prerequisite is drift; (5) triage:
  wrong consumer-POV description → fix the map; working product + dead recipe → fix the
  recipe and RE-DRIVE it before it ships; broken product → product gap, reported, kept out of
  the map change; (6) one commit of proven corrections, or an honest clean/blocked report.

**Cadence seat** (written into the generated skill AND the repo's AGENTS.md): two seats, both
scoped to the TOUCHED surfaces — before designing (step 1: read the touched feature files,
plus a live look where genuinely informative) and after building (step 6: any repo-level
smoke first, then drive the unit's changed mapped features). The skill is never a per-unit
regression walk of the whole map — only MAINTAIN walks everything. Findings always flow to
the cadence's triage; lessons mint at `/close-unit`, never inside the skill.

## Why maintenance is not a separate skill

The map's only writer is its own MAINTAIN mode, and the maintain procedure lives inside the
generated skill — one home, so the procedure and the thing it maintains cannot drift apart,
and any environment that can run the skill can maintain it. Running THIS generator on a repo
that already has its verification skill is a re-seed, not maintenance — refuse and point at
the existing skill's MAINTAIN mode instead.
