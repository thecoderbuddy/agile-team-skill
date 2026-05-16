# /resume — Pick Up After Rate Limit or Session Drop

**First command after any interruption** — rate limit reset, session drop, or context loss.
Restores full context and recovers any incomplete agent chain automatically.

---

## Step 1 — Check for incomplete chain

```bash
cat memory/CHECKPOINT.md 2>/dev/null
```

If `CHECKPOINT.md` exists:

```
INCOMPLETE CHAIN DETECTED
─────────────────────────────────────────
Command:   [/review | /new-task | /bug]
Story:     STORY-XXX
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
