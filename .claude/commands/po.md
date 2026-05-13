# /po — Full Product Owner Review

po-agent does a comprehensive product review: gaps, personas, backlog health.

## Steps

1. Read product state:
   ```bash
   cat memory/STATE.md
   cat memory/BACKLOG.md
   ```

2. Read the project roadmap from CLAUDE.md.

3. Check what's actually built:
   ```bash
   git log --oneline -20
   ```

4. **po-agent reviews:**
   - Phase gate progress — what % complete?
   - Feature gaps — what's missing for the current phase?
   - Persona check — would each target user find value in what's built?
   - Backlog health — is the backlog prioritised correctly?
   - Any stories that have been sitting too long without progress?

5. **Update BACKLOG.md** if any stories need re-prioritisation.

## Output Format

```
PRODUCT OWNER REVIEW
═══════════════════════════════════════
PHASE GATE: [X/Y items complete] ([Z]%)

FEATURE STATUS
  Built:       [list from git log]
  In Progress: [from STATE.md]
  Missing:     [from roadmap / BACKLOG.md]

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
