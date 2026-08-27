# kstack

A portable build discipline, earned in production round by round and distilled into a tool.
One command — `/kstack-init` — installs it into a repo by **generating** that repo's own
procedure file, docs spine, and finding ledger. Nothing is ever copied between repos — kstack
is self-contained, and so is every repo it initializes. The reasoning behind every rule lives
in `PHILOSOPHY.md`.

## The shape of the discipline

Per unit of work (a unit = the body of work answering one named goal, one to five commits):

1. **Premortem** before building — assume it shipped and failed, work backward; cluster the
   scenarios into classes; a facts-before-verbs row per new fact.
2. **Build test-first** against those classes.
3. **Simplify** after building — four lenses: reuse, simplification, efficiency, altitude.
4. **Verify, then certify** — 4a: a ledger-driven verification sweep on EVERY unit; 4b: an
   independent external model certifies gated units (money, lifecycle, customer-facing,
   custody, migrations — unsure ⇒ gated).
5. **Triage before remediating** — cluster by mechanism; missing GUARD / missing FACT / wrong
   MODEL; fix the class, never one guard per finding.
5b. **Close the unit** — distill the round's findings into the finding ledger by Bennett's
   razor (the weakest statement still sufficient); promote enforcement media; the loop
   self-checks for anchoring.
6. **Drive the changed user-facing behavior** as a user experiences it.
7. **Commit** as the system of record.

## The three-layer law

- **Method is carried.** The skills and templates in this repo are project-agnostic and travel
  as-is.
- **Instantiation is generated.** A repo's AGENTS.md — its commands, machine constraints, gated
  scopes — is written by `/kstack-init` from *that repo's* discovered facts, never copied from
  another repo.
- **Evidence is earned.** The generated finding ledger ships EMPTY — kstack carries the
  mechanism (the razor, the regeneration forks, the media ranking); a repo's lessons are minted
  at its own unit closes, from its own findings, and are never seeded from another repo. Until
  lessons exist, the sweep falls back to `/adversarial-audit`'s generic falsification classes
  (the young-ledger bootstrap in `PHILOSOPHY.md`).

## Layout

```
PHILOSOPHY.md         why every rule is the way it is — read this first
skills/
  kstack-init/        the installer: interview wave → owner Q&A → generate
  premortem/          step 1 — prospective-hindsight failure hunt (engineering mode included)
  simplify/           step 3 — the four cleanup lenses (self-contained; no harness built-in needed)
  verify-sweep/       step 4a — the ledger-driven per-unit verification sweep
  external-review/    step 4b — the independent Codex gate (SKILL.md + external-review.sh)
  close-unit/         step 5b — the self-improvement close (razor, forks, loop self-check)
  adversarial-audit/  the generic falsification catalogue — the sweep's floor while the
                      ledger is young, and standalone verification for non-kstack repos
templates/
  AGENTS.template.md            the procedure file kstack-init fills per-repo
  finding-ledger.template.md    the ledger mechanism — ships with an EMPTY lesson list
  docs/                         docs-spine skeletons (000-index, 001-current-state)
```

## Installing

**As a Claude Code plugin:** add this repo as a plugin (skills resolve as `/kstack:<name>`,
e.g. `/kstack:kstack-init`).

**As user-level skills:** copy `skills/*` into `~/.claude/skills/` (skills resolve as
`/<name>`, e.g. `/kstack-init`).

**In non-Claude-Code environments** (Cursor, Codex, any agent that reads markdown): the skills
are plain markdown procedures — point the agent at `skills/<name>/SKILL.md` and it follows the
steps directly. `skills/simplify/SKILL.md` is deliberately self-contained for exactly this
case (in Claude Code it shadows a built-in; elsewhere it IS the pass). The generated AGENTS.md
in the target repo is the universal entry point — Cursor and Codex read it natively.

The external gate needs the Codex CLI installed and logged in (`brew install codex`,
`codex login`). Where it is unavailable, `/kstack-init` records the gap in the generated
AGENTS.md rather than letting it be silently skipped.

## Quick start

```
cd your-repo
/kstack-init          # (or /kstack:kstack-init as a plugin)
```

On an existing repo it runs a read-only interview wave over the codebase, asks the owner only
what code cannot answer, then generates `AGENTS.md`, `docs/`, the finding ledger, and
`scripts/external-review.sh`. On a greenfield repo it is a short Q&A plus defaults. The first
real unit you build is the init's acceptance test — and its close mints the repo's first
ledger lessons.
