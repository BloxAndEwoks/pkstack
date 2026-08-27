---
name: kstack-init
description: "Install the kstack build discipline into a repo: interview the codebase (existing repo) or the owner (greenfield), then GENERATE the repo's AGENTS.md, docs spine, finding ledger, and review-gate script from kstack's templates — never copying another repo's facts. MANDATORY TRIGGERS: 'kstack init', 'run kstack-init', 'install kstack', 'initialise the build cadence', 'set up the build discipline here'. Do NOT re-run on a repo that already carries a kstack-generated AGENTS.md — maintain that file directly instead."
---

# kstack-init

kstack is a portable build discipline: premortem before building, test-first against failure
classes, simplify after, a ledger-driven verification sweep, an independent external gate on
high-value surfaces, mechanism-first triage, and a self-improvement loop that distills every
round's findings into a finding ledger by Bennett's razor. This skill installs it into ONE repo.

## The three-layer law (what this skill may and may not write)

1. **Method is CARRIED.** The cadence skills and templates ship with kstack. This skill never
   rewrites them per-repo; it wires the repo to them.
2. **Instantiation is GENERATED.** AGENTS.md, the docs spine, the ledger file, and the gate
   script are written HERE, from the templates, filled with THIS repo's facts — discovered from
   its code or asked of its owner. **Never copy another repo's machine constraints, commands,
   ports, or migration mechanics.** A fact you cannot ground in this repo does not go in.
3. **Evidence is EARNED.** The generated ledger imports lesson STATEMENTS with empty extensions,
   explicitly marked as imported. Authority accrues locally, at this repo's own unit closes.
   Copying another repo's evidence would be doctrine wearing someone else's proof.

## Step 0 — mode selection and the re-run guard

- If the repo already has an AGENTS.md carrying the kstack cadence (or an equivalent procedure
  file), STOP and say so — maintenance is an edit to that file, not a re-init. If it has a
  NON-kstack AGENTS.md/CONTRIBUTING with real content, absorb that content into the generated
  file (its facts are provenance-grade) and say what moved where; never silently overwrite.
- Repo with substantial code → **existing-repo mode** (interview wave first).
- Empty or near-empty repo → **greenfield mode** (owner Q&A + defaults; skip the wave).

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
- **External gate availability** — is the Codex CLI installed and logged in? If not, record in
  the generated AGENTS.md that step 4b is UNAVAILABLE and every gated unit's close must say so —
  the gap is disclosed, never silently skipped.

Greenfield extras: the stack, the product one-liner, what the first gated surface will be.

## Step 3 — generation (the write step)

From `templates/` in this plugin/repo, generate into the target:

1. **`AGENTS.md`** from `AGENTS.template.md` — fill every `{{PLACEHOLDER}}` from steps 1–2.
   Machine Constraints holds ONLY verified facts, each traceable to a wave report or an owner
   answer; if none exist yet, the section says "none recorded yet — append the first time one
   bites" rather than inventing any. The gated-scope list gets this repo's concrete surfaces
   appended to the generic classes. Unsure whether a scope is gated ⇒ it is gated.
2. **The docs spine** — `docs/000-index.md`, `docs/001-current-state.md` (from the templates),
   plus empty `docs/030-decisions/`, `docs/040-prds/`, `docs/050-probes/`, `docs/070-quality/`.
   All leaf docs carry the three-digit sortable prefix.
3. **`docs/070-quality/004-finding-ledger.md`** from `finding-ledger.template.md` — the
   mechanism header plus the imported starter lessons, extensions empty and marked imported.
4. **`scripts/external-review.sh`** seeded from this plugin's
   `skills/external-review/external-review.sh`, committed to the target repo (skip only if the
   owner declined the gate; record the gap per step 2).
5. **`CLAUDE.md`** as a thin pointer: `@AGENTS.md` plus a note that AGENTS.md is the source of
   truth (Claude Code repos; harmless elsewhere).
6. **Skill availability** — if kstack is installed as a Claude Code plugin or its `skills/` are
   copied to `~/.claude/skills/`, the cadence skills already resolve; otherwise note in the
   generated AGENTS.md that the skill files live in the kstack checkout and are followed as
   plain markdown procedure docs.

## Step 4 — the handshake

Close by presenting: what was generated, every fact's provenance (wave lane / owner answer),
the open questions that got a "none recorded yet", and the first-unit recommendation. The FIRST
unit in the repo runs the full cadence — its close is where the imported ledger earns its first
local members, and it doubles as the acceptance test of this init (a Machine Constraints section
that bites, a Commands section that runs).

A UI-verification skill (a `verify-<project>` feature map + driver, on the pattern of the origin
repo's verify skill) is NOT generated at init — it needs a rendered product to map. Register it
in the generated AGENTS.md with a named trigger: "first unit that touches a rendered UI".

## What this skill never does

- Never copies facts, constraints, or evidence from another repo (including the one kstack was
  extracted from).
- Never writes a fact without provenance.
- Never classifies a scope ungated to make a unit lighter — unsure ⇒ gated.
- Never overwrites an existing procedure file without absorbing and disclosing.
