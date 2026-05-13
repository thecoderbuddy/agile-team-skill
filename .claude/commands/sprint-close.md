# /sprint-close — Sprint Close Ceremony

Run when all sprint stories are done (or deciding to close with carryover).

## Steps

1. Read sprint state:
   ```bash
   cat memory/STATE.md
   cat memory/BACKLOG.md
   git log --oneline -20
   ```

2. **Tally results:**
   - Stories completed this sprint (with commit hashes from git log)
   - Stories carried over (still in progress per STATE.md)
   - Stories descoped (moved back to backlog)
   - Bugs found during sprint
   - Any blockers that slowed progress

3. **Agent sign-offs:**
   - **qa-agent:** All tests passing? Any quality concerns before closing?
   - **po-agent:** Does what shipped match the sprint goal? Carry-overs: back to backlog or next sprint?
   - **tech-lead-agent:** Any tech debt introduced that needs a story?

4. **pm-agent closes the sprint:**
   - Updates `memory/STATE.md` — mark sprint CLOSED, list carried-over stories
   - Updates `memory/BACKLOG.md` — move carried-over stories back to top
   - Appends velocity and lessons to `memory/LEARNINGS.md`
   - Writes `memory/NEXT.md` → `/retro` then `/sprint-plan`

5. Show sprint summary:

```
SPRINT [N] — CLOSED
═══════════════════════════════════════
Goal:        [sprint goal]
Completed:   [X] stories
Carried:     [Y] stories
Descoped:    [Z] stories

SHIPPED
  - STORY-XXX: [desc] — [commit hash]
  ...

CARRIED OVER
  - STORY-XXX: [desc] — [reason]

TECH DEBT INTRODUCED
  - [any shortcuts taken — or "none"]

QUALITY
  - Tests: [pass/fail]
  - Bugs found: [count]

SIGN-OFFS
  qa:       [approved / concerns]
  po:       [goal met / partially met]
  tech:     [clean / debt noted]
═══════════════════════════════════════
Run /retro for retrospective, then /sprint-plan for next sprint.
```
