---
description: Fix a bug end to end — investigate, diagnose, fix, test, review, and commit in one chain
argument-hint: [describe the issue]
---

# /bug — Fix a Bug End to End

Usage: `/bug [describe the issue]`

Arguments: $ARGUMENTS

One command. Agents investigate, diagnose, fix, test, review, and commit.

---

## Checkpoint Protocol

After **every agent step completes**, write to `memory/CHECKPOINT.md` before moving to the next step. This ensures recovery is possible if the session drops or the host sleeps mid-chain.

Format:
```
Command: /bug
Bug: [description]
Started: [timestamp]
Last heartbeat: [timestamp] — Step N — [agent-name]

Steps:
  [DONE] Step 1 — qa-agent — SEV-X — [one-line summary]
  [DONE] Step 2 — tech-lead-agent — [root cause]
  [DONE] Step 3 — dev-agent — fix complete
  [IN_PROGRESS] Step 4 — qa-agent (validation)
  [SKIPPED] Step 5 — security-analyst-agent (not security-adjacent)
  [PENDING] Step 6 — pr-reviewer-agent
  [PENDING] Step 7 — po-agent
```

Format and lifecycle: see Checkpoint Protocol in CLAUDE.md (accepts `Story:` or `Bug:`).

Skipped steps (e.g., Step 5 when the bug is not security-adjacent) must be written to the
checkpoint as `[SKIPPED] ... (reason)` — never left `[PENDING]`, or /resume will try to run them.

On chain completion (commit approved), delete `memory/CHECKPOINT.md`.

---

## Step 0 — Check for incomplete chain + read context

```bash
cat memory/CHECKPOINT.md 2>/dev/null  # check for incomplete prior run
cat memory/STATE.md
git log --oneline -5
```

If `CHECKPOINT.md` exists and shows an incomplete `/bug` chain:
- Show the user which steps completed and which didn't
- Show the last heartbeat timestamp (helps diagnose host sleep vs rate limit)
- Ask: "Resume from Step N ([agent-name]), or start fresh?"
- If resuming: continue from the next uncompleted step, do not re-run completed steps

---

## Step 1 — qa-agent investigates

**qa-agent** reproduces and classifies the bug:
- Reproduce the issue by reading the relevant code and tests
- Classify: bug (broken) vs gap (missing) vs regression (worked before)
- Severity (canonical — shared with /incident):

| Level | Meaning | Response |
|-------|---------|----------|
| SEV-1 | Critical — outage, data loss, or safety impact | Drop everything, fix now |
| SEV-2 | Major function broken, workaround exists | Fix now if in current sprint scope, else top of backlog |
| SEV-3 | Minor function broken | Backlog as a story for this or next sprint |
| SEV-4 | Cosmetic | Log to backlog, stop |

```
QA INVESTIGATION
───────────────────────────────────────
Type:       [bug | gap | regression]
Severity:   [SEV-1/2/3/4]
Reproduced: [YES — how | UNABLE — what's unclear]
Impact:     [who is affected and how]
───────────────────────────────────────
```

---

## Step 2 — tech-lead-agent diagnoses

**tech-lead-agent** finds the root cause and plans the fix:
- Which files are affected?
- What's the root cause (not just the symptom)?
- Fix complexity: XS / S / M / L
- Risk: could the fix introduce regressions elsewhere?
- Any DEC-XXX constraints that apply?

```
TECH LEAD DIAGNOSIS
───────────────────────────────────────
Root cause: [specific cause]
Files:      [list]
Complexity: [XS/S/M/L]
Fix:        [what needs to change]
Risk:       [low | medium — what to watch]
───────────────────────────────────────
```

If SEV-1 → proceed immediately regardless of sprint state.
If SEV-2 → proceed if in current sprint scope, else log to the top of BACKLOG.md and stop.
"In current sprint scope" means: the bug affects a story in the current sprint — check the
stories listed in `memory/STATE.md` (In Progress / Done This Sprint / sprint plan).
If SEV-3 → log to BACKLOG.md as a story for this or next sprint and stop.
If SEV-4 → log to BACKLOG.md and stop (don't interrupt sprint flow).

When logging a bug ticket to BACKLOG.md, the ticket follows the **(bug)** sections of the
"PR & Ticket Description Structure" in CLAUDE.md — Description with file:line + snippet,
Severity, Impact (what-user-sees vs what-happened), Root cause, Repro, Expected vs Actual,
Fix + follow-ups as separate stories, AC, Monitoring.

---

## Step 3 — dev-agent implements the fix

**dev-agent** applies the fix:
- Fix the root cause (not just the symptom)
- Add or update a test that would have caught this bug
- Do not fix unrelated issues in the same commit

```
DEV FIX
───────────────────────────────────────
Files changed: [list]
Test added:    [yes — what it covers | no — why not]
Fix summary:   [one sentence]
───────────────────────────────────────
→ Handing off to QA
```

---

## Step 4 — qa-agent validates the fix

**qa-agent** confirms the bug is resolved:
- Bug no longer reproducible?
- New test passes?
- Existing tests still pass?
- Edge cases that might cause regression?

```
QA VALIDATION
───────────────────────────────────────
Bug fixed:    [YES | NO — still failing]
New test:     [pass | FAIL]
Regression:   [none | FOUND — details]
Result:       PASS | FAIL
───────────────────────────────────────
```

If FAIL → back to Step 3. dev-agent fixes again. QA re-validates.

---

## Step 5 — security-analyst-agent scans (if relevant)

**security-analyst-agent** reviews the fix if the bug was security-adjacent
(auth, input handling, data exposure, dependency issue).

Skip this step for purely functional or UI bugs — and record it in the checkpoint as
`[SKIPPED] Step 5 — security-analyst-agent (reason)`, not `[PENDING]`.

```
SECURITY CHECK
───────────────────────────────────────
Fix introduces new risk: [YES — details | NO]
Root cause was security: [YES — log to DECISIONS.md | NO]
Recommendation: APPROVE | FLAG
───────────────────────────────────────
```

---

## Step 6 — pr-reviewer-agent reviews

**pr-reviewer-agent** reviews the fix diff:
- Fix is targeted — no unrelated changes?
- Test covers the regression case?
- No new tech debt introduced?

```
PR REVIEWER
───────────────────────────────────────
Scope:    [targeted | BLOAT — unrelated changes]
Test:     [adequate | WEAK — what's missing]
Quality:  [PASS | ISSUE — details]
Recommendation: APPROVE | REQUEST CHANGES
───────────────────────────────────────
```

---

## Step 7 — po-agent verdict + commit

**po-agent** collects findings and decides:

```
BUG FIX VERDICT
═══════════════════════════════════════════════════
Bug:      [description]
Severity: [SEV-X]
QA:       PASS
Security: [CLEAN | flagged]
Review:   [APPROVE | changes]

VERDICT: APPROVED | CHANGES REQUESTED
═══════════════════════════════════════════════════
```

If APPROVED → show commit for user approval:

```
READY TO COMMIT
───────────────────────────────────────
git add [files]
git commit -m "fix(area): [description] — fixes #BUG"

Approve commit? [Y/N]
───────────────────────────────────────
```

**pm-agent** updates STATE.md (logs the bug fix) and overwrites NEXT.md.

If CHANGES REQUESTED → dev-agent fixes → return to Step 4.
