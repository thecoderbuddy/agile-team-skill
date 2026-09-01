---
description: Full project picture — pm reads state, all agents report sprint/backlog/quality/security/architecture health
---

# /status — Full Project Picture

Use at the start of every session. Reads state, checks git, shows what's next.

---

## Step 1 — Read all state

```bash
cat .claude/memory/STATE.md
cat .claude/memory/NEXT.md
sed -n '/^## Index/,/^---$/p' .claude/memory/BACKLOG.md   # index only — full bodies not needed for status
git log --oneline -10
git status
```

---

## Step 2 — Each agent reports health

**pm-agent** reads STATE.md and reports sprint health:
- Sprint goal and status (on track / at risk / blocked)
- Stories in progress vs done vs not started
- Velocity so far (stories done / stories planned)

**dev-agent** reports implementation health:
- Current story progress (what's built, what remains)
- Uncommitted or work-in-progress changes (from git status)
- Anything slowing implementation down

**po-agent** works from the BACKLOG.md Index (read in Step 1) and reports backlog health:
- Stories ready to pull into sprint (have AC, estimated, not blocked)
- Stories flagged for grooming: po flags stories whose Index entry lacks an estimate marker; the orchestrator extracts bodies only for those flagged stories (awk pattern) to confirm missing AC or estimates
- Backlog size trend (growing / stable / shrinking)

**qa-agent** reports quality health:
- Any acceptance criteria failures on in-progress stories?
- Test gaps known?

**security-analyst-agent** reports security health:
- Any open security findings not yet resolved?
- Any elevated-risk stories in flight?

**tech-lead-agent** reports architecture health:
- Any decisions pending in DECISIONS.md?
- Any tech debt accumulating that needs a story?

---

## Final Output

```
PROJECT STATUS — [date]
═══════════════════════════════════════════════════
Sprint [n]: [goal]
Status: [PLANNING / ACTIVE / REVIEW / CLOSED]

SPRINT HEALTH
  In Progress: [n stories]
  Done:        [n stories]
  Remaining:   [n stories]
  Velocity:    [n done / n planned = %]
  Goal:        [ON TRACK / AT RISK — reason]

IN PROGRESS
  - STORY-XXX: [title]
  - STORY-XXX: [title]

NEXT ACTION
  [from NEXT.md — exact step]

BACKLOG HEALTH
  Ready to sprint: [n stories]
  Needs grooming:  [n stories]

QUALITY
  [CLEAN / [n] open findings]

SECURITY
  [CLEAN / [n] open findings]

ARCHITECTURE
  [STABLE / pending decisions: [list]]

BLOCKERS
  [none / description — owner — mitigation]

LAST 5 COMMITS
  [git log output]

UNCOMMITTED CHANGES
  [git status summary or "clean"]
═══════════════════════════════════════════════════
Run /standup to begin. Run /new-task to pick up work.
```
