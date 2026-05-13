# /focus-group — Simulate Users Experiencing a Feature

Usage: `/focus-group [feature name]`

Arguments: $ARGUMENTS

Simulate 5 different user personas experiencing the feature. Reveals UX blind spots.

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
   Reviewing code changes for approval. Needs plain English.

   **Persona 5 — Security-Conscious User**
   Worried about what data leaves their machine. Reads every permission dialog.

3. For each persona, report:
   - First impression (5-second test)
   - Can they complete the task?
   - Where do they get confused?
   - What would they complain about?
   - What would they praise?

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

CONSENSUS ISSUES
  - [issues raised by 3+ personas]

QUICK WINS
  - [easy fixes that improve experience]

VERDICT: [SHIP / NEEDS WORK]
═══════════════════════════════════════
```
