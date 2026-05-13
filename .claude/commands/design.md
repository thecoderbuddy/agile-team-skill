# /design — Full Design: Flow + Spec + Agent Review

Usage: `/design [feature name]`

Arguments: $ARGUMENTS

Complete design process before any code is written.

## Steps

1. Read context:
   ```bash
   cat memory/STATE.md
   cat memory/DECISIONS.md
   ```

2. **po-agent leads the process:**

   **Step A — Empathy Map:**
   - Who is this for? (which user persona from your project)
   - What do they think/feel/do today without this feature?
   - What's the pain point this solves?

   **Step B — User Flow:**
   - Entry point → steps → success state
   - Error states and edge cases
   - ASCII flow diagram

   **Step C — Component Spec:**
   - Which UI components are needed
   - Layout at key breakpoints (mobile, tablet, desktop)
   - State management — what state does this feature need?
   - Data flow (API calls, data sources)

3. **tech-lead-agent adds Technical Spec:**
   - Files to create/modify
   - API endpoints needed
   - Data models affected
   - Integration points with existing systems

4. **Agent review round:**
   - po-agent: Does this match user needs?
   - tech-lead-agent: Technically feasible within stack?
   - qa-agent: How will this be tested?
   - security-analyst-agent: Any security implications?

5. Show the design:

```
DESIGN — [feature]
═══════════════════════════════════════
EMPATHY
  Persona: [who]
  Pain:    [what hurts today]
  Goal:    [what success looks like]

USER FLOW
  [ASCII flow diagram]

COMPONENTS
  [component list with layout notes]

TECHNICAL SPEC
  Files:    [list]
  APIs:     [endpoints]
  State:    [what state is needed]
  Models:   [data models]

AGENT REVIEW
  po:       [verdict]
  tech:     [verdict]
  qa:       [verdict]
  security: [verdict]
═══════════════════════════════════════
Approved to build? [Y/N]
```
