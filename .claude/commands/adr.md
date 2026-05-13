# /adr — Write an Architecture Decision Record

Usage: `/adr [decision topic]`

Arguments: $ARGUMENTS

Creates a new DEC-XXX entry in DECISIONS.md. Used when architectural choices need to be documented.

## Steps

1. Read existing decisions to get next DEC number:
   ```bash
   cat memory/DECISIONS.md
   ```

2. **tech-lead-agent drafts the ADR:**

   Format:
   ```
   ### DEC-XXX: [Title]
   **Date:** [today]
   **Status:** proposed / accepted / superseded
   **Context:** [What is the problem or situation?]
   **Decision:** [What was decided?]
   **Consequences:** [What are the trade-offs?]
   **Alternatives considered:** [What else was evaluated and why rejected?]
   ```

3. **Agent review:**
   - po-agent: Does this serve the product and users?
   - security-analyst-agent: Any security implications?
   - qa-agent: Does this affect testability?

4. Present the ADR for approval:

```
ARCHITECTURE DECISION RECORD
═══════════════════════════════════════
DEC-XXX: [title]

Context:      [the problem]
Decision:     [what we're deciding]
Consequences: [trade-offs]
Alternatives: [what else we considered]

Agent consensus: [agreed/split — details]
═══════════════════════════════════════
Approve this decision? [Y/N]
```

5. If approved:
   - Append to memory/DECISIONS.md
