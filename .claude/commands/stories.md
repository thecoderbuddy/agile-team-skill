---
description: Write user stories — po drafts, qa adds test scenarios, security adds constraints, tech-lead estimates; story written to BACKLOG.md
argument-hint: "[feature or topic]"
---

# /stories — Write User Stories (Collaborative Chain)

Usage: `/stories [feature or topic]`

Arguments: $ARGUMENTS

PO writes. QA tests it. Security constrains it. Tech Lead estimates it. Then it's ready.

---

## Step 0 — Read context

```bash
cat memory/STATE.md
sed -n '/^## Index/,/^---$/p' memory/BACKLOG.md   # index only — for next STORY-XXX ID and duplicate check
cat memory/DECISIONS.md
```

Understand the current sprint and existing backlog before writing new stories.

---

## Step 1 — po-agent writes the story

**po-agent** writes one or more stories for `$ARGUMENTS` in this format:

```
STORY-XXX: [Short, action-oriented title]
Priority: High | Medium | Low
Added by: po-agent via /stories

As a [user type — be specific, not "user"],
I want [capability — what they can do],
So that [outcome — why it matters to them].

Acceptance Criteria:
  - Given [context], When [action], Then [result]
  - Given [context], When [action], Then [result]
```

Story bodies follow the ticket sections of the "PR & Ticket Description Structure" in
CLAUDE.md where applicable (Description, Impact, AC).

Stories must answer: "What problem does this solve for which user?"
If po-agent can't answer that, the story goes to icebox.

---

## Step 2 — qa-agent adds test scenarios

**qa-agent** enriches the story with:

```
Test Scenarios:
  - Happy path: [what should work]
  - Edge case: [boundary condition]
  - Failure case: [what should fail gracefully]

Definition of Done:
  - [ ] [specific, testable criterion]
  - [ ] [specific, testable criterion]
  - [ ] All tests pass
```

If acceptance criteria from Step 1 are too vague to test, qa-agent sends it back to
po-agent with specific feedback before continuing. Cap this loop at 2 iterations — if the
AC are still untestable after the second rewrite, escalate to the user with qa's feedback.

---

## Step 3 — security-analyst-agent adds constraints

**security-analyst-agent** reviews the story for security implications and adds:

```
Security Considerations:
  - [constraint or requirement, e.g., "user input must be sanitised before rendering"]
  - [threat to mitigate, e.g., "token must not appear in logs"]
  - [or: "no security concerns for this story"]
```

---

## Step 4 — tech-lead-agent adds technical notes

**tech-lead-agent** reviews and adds:

```
Technical Notes:
  - [implementation constraint or recommended approach]
  - [DEC-XXX that applies]
  - [dependency on another story or system]
  Complexity: XS | S | M | L | XL
  Needs tech spec before dev: YES | NO
```

---

## Final Output — ready for BACKLOG.md

```
USER STORIES — [feature/topic]
═══════════════════════════════════════════════════

STORY-XXX: [title]
Priority: [High/Medium/Low]

As a [user type],
I want [capability],
So that [outcome].

Acceptance Criteria:
  - Given [...], When [...], Then [...]

Test Scenarios:
  - Happy path: [...]
  - Edge case: [...]
  - Failure case: [...]

Definition of Done:
  - [ ] [criterion]
  - [ ] All tests pass

Security Considerations:
  - [constraint or "none"]

Technical Notes:
  - [note]
  Complexity: [S]
  Needs tech spec: [NO]

═══════════════════════════════════════════════════
```

**po-agent writes the completed story to `memory/BACKLOG.md` before closing.**
Only after the write has happened, confirm: `Added to memory/BACKLOG.md ✓`

Stories added to backlog → Run `/backlog` to groom and prioritize.
Ready to sprint? → Run `/sprint-plan` to commit stories to a sprint.
