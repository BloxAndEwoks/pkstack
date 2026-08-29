# pkstack

pstack's body, kstack's nervous system.

A standalone fork merging [pstack](https://github.com/cursor/plugins/tree/main/pstack)
(Lauren Tan, MIT — vendored as a subtree with full history) with kstack's build discipline.
poteto-mode's router and playbooks carry the work; kstack's finding ledger, Bennett's-razor
lessons, the instantiated-lessons map, the verification sweep, and the close-unit
self-improvement loop run through them natively — wired at the playbooks' own chokepoints,
ledger-blind wherever sampling happens.

## Install (Claude Code)

```bash
claude plugin marketplace add /path/to/pkstack
claude plugin install pkstack@pkstack --scope project
```

Then `/setup-pstack` once to write the per-role model override, and `/kstack-init` in a repo
that has no docs spine yet.

## The shape

- **Vertical rigor per finding** (pstack, untouched where it's right): reproduce, confirm the
  mechanism with runtime evidence, smallest fix the evidence justifies, prove it on the real
  surface.
- **Horizontal discipline across findings** (kstack): findings arrive mechanism-clustered,
  are looked up against the repo's ledger, and close-unit forks every recurrence — promote
  the medium or weaken the statement, never a new narrower guard.
- **One ledger per repo, pkstack included.** Working repos queue plugin-level lesson exports;
  they mint here, at this repo's own maintenance closes, with `repo:probe` provenance.

`PATCHES.md` is the permanent register of every edit to a vendored file — the complete
merge-conflict forecast for upstream refreshes. `docs/decisions/001-build-plan.md` records
the ratified design.

## Attribution

The vendored half is pstack 0.14.5 by [Lauren Tan](https://github.com/cursor/plugins)
(MIT — see `LICENSE`), imported with full history via `git subtree split`. The build
discipline descends from kstack (same author as this fork). This repository as a whole is
MIT.
