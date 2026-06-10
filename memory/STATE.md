# Sprint State
# Owned by: pm-agent (Scrum Master)
# Updated after every: standup, sprint-plan, sprint-close

Sprint: 3
Goal: Close Sprint 2 shell-hook bug root causes — fix live gitleaks path, harden spec/dev/QA checklists, patch hook pattern gaps
Status: ACTIVE
Started: 2026-06-09
Ends: 2026-06-16

## Pre-condition (blocking gate)
PROCESS-001: /security-review must complete before any story moves to IN_PROGRESS.
Owned by: pm-agent. Status: PENDING.
No story work begins until this gate clears.

## In Progress
[None — awaiting PROCESS-001 gate]

## Sprint Stories (execution order)
- [x] BUG-009: Fix relative .gitleaks.toml path in pre-commit.sh — S — High [DONE — APPROVED 2026-06-09]
- [x] STORY-017: Tech-lead spec checklist — absolute paths + named constants — XS — High [DONE — APPROVED 2026-06-09]
- [ ] STORY-019: Dev self-review checklist for shell hook stories — XS — High
- [ ] STORY-018: QA boundary-value scenarios at /stories time — XS — High
- [ ] BUG-007 + BUG-008: ghr_ pattern + Stripe comment in pre-tool-use.sh (batched) — XS — Medium
- [ ] STORY-013: /summary command — XS — Low [FLEX]

## Done This Sprint
- [x] BUG-009: Fix relative .gitleaks.toml path in pre-commit.sh — APPROVED 2026-06-09 — full review chain (qa, pr-reviewer, security, tech-lead, po) — no required changes
- [x] STORY-017: Tech-lead spec checklist — absolute paths + named constants — APPROVED 2026-06-09 — full review chain — 2 fixes in PR review round
- [x] STORY-020..025: Token-discipline maintenance work (out-of-plan) — APPROVED 2026-06-10 — full /review chain (cycle 1 → 2) — 6 fixes applied in cycle 2; shipped in d1a3ecd

## Blockers
[None]

## Velocity
Stories planned: 6 (5 core + 1 flex)
Stories done: 2 planned + 6 out-of-plan maintenance (STORY-020..025) = 8 total
Sprint capacity: ~1 working day (~2 hours active work)

## Agent Notes
- Security: BUG-009 is ELEVATED RISK — ships before any gitleaks testing occurs on other stories. PROCESS-001 gate must clear first.
- Tech: BUG-009 fix is single-line — replace relative .gitleaks.toml path with --config "$(git rev-parse --show-toplevel)/.gitleaks.toml". STORY-017 is prompt-only change to tech-lead-agent.md.
- Dev: BUG-007+BUG-008 batched — single pre-tool-use.sh edit. STORY-013 is flex — drop if sprint runs long.
- QA: BUG-007 DoD requires Stripe language precision (sk_live_, sk_test_). BUG-008 DoD requires positive+negative ghr_ test. Both DoD blocks now in BACKLOG.md.
- All stories are prompt/instruction or single-file hook changes — no new infrastructure.
- Release note (BUG-009): CHECKSUMS.sha256 must be regenerated for pre-commit.sh per DEC-005 before next public release. Tracked under BUG-011.

## Last Security Review
2026-06-09 — Critical: 0  High: 0  Medium: 4  Low: 4  — Verdict: NEEDS FIXES
Run by: security-analyst-agent (baseline /security-review)
Findings: BUG-013 (LOW), BUG-014 (MEDIUM), BUG-015 (LOW), BUG-016 (LOW), BUG-017 (MEDIUM), BUG-018 (MEDIUM-supplement)
Previously known: BUG-009 (HIGH — live defect, in sprint), BUG-011 (MEDIUM), BUG-012 (MEDIUM)
Next review due: 2026-07-09

---

## Status values
- PLANNING — sprint is being planned, not started
- ACTIVE   — sprint in progress
- REVIEW   — sprint work done, in /review phase
- CLOSED   — sprint complete, retro run
