# /complete — Mark Story Done, Test, Commit

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

3. **qa-agent validates:**
   - Tests pass?
   - Acceptance criteria from the story met?
   - Any states unhandled (error, empty, loading)?
   - If any check fails — STOP. Do not commit. Fix the issue first.

4. If qa-agent approves, check what files changed:
   ```bash
   git status
   git diff --stat
   ```

5. **pm-agent updates state:**
   - Updates `memory/STATE.md` — marks story done, updates velocity
   - Overwrites `memory/NEXT.md` with the next logical action

6. Stage and commit:
   ```bash
   git add [relevant files]
   git commit -m "feat(area): description — closes STORY-XXX"
   ```

7. Show confirmation:

```
STORY COMPLETE
────────────────
Story:    STORY-XXX
Commit:   [hash]
QA:       passed
Next:     [what NEXT.md now says]
────────────────
```
