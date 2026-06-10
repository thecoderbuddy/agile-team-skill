# Sprint State
# Owned by: pm-agent (Scrum Master)
# Updated after every: standup, sprint-plan, sprint-close

Sprint: 2
Goal: Harden agile-team-skill's security posture — close the Write-tool leak gap,
      add pre-commit secret scanning, track security review cadence, and lock in
      two quick retro process fixes.
Status: ACTIVE
Started: 2026-06-09
Ends: 2026-06-16

## In Progress
[None]

## Sprint Stories (execution order)
- [x] STORY-015: Story readiness gate — implementation notes block — XS — High
- [x] STORY-010: Security agent → opus default model — XS — Medium
- [ ] STORY-016: Test evidence record on story close — XS — Medium [FLEX — drops if sprint runs long]
- [ ] STORY-011: pre-tool-use.sh Write/Edit content secret scan — S — High
- [ ] STORY-006: Pre-commit secret scanning with gitleaks — S — High
- [ ] STORY-007: Security review scheduling — overdue flag in standup — S — High

## Done This Sprint
- [x] STORY-015: Story readiness gate — implementation notes block (2026-06-09)
- [x] STORY-010: Security agent → opus default model (2026-06-09)

## Blockers
[None]

## Velocity
Stories planned: 6 (5 core + 1 flex)
Stories done: 2

## Agent Notes
- Tech: DEC-003 (gitleaks selection) must be written before STORY-006 starts | STORY-011 uses existing hook infrastructure at line 61-87 of pre-tool-use.sh | Execution order: 015 → 010 → 016 → 011 → 006 → 007
- Security: STORY-011 block message must never log matched secret value — test this explicitly | STORY-006 gitleaks version must be pinned, not "latest" | gitleaks config file needs security review before commit
- QA: STORY-011 needs adversarial test of block output format | STORY-006 "tool not installed" path needs explicit test | STORY-016 is flex story

## Last Security Review
[Never run]

---

## Status values
- PLANNING — sprint is being planned, not started
- ACTIVE   — sprint in progress
- REVIEW   — sprint work done, in /review phase
- CLOSED   — sprint complete, retro run
