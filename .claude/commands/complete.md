# /complete — Mark Task Done, Test, Commit

Usage: `/complete STORY-XXX "description"`

Arguments: $ARGUMENTS

## Iron Rules
- Never mark complete without passing tests (qa-agent hard veto)
- Every completed story = one commit
- Commit format: `feat(area): description — closes STORY-XXX`

## Steps

1. Parse the story ID and description from arguments.

2. Run all relevant tests for the project:
   ```bash
   # Run whatever test command is configured for this project
   # e.g. npm test, pytest, go test ./..., etc.
   git status
   ```

3. If tests fail — STOP. Do not commit. Fix the issue first.

4. If tests pass, check what files changed:
   ```bash
   git status
   git diff --stat
   ```

5. **Update memory/STATE.md** — reflect the completion (mark task done, update sprint progress).

6. **Update memory/NEXT.md** — overwrite with next logical action.

7. Stage and commit:
   ```bash
   git add [relevant files]
   git commit -m "feat(area): description — closes STORY-XXX"
   ```

8. Show confirmation:

```
STORY COMPLETE
────────────────
Story:    STORY-XXX
Commit:   [hash]
Tests:    passed
────────────────
Next: [what NEXT.md now says]
```
