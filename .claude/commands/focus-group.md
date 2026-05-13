# /focus-group — Simulate Users Experiencing a Feature

Usage: `/focus-group [feature name]`

Arguments: $ARGUMENTS

Simulate 5 different user personas experiencing the feature. Reveals UX blind spots.
po-agent synthesizes findings into backlog items so nothing is lost.

## Steps

1. Read the feature code/design to understand what was built.

2. **Simulate 5 personas experiencing the feature:**

   Each persona walks through the feature as if using it for the first time:

   **Persona 1 — Power User (Senior Dev)**
   Knows tools deeply. Wants keyboard shortcuts, speed, minimal clicks.

   **Persona 2 — New User (Junior Dev)**
   First time using a tool like this. Needs guidance, clear labels.

   **Persona 3 — Team Lead**
   Cares about team visibility, approval flows, oversight.

   **Persona 4 — Non-Technical Stakeholder**
   Reviewing output for approval. Needs plain English, not jargon.

   **Persona 5 — Security-Conscious User**
   Worried about what data is stored or shared. Reads every prompt.

3. For each persona, report:
   - First impression (5-second test)
   - Can they complete the task?
   - Where do they get confused?
   - What would they complain about?
   - What would they praise?

4. **qa-agent reviews findings:**
   - Are any acceptance criteria from the original story violated?
   - Do the confusion points represent missing edge case handling?
   - Any failure states not covered?

5. **po-agent synthesizes:**
   - Groups consensus issues (raised by 3+ personas)
   - Converts each issue into a backlog story or a quick fix
   - Gives final verdict
   - Writes non-blocking issues to `memory/BACKLOG.md`

## Output Format

```
FOCUS GROUP — [feature]
═══════════════════════════════════════
PERSONA 1: Power User
  First impression: [reaction]
  Task success:     [Y/N — where they got stuck]
  Complaint:        [main gripe]
  Praise:           [what they liked]

PERSONA 2: New User
  ...

[all 5 personas]

CONSENSUS ISSUES (3+ personas)
  - [issue]

QA FLAGS
  - [missing edge case or state]

QUICK WINS
  - [easy fixes that improve experience]

ADDED TO BACKLOG
  - STORY-XXX: [issue as story]

VERDICT: [SHIP / NEEDS WORK]
═══════════════════════════════════════
```
