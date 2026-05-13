# /bug — Report a Broken or Missing Feature

Usage: `/bug [describe the issue]`

Arguments: $ARGUMENTS

## Steps

1. Parse the bug description from arguments.

2. Read current state:
   ```bash
   cat memory/STATE.md
   git log --oneline -5
   ```

3. **qa-agent investigates:**
   - Reproduce the issue (check code, run relevant tests)
   - Classify: bug (broken) vs gap (missing) vs regression
   - Severity: SEV-1 (blocking) / SEV-2 (painful) / SEV-3 (cosmetic) / SEV-4 (minor)
   - Root cause hypothesis

4. **tech-lead-agent assesses:**
   - Fix complexity (S/M/L)
   - Which files/components affected?
   - Risk of fix introducing regressions?

5. Show the bug report:

```
BUG REPORT
════════════════════
Description: [the bug]
Type:        [bug / gap / regression]
Severity:    [SEV-1/2/3/4]
Complexity:  [S/M/L]
Component:   [which area of code]
Root cause:  [hypothesis]

FIX APPROACH
  [what needs to change]

RECOMMENDATION
  [fix now / add to sprint / add to backlog]
════════════════════
```

6. If SEV-1 or SEV-2, ask: "This is high severity. Fix now? [Y/N]"

7. If adding to backlog, append the story to memory/BACKLOG.md.
