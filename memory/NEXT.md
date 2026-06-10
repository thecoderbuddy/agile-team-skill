# Next Action
# Owned by: pm-agent (Scrum Master)
# Overwrite this at the end of every session with the single most specific next step.
# Written precisely enough that zero context is needed to continue.

Sprint: 3
Updated: 2026-06-09

Type: STORY
Story: STORY-019

## Exact Next Step
Run /new-task for STORY-019 — Dev self-review checklist for shell hook stories.

This is the next story in Sprint 3 execution order (after STORY-017 done).
File to change: .claude/agents/dev-agent.md
Change: add two-item shell hook self-review checklist to the pre-QA handoff step:
  1. All paths in the hook are absolute or resolved via git rev-parse --show-toplevel — no CWD assumptions
  2. Every regex pattern has been verified against at least one positive match and one negative match
Checklist is scoped to shell hook files only; N/A for non-hook stories.

## Sprint 3 remaining
- [ ] STORY-019: Dev self-review checklist for shell hook stories — XS — High
- [ ] STORY-018: QA boundary-value scenarios at /stories time — XS — High
- [ ] BUG-007 + BUG-008: ghr_ pattern + Stripe comment in pre-tool-use.sh — XS — Medium
- [ ] STORY-013: /summary command — XS — Low [FLEX]
