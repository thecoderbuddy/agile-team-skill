# /bug — Fix a Bug End to End

Usage: `/bug [describe the issue]`

Arguments: $ARGUMENTS

One command. Agents investigate, diagnose, fix, test, review, and commit.

---

## Step 0 — Read context

```bash
cat memory/STATE.md
git log --oneline -5
```

---

## Step 1 — qa-agent investigates

**qa-agent** reproduces and classifies the bug:
- Reproduce the issue by reading the relevant code and tests
- Classify: bug (broken) vs gap (missing) vs regression (worked before)
- Severity: SEV-1 (blocking users) / SEV-2 (painful) / SEV-3 (cosmetic) / SEV-4 (minor)

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
If SEV-2 → proceed if in current sprint scope, else log to BACKLOG.md and stop.
If SEV-3/4 → log to BACKLOG.md and stop (don't interrupt sprint flow).

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

Skip this step for purely functional or UI bugs.

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
