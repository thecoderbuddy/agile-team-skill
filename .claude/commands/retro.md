# /retro — Sprint Retrospective (Collaborative Chain)

All agents reflect. PM facilitates. PO converts action items to backlog. Learnings logged.

---

## Step 0 — Read sprint history

```bash
cat memory/STATE.md
cat memory/LEARNINGS.md
git log --oneline -20
```

---

## Step 1 — Each agent reflects (three columns)

Every agent answers three questions:
1. **What went well?** — something to keep doing
2. **What to improve?** — something that caused friction
3. **Action item?** — a concrete change for next sprint

**dev-agent reflects:**
```
dev-agent
  Went well:  [specific — what worked in implementation]
  Improve:    [specific — what slowed me down or caused confusion]
  Action:     [one concrete improvement]
```

**qa-agent reflects:**
```
qa-agent
  Went well:  [test coverage wins, quality gates that caught issues]
  Improve:    [gaps in testing, unclear acceptance criteria, late changes]
  Action:     [one concrete improvement]
```

**security-analyst-agent reflects:**
```
security-analyst-agent
  Went well:  [security practices that held, issues caught early]
  Improve:    [security concerns that were found late, missing patterns]
  Action:     [one concrete improvement]
```

**tech-lead-agent reflects:**
```
tech-lead-agent
  Went well:  [architecture decisions that paid off, good patterns]
  Improve:    [tech debt accumulated, specs that were unclear]
  Action:     [one concrete improvement]
```

---

## Step 2 — pm-agent facilitates

**pm-agent** collects all reflections and:
- Groups related items (don't repeat the same thing from multiple agents)
- Votes on action items — which ones are highest impact?
- Calculates velocity: stories planned vs completed vs carried over
- Identifies patterns across retros (check LEARNINGS.md for recurring themes)

---

## Step 3 — po-agent converts actions to backlog

**po-agent** takes every action item and either:
- Adds it to `memory/BACKLOG.md` as a story (with user value statement)
- Flags it as a process change (no story needed — pm-agent owns implementation)
- Explicitly drops it with reasoning (documented inline)

Nothing from the retro disappears — it either becomes a story or is consciously dropped.

---

## Step 4 — pm-agent writes learnings

**pm-agent** appends to `memory/LEARNINGS.md`:

```
## Sprint [N] Retro — [date]
Velocity: [planned] → [completed] ([%])

What we learned:
  - [lesson]
  - [lesson]

Changes next sprint:
  - [change] — owned by [agent]
```

---

## Final Output

```
RETROSPECTIVE — Sprint [N]
═══════════════════════════════════════════════════
VELOCITY: [n planned] → [n completed] ([%])
Carried over: [n stories] → [back to backlog / sprint N+1]

WHAT WENT WELL
  dev:       [...]
  qa:        [...]
  security:  [...]
  tech:      [...]

WHAT TO IMPROVE
  dev:       [...]
  qa:        [...]
  security:  [...]
  tech:      [...]

ACTION ITEMS → BACKLOG
  - STORY-XXX: [action as story] [medium priority]
  - Process change: [description] — owned by pm-agent

LEARNINGS LOGGED
  memory/LEARNINGS.md updated ✓
═══════════════════════════════════════════════════
Run /sprint-plan to plan Sprint [N+1].
```
