# /resume — Pick Up After Rate Limit Reset

**FIRST command after any rate limit reset.** Restores full context without re-reading everything manually.

## Steps

1. Read the exact pickup point:
   ```bash
   cat memory/NEXT.md
   ```

2. Read current project state:
   ```bash
   cat memory/STATE.md
   ```

3. Read recent commits for ground truth:
   ```bash
   git log --oneline -5
   ```

## Output Format

```
RESUMING SESSION
────────────────
Next action:  [from NEXT.md]
Sprint:       [from STATE.md]
Last commits: [from git log]
────────────────
Continuing from where we left off.
```

Then immediately continue the work described in NEXT.md. Do not ask "what should we work on?" — the answer is in NEXT.md.
