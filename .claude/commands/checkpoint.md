# /checkpoint — Save All State Before Stopping

Run before ending a session, before a break, or when context is getting large.
Saves everything so /resume can restore perfectly.

## Steps

1. Read current state to understand what's in flight:
   ```bash
   cat memory/STATE.md
   ```

2. Check for uncommitted work:
   ```bash
   git status
   git diff --stat
   ```

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
────────────────
Safe to stop. Run /resume to continue.
```
