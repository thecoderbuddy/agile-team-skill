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
- **Spec-level errors caught at review, not story time:** BUG-009 (relative path) and BUG-010 (magic number) were structural errors in the implementation spec that passed through /new-task unchanged. For any shell script story, verify path resolution (absolute vs relative) and constant naming before handing off to dev.
- **Discovery migrates upstream sprint over sprint:** Sprint 1 — issues discovered at dev time. Sprint 2 — issues discovered at review time. Goal: push all discoveries to /stories time. Check whether your spec answers: path form, threshold constants, regex coverage, boundary values.
- **Bug discovery migrates upstream sprint-by-sprint:** Sprint 1 = found at dev time; Sprint 2 = found at review time. Watch for this pattern and push discovery to /stories time.
- **Spec gates work but have blind spots:** After adding any spec gate, check the next sprint for bugs that passed through — they reveal what the gate's checklist missed.

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

---

## Sprint 2 Close — 2026-06-09
Velocity: 6/6 (100%) — all stories complete, no carry-overs

Shipped:
  - STORY-015: implementation notes gate in tech-lead-agent
  - STORY-010: security-analyst-agent upgraded to opus
  - STORY-016: test evidence record on /complete
  - STORY-011: Write/Edit content secret scan in pre-tool-use hook
  - STORY-006: gitleaks pre-commit secret scanning
  - STORY-007: security review scheduling and overdue flag in standup

Tech debt backlogged:
  BUG-009 (high urgency): relative gitleaks config path — breaks from subdirectories
  BUG-010: threshold as HTML comment, not named constant
  BUG-006/007/008: minor hook pattern gaps

Notes:
  - /security-review has never been run — will trigger overdue flag on first standup
  - Recommend BUG-009 as first priority in Sprint 3 sprint planning

---

## Sprint 2 Retro — 2026-06-09
Velocity: 6 planned → 6 completed (100%)

What we learned:
  - Sprint 1 process fixes held: STORY-015's implementation notes block meant no mid-sprint discoveries; test evidence (STORY-016) made QA sign-off traceable; DEC-003 held with no pivots
  - The failure mode moved upstream: discoveries shifted from dev time (Sprint 1) to review time (Sprint 2) — BUG-009 and BUG-010 were spec-level errors that passed through the implementation notes gate unchanged
  - Boundary-value test scenarios must be written at /stories time, not after QA flags fragility during review — BUG-010 (threshold as comment) was caught late because no boundary scenario existed for the 30-day constant
  - All 4 sprint bugs (BUG-007/008/009/010) were caught in /review, not before — review is working, but the spec gate is still too shallow for shell script and threshold stories
  - /security-review has never been run; all security coverage has been diff-level only — the full attack surface has not been assessed in two sprints
  - Hook coverage gaps pattern confirmed again: BUG-007 (sk- undocumented Stripe coverage) and BUG-008 (ghr_ missing) are textbook adjacent-vector misses

Changes next sprint:
  - Run /security-review before any new Sprint 3 stories begin — owned by security-analyst — not optional (STORY-007 overdue flag will trigger on first standup)
  - Add two items to tech-lead spec checklist: (1) shell script paths must be absolute/REPO_ROOT-relative; (2) numeric thresholds must be named constants, not inline literals — owned by tech-lead
  - Write boundary-value test scenarios (at-threshold, threshold-minus-1, zero) for any story with a numeric constant or configurable threshold at /stories time, before sprint entry — owned by qa-agent
  - Dev self-review checklist for shell hook stories before QA handoff: verify absolute paths (git rev-parse --show-toplevel), confirm regex patterns cover all known variants — owned by dev-agent
  - BUG-009 to be first story in Sprint 3 (high urgency — breaks any user running git commit from subdirectory)

---

## Sprint 2 Retro (synthesized) — 2026-06-09
Velocity: 6 planned → 6 completed (100%)

What we learned:
  - Process fixes from Sprint 1 retro worked immediately: STORY-015 implementation notes gate eliminated mid-sprint discoveries; STORY-016 test evidence format made QA sign-off unambiguous. The retro → backlog → sprint cycle produces real results within one sprint.
  - Bug discovery is moving upstream but not far enough: Sprint 1 bugs found at dev time, Sprint 2 bugs found at review time (BUG-007/008/009/010). Goal for Sprint 3: push all discovery to /stories time.
  - The spec checklist (STORY-015) works but has gaps: BUG-009 (relative path) and BUG-010 (magic number) are spec-level errors that passed through the gate. Two new checklist items needed: absolute paths + named constants (→ STORY-017).
  - /security-review has never run: two sprints of diff-level security review with no full-surface baseline. STORY-007 activates the overdue flag immediately. Run it before Sprint 3 stories start.
  - 100% velocity two sprints in a row with scope increase (4→6 stories): the team is calibrated.

Changes next sprint:
  - PROCESS-001: run /security-review before Sprint 3 sprint planning — owned by pm-agent
  - STORY-017: add shell path + named constant checks to tech-lead spec output — High priority
  - STORY-018: write boundary-value test scenarios at /stories time — High priority
  - STORY-019: dev self-review checklist for shell hook stories — High priority

## Security Review Log

[2026-06-09] Critical: 0  High: 0  Medium: 4  Low: 4  Verdict: NEEDS FIXES — First baseline review. New findings: BUG-013 (log injection LOW), BUG-014 (force-push bypass MEDIUM), BUG-015 (rm guard gap LOW), BUG-016 (SKIP_SECRET_SCAN scope LOW), BUG-017 (prompt injection surface MEDIUM), BUG-018 (curl-pipe integrity MEDIUM-supplement to BUG-011). Pre-existing tracked: BUG-009 HIGH (in sprint), BUG-011 MEDIUM, BUG-012 MEDIUM. No CRITICAL or HIGH new findings. PROCESS-001 gate cleared.
