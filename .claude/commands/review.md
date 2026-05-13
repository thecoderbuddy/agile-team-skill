# /review — PR Code Review (Collaborative Chain)

Five agents review every diff. QA goes first — no point reviewing code that doesn't pass tests.
If QA fails, stop and return to dev. If QA passes, four more agents review. PO synthesizes.

---

## Step 0 — Read the diff

```bash
git diff --stat
git diff
```

Also read the story from `memory/BACKLOG.md` to understand the intent.

---

## Step 1 — qa-agent (Quality Gate — runs first)

**qa-agent** validates the implementation before anyone else reviews it.

Specifically checks:
- Tests exist for the changed functionality?
- All acceptance criteria from the story are met?
- Edge cases covered: loading, empty, error, success states?
- Existing tests still pass?

**If any check fails — STOP. Report failures. Do not proceed to code review.**
Dev must fix and re-run `/review`. No exceptions (qa-agent hard veto).

```
QA GATE
───────────────────────────────────────
Tests:     [pass / FAIL — what broke]
AC met:    [yes / NO — which criterion missing]
Edge cases:[covered / GAP — what's unhandled]
Result:    PASS → proceed | FAIL → return to dev
───────────────────────────────────────
```

---

## Step 2 — pr-reviewer-agent (Code Quality Lens)

**pr-reviewer-agent** reviews the diff for correctness, style, performance, and maintainability.

Specifically checks:
- Does the code do what the story says it should?
- Does it match existing patterns in the codebase?
- Are error cases handled?
- No hardcoded secrets (first pass)?
- No commented-out code, unrelated changes, or dead code added?

---

## Step 3 — security-analyst-agent (Security Lens)

**security-analyst-agent** reviews the same diff for security vulnerabilities.

Specifically checks:
- Secrets scan: API keys, tokens, passwords in code or config
- Input validation: any user input reaching the system without sanitisation?
- Dependencies: any new packages with known CVEs?
- Data handling: sensitive data logged, exposed, or stored insecurely?
- Auth/AuthZ: any endpoints or resources now accessible without proper checks?

Findings are categorised: CRITICAL/HIGH (blocking) | MEDIUM/LOW (backlog).

---

## Step 4 — tech-lead-agent (Architecture Lens)

**tech-lead-agent** reviews for architecture alignment.

Specifically checks:
- Implementation matches the tech spec (if one was written)?
- Consistent with established patterns in DECISIONS.md?
- Any new patterns introduced — are they intentional and should they be logged as a DEC?
- Tech debt introduced? If so, is it acceptable and backlogged?

---

## Step 5 — po-agent (Synthesis + Verdict)

**po-agent** collects all findings from steps 2–4 and produces the final verdict.

For each finding from any agent, po decides:
- **FIX NOW** — blocks merge. List as required change.
- **BACKLOG** — valid but not blocking. Add to `memory/BACKLOG.md` immediately with
  format: `STORY-XXX: [issue] — found in review of [story] — Source: [agent]`
- **WON'T FIX** — explain why and document reasoning inline.

---

## Final Output

```
CODE REVIEW — STORY-XXX
═══════════════════════════════════════════════════
Files changed: [n] | Lines: +[added] -[removed]

QA:            [PASS / FAIL — summary]
PR REVIEWER:   [PASS / ISSUES — summary]
SECURITY:      [CLEAN / FINDINGS — summary]
TECH LEAD:     [ALIGNED / CONCERNS — summary]

REQUIRED CHANGES (fix before merge):
  1. [specific change required]
  2. [specific change required]

ADDED TO BACKLOG:
  - STORY-XXX: [issue] — Source: [agent]

VERDICT: APPROVED | CHANGES REQUESTED
═══════════════════════════════════════════════════
```

If **APPROVED** → Run `/complete STORY-XXX "description"` to commit and close the story.
If **CHANGES REQUESTED** → Fix the required changes, then run `/review` again.
