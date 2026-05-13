# /health-check — Mid-Sprint Check

Are we on track? Should we descope? Run at sprint midpoint.

## Steps

1. Read sprint state:
   ```bash
   cat memory/STATE.md
   cat memory/BACKLOG.md
   git log --oneline -10
   ```

2. **pm-agent assesses:**
   - Tasks completed vs planned (compare git log against STATE.md sprint goal)
   - Velocity: on track / behind / ahead
   - Any task stalled more than 2 days?
   - Scope: still achievable? Need to descope?

3. **Risk check:**
   - Any task taking longer than estimated?
   - Any new blockers since sprint start?
   - Any dependencies at risk?

4. Show health check:

```
SPRINT HEALTH CHECK
═══════════════════════════════════════
Sprint:    [N]
Midpoint:  [date]

VELOCITY
  Planned: [X] tasks
  Done:    [Y] tasks (from git log)
  Status:  [on track / behind / ahead]

STALLED
  [tasks with no commits in 2+ days]

AT RISK
  [tasks that might not make it]

DESCOPE CANDIDATES
  [tasks to drop if behind — with justification]

RECOMMENDATION
  [continue as-is / descope X / extend sprint]
═══════════════════════════════════════
```
