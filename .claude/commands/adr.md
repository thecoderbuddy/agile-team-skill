---
description: Draft, review, and record an Architecture Decision Record (DEC-XXX) in DECISIONS.md
argument-hint: [decision topic]
---

# /adr — Write an Architecture Decision Record

Usage: `/adr [decision topic]`

Arguments: $ARGUMENTS

Creates a new DEC-XXX entry in DECISIONS.md. Used when architectural choices need to be documented.

## Steps

1. Get the next DEC number (do not cat the full file):
   ```bash
   grep -o 'DEC-[0-9]*' .claude/memory/DECISIONS.md | sort -V | tail -1
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
   - Append to .claude/memory/DECISIONS.md
   - If this decision replaces an earlier one, mark the old entry by appending a status
     line to it: `Status: SUPERSEDED by DEC-XXX` — do not delete or edit its content.

6. If the reviewers reject the decision:
   - Still append the entry to .claude/memory/DECISIONS.md with `Status: REJECTED` and the
     reason for rejection. Rejected decisions are knowledge too — they prevent the
     same debate from being re-run later.
