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

3. **For SEV-1/SEV-2:**
   - Identify the blast radius (what's affected)
   - Check recent commits (did a recent change cause this?)
   - Read relevant code to understand the failure
   - Propose fix or rollback

4. **Log the incident** — add a note to memory/STATE.md under an INCIDENTS section:
   ```
   INCIDENT — SEV-[N] — [date]
   Description: [what happened]
   Impact: [what's affected]
   Status: [investigating / fixing / resolved]
   ```

5. **Log in DECISIONS.md** if this reveals an architectural risk that needs a DEC-XXX decision.

6. Show incident report:

```
INCIDENT — SEV-[N]
═══════════════════════════════════════
Description: [what happened]
Impact:      [what's affected]
Blast radius: [scope]

ROOT CAUSE (hypothesis)
  [what we think caused it]

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
