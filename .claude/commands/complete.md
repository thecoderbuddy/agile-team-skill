---
description: Commit the approved story and close it — archive to ARCHIVE.md, update STATE.md and NEXT.md
argument-hint: STORY-XXX "description"
---

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

2. Confirm the story was reviewed and approved — look for evidence, not vibes:
   ```bash
   git status
   git diff --stat
   cat .claude/memory/CHECKPOINT.md 2>/dev/null   # should be gone — /review deletes it on APPROVED
   cat .claude/memory/NEXT.md
   ```
   Evidence of an APPROVED verdict: `.claude/memory/CHECKPOINT.md` no longer exists AND
   `.claude/memory/STATE.md` or `.claude/memory/NEXT.md` notes the story as APPROVED / ready to complete.
   If there is no evidence of an APPROVED `/review` verdict — warn the user
   ("No record of an APPROVED /review verdict for STORY-XXX") and ask them to explicitly
   confirm before continuing.
   If there are unexpected changes beyond what was reviewed — STOP and re-run `/review`.

3. **qa-agent records test evidence:**

   Before committing, append a `Test evidence:` line to the story's Definition of Done
   in `.claude/memory/BACKLOG.md`. Format:

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

4. **po-agent archives the story:**
   Perform the substeps in this exact order — the ordering matters because each step
   depends on the prior state of BACKLOG.md.

   1. Extract the story body from `.claude/memory/BACKLOG.md`:
      ```bash
      awk '/^- \[.\] STORY-XXX:/,/^---$/' .claude/memory/BACKLOG.md
      ```
      The `[.]` matches either `[ ]` or `[x]` so the extract works regardless of
      whether the checkbox has been marked yet.
   2. In the extracted text, change the leading `- [ ] STORY-XXX:` to `- [x] STORY-XXX:`
      and add a `Completed: [date]` line under the priority/added-by metadata.
   3. Append the marked extract to the end of `.claude/memory/ARCHIVE.md` verbatim. ARCHIVE.md
      is append-only — never edit or delete existing entries.
   4. Remove the story body block and the corresponding line in the `## Index` section
      from `.claude/memory/BACKLOG.md`.

5. **pm-agent updates state:**
   - Moves STORY-XXX from "In Progress" to "Done This Sprint" in `.claude/memory/STATE.md`
   - Updates velocity count (stories done / stories planned)
   - Overwrites `.claude/memory/NEXT.md` with the next logical action

6. Stage, get approval, and commit:

   Stage the code changes AND the .claude/memory/ file updates from Steps 3-5 (STATE.md, NEXT.md,
   ARCHIVE.md, BACKLOG.md) — they all go in the same story commit.

   Show the staged diff summary and ask before committing (Iron Rule 3):
   ```bash
   git add [relevant files + .claude/memory/STATE.md .claude/memory/NEXT.md .claude/memory/ARCHIVE.md .claude/memory/BACKLOG.md]
   git diff --stat --cached
   ```
   > "Approve commit? [Y/N]"

   Only on Y:
   ```bash
   git commit -m "feat(area): description — closes STORY-XXX"
   ```
   The commit body / PR description follows the **(PR)** sections of the
   "PR & Ticket Description Structure" in CLAUDE.md — test plan & evidence,
   risk & rollback, out of scope, links.

7. **dev-agent runs post-merge verification:**

   Run the Monitoring check from the commit/PR description (§14 of the PR & Ticket
   Description Structure) — the named log query, alert, dashboard, or test run.
   If the project has no deploy target, the result is "local-only — verified by test
   suite". Never skip silently — the result line always appears in the confirmation.

8. Show confirmation:

```
STORY COMPLETE
════════════════════════════════════════
Story:      STORY-XXX — [title]
Commit:     [hash]
QA:         passed (in /review)
Post-merge: [monitoring check + result | local-only — verified by test suite]
Velocity:   [n done] / [n planned]
════════════════════════════════════════
```

If more stories remain in the sprint → Run `/new-task` to pick up the next story.
If this was the last story → Run `/sprint-close` to close the sprint.
