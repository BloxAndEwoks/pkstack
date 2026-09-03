# NNN — <feature name>

<!-- Seeded by kstack-init. To write a PRD: copy this file to the band's next number
     (`docs/040-prds/NNN-<slug>.md`), fill every section, delete the comments. A PRD precedes
     substantial product or feature work; it states WHAT and WHY — the probe (050) owns the
     failure analysis and the build record. -->

Date: YYYY-MM-DD · Status: draft | ratified | built | superseded

## Problem — and why now

<!-- The user/business problem in the consumers' terms, and what makes it worth building now. -->

## Users and journeys

<!-- The personas touched and the consumer surfaces they meet (UI, API, CLI, token links,
     outbound messages). Where a verification skill exists, name the feature-map files these
     journeys live in. -->

## Scope

<!-- In and OUT — the out-list is the part that prevents scope creep. Deferred slices get a
     named trigger, never a vague "later". -->

## Requirements

<!-- Behavioral and observable — each one testable as stated. Unhappy paths and absence
     states are requirements, not footnotes. -->

## Gated-scope classification

<!-- Classify against the gated scope in the repo's procedure file (AGENTS.md) — the default
     list is money rails, the lifecycle/state machine, customer- or supplier-facing flows,
     custody, or a migration, and a profile may have narrowed it with a named re-widening
     trigger. Classify per the profile's gated scope; unsure means gated within it. This line
     decides whether the unit takes a non-author review round over its whole diff before the
     PR opens. -->

## New facts (facts-before-verbs preview)

<!-- For each fact this feature introduces: occurrence-or-state · writer set · requiredness
     per boundary · intended enforcement tier. The probe's design-package table refines this. -->

## Open questions

<!-- Each with an owner and what unblocks it. -->
