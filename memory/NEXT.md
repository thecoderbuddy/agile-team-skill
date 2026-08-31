# Next Action
# Owned by: pm-agent (Scrum Master)
# Overwrite this at the end of every session with the single most specific next step.
# Written precisely enough that zero context is needed to continue.

Sprint: 3 (stale — 76 days past end date; close after step 2 below)
Updated: 2026-08-31

Type: VERIFICATION
Story: N/A (out-of-plan ROSTER-EXPANSION)

## Exact Next Step
Resume the paused /review of the ROSTER-EXPANSION change set: answer the
diff-size prompt (team recommends "continue"), run the full chain
(qa → pr-reviewer → security → tech-lead → po), fix any FIX NOW items, commit.
Scope: 6 modified agent files, 12 modified command files, 6 new agent files,
CLAUDE.md, install.sh, memory/TEAM.md. EXCLUDE pre-existing unrelated changes:
.claude/settings.json, .gitignore, memory/RISKS.md, office/, assets/characters/,
.claude/hooks/office-event.sh.

## Then
1. /security-review — clears PROCESS-001 gate AND the 83-day overdue flag
2. /sprint-close — Sprint 3 is stale; carry STORY-019, STORY-018, BUG-007+008
3. /sprint-plan — apply the new debt-budget rule and estimation conversion table

## Why
An unreviewed, uncommitted ~660-line change to the team's own process files is
the biggest current risk — every ceremony run before it's reviewed executes
unreviewed instructions.
