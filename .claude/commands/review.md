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
git diff --stat --no-color
git diff
cat memory/BACKLOG.md   # find the story's acceptance criteria
cat memory/DECISIONS.md # architectural constraints
```

If `CHECKPOINT.md` exists, validate it before acting on it (see DEC-002):

**Valid checkpoint** — must contain all of: `Command:`, `Story:`, `Started:`, `Last heartbeat:`, and a `Steps:` block with at least one entry. If the file is empty or any required field is missing → corrupt. Delete it and start fresh (cycle 1).

**Stale checkpoint** — if the Story ID already appears in the "Done This Sprint" list in `memory/STATE.md` → the chain already completed. Delete it and start fresh.

**Recoverable checkpoint** — valid, story not yet done, the `Command:` field contains `/review`:
- Show the user what completed and what didn't
- Ask: "Resume from Step N ([agent-name]), or restart from Step 1?"
- Continue from the chosen point — do not re-run completed steps

This is **review cycle 1** (or the cycle from CHECKPOINT.md if resuming). Track the cycle number — it increments on each loop.

Using the `git diff --stat --no-color` output already captured above, parse the summary line (e.g. `3 files changed, 142 insertions(+), 67 deletions(-)`):
- **Lines changed** = insertions + deletions
- **Files changed** = the integer before "files changed"

Compare against thresholds — use `MAX_DIFF_LINES` / `MAX_DIFF_FILES` env vars if set, otherwise defaults:
- Default: **500 lines** or **20 files**

If either threshold is exceeded, pause and show the user:

```
DIFF TOO LARGE — confirm before review
───────────────────────────────────────
Files changed: [N]   (threshold: 20)
Lines changed: [N]   (threshold: 500)

Large diffs reduce review quality. Consider splitting into smaller stories.

Continue anyway, or split this PR? [continue / split]
───────────────────────────────────────
```

- If **continue** → proceed with a note in the review output that the diff is large
- If **split** → stop. Remind user to break the work into smaller stories, then re-run `/review`
- If within threshold → proceed silently

---

## Step 1 — qa-agent (Quality Gate — always first)

**qa-agent** validates before anyone else reviews. Hard gate — if this fails, the review stops here.

Use your **full 7-item quality gate checklist** from your agent definition. "PASS" without naming specific tests or citing lines is not acceptable.

Run the test suite if possible (`Bash` tools available). Report exact results (N passed, N failed).

```
QA GATE  [cycle N]
───────────────────────────────────────
Tests exist:    [PASS — name test file(s) | FAIL — what's missing]
Happy path:     [PASS — name test | FAIL]
Failure case:   [PASS — name test | FAIL]
Existing tests: [PASS — N passed, N failed | FAIL — exact failures]
AC verified:    [YES — criterion → test name | NO — which criterion not met]
UI states:      [COVERED — loading/empty/error/success | GAP — what's unhandled | N/A — non-UI]
Security:       [CLEAN — confirmed with security-analyst | RISK — details | N/A]

Result: PASS → continue to code review
        FAIL → stop. PR response written below. Dev fixes and re-runs /review.
───────────────────────────────────────
```

If FAIL — write the PR response (Step 5) immediately and stop. No code review of broken code.

---

## Step 2 — pr-reviewer-agent (Code Quality)

**pr-reviewer-agent** reviews the full diff. Use your **full output format** from your agent definition (inline comments per file + summary). All 17 dimensions must be covered — file:line evidence or explicit "checked N files, no issues found" required. A bare "PASS" is not acceptable.

**On cycle 2+:** Before the inline comments, output a delta block:

```
RE-REVIEW DELTA  [cycle N]
───────────────────────────────────────
Previously flagged:   [N total from cycle N-1]
  Resolved:           [N] — [item summary]
  Still present:      [N] — [item summary — treat as new BLOCK if same severity]
  New issues found:   [N] — [item summary]
───────────────────────────────────────
```

Then proceed with the full inline comment format as defined in your agent definition.

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

**tech-lead-agent** checks alignment with the established architecture. Use your **full output format** from your agent definition — enumerate every relevant DEC from DECISIONS.md explicitly. "ALIGNED" without citing specific DECs is not acceptable.

Checks:
- Every relevant DEC in DECISIONS.md — does this change COMPLY, VIOLATE, or is it NOT APPLICABLE?
- New patterns introduced — are they intentional? Should they be logged as a DEC?
- Tech debt introduced? Is it acceptable? Should it get a backlog story?
- **README accuracy:** does README.md still accurately describe the system after this change? Stale = REQUEST CHANGES, not a backlog item.

```
TECH LEAD  [cycle N]
───────────────────────────────────────
DEC compliance:
  DEC-001 — [title] — COMPLIES [evidence] | VIOLATES [file:line] | NOT APPLICABLE [reason]
  DEC-XXX — [title] — COMPLIES [evidence] | VIOLATES [file:line] | NOT APPLICABLE [reason]

New patterns introduced:
  [pattern] at [file:line] — intentional? — needs DEC? YES (logged as DEC-XXX) | NO

Tech debt:
  [NONE | description — severity — add to BACKLOG? YES | NO]

README accuracy:
  CURRENT — [sections checked] | STALE — [which section] — [what is wrong or missing]
───────────────────────────────────────
```

If a new DEC is needed → tech-lead-agent writes it to `memory/DECISIONS.md` before closing.
If README is stale → flag as REQUEST CHANGES. Dev updates README before merge.

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

After fixing, **run the test suite** before triggering the next cycle. If tests fail after your fixes, resolve the failures before restarting — do not hand broken code to the review chain.

```
DEV FIX COMPLETE  [cycle N]
───────────────────────────────────────
Fixed:
  1. [item 1] — [what changed] at [file:line]
  2. [item 2] — [what changed] at [file:line]

Not fixed: [item N] — [reason, if any — flag to user if blocked]

Post-fix test run: [N passed, N failed | no test suite detected]
───────────────────────────────────────
→ Restarting review from Step 1 (cycle [N+1])
```

If the post-fix test run shows failures → stop. Fix the failures first, then restart the cycle.

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

Run `/complete STORY-XXX "description"` or approve inline to commit and close the story. After the commit is confirmed, delete `memory/CHECKPOINT.md` — the /review chain has no pm-agent step, so this deletion runs here, at the terminal success point, before returning control to the user (see DEC-002).

---

## Cycle Limits

- If the same finding appears in 3 consecutive cycles → pause and flag to user. Something is structurally wrong.
- If QA fails twice in a row → pause and show the user the exact failing criteria. Ask: "Fix manually or rewrite the approach?"
- Security CRITICAL on any cycle → pause before dev fixes. Show finding and ask user to confirm the fix approach.
