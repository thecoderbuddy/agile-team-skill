# /sprint-plan — Sprint Planning (Collaborative Chain)

Six agents collaborate to build the sprint. PO proposes. Dev commits capacity. Team challenges. SM finalizes.

---

## Step 0 — Read current state

```bash
cat memory/STATE.md
cat memory/BACKLOG.md
git log --oneline -10
```

---

## Step 1 — po-agent proposes

**po-agent** reads the backlog and proposes:
- Sprint goal (one sentence — what user value do we deliver?)
- Top 5-7 stories from BACKLOG.md ordered by priority
- Why these stories, not others (value justification)

```
PO PROPOSAL
───────────────────────────────────────
Sprint goal: [one sentence]

Proposed stories (priority order):
  1. STORY-XXX: [title] — [user value]
  2. STORY-XXX: [title] — [user value]
  ...
───────────────────────────────────────
```

---

## Step 2 — dev-agent commits capacity

**dev-agent** reviews the proposed stories and states:
- How many stories they can realistically complete this sprint (based on available days)
- Time estimate per story in days (dev knows their own pace, not tech-lead)
- Questions or clarifications needed before starting any story

```
DEV CAPACITY
───────────────────────────────────────
Available this sprint: [N days]
Stories I can take:    [n stories]

STORY-XXX: [2 days] — [clear, ready to start]
STORY-XXX: [1 day]  — [need tech spec first]
STORY-XXX: [3 days] — [have a question: ...]

Total committed: [N days]
───────────────────────────────────────
```

If total committed days exceed available days, dev-agent proposes which story to drop.
pm-agent and po-agent decide on the trim.

---

## Step 4 — tech-lead-agent estimates

**tech-lead-agent** reviews the proposed stories and provides:
- Complexity estimate for each story: XS / S / M / L / XL
- Dependencies (story B requires story A to be done first)
- Stories that need a tech spec before work starts
- Architectural concerns or DEC-XXX constraints that apply

```
TECH LEAD INPUT
───────────────────────────────────────
STORY-XXX: [S] — [dependency: none] — [no spec needed]
STORY-XXX: [M] — [dependency: STORY-XXX] — [needs tech spec]
STORY-XXX: [L] — [dependency: none] — [DEC-XXX applies]
Concern: [any architectural risk]
───────────────────────────────────────
```

---

## Step 5 — qa-agent validates acceptance criteria

**qa-agent** reviews each proposed story and:
- Confirms acceptance criteria are testable (flags if too vague)
- Adds test effort estimate (small / medium / large) per story
- Flags stories that don't have acceptance criteria yet (must be written before dev starts)

```
QA INPUT
───────────────────────────────────────
STORY-XXX: AC testable ✓ — test effort: small
STORY-XXX: AC MISSING — cannot start without criteria
STORY-XXX: AC needs clarification — [what's unclear]
───────────────────────────────────────
```

---

## Step 6 — security-analyst-agent flags risk

**security-analyst-agent** reviews the sprint stories and flags:
- Any story with elevated security risk (auth, data handling, external APIs)
- Stories that need security review time factored in
- Any compliance concerns with the proposed work

```
SECURITY INPUT
───────────────────────────────────────
STORY-XXX: low risk
STORY-XXX: ELEVATED RISK — [reason] — add 0.5 days for security review
───────────────────────────────────────
```

---

## Step 7 — pm-agent finalizes

**pm-agent** synthesizes all input and:
- Adjusts scope if total complexity exceeds sprint capacity
- Resolves dependency ordering
- Confirms all stories have testable AC (no exceptions)
- Writes the finalized sprint to `memory/STATE.md`
- Writes the first task to `memory/NEXT.md`

---

## Final Output

```
SPRINT [N] — PLAN
═══════════════════════════════════════════════════
Goal:     [sprint goal]
Stories:  [n] | Complexity: [total estimate]

STORIES (in execution order)
  1. STORY-XXX: [title] — [complexity] — [priority]
     AC: [key criteria]
  2. STORY-XXX: [title] — [complexity] — [priority]
     AC: [key criteria]
  ...

AGENT NOTES
  PO:       [priority rationale]
  Tech:     [architectural notes, specs needed]
  QA:       [test coverage plan]
  Security: [risk flags]

BACKLOGGED (considered but not in sprint)
  - STORY-XXX: [reason not included]

FIRST TASK → [STORY-XXX: title]
═══════════════════════════════════════════════════
Sprint [N] ready. Run /standup to begin.
```

**pm-agent writes STATE.md and NEXT.md before closing planning.**
