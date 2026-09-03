# Probe 003 — panel independence is fresh contexts, not roles (registered follow-up, 2026-09-03)

**Unit.** The Claude Code dispatch sweep (2e8bd6e, b966f20, e4eb705, 213fe09), which retargeted
every review panel from a four-vendor list to Claude models the Agent tool can actually
dispatch: three `opus` seats and one `sonnet` in architect's runners, arena's runners, how's
critics, and interrogate's reviewer table.

**Registered follow-up.** Each of those panels now carries the sentence "Model diversity across
providers is not available in Claude Code; the panel's independence comes from its roles and
fresh contexts." The second half of that sentence is true today and the first half is not:
arena states outright that every candidate receives the same prompt ("the prompt is the
contract"), how fills one `references/critic-prompt.md` for every critic, and interrogate sends
the same filled `references/reviewer-prompt.md` to Reviewer A through D. So what actually
separates the seats right now is a fresh context and independent sampling, nothing else, and
with the vendor spread gone that is a real reduction in the variance these rounds were built to
buy. The follow-up is per-seat role prompts, one differentiated lens per seat in arena's runner
brief, how's critic prompt, and interrogate's reviewer prompt, so the claim the panels make
about themselves becomes the mechanism they run on. **Trigger:** the next time a panel round
returns near-identical findings across its seats, or the next maintenance unit that touches any
of those three prompt files, whichever comes first.
