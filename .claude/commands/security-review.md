# /security-review — Full Security Audit

security-analyst-agent reviews the codebase. Run monthly or before major releases.

## Steps

1. Read architectural context:
   ```bash
   cat memory/DECISIONS.md
   ```

2. **security-analyst-agent scans:**
   - Dependency vulnerabilities: run `npm audit` / `pip-audit` / `bundle audit` (whichever fits stack)
   - Exposed secrets: scan for API keys, tokens, passwords hardcoded in source
   - Environment variables: all secrets in `.env`, none hardcoded?
   - Authentication: auth checks on all endpoints?
   - OWASP Top 10 check against codebase
   - Input validation: user input sanitised at all boundaries?
   - Data handling: PII handled correctly? Encryption at rest/transit?

3. **tech-lead-agent reviews:**
   - Any new DEC-XXX decisions triggered by findings?
   - Architecture-level exposure points?

4. Log ALL findings (any severity) as stories in BACKLOG.md, tagged with their severity (Critical / High / Medium / Low). Do not log findings themselves as DEC-XXX entries — DECISIONS.md is for architecture decisions only. If a finding reveals an architectural gap that requires a design decision, tech-lead-agent logs that decision as a DEC-XXX separately.

5. **Record the review in memory/STATE.md:**
   Overwrite the `## Last Security Review` section (the line beneath it) with:
   ```
   Last security review: YYYY-MM-DD — Critical: N  High: N  Medium: N  Low: N  — Verdict: VERDICT
   ```
   - `YYYY-MM-DD` is today's date in ISO 8601 format (use `currentDate` from session context — do NOT shell out)
   - `N` values are the integer counts from the scan above
   - `VERDICT` must be exactly one of: `SECURE`, `NEEDS FIXES`, or `CRITICAL ISSUES`

6. **Append a one-line summary to memory/LEARNINGS.md** under the `## Security Review Log` section.
   If the section does not exist, create it at the end of the file before appending.
   Format:
   ```
   [YYYY-MM-DD] Critical: N  High: N  Medium: N  Low: N  Verdict: VERDICT
   ```
   Use the same date, counts, and verdict as step 5. This section is append-only — never delete previous entries.

## Output Format

```
SECURITY REVIEW
═══════════════════════════════════════
DEPENDENCY AUDIT
  Critical: [count]  High: [count]  Medium: [count]
  Tool used: [npm audit / pip-audit / etc.]

SECRET SCAN
  [Pass / FOUND — details]

AUTHENTICATION
  [Pass / Concern — details]

OWASP TOP 10
  A01 Broken Access Control:    [Pass/Fail]
  A02 Cryptographic Failures:   [Pass/Fail]
  A03 Injection:                [Pass/Fail]
  A04 Insecure Design:          [Pass/Fail]
  A05 Security Misconfiguration:[Pass/Fail]
  A06 Vulnerable Components:    [Pass/Fail]
  A07 Auth Failures:            [Pass/Fail]
  A08 Data Integrity Failures:  [Pass/Fail]
  A09 Logging Failures:         [Pass/Fail]
  A10 SSRF:                     [Pass/Fail]

FINDINGS
  [numbered list: issue, severity, fix recommendation]

VERDICT: [SECURE / NEEDS FIXES / CRITICAL ISSUES]
═══════════════════════════════════════
```
