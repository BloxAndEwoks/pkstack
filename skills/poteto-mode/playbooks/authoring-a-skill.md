### Authoring or modifying a skill

**You own the skill's voice.** Agent-facing prose has a higher bar than human prose; unhelpful sentences become instructions.

1. Draft the `SKILL.md` here: frontmatter first (`name`, then a `description` naming the triggers that should route to it), then the body as steps an agent executes, not prose about the topic.
2. Validate the skill: frontmatter has `name` and `description`, referenced files exist, cross-skill links resolve. If its outputs include findings, verdicts, or a synthesis, it also declares their shape (location, severity, mechanism) and their consumer, the **close-unit** skill, the decision record, or neither. Most skills produce none of those and skip the field.
3. Test cases if structural; skip if subjective.
4. Run **Opening a PR**.

When in doubt, delete; prose earns its keep by changing a decision. Tell it to do the thing and skip the reason. Explain only when the rule is confusing without one. Match tone to scope. Point at structural sources (types, READMEs, config); hardcoded details go stale (the **encode-lessons-in-structure** principle skill). Delegate to other skills by path; don't restate. A workflow you keep hitting but isn't captured → propose a new skill.

**Reply:** summary of the skill, key design decisions, validation notes.
