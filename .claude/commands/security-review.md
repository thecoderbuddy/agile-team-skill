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

4. Log critical/high findings as DEC-XXX in DECISIONS.md. Log medium/low as BACKLOG.md stories.

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
