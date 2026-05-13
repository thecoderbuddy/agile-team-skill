# /discover — Discovery Session Before Writing Stories

Usage: `/discover [feature name]`

Arguments: $ARGUMENTS

Deep dive before committing to build. Understand the problem space first.

## Steps

1. Read context:
   ```bash
   cat memory/STATE.md
   cat memory/DECISIONS.md
   ```

2. **po-agent leads discovery:**
   - Who is this for? (specific persona)
   - What problem does this solve?
   - How do they solve it today (without this tool)?
   - What's the smallest thing we can build to validate?
   - What's explicitly out of scope?
   - How do competitors / other tools handle this? (use WebSearch if helpful)

3. **tech-lead-agent assesses:**
   - What exists in our codebase that already supports this?
   - What's missing or needs to be built?
   - Technical risks or unknowns?
   - Any DEC-XXX decisions that constrain the approach?

4. **security-analyst-agent flags early risks:**
   - Does this feature touch user data, auth, or external APIs?
   - Any privacy or data handling concerns to design around from the start?

5. Show discovery output:

```
DISCOVERY — [feature]
═══════════════════════════════════════
PERSONA:     [who]
PROBLEM:     [what hurts]
CURRENT FIX: [how they solve it today]
OUR ANGLE:   [why your solution is better]

SCOPE
  In:  [what we'll build]
  Out: [what we won't build]

COMPETITIVE LANDSCAPE
  [how others handle it — po-agent research]

TECHNICAL ASSESSMENT
  Exists: [what we already have]
  Needed: [what we need to build]
  Risks:  [unknowns]

SECURITY EARLY FLAGS
  [data handling, auth, privacy concerns — or "none"]

NEXT STEP
  [/stories or /design]
═══════════════════════════════════════
```
