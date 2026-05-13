# /standup — Daily Standup (Collaborative Chain)

All agents report. PM synthesizes. PO notes. Use at the start of every session.

---

## Step 0 — Read current state

```bash
cat memory/STATE.md
cat memory/NEXT.md
git log --oneline -5
```

---

## Step 1 — Each agent reports

**dev-agent** reports:
```
dev-agent
  Done:    [specific work completed — name files/features, not "worked on X"]
  Doing:   [exactly what's in progress right now]
  Blocked: [specific blocker with context, or "nothing"]
```

**qa-agent** reports:
```
qa-agent
  Done:    [tests written, stories validated, or issues found]
  Doing:   [what's being tested or reviewed now]
  Blocked: [missing acceptance criteria, broken test env, or "nothing"]
```

**security-analyst-agent** reports:
```
security-analyst-agent
  Done:    [security scans completed, findings addressed]
  Doing:   [any active security review]
  Blocked: [nothing, or specific concern]
```

**tech-lead-agent** reports:
```
tech-lead-agent
  Done:    [specs written, decisions logged, unblocking done]
  Doing:   [active architecture work or review]
  Blocked: [nothing, or what needs a decision]
```

---

## Step 2 — pm-agent synthesizes

**pm-agent** reads all reports and:
1. Lists active blockers and assigns an owner + mitigation for each
2. Confirms today's focus matches `memory/NEXT.md` — updates NEXT.md if it doesn't
3. Updates the "In Progress" section of `memory/STATE.md`
4. Flags any sprint goal risk (if velocity is off track)

---

## Step 3 — po-agent notes

**po-agent** listens and flags:
- Any scope creep (work happening outside the sprint stories)
- Stories that need re-sizing based on what dev reported
- Priority shifts based on blockers

---

## Final Output

```
STANDUP — [date]
════════════════════════════════════════
SPRINT [n] — [sprint goal]

dev-agent
  Done:    [...]
  Doing:   [...]
  Blocked: [...]

qa-agent
  Done:    [...]
  Doing:   [...]
  Blocked: [...]

security-analyst-agent
  Done:    [...]
  Doing:   [...]
  Blocked: [...]

tech-lead-agent
  Done:    [...]
  Doing:   [...]
  Blocked: [...]

BLOCKERS
  [description] — owner: [agent] — mitigation: [plan]
  [or: none]

SPRINT GOAL HEALTH
  [on track / at risk — reason]

TODAY'S FOCUS
  [from NEXT.md — single most specific next action]
════════════════════════════════════════
```

After standup: if next action is clear → start it. If not → run `/new-task`.
