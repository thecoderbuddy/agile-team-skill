# /logs — Summary of Memory Files

Usage: `/logs [optional: specific log]`

Arguments: $ARGUMENTS

If no argument: show summary of all memory files.
If argument provided: show that specific file in detail.

## Log Types

| Argument | File | What it shows |
|----------|------|---------------|
| (none) | all | One-line summary of each memory file |
| `decisions` | DECISIONS.md | All architecture decisions DEC-XXX |
| `learnings` | LEARNINGS.md | All captured lessons |
| `backlog` | BACKLOG.md | Current backlog with priorities |
| `state` | STATE.md | Current sprint and project state |
| `next` | NEXT.md | Exact next action |

## Steps

1. If no argument — read all files and show one-line summary each:
   ```
   MEMORY SUMMARY
   ════════════════════
   Decisions:  [count] entries — last: DEC-XXX [topic]
   Learnings:  [count] entries — last: [topic]
   Backlog:    [count] stories — [X] ready, [Y] needs grooming
   State:      Sprint [N] — [status]
   Next:       [first line of NEXT.md]
   ════════════════════
   Type /logs [name] for details.
   ```

2. If argument provided — read that specific file and display contents:
   ```bash
   cat memory/[FILE].md
   ```
