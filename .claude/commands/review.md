# /review — PR Code Review (Collaborative Chain)

Five agents review every diff. Each brings a different lens. The PO synthesizes.

---

## Step 0 — Read the diff

```bash
git diff --stat
git diff
```

Also read the story from `memory/BACKLOG.md` to understand the intent.

---

## Step 1 — pr-reviewer-agent (Code Quality Lens)

**pr-reviewer-agent** reviews the diff for correctness, style, security surface, performance,
and maintainability. Uses the output format from its agent definition.

Specifically checks:
- Does the code do what the story says it should?
- Does it match existing patterns in the codebase?
- Are error cases handled?
- No hardcoded secrets (first pass)?
- No commented-out code, unrelated changes, or dead code added?

---

## Step 2 — security-analyst-agent (Security Lens)

**security-analyst-agent** reviews the same diff for security vulnerabilities.

Specifically checks:
- Secrets scan: API keys, tokens, passwords in code or config
- Input validation: any user input reaching the system without sanitisation?
- Dependencies: any new packages with known CVEs?
- Data handling: sensitive data logged, exposed, or stored insecurely?
- Auth/AuthZ: any endpoints or resources now accessible without proper checks?

Findings are categorised: CRITICAL/HIGH (blocking) | MEDIUM/LOW (backlog).

---

## Step 3 — qa-agent (Test Coverage Lens)

**qa-agent** reviews for test coverage and acceptance criteria.

Specifically checks:
- Tests exist for the changed functionality?
- Acceptance criteria from the story are met?
- Edge cases covered in tests?
- All UI/API states handled: loading, empty, error, success?
- Existing tests still pass?

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

**po-agent** collects all findings from steps 1–4 and produces the final verdict.

For each finding from any agent, po decides:
- **FIX NOW** — blocks merge. List as required change.
- **BACKLOG** — valid but not blocking. Add to `memory/BACKLOG.md` immediately with
  format: `STORY-XXX: [issue] — found in review of [story] — Added by: security/qa/etc`
- **WON'T FIX** — explain why and document reasoning inline.

---

## Final Output

```
CODE REVIEW
═══════════════════════════════════════════════════
Story:         STORY-XXX — [title]
Files changed: [n] | Lines: +[added] -[removed]

PR REVIEWER:   [PASS / ISSUES — summary]
SECURITY:      [CLEAN / FINDINGS — summary]
QA:            [PASS / GAPS — summary]
TECH LEAD:     [ALIGNED / CONCERNS — summary]

REQUIRED CHANGES (fix before merge):
  1. [specific change required]
  2. [specific change required]

ADDED TO BACKLOG:
  - STORY-XXX: [issue] [medium priority]
  - STORY-XXX: [issue] [low priority]

VERDICT: APPROVED | CHANGES REQUESTED
═══════════════════════════════════════════════════
```

If APPROVED: "Ready to commit. Format: `feat(area): description — closes STORY-XXX`"
If CHANGES REQUESTED: Address required changes, then re-run `/review`.
