---
description: Lightweight triage of a rough idea — evaluate, decompose into stories, prioritise, backlog
argument-hint: [describe the idea]
---

# /idea — Turn a Rough Idea Into Backlog Stories

Usage: `/idea [describe the idea]`

Arguments: $ARGUMENTS

Takes a raw idea and runs it through the product pipeline: evaluate, decompose, prioritise.

> Not sure which command? `/idea` = lightweight triage of a rough idea; `/discover` = deep structured discovery before writing stories.

## Steps

1. Read current state for context:
   ```bash
   cat .claude/memory/STATE.md
   cat .claude/memory/DECISIONS.md
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

5. **Decompose into stories** (if approved):
   - Break into STORY-XXX items
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

STORIES (if approved)
  - STORY-XXX: [title] — [agent] — [S/M/L]
  ...

CONCERNS
  [any risks or dependencies]
═══════════════════════════════════════
```

7. If approved, ask: "Add these stories to the backlog? [Y/N]"

8. **On [Y], write to .claude/memory/BACKLOG.md:**
   - Read the `## Index` to find the highest existing STORY number; new stories
     take the next numbers.
   - Append each story below the Index in the standard story format (title,
     priority, user story, acceptance criteria, complexity).
   - Add one line per new story to the `## Index` so it stays in sync.
   - Confirm: "Added STORY-XXX..STORY-YYY to BACKLOG.md."
