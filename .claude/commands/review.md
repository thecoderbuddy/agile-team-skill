---
description: Full PR review loop — qa gate, code review, security scan, architecture check, po verdict; loops dev fixes until APPROVED
argument-hint: "[STORY-XXX]"
---

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

Delete `memory/CHECKPOINT.md` when the APPROVED verdict is written (Step 5). Keep it alive
during CHANGES REQUESTED loops. Format and lifecycle: see "Checkpoint Protocol" in CLAUDE.md.

---

## Step 0 — Check for incomplete chain + read context

```bash
cat memory/CHECKPOINT.md 2>/dev/null  # check for incomplete prior run
cat memory/TEAM.md                    # roster — which extended lenses join Step 4b
git diff --stat --no-color
git diff
# Extract ONLY the story under review — do not read the full backlog:
awk '/^- \[.\] STORY-XXX:/,/^---$/' memory/BACKLOG.md
cat memory/DECISIONS.md # architectural constraints
```

**Roster check:** note which extended agents are ACTIVE in `memory/TEAM.md` — they run in
Step 4b. If none are ACTIVE, Step 4b is skipped entirely.

**Story ID resolution:** use the story ID from `$ARGUMENTS` in the awk pattern above. If
`$ARGUMENTS` is empty, derive the story ID from the "In Progress" entry in `memory/STATE.md`
(fall back to `memory/NEXT.md`). If no story ID can be found in either, ask the user which
story is under review before proceeding.

**If returning from Step 6 (fix loop):** skip checkpoint recovery — the existing
CHECKPOINT.md belongs to this run; update it in place and continue with the new cycle.

**Token rule:** the story body extracted above is passed to each agent in its step prompt.
Agents in this chain must NOT re-read `memory/BACKLOG.md` themselves — they receive the
story AC and the diff as input. Only po-agent (Step 5) touches BACKLOG.md, to append findings.

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

## Step 4b — Extended lenses (roster-gated — skip if no extended agent is ACTIVE)

Run only the lenses whose agent is marked ACTIVE in `memory/TEAM.md` **and** whose surface
the diff touches. Each lens outputs findings in its agent-definition format; a lens whose
surface isn't touched outputs one line ("AI surface: not touched — skipped") and stands down.

- **ai-engineer-agent** (if ACTIVE, diff touches prompts/model calls/AI pipelines):
  run the 10-item AI review checklist. Blocking: prompt injection, PII to providers,
  unvalidated output execution, prompt change with zero eval evidence.
- **design-lead-agent** (if ACTIVE, diff touches UI):
  run the 7 UX dimensions. Blocking: task cannot be completed, a11y failure.
- **senior-engineer-agent** (if ACTIVE, only when pr-reviewer or po explicitly requests
  a depth pass on an L+ diff): implementation-depth consult — feeds findings, no verdict.

Record each lens in CHECKPOINT.md as `Step 4b — [agent] — [run | skipped (reason)]`.

---

## Step 5 — po-agent writes the PR response

**po-agent** collects all findings from Steps 1–4 (and Step 4b extended lenses, if any)
and writes the formal PR response.
The verdict output must follow the "PR & Ticket Description Structure" in CLAUDE.md
(Impact, Fix, Out of scope/BACKLOG items, Acceptance criteria).

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
  AI lens:   [PASS | N findings | skipped — not ACTIVE or no AI surface]
  UX lens:   [PASS | N findings | skipped — not ACTIVE or no UI surface]

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

Run `/complete STORY-XXX "description"` or approve inline to commit and close the story. `memory/CHECKPOINT.md` was already deleted when the APPROVED verdict was written in Step 5 — if it still exists at this point, delete it now (see DEC-002). Format and lifecycle: see "Checkpoint Protocol" in CLAUDE.md.

---

## Cycle Limits

- If the same finding appears in 3 consecutive cycles → pause and flag to user. Something is structurally wrong.
- If QA fails twice in a row → pause and show the user the exact failing criteria. Ask: "Fix manually or rewrite the approach?"
- Security CRITICAL on any cycle → pause before dev fixes. Show finding and ask user to confirm the fix approach.

## Escalation

- po cannot override a security block or qa hard veto — only **cto-agent** can approve
  that exception (invoke it explicitly), and only with a compensating control + follow-up
  story. Default is NO.
- If pr-reviewer and tech-lead reach opposite verdicts on an architectural question and
  po cannot resolve it → consult **principal-engineer-agent** as tie-breaker before cto.
