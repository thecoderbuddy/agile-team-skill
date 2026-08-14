---
description: Mid-sprint health check — velocity, stalled stories, quality risk, descope recommendation
---

# /health-check — Mid-Sprint Check

Are we on track? Should we descope? Run at sprint midpoint.

## Steps

1. Read sprint state:
   ```bash
   cat memory/STATE.md
   sed -n '/^## Index/,/^---$/p' memory/BACKLOG.md   # index only
   git log --oneline -10
   ```

2. **pm-agent assesses velocity:**
   - Stories completed vs planned (compare git log against STATE.md)
   - Velocity: on track / behind / ahead
   - Stalled stories — use observable signals only: a story is stalled if it is
     IN_PROGRESS in STATE.md with no STATE.md change and no commits since it started
     (`git log --since="[start date]"` if STATE.md records a start date; if no start
     date is recorded, flag as "cannot determine — ask dev")
   - Scope: still achievable this sprint?

3. **po-agent assesses value delivery:**
   - Is the sprint goal still on track to be met?
   - If behind: which stories to descope (lowest value, highest effort)?
   - Any priority shifts needed based on what's been built?

4. **qa-agent reports quality health:**
   - Any known test failures on in-progress stories?
   - Any acceptance criteria that have been quietly dropped?
   - Quality risk if we rush to close?

5. Show health check:

```
SPRINT HEALTH CHECK
═══════════════════════════════════════
Sprint:    [N]
Midpoint:  [date]

VELOCITY
  Planned: [X] stories
  Done:    [Y] stories
  Status:  [on track / behind / ahead]

STALLED
  [IN_PROGRESS stories with no STATE.md change and no commits since start, "cannot determine — ask dev", or "none"]

QUALITY
  [qa-agent findings or "clean"]

AT RISK
  [stories that might not make it]

DESCOPE CANDIDATES
  [po-agent recommendation: stories to drop if behind]

RECOMMENDATION
  [continue as-is / descope X / extend sprint]
═══════════════════════════════════════
```

Based on recommendation:
- On track → Continue with `/new-task` or `/standup`.
- Behind, stories to descope → Run `/backlog` to reprioritize and move stories out of sprint.
- Story stalled / blocked → Run `/unblock STORY-XXX` to clear the blocker.
- Behind but no descope → Alert in next `/standup`, flag sprint goal as AT RISK.
