# /incident — Incident Response Playbook

Usage: `/incident SEV-[1-4] [description]`

Arguments: $ARGUMENTS

Triggers incident response. SEV-1 = production down.

## Severity Levels

| Level | Meaning | Response |
|-------|---------|----------|
| SEV-1 | Production down, data loss risk | All hands, fix immediately |
| SEV-2 | Major feature broken, workaround exists | Fix within session |
| SEV-3 | Minor feature broken | Fix this sprint |
| SEV-4 | Cosmetic / low impact | Add to backlog |

## Steps

1. Parse severity and description from arguments.

2. **Immediate triage:**
   ```bash
   git log --oneline -5
   git status
   ```

3. **security-analyst-agent assesses exposure:**
   - Is there a data breach or security risk involved?
   - Any sensitive data exposed?
   - Does this need immediate containment before fixing?

4. **tech-lead-agent investigates root cause:**
   - Identify the blast radius (what's affected)
   - Check recent commits — did a recent change cause this?
   - Read relevant code to understand the failure
   - Propose fix approach or rollback option
   - If architectural issue: log DEC-XXX in `memory/DECISIONS.md`

5. **pm-agent logs and coordinates:**
   - Add incident to `memory/STATE.md` under INCIDENTS section:
     ```
     INCIDENT — SEV-[N] — [date]
     Description: [what happened]
     Impact: [what's affected]
     Status: [investigating / fixing / resolved]
     ```
   - For SEV-3/4: add story to `memory/BACKLOG.md` instead

6. Show incident report:

```
INCIDENT — SEV-[N]
═══════════════════════════════════════
Description:  [what happened]
Impact:       [what's affected]
Blast radius: [scope]

SECURITY ASSESSMENT
  [data exposure risk or "none"]

ROOT CAUSE (hypothesis)
  [what tech-lead-agent identified]

RECENT CHANGES
  [last 5 commits]

FIX PLAN
  1. [step]
  2. [step]

ROLLBACK OPTION
  [can we revert? which commit?]
═══════════════════════════════════════
```

7. For SEV-1: Begin fix immediately. Do not ask "should I start?" — start.
