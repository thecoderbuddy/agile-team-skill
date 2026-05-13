# /sprint-close — Sprint Close Ceremony

Run when all sprint tasks are done (or deciding to close with carryover).

## Steps

1. Read sprint state:
   ```bash
   cat memory/STATE.md
   cat memory/BACKLOG.md
   git log --oneline -20
   ```

2. **Tally results:**
   - Tasks completed this sprint (with commit hashes from git log)
   - Tasks carried over (still in progress per STATE.md)
   - Tasks descoped (moved back to backlog)
   - Bugs found during sprint
   - Any blockers that slowed progress

3. **Agent sign-offs:**
   - qa-agent: All tests passing? Any quality concerns?
   - po-agent: Does what shipped match the sprint goal?
   - tech-lead-agent: Any tech debt introduced?

4. **Update memory files:**
   - STATE.md — mark sprint as SPRINT_CLOSING, list carried-over tasks
   - BACKLOG.md — move carried-over stories back to top of backlog
   - LEARNINGS.md — append any lessons from this sprint

5. Show sprint summary:

```
SPRINT [N] — CLOSED
═══════════════════════════════════════
Goal:        [sprint goal]
Completed:   [X] tasks
Carried:     [Y] tasks
Descoped:    [Z] tasks

SHIPPED
  - TASK-XXX: [desc] — [hash]
  ...

CARRIED OVER
  - TASK-XXX: [desc] — [reason]

TECH DEBT INTRODUCED
  - [any shortcuts taken]

QUALITY
  - Tests: [pass/fail count]
  - Bugs found: [count]
═══════════════════════════════════════
Run /retro for retrospective, then /sprint-plan for next sprint.
```
