---
description: Incident response playbook — triage, security assessment, root cause, fix plan by severity
argument-hint: SEV-[1-4] [description]
---

# /incident — Incident Response Playbook

Usage: `/incident SEV-[1-4] [description]`

Arguments: $ARGUMENTS

Triggers incident response. SEV-1 = production down.

Long chain — write `.claude/memory/CHECKPOINT.md` after each step per the Checkpoint Protocol in CLAUDE.md.

## Severity Levels (canonical — shared with /bug)

| Level | Meaning | Response |
|-------|---------|----------|
| SEV-1 | Critical — outage, data loss, or safety impact | Drop everything, fix now |
| SEV-2 | Major function broken, workaround exists | Fix now if in current sprint scope, else top of backlog |
| SEV-3 | Minor function broken | Backlog as a story for this or next sprint |
| SEV-4 | Cosmetic | Log to backlog, stop |

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
   - If architectural issue: log DEC-XXX in `.claude/memory/DECISIONS.md`
   - **Escalation:** if a SEV-1 root cause resists this investigation, hand the technical
     investigation to **principal-engineer-agent** (on-demand — invoke explicitly);
     tech-lead stays on coordination of the fix

5. **pm-agent logs and coordinates:**
   - Add incident to `.claude/memory/STATE.md` under INCIDENTS section:
     ```
     INCIDENT — SEV-[N] — [date]
     Description: [what happened]
     Impact: [what's affected]
     Status: [investigating / fixing / resolved]
     ```
   - For SEV-3/4: add story to `.claude/memory/BACKLOG.md` instead

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

7. Route by severity:
   - **SEV-1:** stabilize/mitigate immediately per the fix plan and rollback option above
     (do not ask "should I start?" — start), then hand off to `/bug` for the actual fix.
     Tests-first still applies in the /bug chain.
   - **SEV-2:** stabilize/mitigate if needed, then hand off to `/bug` — it proceeds if the
     bug is in current sprint scope, else logs to the top of the backlog.
   - **SEV-3/4:** already backlogged in Step 5 — stop here.

8. **Postmortem (SEV-1/2 only, after resolution):**
   - **tech-lead-agent** writes a blameless postmortem and appends it to
     `.claude/memory/LEARNINGS.md` under `## Postmortems`:
     ```
     ### POSTMORTEM — SEV-[N] — [date] — [one-line title]
     Timeline: [detected → mitigated → resolved, with times if known]
     Root cause: [systems and process — never people]
     Contributing factors: [what made it possible or worse]
     Prevention actions: [each becomes a BACKLOG.md item — list the STORY-XXX IDs]
     ```
   - **pm-agent** confirms every prevention action reached BACKLOG.md and marks the
     incident `resolved` in STATE.md. An incident is not closed until the postmortem
     is in LEARNINGS.md.
   - **SEV-1 only:** invoke **cto-agent** (on-demand) to sign off the postmortem —
     honesty check (blameless, root cause systemic) and confirmation that prevention
     actions are scheduled into a sprint, not just backlogged. principal-engineer-agent
     reviews it for technical depth if it was involved in the investigation.

9. **Overwrite `.claude/memory/NEXT.md`** with the exact next action (Iron Rule 6) — e.g.,
   "Run /bug [description] to fix INCIDENT SEV-N" or "Incident resolved — resume STORY-XXX".
