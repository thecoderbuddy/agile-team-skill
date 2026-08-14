---
description: Save all session state (NEXT.md, STATE.md) before stopping so /resume can restore perfectly
---

# /checkpoint — Save All State Before Stopping

Run before ending a session, before a break, or when context is getting large.
Saves everything so /resume can restore perfectly.

Note: `/checkpoint` (this session-save command) and `memory/CHECKPOINT.md` (the chain
recovery file written by /bug, /review, /new-task) are unrelated — see the Checkpoint
Protocol section in CLAUDE.md.

## Steps

1. Read current state to understand what's in flight:
   ```bash
   cat memory/STATE.md
   ```

2. Check for uncommitted work and a live chain checkpoint:
   ```bash
   git status
   git diff --stat
   cat memory/CHECKPOINT.md 2>/dev/null
   ```
   If `memory/CHECKPOINT.md` exists, surface it — do NOT delete it:
   > "A chain checkpoint exists (Command: X, Story/Bug: Y) — /resume will pick this up next session."

3. **Overwrite NEXT.md** with the EXACT next action. Be so specific that zero context is needed to continue:
   - What file to open
   - What function to write/edit
   - What the expected outcome is
   - Any decisions already made

4. **Update STATE.md** — reflect current phase, sprint, and what's in progress.

5. Show confirmation:

```
CHECKPOINT SAVED
────────────────
NEXT.md:     [first line of what was written]
STATE.md:    updated
Uncommitted: [file count or "none"]
Chain:       [live CHECKPOINT.md — Command + Story/Bug, or "none"]
────────────────
Safe to stop. Run /resume to continue.
```
