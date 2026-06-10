# /complete — Commit and Close Story

Usage: `/complete STORY-XXX "description"`

Arguments: $ARGUMENTS

Run this after `/review` returns APPROVED. QA already passed in the review step.
This step commits the code and closes the story in STATE.md.

## Iron Rules
- Only run after `/review` gives APPROVED verdict
- Every completed story = one commit
- Commit format: `feat(area): description — closes STORY-XXX`

## Steps

1. Parse the story ID and description from arguments.

2. Confirm the story was reviewed and approved:
   ```bash
   git status
   git diff --stat
   ```
   If there are unexpected changes beyond what was reviewed — STOP and re-run `/review`.

3. **qa-agent records test evidence:**

   Before committing, append a `Test evidence:` line to the story's Definition of Done
   in `memory/BACKLOG.md`. Format:

   ```
   Test evidence: [what was tested] — [method: manual inspection | automated | visual review] — [result: PASS | FAIL] — [date]
   ```

   Examples:
   - `Test evidence: all 4 AC verified by reading changed files — manual inspection — PASS — 2026-06-09`
   - `Test evidence: visual review — README section rendered and read correctly — PASS — 2026-05-16`
   - `Test evidence: hook blocked sk- pattern in Write content; pass-through confirmed on clean write — manual inspection — PASS — 2026-06-09`

   If the story has no testable output (pure documentation):
   `Test evidence: visual review — [what was visually confirmed] — PASS — [date]`

   This line is added to the story's DoD section in BACKLOG.md, after the last `- [ ]` or `- [x]` checkbox.
   Do not skip this step — it is required before the commit is written.

4. **pm-agent updates state:**
   - Moves STORY-XXX from "In Progress" to "Done This Sprint" in `memory/STATE.md`
   - Updates velocity count (stories done / stories planned)
   - Overwrites `memory/NEXT.md` with the next logical action

5. Stage and commit:
   ```bash
   git add [relevant files]
   git commit -m "feat(area): description — closes STORY-XXX"
   ```

6. Show confirmation:

```
STORY COMPLETE
════════════════════════════════════════
Story:    STORY-XXX — [title]
Commit:   [hash]
QA:       passed (in /review)
Velocity: [n done] / [n planned]
════════════════════════════════════════
```

If more stories remain in the sprint → Run `/new-task` to pick up the next story.
If this was the last story → Run `/sprint-close` to close the sprint.
