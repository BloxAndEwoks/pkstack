---
name: kstack-init
description: "Install the kstack build discipline into a repo: interview the codebase (existing repo) or the owner (greenfield), then GENERATE the repo's AGENTS.md, docs spine, and finding ledger from kstack's templates — never copying another repo's facts. MANDATORY TRIGGERS: 'kstack init', 'run kstack-init', 'install kstack', 'initialise the build cadence', 'set up the build discipline here'. Do NOT re-run on a repo that already carries a kstack-generated AGENTS.md — maintain that file directly instead."
---

# kstack-init

kstack is a portable build discipline: premortem before building, test-first against failure
classes, simplify after, a ledger-driven verification sweep, a fresh-context non-author review
round, mechanism-first triage, and a self-improvement loop that distills every
round's findings into a finding ledger by Bennett's razor. This skill installs it into ONE repo.
The reasoning behind every rule here lives in kstack's `PHILOSOPHY.md` — read it before the
first init.

## The three-layer law (what this skill may and may not write)

1. **Method is CARRIED.** The loop's skills and templates ship with kstack. This skill never
   rewrites them per-repo; it wires the repo to them.
2. **Instantiation is GENERATED.** AGENTS.md, the docs spine, and the ledger file are written
   HERE, from the templates, filled with THIS repo's facts — discovered from
   its code or asked of its owner. **Never copy another repo's machine constraints, commands,
   ports, or migration mechanics.** A fact you cannot ground in this repo does not go in.
3. **Evidence is EARNED.** The generated ledger starts EMPTY: the mechanism header travels;
   lesson statements do not — from any repo, kstack's origin included. A repo's lessons are
   minted at its own unit closes, from its own findings; until then the verification sweep
   falls back to the generic falsification classes in its own seam catalogue
   (`skills/verify-sweep/references/seam-catalogue.md`; the young-ledger bootstrap in
   PHILOSOPHY.md). A seeded statement would be doctrine wearing no proof,
   anchored to another codebase's failure distribution.

## Step 0 — mode selection and the re-run guard

- If the repo already has an AGENTS.md carrying the kstack loop (or an equivalent procedure
  file), the only legitimate re-run is **GAP-FILL**: walk step 3's FULL generation list (the
  spine manifest, the ledger, the CLAUDE.md pointer), create what is missing, touch NOTHING
  that exists, report what was filled — never a re-init.
  If it has a NON-kstack AGENTS.md/CONTRIBUTING with real content, absorb that content into
  the generated file (its facts are provenance-grade) and say what moved where; never silently
  overwrite.
- Classify the DOCS STATE independently of the code state — it decides how step 3.2 runs:
  **absent** (no `docs/`), **kstack-shaped** (a numbered spine present, wholly or partly), or
  **foreign** (a docs tree in another convention — unnumbered files, an `adr/` dir, RFCs, a
  wiki folder).
- Repo with substantial code → **existing-repo mode** (interview wave first).
- Empty or near-empty repo → **greenfield mode** (owner Q&A + defaults; skip the wave). An
  "empty empty" repo still gets the FULL docs spine — the spine needs no code to exist.

## Step 1 (existing repo) — the interview wave

Fan out parallel READ-ONLY general-purpose agents (never depth-capped search agents), one lane
each. Every claim an agent returns must carry provenance — file:line, a config key, or a command
output. The driver treats each report as a claim and spot-validates before writing it anywhere.

1. **Commands + toolchain** — package manager, build/test/lint/typecheck/run commands, CI
   config, required runtimes. Output: the Commands section, verbatim-runnable.
2. **Test infrastructure** — how the suite runs, what state it shares (one database? containers?
   fixed ports? global fixtures?), parallelism hazards, suite duration. Output: candidate
   machine constraints + the testing-strategy facts.
3. **Data + migrations** — schema tool, migration mechanics, how migrations are applied and
   where, ordering/journal semantics, whether production data exists. Output: migration
   machine-constraints candidates + the "is anything live?" flag for the owner interview.
4. **Risk surfaces** — where money, the lifecycle/state machine, customer- or supplier-facing
   flows, custody (authn/authz/RLS/grants), and migrations live in this codebase, with paths.
   Output: the gated-scope map (what makes a unit GATED here).
5. **Architecture + boundaries** — layering rules, import boundaries, env-var access points,
   existing docs/ADRs/READMEs worth absorbing or pointing at. Output: the boundaries summary +
   the absorption list.

## Step 2 (both modes) — the owner interview

Ask ONLY what the code cannot answer, batched into one round of questions where possible:

- **Deployment reality** — is this deployed? Is there live data? What is the actual mechanism
  for applying migrations to it? (Reason about live data before any schema/invariant work.)
- **Who the users are** — what counts as customer-facing or supplier-facing here; who is the
  merchant of record if money moves.
- **Machine constraints not inferrable from code** — single-process rules, fixed ports, shared
  local services, credentials location, anything a fresh agent would break by not knowing.
- **Commit policy** — author identity, co-author trailer, push policy (kstack default: commit
  per checkpoint, never push; the owner pushes).
Greenfield extras: the stack, the product one-liner, what the first gated surface will be.

## Step 3 — generation (the write step)

From `templates/` in this plugin/repo, generate into the target:

1. **`AGENTS.md`** from `AGENTS.template.md` — fill every `{{PLACEHOLDER}}` from steps 1–2.
   Machine Constraints holds ONLY verified facts, each traceable to a wave report or an owner
   answer; if none exist yet, the section says "none recorded yet — append the first time one
   bites" rather than inventing any. The gated-scope list gets this repo's concrete surfaces
   appended to the generic classes. Unsure whether a scope is gated ⇒ it is gated. The
   default list travels as written. Where the owner NARROWS it (a pre-launch repo with no real
   users, say), record the narrowing in the generated file with a named re-widening trigger
   beside it; a narrowing with no trigger is not recorded.
2. **The docs spine** — governed by one law: **init CREATES, never rewrites**. A file that
   exists is never overwritten, regenerated, or renamed by this skill, whatever its content.
   The spine MANIFEST — the checkable definition of "spine present":
   - `docs/000-index.md` · `docs/001-current-state.md` (from the templates; the index carries
     the BAND MAP — where every future doc kind goes)
   - `docs/030-decisions/` · `docs/040-prds/` · `docs/050-probes/` · `docs/070-quality/`,
     each band seeded with its in-band doc-type template
     (`000-adr-template.md` / `000-prd-template.md` / `000-probe-template.md`, from
     `templates/docs/` — a new ADR/PRD/probe starts as a copy at the band's next number, so a
     fresh repo has the doc conventions before the loop first demands one)
   - `docs/070-quality/004-finding-ledger.md` (from the ledger template)
   Bands outside the manifest (010 product, 020 architecture, 060 operations, 099 archive)
   are DEFINED in the band map but created on first need, never at init.

   By docs state (step 0's classification):
   - **Absent** → generate the full manifest. Greenfield included: `001-current-state.md`
     then honestly records "nothing built yet" rather than waiting for code.
   - **kstack-shaped (whole or partial)** → GAP-FILL: create only the missing manifest
     entries. Numbering continues from the repo's existing numbers — preserve existing
     numbers, never renumber. Where the repo already keeps an EQUIVALENT file under another
     number or path (a finding ledger elsewhere, an index by another name), USE the repo's
     file — create no duplicate — and point the generated AGENTS.md at the actual path.
   - **Foreign** → ABSORB, never convert: leave every existing doc exactly where it is,
     write `000-index.md` as the map OVER what exists (each doc indexed in place; ADR/RFC
     dirs pointed at, not moved), and apply the numbering rule to NEW files only. Renumbering
     or moving existing docs is a separate, owner-approved migration that leaves archive
     pointers — never an init side effect.

   Re-running init on any repo is therefore safe by construction: it can only fill gaps.
3. **`docs/070-quality/004-finding-ledger.md`** from `finding-ledger.template.md` — the
   mechanism header, an empty lesson list, and the empty mechanization-queue and loop-health
   tables. Never pre-populate a lesson.
4. **No gate script.** The external-review gate is unrouted toolbox and stays in the plugin.
   Nothing is seeded into the target repo. A repo that wants the gate names it in its own
   procedure file, and `/external-review` resolves the plugin's own copy when it runs.
5. **`CLAUDE.md`** as a thin pointer: `@AGENTS.md` plus a note that AGENTS.md is the source of
   truth (Claude Code repos; harmless elsewhere).
6. **Skill availability** — if kstack is installed as a Claude Code plugin or its `skills/` are
   copied to `~/.claude/skills/`, the loop's skills already resolve; otherwise note in the
   generated AGENTS.md that the skill files live in the kstack checkout and are followed as
   plain markdown procedure docs.

## Step 4 — the handshake

Close by presenting: what was generated, every fact's provenance (wave lane / owner answer),
the open questions that got a "none recorded yet", and the first-unit recommendation. The FIRST
unit in the repo runs the full loop — its close mints the repo's first ledger lessons, and
it doubles as the acceptance test of this init (a Machine Constraints section that bites, a
Commands section that runs).

The repo's verification skill (`verify-<project>` — the feature map of its consumer-facing
surfaces plus the driver that operates them as a consumer does) is NOT generated at init — it
needs a running product to map, and a hermetic stack to drive it against. It has its own
generator: `/create-verification-skill`, which also defines the hermetic-stack precondition and
the map contract. Register it in the generated AGENTS.md with a named trigger: "first unit that
touches a consumer-facing surface runs /create-verification-skill (building the hermetic launch
first if none exists)".

## What this skill never does

- Never copies facts, constraints, or evidence from another repo — and never seeds the ledger
  with lesson statements, from any source.
- Never overwrites, renames, or renumbers an existing doc — the spine law is create-only;
  converting a foreign docs tree is separate owner-approved migration work.
- Never writes a fact without provenance.
- Never classifies a scope ungated to make a unit lighter — unsure ⇒ gated. A profile narrows
  the default scope list only with a named re-widening trigger recorded beside it.
- Never overwrites an existing procedure file without absorbing and disclosing.
