# /health-check — Mid-Sprint Check

Are we on track? Should we descope? Run at sprint midpoint.

## Steps

1. Read sprint state:
   ```bash
   cat memory/STATE.md
   cat memory/BACKLOG.md
   git log --oneline -10
   ```

2. **pm-agent assesses velocity:**
   - Stories completed vs planned (compare git log against STATE.md)
   - Velocity: on track / behind / ahead
   - Any story stalled more than 2 days with no commits?
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
  [stories with no commits in 2+ days or "none"]

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
