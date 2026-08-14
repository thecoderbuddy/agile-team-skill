---
description: End-of-session save — write NEXT.md and STATE.md, then show a session summary
---

# /done — End of Session Save + Summary

Run when you're stopping for the day. Saves everything and shows a summary.

## Steps

1. Check for uncommitted work:
   ```bash
   git status
   ```
   If there are uncommitted changes, warn before proceeding.
   Note: the commit decision happens in Step 6 — after the memory files are updated
   in Steps 3-4 — so memory updates are included in the commit.

2. Read current state and check for a live chain checkpoint:
   ```bash
   cat memory/STATE.md
   git log --oneline -10
   cat memory/CHECKPOINT.md 2>/dev/null
   ```
   If `memory/CHECKPOINT.md` exists, surface it — do NOT delete it:
   > "A chain checkpoint exists (Command: X, Story/Bug: Y) — /resume will pick this up next session."

3. **Overwrite NEXT.md** with the EXACT next action — written so precisely that zero context is needed to continue.

4. **Update STATE.md** with end-of-session snapshot.

5. Show end-of-day summary:

```
SESSION COMPLETE
═══════════════════════════════════════
COMPLETED THIS SESSION
  - [list of tasks completed — from git log]

UNCOMMITTED CHANGES
  [count or "none — all committed"]

NEXT SESSION STARTS WITH
  [exact content of NEXT.md]
═══════════════════════════════════════
```

6. If there are uncommitted changes, ask:
   > "There are uncommitted changes. Should I commit them before ending?"
