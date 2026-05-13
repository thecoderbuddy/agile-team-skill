# /ux-review — Critical UX Review of Existing UI

Usage: `/ux-review [page or component]`

Arguments: $ARGUMENTS

po-agent + qa-agent critically review built UI against usability principles.

## Steps

1. Read the target page/component code.

2. **po-agent reviews from the user perspective:**
   - Does this serve the persona it was designed for?
   - Is the primary action obvious within 5 seconds?
   - Does it match the user story acceptance criteria?

3. **qa-agent reviews against quality criteria:**
   - **Consistency**: Does it match the rest of the UI (patterns, naming, layout)?
   - **Responsiveness**: Works across different screen sizes?
   - **Accessibility**: Keyboard nav, contrast, aria labels?
   - **Empty states**: What shows when there's no data?
   - **Error states**: What shows when something fails?
   - **Loading states**: Feedback while data loads?
   - **Information hierarchy**: Is the most important thing most visible?
   - **Cognitive load**: Can a new user understand this immediately?

4. **Rate each criterion**: Pass / Needs Work / Fail

5. Show the review:

```
UX REVIEW — [page/component]
═══════════════════════════════════════
PERSONA CHECK
  Designed for: [persona]
  Primary action clear: [Y/N — note]
  AC met: [Y/N]

QUALITY CHECKLIST
  Consistency:     [Pass/Needs Work/Fail] — [note]
  Responsiveness:  [Pass/Needs Work/Fail] — [note]
  Accessibility:   [Pass/Needs Work/Fail] — [note]
  Empty states:    [Pass/Needs Work/Fail] — [note]
  Error states:    [Pass/Needs Work/Fail] — [note]
  Loading states:  [Pass/Needs Work/Fail] — [note]
  Hierarchy:       [Pass/Needs Work/Fail] — [note]
  Cognitive load:  [Pass/Needs Work/Fail] — [note]

FIXES NEEDED
  1. [specific fix]
  2. [specific fix]
  ...

VERDICT: [APPROVED / NEEDS FIXES]
═══════════════════════════════════════
```
