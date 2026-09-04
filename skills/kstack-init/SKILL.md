---
name: kstack-init
description: "Install the kstack build discipline into a repo: interview the codebase (existing repo) or the owner (greenfield), then GENERATE the repo's AGENTS.md, docs spine, and finding ledger from kstack's templates — never copying another repo's facts. MANDATORY TRIGGERS: 'kstack init', 'run kstack-init', 'install kstack', 'initialise the build flow', 'set up the build discipline here', 'kstack refresh', 'refresh AGENTS.md', 'bring AGENTS.md up to the current template'. Do NOT re-run on a repo that already carries a kstack-generated AGENTS.md outside GAP-FILL or REFRESH (Step 0) — maintain that file directly instead."
---

# kstack-init

kstack is a portable build discipline: premortem before building, test-first against failure
classes, simplify after, a ledger-driven verification sweep, a non-author verifier on every PR,
mechanism-first triage, and a self-improvement loop that distills every round's findings into a
finding ledger by Bennett's razor. This skill installs it into ONE repo.
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
   minted at its own unit closes, from its own findings; until then the sweep's executors hunt
   from their own plan over the diff, independence first, and the ledger fills from what lands.
   A seeded statement would be doctrine wearing no proof, anchored to another codebase's failure
   distribution, and a generic catalogue is such a seed.

## Step 0 — mode selection and the re-run guard

- If the repo already has an AGENTS.md carrying the kstack loop (or an equivalent procedure
  file), the legitimate re-runs are **GAP-FILL** and **REFRESH** — never a blind re-init.
  **GAP-FILL**: walk step 3's FULL generation list (the spine manifest, the ledger, the
  CLAUDE.md pointer), create what is missing, touch NOTHING that exists, report what was
  filled.
  **REFRESH**: the existing AGENTS.md's PROCEDURE has drifted from the current
  `templates/AGENTS.template.md` (a renamed step, a retired section, a section the template
  now requires that the old file never had) while the repo's own facts stayed current — see
  "REFRESH mode" below for detection, section ownership, and the procedure, and "The DOCS PASS"
  for the living documents AGENTS.md routes agents into. Run REFRESH's detection before assuming
  it is needed; a file that passes all three checks — the third being the sentence-level sync —
  skips straight to GAP-FILL.
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

## REFRESH mode

The maintenance path for a repo whose kstack-generated AGENTS.md predates the current
`templates/AGENTS.template.md` — the PROCEDURE drifted (a vocabulary rename, a retired section,
a section the template now requires) while the repo's own facts stayed current. REFRESH
regenerates the procedure only. It never touches the repo's own facts, existing numbering, or
the finding ledger, and it never rewrites elsewhere under `docs/` — the one exception is the
relocation pointer below, and it is named explicitly in the Never list at the end of this
section.

**Triggers.** 'kstack refresh', 'refresh AGENTS.md', 'bring AGENTS.md up to the current
template'.

**Detection — two greps, then a sentence-level diff.** An AGENTS.md is STALE when any of the
three checks below finds something. Empty greps are not a stop: a file can pass both and still
lack sentences the template ADDED since that file was written, which no grep for a retired word
can see. Both greps empty means proceed to check 3; stop only when THAT finds no difference, and
then report the file current.

1. Missing a plugin-owned procedure heading:
   ```bash
   for h in "## Build principles" "## Units and the PR" \
            "## Mechanism first, reachability second" \
            "## Checkpoint review and the PR verifier" "## The close" \
            "## Tests before implementation" "## Proportionality"; do
     grep -qF "$h" AGENTS.md || echo "missing: $h"
   done
   ```
   A section relocated per the template's relocation form (its heading present, its body the
   one-line `Lives in `<path>`; that file carries the current text.` pointer) counts as
   present — the heading string is still in AGENTS.md, so `grep -qF` above already passes on
   it; no separate carve-out needed in this check. Run a second grep to see which sections are
   relocated and where, so the driver knows which repo docs REFRESH will regenerate into:
   ```bash
   grep -nE '^Lives in `[^`]+`; that file carries the current text\.$' AGENTS.md
   ```
2. Carries a retired heading or a retired word:
   ```bash
   grep -inE 'Units in this repository|Gated scope\.|Registration\.|Cross-model round\.|The close is procedural|cadence|gate record|re-gate|step 4a|step 4b|step 5b' AGENTS.md
   ```
3. Missing what the template ADDED — a diff BY MEANING, read, not grepped. For every PLUGIN row
   of the ownership table below, read that section in `templates/AGENTS.template.md` against the
   repo's, sentence by sentence: a template sentence whose MEANING appears nowhere in the repo's
   section is a miss, and one miss makes the file stale. This is the procedure's step 3 run as a
   check — when it finds nothing, the procedure has nothing left to do.

**Section ownership.** Every heading in the current template is either regenerated from the
template (PLUGIN) or carried over from the old file verbatim (REPO):

**No content is discarded.** A sentence inside a plugin-owned section that states a REPO FACT —
a path, a service, a tool, a person's act, a capability the repo lacks today, anything the
template's text does not contain — is repo-owned wherever it sits. REFRESH carries it forward
verbatim as a trailing paragraph under the regenerated section (under the synced text, for a
relocated section), and the report names every such carry, old section → new location. A
sentence the driver cannot place under its own section lands under the nearest regenerated
section instead, named in the report the same way. Nothing in the old file is lost.

**Who wins on a contradiction.** A regenerated plugin-owned section and a carried repo-owned
sentence can end up stating opposite things — the template's PR flow against a repo bullet
saying this repo ships by commit with no PRs. The plugin's text wins for PROCEDURE, what an
agent is to DO; the repo's wins for a FACT, what is true here. Neither is silently dropped: the
contradiction is named in the report with both sentences quoted, for the owner to settle.

| Template section | Owner | REFRESH action |
|---|---|---|
| Intro's first sentence naming the flow | Repo | Carry verbatim |
| Intro's remaining sentences | Plugin | Regenerate — any repo-fact sentence among them carries per the rule above |
| Read first (the ledger's actual path travels here) | Repo | Carry verbatim — except an entry describing a document as "doctrine" or "procedure", rewritten per the DOCS PASS's Read-first rule |
| Build principles (+ Core doctrine) | Plugin | Regenerate in AGENTS.md — unless behind a relocation pointer, see the relocation row below |
| Units and the PR | Plugin | Regenerate |
| Mechanism first, reachability second | Plugin | Regenerate |
| Checkpoint review and the PR verifier | Plugin | Regenerate |
| The close | Plugin | Regenerate |
| Consumer verification — the Step 1 / Step 5 seat sentences | Plugin | Regenerate |
| Consumer verification — `{{UI_VERIFICATION}}` (skill name, path, launch) | Repo | Carry verbatim |
| Tests before implementation | Plugin | Regenerate |
| Proportionality | Plugin | Regenerate |
| Machine constraints (a retired "Gated scope" paragraph's paths and irreplaceable-artifact facts land here — the heading is retired, the facts are not) | Repo | Carry verbatim |
| Commands | Repo | Carry verbatim |
| Commits — procedural sentences | Plugin | Regenerate |
| Commits — `{{COMMIT_RULES}}` (repo-specific commit/push law) | Repo | Carry verbatim |
| Documentation discipline — generic bullets | Plugin | Regenerate |
| Documentation discipline — repo-specific bullets, and any repo-specific law with a stated reason | Repo | Carry verbatim |
| Repo-fact sentences inside any plugin-owned section | Repo | Carry verbatim as a trailing paragraph under that section |
| Any plugin-owned section behind a relocation pointer | Plugin | AGENTS.md keeps only the pointer line; the plugin-owned text is synced inside the file the pointer names. The rule is stated once, in the DOCS PASS's RELOCATED PLUGIN SECTION class — follow it there. |

**Procedure.**
1. Read the current `templates/AGENTS.template.md` and the repo's existing AGENTS.md side by
   side.
2. Align heading text to the template's exactly. A repo's own heading wording — "## Units and
   the pull request" for "## Units and the PR," bold-paragraph subsections in place of the
   template's own "##" headings — is a STALE SIGNAL, not a repo-owned fact: rename it, then
   carry its content per the ownership table above.
3. Every regenerate — inside a relocated file or directly in AGENTS.md — syncs the template's
   wording to the repo BY MEANING, sentence by sentence, applying the repo's own spelling
   convention (UK/US), emphasis, wrapping, and punctuation rather than the template's, so a
   sentence that already carries the template's meaning in the repo's own style gets no edit at
   all.
4. For each PLUGIN row, apply step 3's sync to the current template's text, cross-references
   (the Feature playbook, `/close-unit`) included — then check the OLD section's text for a
   repo-fact sentence (rule above) and carry it forward as a trailing paragraph; never let
   regeneration discard it.
5. For each REPO row, copy the old file's text for that section into the new placeholder
   verbatim. Where the new template needs a fact the old file never had, ask the owner for that
   one fact — no re-interview.
6. For each section behind a relocation pointer, apply step 3's sync inside the file the
   pointer names, same commit; leave that file's own repo-specific sentences and sections
   alone, and leave AGENTS.md's pointer line as its only content for that heading. A file where
   every sentence's meaning already matches gets no edit — say so in the report.
7. Never invent a machine constraint. A fact absent from the old file and un-askable stays
   absent, flagged exactly as init leaves it: "none recorded yet — append the first time one
   bites."
8. Keep the repo's existing numbering, paths, and doc-spine references untouched.
9. Run the **DOCS PASS** below, in the same commit — after this regeneration, before GAP-FILL.
   A refreshed AGENTS.md that still routes agents into a document carrying the retired flow has
   moved the headings and left the law in force.
10. Produce the result as a diff over the existing AGENTS.md and every file the DOCS PASS
    touched, for the owner to read, plus the report the DOCS PASS specifies in (h): every
    repo-fact sentence carried per the rule above (old section → new location), and for each
    relocated file, exactly what changed and what needed no edit — never a silent rewrite.
11. Land it as one PR on a branch, through the router's Opening a PR playbook: the file is the
    unit, and a non-author verifier reads the diff before it merges.
12. Run **GAP-FILL** afterwards, in the same sitting — a refreshed procedure can still be
    missing a spine file the old AGENTS.md never named.

**Never**: rewrite anything under `docs/` outside the DOCS PASS's scope, renumber an existing
doc, discard a repo-fact sentence found inside a plugin-owned section, rewrite a probe, an ADR
or PRD body, or the ledger's lessons, evidence and loop-health rows, or treat REFRESH as licence
to re-interview the repo — it reads the old file's facts, it does not re-derive them.

## The DOCS PASS

Runs inside REFRESH, after the AGENTS.md regeneration and before GAP-FILL, in the same commit.

AGENTS.md is half the refresh. The retired flow survives in the documents AGENTS.md routes
agents INTO — a quality-band file the Read-first list calls "doctrine", a current-state block
stating the old registration rule in the present tense — and an agent that reads one obeys it.
This pass makes the template's law true in the repo: **build procedure lives in exactly two
places, the plugin's playbooks and skills, and AGENTS.md.** Every other document carries facts,
decisions, evidence, measurements, or pointers. The law is about LOCATION, so the pass cuts a
correct statement of today's build procedure outside those two places just as it cuts a retired
one — a second copy is right only until the first changes. Procedure that is not BUILD procedure
— a runbook, a release checklist — is not this law's business at all.

**a. Scope — the living documents, by path AND range.** A path in scope is not wholly in scope.
Each carries the range this pass may touch, and a hit outside its file's range is not this
pass's hit:

| In scope | The range |
|---|---|
| every path AGENTS.md's Read-first list names | the Read-first ENTRY that names it — its one-line description of what that document carries. The document's own body enters scope only where a row below puts it there. |
| `docs/000-index.md` | the whole file, its dated anchors excepted |
| `docs/001-current-state.md` | the present-tense block only |
| the quality band (`docs/070-quality/` or the repo's equivalent) | every file in it, minus the dated reports and session extracts it holds |
| the finding ledger | its header and mechanism prose only |
| the roadmap where one exists | the whole file |
| the generated `verify-<project>` skill | its seat sentences, plus any sentence anywhere in it that INSTRUCTS — see (f); its product facts never |
| `CLAUDE.md` | the whole file |

Out of scope, history by definition: probes; the founder-decision log's dated entries; ADR and
PRD bodies (their Read-first ENTRIES are in scope, their bodies never); the archive band; the
ledger's lessons, extensions, evidence, queues, and loop-health rows; any dated report or
session extract, wherever it sits. Each is a record of what was done under the process of its
day, and it is never edited to match today's.

**b. Detection — run it as a grep, don't eyeball it.** Over the in-scope FILES only, and inside
(a)'s range for each:

```bash
# The scope, one FILE per line — never a directory. A directory re-collects the ranges (a)
# excluded (a session extract in the quality band, the ledger's evidence) and buys hundreds of
# forced classifications. Expand the quality band by hand, minus its dated reports; add every
# Read-first path, the roadmap, and .claude/skills/verify-*/SKILL.md.
# (An array, not a string — zsh does not word-split an unquoted variable.)
scope=(docs/000-index.md docs/001-current-state.md CLAUDE.md \
       docs/070-quality/001-testing-strategy.md docs/070-quality/004-finding-ledger.md)
# 1. retired vocabulary
grep -inE 'cadence|gate record|re-gate|step [45][ab]\b|gated unit|ungated|external certification|adversarial.audit|ships by commit|registers at BASE|the close is procedural|two-round cap' "${scope[@]}"
# 2. procedure in the present tense, outside the two allowed places
grep -inE '^ *[0-9]+\. |round|gate|certif|verdict|register|close-unit' "${scope[@]}"
```

Grep 2 over-fires by design: it is a reading list, not a verdict. Read each hit and ask whether
the sentence tells an agent WHAT TO DO — a step, a round, a gate, a verdict rule — or records a
fact. A numbered list whose items are build steps is a hit however it is worded. A hit falling
outside its file's (a) range — a line in current-state's dated history, a passage in the
ledger's evidence — is dropped unread.

**Classify every hit into exactly one of seven classes.** A hit nobody can classify is not done.

| Class | What it is | Action |
|---|---|---|
| RELOCATED PLUGIN SECTION | the body of a plugin-owned AGENTS.md section, living at the path a relocation pointer names (the one-line pointer form: *Lives in `<path>`; that file carries the current text.*) | AGENTS.md keeps only the pointer line. Regenerate BY MEANING inside that file, same commit: sync the template section's STATEMENT SET — every statement it makes — in whatever SHAPE that file already holds it (bullets, numbered evidence sections, running prose), in the repo's own house style (UK/US spelling, emphasis convention, wrapping, punctuation), edited only where the meaning actually differs. Never reshape the file to the template's structure. A statement whose meaning already stands gets no edit; a file where none differ gets no edit at all. That file's OTHER sentences are not covered by this class — they are classified on their own by the six rows below. This is the only text outside AGENTS.md that may carry plugin procedure, because it IS AGENTS.md's text at another path. The report lists what changed and what stayed. |
| RETIRED PROCEDURE | build procedure stated in the present tense anywhere but the two allowed places. The test is LOCATION, not vintage: a correct statement of TODAY's flow outside the plugin's playbooks and skills and AGENTS.md is a second source, and it drifts the day the first changes. Steps, rounds, gates, and verdict rules from the flow this refresh retired are the common case, not the definition. | Cut, per (c). |
| REPO FACT inside a procedure passage | a path, a measurement, a probe number, a decision, a capability the repo lacks — a fact the retired wording was merely carrying | Carry it BEFORE the cut to where it belongs: a constraint to AGENTS.md's Machine constraints, evidence to its lesson in the ledger, a decision to the decision log, a plain fact to the doc's own facts section. Named in the report, old location → new. A cut never loses a fact. |
| OTHER PROCEDURE | steps that are not BUILD procedure — a runbook, a release checklist, an ops ceremony, a drive or data recipe. How to OPERATE the thing, not how to change it. | Leave. The two-places law governs build procedure only, and a runbook is where its own steps belong. |
| TEMPLATE TEXT | plugin-owned prose this pass itself wrote or synced — the ledger's regenerated header and mechanism prose, a relocated section's body. It says "round", "gate", and "verdict" because the template says them. | Leave, and name it in (i)'s residue list. Re-cutting the pass's own output is the loop this row exists to break. |
| HISTORY | a dated record of what was done, decided, or measured | Leave it. Add the supersession line — ONE dated line immediately above the passage, `Superseded by AGENTS.md's "<section>" (<date>).` — ONLY where the passage would otherwise read as a CURRENT instruction, and only where a named AGENTS.md section actually supersedes it. In a block that is nothing but dated, self-marked entries (an index's dated anchors, current-state's history blockquotes) the line is noise: the entries announce themselves. Where nothing in AGENTS.md supersedes the record — a stale test baseline, an old measurement — the line would be false, so it is not written. Never delete the record and never restate it in today's words. |
| PSTACK'S OWN WORD | "cadence" in its rhythm sense; "gate", "register" or "round" as a word of the repo's own domain; a vendor tool the repo still runs, named in a fact — Codex in a machine constraint, an adversarial-audit script the repo ships | Leave, and name it in (i)'s residue list so the next refresh does not re-litigate it. |

**c. The cut.** A RETIRED PROCEDURE passage in a living doc is replaced by exactly one line
naming the AGENTS.md section that now owns it. **The heading survives**, and only the BODY
becomes the pointer line, so an existing citation of that section — by number or by name — still
lands somewhere:

> ### 4. The close
>
> The close: AGENTS.md's "The close". This section carried the pre-2026-09-03 cadence;
> superseded 2026-09-03.

Where the cut passage stated TODAY's procedure correctly, the line says what actually happened —
*The close: AGENTS.md's "The close". Procedure lives there; this copy was a second source, cut
2026-09-03.* — because nothing was superseded, only de-duplicated.

**Archive by size, not by count.** A cut PASSAGE — a section, a paragraph, a numbered list —
moves to the archive band. A single word or a clause whose meaning SURVIVES in the replacement
("the gated unit's probe" → "the unit's probe") is not archived: the replacement sentence carries
it, and a file per word buries the band and the reader with it.

The removed passages are not lost. They move to the archive band (`docs/099-archive/` or the
repo's equivalent) as ONE dated file per source document, at the band's next number and named so
a reader hunting the old flow finds it (`NNN-<source-slug>-retired-procedure-YYYY-MM-DD.md`),
with a header naming the source path, the date, and the AGENTS.md section that supersedes it.
Never rewrite a probe, an ADR or PRD body, or the ledger's lessons — they are out of scope and
the cut never reaches them.

**The Read-first list.** Repo-owned and carried verbatim, with one exception, applied AFTER the
cut: an entry describing a document as "doctrine" or "procedure" is rewritten to describe what
that document now carries — facts, evidence, measurements, decisions — never as a second source
of procedure. It may point at a relocated plugin-owned section by that section's pointer. It may
not present any repo document as the place an agent learns the steps.

**d. current-state.** `docs/001-current-state.md`'s present-tense block gets ONE paragraph
stating the flow in the router's words, naming the plugin's version and the date: "The build
process is pkstack poteto-mode (pkstack <version>, refreshed <date>): work enters through the
`/poteto-mode` router, the matched playbook's steps carry the work, and `AGENTS.md` is the
repository profile." It REPLACES every sentence in that block that states the retired procedure
— a registration rule, a review-round count, a ships-by-commit-not-PR clause. Those replaced
sentences are a RETIRED PROCEDURE passage like any other: archive them per (c) BEFORE the
paragraph is written, or the replacement is a silent delete. The dated history entries below the
block stay exactly as written; they are HISTORY.

**e. The finding ledger.** Its header and mechanism prose are regenerated BY MEANING from
`templates/finding-ledger.template.md`, the same sentence-by-sentence sync a relocated section
gets. The lessons, their extensions and evidence, the mechanization and export queues, and every
loop-health ROW are untouched. What the sync writes is TEMPLATE TEXT from the moment it lands:
(i) does not re-cut the pass's own output.

The loop-health `mode:` FORMAT line is updated to the verifier form — `mode: <verifier model
id>·<fed|blind>`, and `mode: self` where a close ran with no verifier verdict — without editing
a single existing row. **Unless repo CODE enforces the format the template would change**: a
test pinning the `mode:` tokens, a script counting `·fed` rows to schedule the blind control.
Then the format line records the TARGET form and a named trigger — "target form `mode: <model
id>·<fed|blind>`; moves when the loop-health parser next changes" — and the enforced format is
left exactly as it stands. A docs pass that edits a format a code assert reads breaks the repo
from a documentation commit; the medium moves in a CODE unit that changes the test, the script,
and this line together.

**Structure is not added.** A template section the repo's ledger has no equivalent of — `## The
export queue` in a ledger that keeps export entries inside the mechanization queue — is not
created by this pass. The sync is sentence-level over the prose that EXISTS. A missing section
is registered in the report with a named trigger, and it lands when a unit needs it.

**Polarity is not backfilled.** Where the template's lesson entry form has gained a field the
repo's standing lessons predate — **Polarity** is the current one — the form's description is
synced and the existing entries are left under-specified. Each takes its field at the next
`/close-unit` that touches it, from the person holding its evidence. This pass never infers a
lesson's polarity.

**f. The verify-`<project>` skill.** A generated skill whose `SKILL.md` still carries the
"Cadence seat" heading, or seat sentences from the retired flow, has that heading and those
sentences rewritten per `skills/create-verification-skill/SKILL.md`'s current "Where the skill
sits" output.

The feature map is split by INSTRUCTS versus RECORDS, not by file. Its product FACTS — surfaces,
journeys, selectors, expected behaviour — are not touched: only MAINTAIN writes them. A dated
RECORD inside the map (a last-verified stamp, an observed-behaviour note) is HISTORY, left for
MAINTAIN too and named in the residue. But a sentence in the map or its README that INSTRUCTS —
a build-procedure pointer, a step from the retired flow, a rule about how to change the code —
is classified like any other hit and cut per (c). Product facts are the map's; build procedure
is never the map's, wherever inside it the sentence sits.

**g. The decision log.** The repo's founder-decision log or equivalent gets ONE entry recording
the refresh — or one line under the latest entry where the repo keeps that convention: files
cut, files archived, the plugin version, the date. Same commit.

A repo that keeps NO decision log records the refresh in its own convention instead — a dated
paragraph in `docs/001-current-state.md`'s history, a line in a changelog, whatever that repo
already uses to date its own changes. Never mint a decision log, or a docs band to hold one, as
a side effect of this pass: a repo gains a decision log when its owner decides it wants one.

**h. The report.** A table, not a narrative. One row per passage: `file:line · class · action ·
destination`, where class is one of the seven above and action is cut / carried / archived /
regenerated / left / registered. A REGISTER gets its own row with the trigger named in the
destination cell: a ledger section the pass did not create, a format left standing because code
enforces it, a contradiction between a plugin section and a repo fact. The owner reads a diff
and a table.

**i. Re-run the detection.** Run (b)'s greps over the scope again at the end. The pass is done
when every hit IN THE (a) SCOPE — inside its file's range; a hit outside it was never this
pass's — is HISTORY, PSTACK'S OWN WORD, OTHER PROCEDURE, or TEMPLATE TEXT, and each one is named
in the report with its class. Those four are the whole admissible residue. Anything else still
standing means the pass is not done.

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
   Output: the risk-surface map, with paths, for the profile's machine constraints and for the
   premortem's failure classes.
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
Greenfield extras: the stack, the product one-liner, what the first consumer-facing surface will
be.

## Step 3 — generation (the write step)

From `templates/` in this plugin/repo, generate into the target:

1. **`AGENTS.md`** from `AGENTS.template.md` — fill every `{{PLACEHOLDER}}` from steps 1–2.
   Machine Constraints holds ONLY verified facts, each traceable to a wave report or an owner
   answer; if none exist yet, the section says "none recorded yet — append the first time one
   bites" rather than inventing any. The risk-surface map from wave lane 4 lands as this repo's
   concrete paths inside Machine constraints and the Read-first list, never as a rule that
   lightens a unit.
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
- Never overwrites an existing procedure file without absorbing and disclosing.
- Never leaves build procedure in a generated doc. The docs carry facts, decisions, evidence,
  measurements, and pointers; AGENTS.md and the plugin's playbooks and skills carry the steps.
