---
description: Sprint close ceremony — pm tallies results, agents sign off, pm marks sprint CLOSED and logs velocity
---

# /sprint-close — Sprint Close Ceremony

Run when all sprint stories are done (or deciding to close with carryover).

**Edge case:** if `memory/STATE.md` has no active sprint (none defined, or already marked
CLOSED) — stop and say so. There is nothing to close.

## Steps

1. Read sprint state:
   ```bash
   cat memory/STATE.md
   sed -n '/^## Index/,/^---$/p' memory/BACKLOG.md   # index only — read a story's full body only if its carry-over disposition needs it
   git log --oneline -20
   ```

2. **pm-agent tallies results:**
   - Stories completed this sprint (with commit hashes from git log)
   - Stories carried over (still in progress per STATE.md)
   - Stories descoped (moved back to backlog)
   - Bugs found during sprint
   - Any blockers that slowed progress

3. **Agent sign-offs:**
   - **dev-agent:** Is the shipped work actually complete — no hidden TODOs, no uncommitted changes?
   - **qa-agent:** All tests passing? Any quality concerns before closing?
   - **po-agent:** Does what shipped match the sprint goal? For each carry-over story, po decides its disposition: back to backlog or straight into next sprint.
   - **tech-lead-agent:** Any tech debt introduced that needs a story?

4. **pm-agent closes the sprint:**
   - Updates `memory/STATE.md` — mark sprint CLOSED, list carried-over stories
   - Updates `memory/BACKLOG.md` per po's per-story disposition from step 3: stories po sent back to backlog move to the top of BACKLOG.md; stories po earmarked for next sprint stay flagged in STATE.md for `/sprint-plan`
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
  dev:      [complete / loose ends noted]
  qa:       [approved / concerns]
  po:       [goal met / partially met]
  tech:     [clean / debt noted]
═══════════════════════════════════════
Run /retro for retrospective, then /sprint-plan for next sprint.
```
