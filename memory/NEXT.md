# Next Action
# Owned by: pm-agent (Scrum Master)
# Overwrite this at the end of every session with the single most specific next step.
# Written precisely enough that zero context is needed to continue.

Sprint: 2
Updated: 2026-06-09

Type: CEREMONY
Story: N/A

## Exact Next Step
All 6 Sprint 2 stories are DONE. Run /sprint-close to formally close the sprint.

/sprint-close will:
  1. Read velocity from STATE.md (6/6 — full sprint delivered)
  2. Confirm all committed stories are in "Done This Sprint" — they are
  3. Ask po-agent to confirm no stories need to be carried forward or dropped
  4. Set STATE.md Status from ACTIVE to CLOSED
  5. Write the sprint close summary (goal achieved, velocity, dates)
  6. Reset STATE.md In Progress and Blockers sections for Sprint 3

After /sprint-close, immediately run /retro:
  - Each agent contributes one item per column (went well / improve / action items)
  - pm-agent facilitates
  - po-agent converts action items to BACKLOG.md entries
  - Retro summary is appended to memory/LEARNINGS.md

Do not start Sprint 3 planning until both /sprint-close and /retro are complete.

## Why
Sprint 2 is fully delivered (6/6 stories, 100% velocity). Closing the sprint and running
the retro unblocks Sprint 3 planning and captures process improvements before they are lost.

## Sprint 2 Final Velocity
Stories planned: 6 (5 core + 1 flex)
Stories done: 6
Pace: ON TRACK — full sprint delivered on day 1
Sprint goal: ACHIEVED
