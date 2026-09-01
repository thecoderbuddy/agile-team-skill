---
description: Clear a blocker — tech-lead confirms resolution, pm removes it from STATE.md BLOCKERS and updates NEXT.md
argument-hint: "STORY-XXX \"what was blocking and how it's resolved\""
---

# /unblock — Clear a Blocker

Usage: `/unblock STORY-XXX "what was blocking and how it's resolved"`

Arguments: $ARGUMENTS

Run when a blocked story is ready to move again.
Blockers are logged in STATE.md during `/standup` — this command clears them.

## Steps

1. Parse the story ID and resolution description from arguments.

2. Read current state:
   ```bash
   cat .claude/memory/STATE.md
   cat .claude/memory/TEAM.md   # roster — senior-engineer pairs on technical blockers if ACTIVE
   ```

3. **tech-lead-agent confirms the blocker is resolved:**
   - Is the blocking dependency now available?
   - Is the architectural question answered?
   - Does the resolution introduce any new risk?
   - If a decision was made to unblock → log it as DEC-XXX in `.claude/memory/DECISIONS.md`

   **If the blocker is NOT yet resolved** and it is technical (not a requirements or
   priority question) and senior-engineer-agent is ACTIVE in the roster:
   senior-engineer pairs with dev to reproduce, isolate, and clear it — then appends
   one LEARNINGS.md entry (symptom → root cause → recognition pattern) and this
   command resumes at this step with the resolution.

4. **pm-agent updates STATE.md:**
   - Removes the blocker from the BLOCKERS section
   - Confirms STORY-XXX remains "In Progress"
   - Overwrites `.claude/memory/NEXT.md` with the exact next implementation step

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

## Error States

| Situation | Action |
|---|---|
| Story not found in STATE.md BLOCKERS | List the current blockers from STATE.md and stop. |
| Empty $ARGUMENTS | Ask which story to unblock (show the BLOCKERS list). |
| Story was blocked before it ever started | Return it to the Sprint Backlog section instead of "In Progress". |
