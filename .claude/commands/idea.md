# /idea — Turn a Rough Idea Into Backlog Tasks

Usage: `/idea [describe the idea]`

Arguments: $ARGUMENTS

Takes a raw idea and runs it through the product pipeline: evaluate, decompose, prioritise.

## Steps

1. Read current state for context:
   ```bash
   cat memory/STATE.md
   cat memory/DECISIONS.md
   ```

2. **po-agent evaluates the idea:**
   - Does this align with the current phase?
   - Which persona benefits?
   - What's the user story? (As a [persona], I want [action], so that [benefit])
   - Priority relative to current backlog?

3. **tech-lead-agent assesses feasibility:**
   - Technical complexity (S/M/L/XL)
   - Dependencies on existing code
   - Any architectural decisions needed? (DEC-XXX)
   - Fits within project tech stack?

4. **security-analyst-agent checks constraints:**
   - Does it introduce any security surface?
   - Any data privacy implications?

5. **Decompose into tasks** (if approved):
   - Break into TASK-XXX items
   - Define acceptance criteria
   - Estimate complexity

6. Show the evaluation:

```
IDEA EVALUATION
═══════════════════════════════════════
Idea:     [the idea]
Verdict:  [APPROVED / DEFERRED / REJECTED]
Persona:  [who benefits]
Priority: [critical/high/medium/low]
Phase:    [which phase it fits in]

USER STORY
  As a [persona], I want [action], so that [benefit].

TASKS (if approved)
  - TASK-XXX: [title] — [agent] — [S/M/L]
  ...

CONCERNS
  [any risks or dependencies]
═══════════════════════════════════════
```

7. If approved, ask: "Add these tasks to the backlog? [Y/N]"
