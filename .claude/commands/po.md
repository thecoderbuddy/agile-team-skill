---
description: Comprehensive product owner review — feature gaps, persona check, backlog health, priorities
---

# /po — Full Product Owner Review

po-agent does a comprehensive product review: gaps, personas, backlog health.

## Steps

1. Read product state:
   ```bash
   cat memory/STATE.md
   sed -n '/^## Index/,/^---$/p' memory/BACKLOG.md   # index only — extract a single story body with awk if a verdict requires it
   ```

2. Note the sprint goal from STATE.md and the backlog priorities from the Index (already read in Step 1).

3. Check what's actually built:
   ```bash
   git log --oneline -20
   ```

4. **po-agent reviews:**
   - Sprint goal — is what's built tracking toward the goal in STATE.md?
   - Feature gaps — what's missing relative to the backlog priorities in the Index?
   - Persona check — would each target user find value in what's built?
   - Backlog health — is the backlog prioritised correctly?
   - Any stories that have been sitting too long without progress?

5. **Update BACKLOG.md** if any stories need re-prioritisation.
   Before writing, show the proposed priority diff (current order → proposed order,
   with one-line reasons) and ask the user to approve (Iron Rule 3). Only write on approval.

## Output Format

```
PRODUCT OWNER REVIEW
═══════════════════════════════════════
SPRINT GOAL: [goal from STATE.md] — [on track / at risk / off track]

FEATURE STATUS
  Built:       [list from git log]
  In Progress: [from STATE.md]
  Missing:     [from backlog Index priorities]

PERSONA CHECK
  [For each relevant persona: would they find value? Y/N + why]

BACKLOG HEALTH
  Total stories: [count]
  Ready (has AC + estimate): [count]
  Needs grooming: [count]

RECOMMENDATIONS
  [po-agent's priority recommendations]
═══════════════════════════════════════
```
