# Next Action
# Owned by: pm-agent (Scrum Master)
# Overwrite this at the end of every session with the single most specific next step.
# Written precisely enough that zero context is needed to continue.

Sprint: 1
Updated: 2026-05-16

## Exact Next Step
Run /new-task to implement STORY-003: Max diff threshold — escalate to human before review.

## Why
STORY-004 is done (committed). STORY-003 is next in execution order (S complexity, Medium priority).
It requires adding a diff size check to Step 0 of .claude/commands/new-task.md and .claude/commands/review.md.
Use `git diff --stat --no-color` for counts. Default threshold: 500 lines or 20 files.
After STORY-003: /new-task for STORY-001 (session continuity — the M complexity flagship).
