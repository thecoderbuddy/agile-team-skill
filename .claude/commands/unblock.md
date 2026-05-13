# /unblock — Clear a Blocker

Usage: `/unblock STORY-XXX "what was blocking and how it's resolved"`

Arguments: $ARGUMENTS

Run when a blocked story is ready to move again.
Blockers are logged in STATE.md during `/standup` — this command clears them.

## Steps

1. Parse the story ID and resolution description from arguments.

2. Read current state:
   ```bash
   cat memory/STATE.md
   ```

3. **tech-lead-agent confirms the blocker is resolved:**
   - Is the blocking dependency now available?
   - Is the architectural question answered?
   - Does the resolution introduce any new risk?
   - If a decision was made to unblock → log it as DEC-XXX in `memory/DECISIONS.md`

4. **pm-agent updates STATE.md:**
   - Removes the blocker from the BLOCKERS section
   - Confirms STORY-XXX remains "In Progress"
   - Overwrites `memory/NEXT.md` with the exact next implementation step

5. Show confirmation:

```
BLOCKER CLEARED
════════════════════════════════════════
Story:      STORY-XXX — [title]
Was blocked: [what the blocker was]
Resolved:   [how it was resolved]
Decision:   [DEC-XXX logged / no decision needed]

STATE.md:   blocker removed ✓
NEXT.md:    [exact next step for dev]
════════════════════════════════════════
```

Ready to continue → Run `/new-task` to re-confirm the assignment, or continue directly if context is clear.
If a decision was made → Run `/adr` to document it properly.
