---
description: Tech-lead + security architecture review before a complex build, with verdict and backlogged recommendations
argument-hint: [feature or area]
---

# /arch-review — Architecture Review Before Complex Build

Usage: `/arch-review [feature or area]`

Arguments: $ARGUMENTS

tech-lead-agent + security-analyst-agent review before complex builds.

## Steps

1. Read architectural context (bounded — never cat all of LEARNINGS.md):
   ```bash
   cat .claude/memory/DECISIONS.md
   grep -i -A 3 -E 'architect|design|stack|dependency|performance' .claude/memory/LEARNINGS.md | head -60
   ```
   If the grep yields nothing useful, read only the most recent sprint's section of
   LEARNINGS.md instead.

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

7. If new DEC-XXX decision needed, append to .claude/memory/DECISIONS.md.

8. **Persist the outcome (Iron Rule 4 — backlog everything):**
   - Every RECOMMENDATIONS item, and every item behind a NEEDS CHANGES or BLOCKED
     verdict, is written to .claude/memory/BACKLOG.md as a story (next STORY number from the
     `## Index`, standard story format with priority and complexity).
   - Add a matching line to the `## Index` for each story added.
   - The review output on screen is not the artifact — the BACKLOG.md entries are.
