# /new-task — Begin Next Task (Collaborative Chain)

PO selects. Tech Lead specs if needed. PM assigns. Dev starts. No ambiguity.

---

## Step 0 — Read state

```bash
cat memory/STATE.md
cat memory/NEXT.md
cat memory/BACKLOG.md
```

---

## Step 1 — Determine what's next

| State | Action |
|---|---|
| NEXT.md has a specific task | Start that task — skip to Step 2 |
| Sprint has unstarted stories | po-agent selects highest priority unblocked |
| All sprint stories in progress or done | qa-agent: anything needs testing? Otherwise → /sprint-close |
| Sprint complete | Run /sprint-close then /sprint-plan |
| No active sprint | Run /sprint-plan first |

---

## Step 2 — po-agent selects

**po-agent** picks the next story from the sprint (in STATE.md "In Progress" candidate order):
- Highest priority
- Not blocked
- Has testable acceptance criteria (qa-agent confirmed)

```
PO SELECTION
───────────────────────────────────────
Next story: STORY-XXX — [title]
Why: [highest priority unblocked story in sprint]
User value: [one sentence from the story]
───────────────────────────────────────
```

---

## Step 3 — tech-lead-agent confirms readiness

**tech-lead-agent** checks:
- Does this story have a tech spec? (Required for M+ complexity)
- If YES → proceed
- If NO and complexity is M+ → write the tech spec now before dev starts
- Any DEC-XXX decisions to apply?

```
TECH LEAD CHECK
───────────────────────────────────────
Tech spec: [exists / written now / not needed (S complexity)]
DEC constraints: [DEC-XXX applies | none]
Implementation approach: [one sentence]
Files likely affected: [list]
───────────────────────────────────────
```

---

## Step 4 — pm-agent assigns and updates state

**pm-agent**:
- Moves STORY-XXX to "In Progress" in STATE.md
- Writes NEXT.md with the exact first implementation step

---

## Step 5 — dev-agent begins

**dev-agent** receives the assignment and confirms:
- Story understood ✓
- Acceptance criteria clear ✓
- Tech approach clear ✓
- Any questions? (Ask now, not mid-implementation)

Then begins work immediately. No further coordination needed until /review.

---

## Output

```
STARTING STORY
═══════════════════════════════════════════════════
Story:    STORY-XXX — [title]
Priority: [High/Medium/Low]
Goal:     [user value statement]

Acceptance Criteria:
  - [criterion]
  - [criterion]

Tech approach: [one sentence]
Files:         [list]
DEC applies:   [DEC-XXX or none]

NEXT.md updated → [exact first step]
STATE.md updated → STORY-XXX In Progress
═══════════════════════════════════════════════════
Beginning implementation. Run /review when done.
```
