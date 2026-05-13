# /arch-review — Architecture Review Before Complex Build

Usage: `/arch-review [feature or area]`

Arguments: $ARGUMENTS

tech-lead-agent + security-analyst-agent review before complex builds.

## Steps

1. Read architectural context:
   ```bash
   cat memory/DECISIONS.md
   cat memory/LEARNINGS.md
   ```

2. Read relevant code in the area being reviewed.

3. **tech-lead-agent reviews:**
   - Does this fit the project's tech stack and conventions?
   - Does it violate any DEC-XXX decisions?
   - Data flow: where does data enter, transform, exit?
   - Performance: will this scale? Any N+1 risks?
   - Code organisation: right directory, right abstraction level?
   - Dependencies: minimal new deps? Any risks?
   - Error handling: graceful degradation?

4. **security-analyst-agent reviews:**
   - Attack surface: any new security exposure?
   - Data handling: PII or sensitive data involved?
   - Auth: access controls correct?
   - Input validation: are all boundaries covered?

5. **Produce DEC-XXX if needed** — any new architectural decision gets logged.

6. Show the review:

```
ARCHITECTURE REVIEW — [feature/area]
═══════════════════════════════════════
STACK COMPLIANCE:  [Pass/Violation]
DEC COMPLIANCE:    [Pass/Violation — which DEC]
DATA FLOW:         [diagram or description]
SECURITY:          [Pass/Concern — details]
PERFORMANCE:       [Pass/Concern — details]

CODE ORGANISATION
  [assessment]

NEW DECISIONS NEEDED
  DEC-XXX: [decision if any]

RECOMMENDATIONS
  1. [specific recommendation]
  ...

VERDICT: [APPROVED / NEEDS CHANGES / BLOCKED]
═══════════════════════════════════════
```

7. If new DEC-XXX decision needed, append to memory/DECISIONS.md.
