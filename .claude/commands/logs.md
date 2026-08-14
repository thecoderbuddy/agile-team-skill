---
description: Show a one-line summary of each memory file, or a specific log in detail
argument-hint: [decisions|learnings|backlog|state|next]
---

# /logs — Summary of Memory Files

Usage: `/logs [optional: specific log]`

Arguments: $ARGUMENTS

If no argument: show summary of all memory files.
If argument provided: show that specific file in detail.
If the argument is not one of the log types below: say it's not recognized and list the valid options (`decisions`, `learnings`, `backlog`, `state`, `next`) — do not guess.

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

1. If no argument — gather counts without reading full files (token discipline):
   ```bash
   grep -c '^## DEC-' memory/DECISIONS.md      # decision count
   tail -5 memory/DECISIONS.md                  # last decision topic
   grep -c '^## ' memory/LEARNINGS.md           # learnings count
   tail -5 memory/LEARNINGS.md                  # last learning topic
   sed -n '/^## Index/,/^---$/p' memory/BACKLOG.md   # index only — never cat the full backlog
   cat memory/STATE.md
   cat memory/NEXT.md
   ```
   Then show one-line summary each:
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

2. If a valid argument is provided — read that specific file and display contents:
   ```bash
   cat memory/[FILE].md
   ```
   Exception — `backlog`: read the Index only, never the full file:
   ```bash
   sed -n '/^## Index/,/^---$/p' memory/BACKLOG.md
   ```
   Extract a single story body with `awk '/^- \[.\] STORY-XXX:/,/^---$/'` only if the user asks about a specific story.

3. If the argument is anything else — respond:
   ```
   Unknown log "[argument]". Valid options: decisions, learnings, backlog, state, next.
   ```
