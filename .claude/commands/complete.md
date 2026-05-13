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

3. **pm-agent updates state:**
   - Moves STORY-XXX from "In Progress" to "Done This Sprint" in `memory/STATE.md`
   - Updates velocity count (stories done / stories planned)
   - Overwrites `memory/NEXT.md` with the next logical action

4. Stage and commit:
   ```bash
   git add [relevant files]
   git commit -m "feat(area): description — closes STORY-XXX"
   ```

5. Show confirmation:

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
