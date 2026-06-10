# Team Learnings
# Append-only — never delete entries.
# Updated by: pm-agent at every /retro
# Read by: all agents before starting work in a new area

---

## Format

```
## Sprint [N] Retro — [date]
Velocity: [planned] → [completed] ([%])

What we learned:
  - [lesson — specific enough to act on]
  - [lesson]

Changes next sprint:
  - [change] — owned by [agent]
  - [change] — owned by [agent]
```

---

## Patterns to watch for

As learnings accumulate, add recurring patterns here so agents check before starting work:

- **Implicit implementation assumptions:** When a story reads shell output or uses env vars, flags and sanitisation requirements are often discovered during dev, not during story writing. Always make them explicit in tech notes before dev starts.
- **Hook coverage gaps:** Security hooks tend to cover the most obvious attack vector but miss adjacent ones. After writing any security hook, explicitly ask: "what can an agent do that bypasses this check?"

---

## Sprint 1 Retro — 2026-06-09
Velocity: 4 planned → 4 completed (100%)

What we learned:
  - The review chain works: 5 bugs surfaced across 4 stories, none were regressions, all were caught before merge
  - Stories reaching dev without enough implementation context caused mid-sprint discoveries (--no-color flag in STORY-003, sanitisation requirements implicit not explicit)
  - The pre-tool-use.sh hook gives false security confidence: it checks bash redirection but not Write/Edit tool content — an agent could write a hardcoded key undetected
  - Any story that reads shell output or user-controlled input needs an explicit sanitisation checkpoint in tech notes before dev starts — this was implicit, should be explicit
  - DEC-first approach paid off: writing DEC-001 before STORY-001 started made the architecture unambiguous; no mid-sprint pivots needed
  - Test evidence exists only in agent memory, not in artifacts — "tests pass" is asserted but not traceable

Changes next sprint:
  - tech-lead-agent adds implementation notes block (flags, sanitisation, env validation) to /new-task and /stories — owned by tech-lead (STORY-015)
  - /complete adds a one-line test evidence note to story DoD — owned by qa-agent (STORY-016)
  - STORY-011 promoted to High priority: Write/Edit content secret scan is a real gap, not a nice-to-have
  - Sprint 2 theme: security hardening (STORY-006, STORY-007, STORY-011, STORY-015)
