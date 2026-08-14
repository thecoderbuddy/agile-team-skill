---
description: Review the risk register (memory/RISKS.md) — update existing risks, append new ones, mark resolved
---

# /risk-review — Review and Update Risk Register

Review active risks, mitigations, and add new risks. Run monthly or before major releases.
The risk register lives in `memory/RISKS.md` — this command reads it first and writes updates back.

## Steps

1. Read the risk register and context:
   ```bash
   cat memory/RISKS.md
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

5. Compare findings against the register read in step 1:
   - Existing risks still open → keep, reassess Likelihood/Impact/Mitigation.
   - Register risks no longer applicable → these are RESOLVED SINCE LAST REVIEW.
   - Findings not in the register → NEW RISKS (assign the next RISK-XXX ID).

6. Show the risk review:

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
  - RISK-XXX: [what got resolved and how]
═══════════════════════════════════════
```

7. **Write updates back to memory/RISKS.md:**
   - Append one table row per new RISK-XXX.
   - For existing rows, update Status (`Open` / `Mitigating` / `Resolved`) and the
     Last-reviewed date in place. Never delete rows — resolved risks stay in the
     table with `Status: Resolved`.

Risks live in memory/RISKS.md, NOT in DECISIONS.md — DECISIONS.md is for
architecture decisions only. Only if a risk mitigation causes an architecture
decision does tech-lead-agent create a DEC-XXX entry for that decision.
