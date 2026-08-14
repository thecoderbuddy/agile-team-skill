---
description: Restore context after a rate limit or session drop — recover any incomplete agent chain from CHECKPOINT.md
---

# /resume — Pick Up After Rate Limit or Session Drop

**First command after any interruption** — rate limit reset, session drop, or context loss.
Restores full context and recovers any incomplete agent chain automatically.

---

## Step 1 — Check for incomplete chain

```bash
cat memory/CHECKPOINT.md 2>/dev/null
```

If `CHECKPOINT.md` exists, validate it before acting on it (see DEC-002 and the
Checkpoint Protocol section in CLAUDE.md — the canonical format):

**Valid checkpoint** — must contain `Command:` and either `Story:` OR `Bug:` (`/bug` chains write `Bug: [slug]` instead of `Story:`), plus `Started:`, `Last heartbeat:`, and a `Steps:` block with at least one entry. If the file is empty or any required field is missing → corrupt.

**Corrupt checkpoint** — do NOT delete silently. Show the file contents to the user and ask:

```
CORRUPT CHECKPOINT
─────────────────────────────────────────
[contents of memory/CHECKPOINT.md]
─────────────────────────────────────────
This checkpoint is missing required fields and cannot be resumed.
Delete it and proceed with a normal resume? [Y / N — keep the file]
```

On Y → delete and proceed to Step 2. On N → keep the file and proceed to Step 2.

**Stale checkpoint** — for `Story:` checkpoints: if the Story ID already appears in the "Done This Sprint" list in `memory/STATE.md` → the chain already completed. For `Bug:` checkpoints, this check does not apply — instead check whether the bug's fix commit already exists (`git log --oneline -10 | grep -i fix`); if inconclusive, treat as recoverable. If stale, show it and ask [Y/N] before deleting (same prompt as corrupt), then proceed to Step 2.

**Recoverable checkpoint** — valid, story not yet done:

```
INCOMPLETE CHAIN DETECTED
─────────────────────────────────────────
Command:   [/review | /new-task | /bug]
Story:     STORY-XXX   (or Bug: [slug] for /bug chains)
Started:   [timestamp]
Last heartbeat: [timestamp] — Step N — [agent-name]
Interruption:  [rate limit | host sleep suspected (gap > 5 min) | unknown]

Completed: Step 1 — qa-agent — PASS
           Step 2 — pr-reviewer-agent — APPROVE
Stopped:   Step 3 — security-analyst-agent — NOT STARTED
Pending:   Step 4 — tech-lead-agent
           Step 5 — po-agent
─────────────────────────────────────────
Resume from Step 3 (security-analyst-agent)? [Y / N — start fresh]
```

**Interruption classification:**
- If gap between `Last heartbeat` and now is < 2 minutes → likely rate limit reset
- If gap is > 5 minutes → host sleep suspected (Mac lid closed, screensaver sleep)
- Either way: chain state is preserved in CHECKPOINT.md — resume is safe

If user confirms resume → continue the chain from the first `[PENDING]` or `[IN_PROGRESS]` step.
Do not re-run `[DONE]` steps — trust the checkpoint.

If `CHECKPOINT.md` does not exist → proceed to Step 2 (normal resume).

---

## Step 2 — Read current state

```bash
cat memory/NEXT.md
cat memory/STATE.md
git log --oneline -5
```

---

## Step 3 — Output and continue

```
RESUMING SESSION
─────────────────────────────────────────
Incomplete chain: [YES — resuming /review Step N | NO]
Next action:      [from NEXT.md]
Sprint:           [goal + status from STATE.md]
Last commits:     [git log]
─────────────────────────────────────────
```

Then immediately continue the work. Do not ask "what should we work on?" — the answer is in NEXT.md or CHECKPOINT.md.
