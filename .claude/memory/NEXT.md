# Next Action
# Owned by: pm-agent (Scrum Master)
# Overwrite this at the end of every session with the single most specific next step.
# Written precisely enough that zero context is needed to continue.

Sprint: 3 (stale — 76+ days past end date; close after step 1 below)
Updated: 2026-08-31

Type: VERIFICATION
Story: PROCESS-001

## Exact Next Step
Run /security-review. This clears two blockers at once: the PROCESS-001 sprint
gate AND the 83-day-overdue cadence flag (threshold: 30 days). Record results in
STATE.md ## Last Security Review and LEARNINGS.md per the standard flow.

## Then
1. /sprint-close — Sprint 3 is stale; carry STORY-019, STORY-018, BUG-007+008
2. /sprint-plan — apply the new debt-budget rule + estimation conversion table;
   candidates: carried stories + STORY-034/035/036 (High) from the roster review

## Done this session (context)
ROSTER-EXPANSION reviewed (2 cycles, APPROVED) and committed as b1e7ff3.
Follow-ups tracked: STORY-034..040, BUG-024.
Uncommitted unrelated changes still in tree: .claude/settings.json, .gitignore,
.claude/memory/RISKS.md, office/, assets/characters/, .claude/hooks/office-event.sh —
user's separate work, do not touch.

## Why
No sprint story may start until PROCESS-001 clears, and the security review is
the single action that unblocks everything downstream.
