# /review — Full PR Review Loop

Use this when **you wrote the code yourself** and want the full review cycle.
Agents review → write a PR response → dev fixes → agents re-review. Loops until approved.

If agents are implementing the story for you, use `/new-task` instead — it includes this chain.

Arguments: $ARGUMENTS (optional story ID for context)

---

## Checkpoint Protocol

After **every agent step completes**, write to `memory/CHECKPOINT.md` before moving to the next step. This ensures recovery is possible if the session drops mid-chain.

Format:
```
Command: /review
Story: STORY-XXX
Cycle: N
Started: [timestamp]
Last heartbeat: [timestamp] — Step N — [agent-name]

Steps:
  [DONE] Step 1 — qa-agent — PASS | FAIL — [one-line summary]
  [DONE] Step 2 — pr-reviewer-agent — APPROVE | CHANGES — [one-line summary]
  [IN_PROGRESS] Step 3 — security-analyst-agent
  [PENDING] Step 4 — tech-lead-agent
  [PENDING] Step 5 — po-agent
```

On chain completion (APPROVED verdict written), delete `memory/CHECKPOINT.md`.

---

## Step 0 — Check for incomplete chain + read context

```bash
cat memory/CHECKPOINT.md 2>/dev/null  # check for incomplete prior run
git diff --stat
git diff
cat memory/BACKLOG.md   # find the story's acceptance criteria
cat memory/DECISIONS.md # architectural constraints
```

If `CHECKPOINT.md` exists and shows an incomplete `/review` chain for the same story:
- Show the user what completed and what didn't
- Ask: "Resume from Step N ([agent-name]), or restart from Step 1?"
- Continue from the chosen point — do not re-run completed steps

This is **review cycle 1** (or the cycle from CHECKPOINT.md if resuming). Track the cycle number — it increments on each loop.

---

## Step 1 — qa-agent (Quality Gate — always first)

**qa-agent** validates before anyone else reviews. Hard gate — if this fails, the review stops here.

Checks:
- Tests exist for all changed functionality?
- All acceptance criteria from the story are met?
- Edge cases handled: empty, error, loading, success states?
- Existing tests still pass?

```
QA GATE  [cycle N]
───────────────────────────────────────
Tests:      [PASS | FAIL — what's missing or broken]
AC met:     [YES | NO — which criterion is not met]
Edge cases: [COVERED | GAP — what's unhandled]

Result: PASS → continue to code review
        FAIL → stop. PR response written below. Dev fixes and re-runs /review.
───────────────────────────────────────
```

If FAIL — write the PR response (Step 5) immediately and stop. No code review of broken code.

---

## Step 2 — pr-reviewer-agent (Code Quality)

**pr-reviewer-agent** reviews the full diff.

Checks:
- Code does what the story says it should?
- Matches existing patterns in the codebase?
- Error cases handled?
- No hardcoded secrets, commented-out code, dead code, or unrelated changes?
- No N+1 queries, unbounded loops, or blocking calls in async context?

```
PR REVIEWER  [cycle N]
───────────────────────────────────────
Correctness:     [PASS | ISSUE — file:line — details]
Style:           [PASS | ISSUE — file:line — details]
Performance:     [PASS | ISSUE — file:line — details]
Maintainability: [PASS | ISSUE — file:line — details]

Inline comments:
  [file:line] — [specific actionable comment]
  [file:line] — [specific actionable comment]
───────────────────────────────────────
```

---

## Step 3 — security-analyst-agent (Security)

**security-analyst-agent** scans the same diff.

Checks:
- Secrets: API keys, tokens, passwords, connection strings in code or config?
- Input validation: user input reaching the system without sanitisation?
- Dependencies: new packages with known CVEs?
- Data handling: sensitive data logged, exposed, or stored insecurely?
- Auth/AuthZ: endpoints or resources now reachable without proper checks?

```
SECURITY  [cycle N]
───────────────────────────────────────
Secrets:    [CLEAN | FOUND — details]
Input:      [CLEAN | RISK — file:line — details]
Deps:       [CLEAN | CVE — package, severity, CVE-ID]
Data:       [CLEAN | RISK — details]
Auth/AuthZ: [CLEAN | RISK — details]

Findings:
  CRITICAL: [description] — blocks merge
  HIGH:     [description] — blocks merge
  MEDIUM:   [description] → BACKLOG
  LOW:      [description] → BACKLOG or info
───────────────────────────────────────
```

CRITICAL and HIGH are blocking. MEDIUM/LOW go to BACKLOG.md — not forgotten, not blocking.

---

## Step 4 — tech-lead-agent (Architecture)

**tech-lead-agent** checks alignment with the established architecture.

Checks:
- Implementation matches the tech spec (if one was written for this story)?
- Consistent with patterns in DECISIONS.md?
- New patterns introduced — are they intentional? Should they be logged as a DEC?
- Tech debt introduced? Is it acceptable? Should it get a backlog story?

```
TECH LEAD  [cycle N]
───────────────────────────────────────
Spec alignment:    [MATCHES | DRIFT — details]
Pattern:           [CONSISTENT | INCONSISTENT — file:line — details]
Tech debt:         [NONE | INTRODUCED — log to backlog?]
New decision:      [NONE | DEC-XXX needed — description]
───────────────────────────────────────
```

If a new DEC is needed → tech-lead-agent writes it to `memory/DECISIONS.md` before closing.

---

## Step 5 — po-agent writes the PR response

**po-agent** collects all findings from Steps 1–4 and writes the formal PR response.

For each finding, po decides:
- **FIX NOW** → blocks merge. Numbered, specific, actionable.
- **BACKLOG** → valid but non-blocking. Written to `memory/BACKLOG.md` immediately.
- **WON'T FIX** → documented with reasoning so it's not raised again.

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
PR REVIEW — STORY-XXX  [Cycle N of M]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Files changed: [n] | +[lines added] -[lines removed]

REVIEW SUMMARY
  QA:        [PASS | FAIL]
  Code:      [PASS | N issues]
  Security:  [CLEAN | N findings]
  Arch:      [ALIGNED | N concerns]

──────────────────────────────────────────────────
REQUIRED CHANGES  (fix all before merge)
──────────────────────────────────────────────────
  1. [file:line] [CATEGORY] — [specific change required]
     Why: [brief reason]

  2. [file:line] [CATEGORY] — [specific change required]
     Why: [brief reason]

──────────────────────────────────────────────────
ADDED TO BACKLOG  (non-blocking, tracked)
──────────────────────────────────────────────────
  - [issue] — Source: [agent] — STORY-BUG-XXX created

──────────────────────────────────────────────────
WON'T FIX
──────────────────────────────────────────────────
  - [issue] — Reason: [why it's acceptable]

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
VERDICT:  APPROVED ✓  |  CHANGES REQUESTED ✗
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

**po-agent appends any BACKLOG items to `memory/BACKLOG.md` before handing off.**

---

## Step 6 — If CHANGES REQUESTED: dev-agent addresses all required changes

**dev-agent** reads the PR response and fixes every FIX NOW item:
- Work through the list top to bottom
- Do not skip items or partially address them
- Do not introduce unrelated changes

When done:

```
DEV FIX COMPLETE  [cycle N]
───────────────────────────────────────
Fixed:
  1. [item 1] — [what changed] at [file:line]
  2. [item 2] — [what changed] at [file:line]

Not fixed: [item N] — [reason, if any — flag to user if blocked]
───────────────────────────────────────
→ Restarting review from Step 1 (cycle [N+1])
```

→ **Return to Step 0 automatically. A new review cycle begins.**

---

## Step 7 — If APPROVED: ready to commit

```
APPROVED — READY TO COMMIT
───────────────────────────────────────
Cycles:   [N]
Story:    STORY-XXX — [title]
Changes:  [summary of what was implemented]

git add [files]
git commit -m "feat(area): [description] — closes STORY-XXX"

Approve commit? [Y/N]
───────────────────────────────────────
```

Run `/complete STORY-XXX "description"` or approve inline to commit and close the story.

---

## Cycle Limits

- If the same finding appears in 3 consecutive cycles → pause and flag to user. Something is structurally wrong.
- If QA fails twice in a row → pause and show the user the exact failing criteria. Ask: "Fix manually or rewrite the approach?"
- Security CRITICAL on any cycle → pause before dev fixes. Show finding and ask user to confirm the fix approach.
