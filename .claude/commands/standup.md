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

Before reporting, read `memory/STATE.md` and evaluate security review cadence:

- Security review threshold: **30 days**  <!-- CONFIGURABLE: Edit only this value to change the threshold everywhere in this block -->
- Use `currentDate` from session context for date arithmetic — do NOT shell out for the date.
- If the `## Last Security Review` section heading is absent from STATE.md entirely → set Blocked to:
  `SECURITY REVIEW OVERDUE — '## Last Security Review' section missing from STATE.md. Check STATE.md structure, then run /security-review.`
- If the `## Last Security Review` line reads `[Never run]` → set Blocked to:
  `SECURITY REVIEW OVERDUE — never run. Run /security-review.`
- If the `## Last Security Review` line contains a date and that date is more than the configured threshold before today → set Blocked to:
  `SECURITY REVIEW OVERDUE — last run N days ago (threshold: [configured value] days). Run /security-review.`
  (replace N with the actual number of days elapsed; replace [configured value] with the threshold set above)
- If the date is within the configured threshold → Blocked is `nothing` (no flag, no noise)

<!-- Verification scenarios — security-analyst-agent must match these exactly:
  Scenario A: STATE.md has "Last Security Review: [Never run]"
              Expected: overdue flag in Blocked — "SECURITY REVIEW OVERDUE — never run. Run /security-review."
  Scenario B: STATE.md has "Last Security Review: 2026-05-01 — ..." (35 days before 2026-06-09)
              Expected: overdue flag — "SECURITY REVIEW OVERDUE — last run 35 days ago (threshold: [configured value] days). Run /security-review."
  Scenario C: STATE.md has "Last Security Review: 2026-06-08 — ..." (1 day ago)
              Expected: no flag — Blocked is "nothing"
-->

```
security-analyst-agent
  Done:    [security scans completed, findings addressed]
  Doing:   [any active security review]
  Blocked: [cadence flag from above, or "nothing"]
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

After standup:
- Next action is clear → start it. Run `/new-task` if you need the full task context.
- Blocker found → raise to tech-lead-agent or run `/unblock STORY-XXX` to clear it.
- Sprint goal at risk → run `/health-check` to assess and decide on descopes.
