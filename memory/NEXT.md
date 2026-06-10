# Next Action
# Owned by: pm-agent (Scrum Master)
# Overwrite this at the end of every session with the single most specific next step.
# Written precisely enough that zero context is needed to continue.

Sprint: 2
Updated: 2026-06-09

Type: CEREMONY
Story: STORY-007

## Exact Next Step
Run /new-task to implement STORY-007: Security review scheduling — track last scan date
and prompt when overdue. This is the final story in Sprint 2.

po-agent selects STORY-007. tech-lead specs the two touch points:
  1. /security-review command — write "Last security review: [date]" to STATE.md on completion
     and append a one-line summary to LEARNINGS.md (date + finding counts by severity).
  2. /standup security-analyst-agent step — read STATE.md "Last security review:" field;
     flag as overdue if >30 days old, or flag "never run" if field is absent.
Threshold (30 days) must be documented in CLAUDE.md as configurable.
Complexity: S.

## Why
STORY-006 was approved and closed (5/6 sprint stories done). STORY-007 is the only
remaining story. Completing it closes Sprint 2 and unblocks /sprint-close + /retro.

## Sprint 2 Remaining (execution order)
6. STORY-007: Security review scheduling (S) — last story — START HERE
