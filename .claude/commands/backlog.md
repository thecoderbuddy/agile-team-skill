# /backlog — Backlog Grooming (Collaborative Chain)

PO leads. Tech Lead estimates. QA validates AC. Security flags risk. Backlog exits with real priorities.

---

## Step 0 — Read current state

```bash
cat memory/BACKLOG.md
cat memory/STATE.md
cat memory/DECISIONS.md
```

---

## Step 1 — po-agent leads prioritization

**po-agent** reads BACKLOG.md and for each item asks:
- "What user problem does this solve?"
- "Is this more or less important than the item above it?"
- "Is this still relevant, or has the world changed?"

po-agent produces a draft priority order:
```
DRAFT PRIORITY ORDER
───────────────────────────────────────
High:
  STORY-XXX: [title] — [value rationale]
  STORY-XXX: [title] — [value rationale]

Medium:
  STORY-XXX: [title] — [value rationale]

Low:
  STORY-XXX: [title] — [value rationale]

Icebox (no near-term value):
  STORY-XXX: [title] — [reason for icebox]
───────────────────────────────────────
```

---

## Step 2 — tech-lead-agent reviews for effort accuracy

**tech-lead-agent** checks each story for:
- Are complexity estimates still accurate? (Things change as you build)
- Are there hidden dependencies between stories?
- Any stories that can be split to deliver earlier value?
- Any stories that are actually 3x harder than estimated?

tech-lead flags corrections and po-agent adjusts.

---

## Step 3 — qa-agent validates acceptance criteria

**qa-agent** checks each story:
- Does it have testable acceptance criteria?
- Stories without criteria get flagged — po-agent must add before they can enter a sprint
- Stories with criteria that are too vague get sent back for refinement

---

## Step 4 — security-analyst-agent flags risk

**security-analyst-agent** scans for:
- Stories involving auth, user data, external APIs, file handling → flag as elevated risk
- Elevated risk stories need extra time in sprint estimates

---

## Final Output — updated BACKLOG.md

```
BACKLOG GROOMING — [date]
═══════════════════════════════════════════════════

PRIORITY CHANGES
  Promoted: STORY-XXX [reason]
  Demoted:  STORY-XXX [reason]
  Iceboxed: STORY-XXX [reason]
  Split:    STORY-XXX → STORY-XXX + STORY-XXX

STORIES NEEDING AC (cannot enter sprint)
  - STORY-XXX: [what's missing]

SECURITY FLAGS
  - STORY-XXX: elevated risk — [reason]

═══════════════════════════════════════════════════
memory/BACKLOG.md updated ✓

Ready to sprint plan? Run /sprint-plan
```

**po-agent writes the updated priority order to `memory/BACKLOG.md` before closing.**
