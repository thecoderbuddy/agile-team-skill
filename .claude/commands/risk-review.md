# /risk-review — Review and Update Risk Register

Review active risks, mitigations, and add new risks. Run monthly or before major releases.

## Steps

1. Read decision and learning context:
   ```bash
   cat memory/DECISIONS.md
   cat memory/LEARNINGS.md
   cat memory/STATE.md
   ```

2. **tech-lead-agent identifies technical risks:**
   - New dependencies, architecture gaps, tech debt accumulation
   - Performance bottlenecks or scalability concerns
   - Missing test coverage areas

3. **security-analyst-agent identifies security risks:**
   - Exposed secrets or misconfigured auth
   - New attack surface from recent changes
   - Dependency vulnerabilities: run `npm audit` or `pip-audit` or equivalent

4. **po-agent identifies product risks:**
   - Feature gaps that block user value
   - Persona needs unmet
   - Sprint velocity risks

5. Show the risk review:

```
RISK REVIEW
═══════════════════════════════════════
HIGH
  RISK-XXX: [description] — Likelihood: [H/M/L] Impact: [H/M/L]
    Mitigation: [what we're doing]
    Owner: [which agent / team member]

MEDIUM
  ...

LOW
  ...

NEW RISKS IDENTIFIED
  - RISK-XXX: [description + mitigation plan]

RESOLVED SINCE LAST REVIEW
  - [what got resolved and how]
═══════════════════════════════════════
Log new risks in DECISIONS.md (DEC-XXX) if they require an architectural decision.
```
