# Product Backlog
# Owned by: po-agent (Product Owner)
# Stories are added here by: /stories, /retro (action items), /review (non-blocking findings)
# Groomed by: /backlog
# Stories enter a sprint via: /sprint-plan

---

## High Priority

- [ ] STORY-001: Session continuity — recover from host sleep mid-chain
  Priority: High
  Added by: po-agent on 2026-05-16

  As a developer running a long agent chain,
  I want the chain to pause gracefully if the host sleeps and resume cleanly next session,
  So that no work is silently lost or the chain falsely claims continuity.

  Acceptance Criteria:
    - Given a chain is in progress, when any agent step completes, then a heartbeat timestamp + step name is written to memory/CHECKPOINT.md
    - Given the host sleeps mid-chain, when the session resumes, then /new-task detects the incomplete CHECKPOINT.md and asks the user to resume or restart
    - Given a resume is chosen, when the chain continues, then only uncompleted steps run — completed steps are not re-run
    - Given the chain completes successfully, when the commit is approved, then CHECKPOINT.md is deleted

  Test Scenarios:
    - Happy path: chain completes end-to-end, CHECKPOINT.md is deleted on commit
    - Sleep mid-chain: CHECKPOINT.md shows last completed step, resume skips those steps
    - Corrupt checkpoint: missing required fields → treat as no checkpoint, start fresh

  Definition of Done:
    - [ ] CHECKPOINT.md written after every agent step
    - [ ] /new-task reads CHECKPOINT.md at Step 0 and offers resume
    - [ ] Resume skips completed steps correctly
    - [ ] CHECKPOINT.md deleted on chain completion

  Security Considerations: none
  Technical Notes: Heartbeat must include step number, agent name, story ID, and ISO timestamp | Complexity: M

---

- [x] STORY-002: Positioning — add "what makes this different" section
  Priority: High
  Added by: po-agent on 2026-05-16
  Completed: 2026-05-16

  As a developer evaluating agile-team-skill,
  I want a clear explanation of what makes this approach different,
  So that I can quickly understand the value without reading the whole README.

  Acceptance Criteria:
    - Given a user visits the README, when they read it, then they find a dedicated positioning section explaining the organizational tension model
    - Given the section, when read, then it covers: veto authority, enforcement vs suggestion, persistent memory, and review chain design
    - Given the section, when read, then a new user understands the philosophy in under 60 seconds

  Definition of Done:
    - [x] "What makes this different" section added to README.md
    - [x] No competitor names mentioned
    - [x] Leads with organizational tension as the core idea

  Security Considerations: none
  Technical Notes: README-only change | Complexity: XS

---

## Medium Priority

- [ ] STORY-003: Max diff threshold — escalate to human before review chain
  Priority: Medium
  Added by: po-agent on 2026-05-16

  As a developer,
  I want the /review chain to warn me before running if the diff is very large,
  So that I can decide whether to split the PR rather than burning agent steps on an oversized change.

  Acceptance Criteria:
    - Given a /review or /new-task is triggered, when the diff exceeds a configurable threshold (default: 500 lines or 20 files), then the chain pauses and asks the user to confirm or split
    - Given the user confirms, when the chain continues, then it runs normally with a note that the diff is large
    - Given the user wants to configure the threshold, when they set MAX_DIFF_LINES or MAX_DIFF_FILES in a config, then the chain uses those values

  Test Scenarios:
    - Happy path: small diff, no interruption
    - Large diff: pause shown with file count and line count, user confirms
    - Config override: custom threshold respected

  Definition of Done:
    - [ ] Threshold check added to Step 0 of /new-task and /review
    - [ ] Default thresholds documented in CLAUDE.md
    - [ ] User confirmation prompt shows diff stats (lines changed, files changed)

  Security Considerations: none
  Technical Notes: Use `git diff --stat` output for counts | Complexity: S

---

- [ ] STORY-004: Multi-model execution — configurable model per agent role
  Priority: Medium
  Added by: po-agent on 2026-05-16

  As a developer running agent chains,
  I want to assign a different Claude model to each agent role,
  So that I can balance cost vs quality (e.g. Opus for security review, Haiku for standup).

  Acceptance Criteria:
    - Given an agent definition file, when it includes a `model:` frontmatter field, then Claude Code uses that model for that agent's invocations
    - Given no model is specified, when the agent runs, then it inherits the default session model
    - Given a user wants a fast/cheap chain, when they set dev-agent and pm-agent to haiku, then those steps run on Haiku while qa and security stay on Sonnet/Opus

  Test Scenarios:
    - Happy path: model field set in agent frontmatter → agent runs on that model
    - Fallback: no model field → inherits session default, no error
    - Invalid model name → clear error message, chain pauses

  Definition of Done:
    - [ ] model field added to all 7 agent .md files with recommended defaults
    - [ ] README documents the model-per-agent config
    - [ ] Example config showing cost-optimized vs quality-optimized setup

  Security Considerations: none
  Technical Notes: Claude Code already supports model frontmatter in agent files per SDK docs | Complexity: S

---

## Low Priority

- [ ] STORY-005: Per-run audit log — record exact commands run per chain step
  Priority: Low
  Added by: po-agent on 2026-05-16

  As a developer debugging a failed chain,
  I want a record of exactly which commands each agent ran during the chain,
  So that I can replay or investigate without relying on scroll-back history.

  Acceptance Criteria:
    - Given any /new-task or /review chain runs, when an agent step completes, then each tool call (file reads, edits, bash commands) is appended to memory/RUN_LOG.md with step number, agent, and timestamp
    - Given a chain completes or is abandoned, when the user opens RUN_LOG.md, then they see a complete ordered record of every action taken
    - Given a new chain starts, when CHECKPOINT.md does not exist (fresh run), then RUN_LOG.md is rotated (old log renamed with timestamp)

  Test Scenarios:
    - Happy path: chain completes, RUN_LOG.md has one entry per tool call
    - Chain abandoned mid-run: log shows partial record up to the failure point
    - Log rotation: previous RUN_LOG.md renamed before new chain starts

  Definition of Done:
    - [ ] RUN_LOG.md written during chain execution
    - [ ] Log rotation on fresh chain start
    - [ ] Format includes: step, agent, action type, file/command, timestamp

  Security Considerations: Do not log file contents — only file names and command names | Complexity: M

---

## Icebox

[Valid ideas with no near-term priority — revisit each sprint]

---

## Bugs (found during review)

- [ ] STORY-BUG-001: Fix command count inconsistency (29 vs 30) in README — found during STORY-002
  The README badge, section heading, and "Multiple Projects" prose use 29 and 30 interchangeably.
  Fix: audit actual command count in .claude/commands/, update badge + all prose references to match.

---

## Story format reference

```
- [ ] STORY-XXX: [Short, action-oriented title]
  Priority: High | Medium | Low
  Added by: [agent or ceremony] on [date]

  As a [specific user type],
  I want [capability],
  So that [outcome].

  Acceptance Criteria:
    - Given [...], When [...], Then [...]

  Test Scenarios:
    - Happy path: [...]
    - Edge case: [...]
    - Failure case: [...]

  Definition of Done:
    - [ ] [specific criterion]
    - [ ] All tests pass

  Security Considerations: [constraint or "none"]
  Technical Notes: [note] | Complexity: [XS/S/M/L/XL]
```
