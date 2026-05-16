# /new-task — Full Autonomous Story Pipeline

One command. Agents plan, implement, review, and commit — end to end.
You only intervene if agents are blocked or a decision needs your input.

Arguments: $ARGUMENTS (optional story ID — skips selection if provided)

---

## Checkpoint Protocol

After **every agent step completes**, write to `memory/CHECKPOINT.md` before moving to the next step. This ensures recovery is possible if the session drops mid-chain.

Format:
```
Command: /new-task
Story: STORY-XXX
Started: [timestamp]
Last heartbeat: [timestamp] — Step N — [agent-name]

Steps:
  [DONE] Step 1 — po-agent — selected STORY-XXX
  [DONE] Step 2 — tech-lead-agent — spec written | not needed (S)
  [DONE] Step 3 — dev-agent — implementation complete
  [DONE] Step 4 — qa-agent — PASS | FAIL
  [IN_PROGRESS] Step 5 — pr-reviewer-agent
  [PENDING] Step 6 — security-analyst-agent
  [PENDING] Step 7 — tech-lead-agent (arch review)
  [PENDING] Step 8 — po-agent (verdict)
```

On chain completion (commit approved and written), delete `memory/CHECKPOINT.md`.

---

## Step 0 — Check for incomplete chain + read state

```bash
cat memory/CHECKPOINT.md 2>/dev/null  # check for incomplete prior run
cat memory/STATE.md
cat memory/NEXT.md
cat memory/BACKLOG.md
```

If `CHECKPOINT.md` exists and shows an incomplete `/new-task` chain:
- Show the user which steps completed and which didn't
- Ask: "Resume from Step N ([agent-name]), or start a new task?"
- If resuming: continue from the next uncompleted step, do not re-run completed steps

---

## Step 1 — po-agent selects the story

**po-agent** picks the next story:
- From NEXT.md if a specific story is noted there
- Otherwise: highest priority, unblocked, with testable AC from the sprint

If no stories are sprint-ready → tell user to run `/sprint-plan` first. Stop.

```
PO SELECTION
───────────────────────────────────────
Story:      STORY-XXX — [title]
Priority:   [High/Medium/Low]
User value: [one sentence]
AC ready:   YES / NO — [flag if missing, must resolve before continuing]
───────────────────────────────────────
```

---

## Step 2 — tech-lead-agent specs the story

**tech-lead-agent** reads `memory/DECISIONS.md` and the story, then:
- If complexity is M or higher → write a tech spec inline before dev starts
- If S or XS → one-line approach note is enough

```
TECH LEAD
───────────────────────────────────────
Complexity:   [XS/S/M/L/XL]
Spec needed:  YES → [write spec inline] | NO
DEC applies:  [DEC-XXX | none]
Approach:     [one sentence]
Files:        [list of files to create or modify]
───────────────────────────────────────
```

If spec is written, log any new architectural decisions as DEC-XXX in `memory/DECISIONS.md` before dev starts.

---

## Step 3 — dev-agent implements

**dev-agent** reads the story, acceptance criteria, and tech spec, then writes the code.

- Follow the approach from Step 2
- Implement ALL acceptance criteria — not just the happy path
- Write or update tests for any new functionality
- No TODO comments — if it's not done, it's not done

When implementation is complete, output:

```
DEV COMPLETE
───────────────────────────────────────
Files changed:  [list]
Tests written:  [yes — describe | no — why not]
AC addressed:   [list each criterion and how it's met]
───────────────────────────────────────
→ Handing off to QA
```

---

## Step 4 — qa-agent quality gate

**qa-agent** validates the implementation. This is a hard gate — nothing proceeds if it fails.

Checks:
- Tests exist for all new functionality?
- All acceptance criteria met (from the story in BACKLOG.md)?
- Edge cases covered: empty, error, loading, success states?
- Existing tests still pass?

```
QA GATE
───────────────────────────────────────
Tests:      [pass / FAIL — what's missing]
AC:         [met / FAIL — which criterion not met]
Edge cases: [covered / GAP — what's missing]
Result:     PASS | FAIL
───────────────────────────────────────
```

**If FAIL → go back to Step 3.** dev-agent addresses the gaps. QA re-validates.
If it fails a second time, flag to the user with a specific list of what's missing.
Do not proceed to code review until QA passes.

---

## Step 5 — pr-reviewer-agent reviews the code

**pr-reviewer-agent** reviews the full diff for correctness, style, performance, and maintainability.

```
PR REVIEWER
───────────────────────────────────────
Correctness:     [PASS | ISSUE — details]
Style:           [PASS | ISSUE — details]
Performance:     [PASS | ISSUE — details]
Maintainability: [PASS | ISSUE — details]

Inline comments:
  [file:line] — [comment]

Recommendation: APPROVE | REQUEST CHANGES
───────────────────────────────────────
```

---

## Step 6 — security-analyst-agent scans

**security-analyst-agent** scans the diff for vulnerabilities.

```
SECURITY
───────────────────────────────────────
Secrets:     [CLEAN | FOUND — details]
Input:       [CLEAN | RISK — details]
Deps:        [CLEAN | CVE — package, severity]
Auth/AuthZ:  [CLEAN | RISK — details]

Findings:
  CRITICAL/HIGH: [blocks — dev must fix]
  MEDIUM/LOW:    [→ BACKLOG.md]

Recommendation: APPROVE | BLOCK
───────────────────────────────────────
```

CRITICAL or HIGH findings → back to Step 3. dev-agent fixes. Full chain reruns from Step 4.

---

## Step 7 — tech-lead-agent architecture check

**tech-lead-agent** confirms the implementation aligns with established patterns.

```
TECH LEAD REVIEW
───────────────────────────────────────
Spec alignment:   [matches / DRIFT — details]
Pattern consistency: [aligned / INCONSISTENT — details]
Tech debt:        [none / INTRODUCED — log to BACKLOG?]
New DEC needed:   [yes — log DEC-XXX | no]

Recommendation: APPROVE | REQUEST CHANGES
───────────────────────────────────────
```

---

## Step 8 — po-agent verdict

**po-agent** collects all findings from Steps 5–7 and makes the final call.

For each finding:
- **FIX NOW** → blocks merge, dev fixes, chain reruns from Step 4
- **BACKLOG** → append to `memory/BACKLOG.md` as `STORY-BUG-XXX: [issue] — found during STORY-XXX`
- **WON'T FIX** → document reasoning inline

```
PO VERDICT — STORY-XXX
═══════════════════════════════════════════════════
QA:       PASS
Security: [CLEAN | n findings]
Review:   [APPROVE | n changes]
Arch:     [ALIGNED | notes]

REQUIRED CHANGES: [list | none]
BACKLOGGED:       [list | none]

VERDICT: APPROVED | CHANGES REQUESTED
═══════════════════════════════════════════════════
```

---

## Step 9 — If APPROVED: pm-agent closes and commits

**pm-agent**:
- Moves STORY-XXX to "Done This Sprint" in `memory/STATE.md`
- Updates velocity
- Writes `memory/NEXT.md` with the next story or `/sprint-close` if sprint is complete

Then show the user the exact commit that will be made and ask for approval:

```
READY TO COMMIT
───────────────────────────────────────
git add [files]
git commit -m "feat(area): [description] — closes STORY-XXX"

Approve commit? [Y/N]
───────────────────────────────────────
```

If approved → commit. Then:
- Sprint has more stories? → Automatically begin the next story from Step 1.
- Sprint complete? → "All stories done. Run /sprint-close."

---

## Step 9b — If CHANGES REQUESTED: dev-agent fixes

**dev-agent** addresses all FIX NOW items from the PO verdict.
→ Return to Step 4. Full review chain reruns automatically.

---

## Error States

| Situation | Action |
|---|---|
| No sprint active | Stop. "Run /sprint-plan first." |
| Story has no AC | Stop. "AC missing — run /stories STORY-XXX to add them." |
| QA fails twice | Pause. Show user exact gaps. Ask: "Fix manually or reprioritize?" |
| Security CRITICAL | Pause. Show finding. Ask user to confirm fix approach before dev proceeds. |
| Story is blocked | Stop. Show blocker. "Run /unblock STORY-XXX when resolved." |
