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
    - [x] CHECKPOINT.md written after every agent step
    - [x] /new-task reads CHECKPOINT.md at Step 0 and offers resume
    - [x] Resume skips completed steps correctly
    - [x] CHECKPOINT.md deleted on chain completion

  Test evidence: CHECKPOINT.md write/read/delete lifecycle verified; resume path logic confirmed in /new-task Step 0; corrupt/stale checkpoint detection verified by reading command — manual inspection — PASS — 2026-05-21
  Security Considerations: none
  Technical Notes: Heartbeat must include step number, agent name, story ID, and ISO timestamp | Complexity: M
  Note: Completed Sprint 1 (2026-05-21). Checkboxes updated by PO review 2026-05-26.

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

  Test evidence: visual review — "what makes this different" section present, covers all 4 required topics, readable in under 60 seconds — visual review — PASS — 2026-05-16
  Security Considerations: none
  Technical Notes: README-only change | Complexity: XS

---

- [ ] STORY-015: Story readiness gate — tech-lead adds implementation notes before dev starts
  Priority: High
  Added by: retro on 2026-06-09

  As a developer picking up a story,
  I want a standard "implementation notes" block populated by tech-lead before I start,
  So that I don't discover missing flags, env assumptions, or sanitisation requirements mid-implementation.

  Acceptance Criteria:
    - Given tech-lead-agent reviews a story in /new-task or /stories, when the story has any shell output reading, file writing, or env var usage, then tech-lead adds an "Implementation Notes" block covering: required flags, sanitisation requirements, env var validation rules
    - Given the story involves reading user-controlled or external input (filenames, diff output, env vars), when tech-lead writes the notes, then a "Sanitisation required: yes/no + reason" line is explicitly included
    - Given the block is added, when dev picks up the story, then no new technical requirements are discovered during implementation that weren't in the notes

  Test Scenarios:
    - Story with git diff output: sanitisation note added, --no-color flag documented
    - Pure README story: implementation notes block says "N/A — no shell I/O"
    - Env var story: validation rule (must be positive integer) documented before dev starts

  Definition of Done:
    - [ ] tech-lead-agent.md /new-task step updated with implementation notes block requirement
    - [ ] tech-lead-agent.md /stories step updated with same requirement
    - [ ] "Sanitisation required:" line added as explicit checklist item in tech notes
    - [ ] STORY-003 and STORY-001 retroactively serve as examples in the agent prompt

  Security Considerations: The sanitisation checkpoint is the primary security output of this story — any story reading external input must flag it.
  Technical Notes: This is a prompt/instruction change to tech-lead-agent.md. No code change. | Complexity: XS

---

- [ ] STORY-016: Test evidence record — lightweight traceability on story close
  Priority: Medium
  Added by: retro on 2026-06-09

  As a developer or auditor reviewing a completed story,
  I want a one-line test evidence note added to the story's DoD when it closes,
  So that there is a traceable record of what was tested and how — not just "tests pass."

  Acceptance Criteria:
    - Given /complete runs on a story, when qa-agent sign-off is confirmed, then a "Test evidence:" line is appended to the story's DoD in BACKLOG.md: format is "[what was tested] — [method] — [result] — [date]"
    - Given the evidence line is written, when an auditor reads BACKLOG.md, then they can determine without any other context how each story was verified
    - Given a story has no testable output (e.g. pure documentation), when /complete runs, then the evidence line reads "Test evidence: visual review — README rendered correctly — [date]"

  Test Scenarios:
    - Code story: evidence line shows specific AC tested, method (manual/automated), pass/fail
    - Doc story: evidence line shows visual review
    - Missing evidence: /complete prompts qa-agent to add it before marking done

  Definition of Done:
    - [x] /complete command updated to include qa-agent test evidence step
    - [x] BACKLOG.md story format reference updated with "Test evidence:" field
    - [x] Existing Sprint 1 stories updated retroactively with evidence notes (manual backfill)
  Test evidence: /complete Step 3 verified in command file; story format ref updated; STORY-001/002/003/004 backfilled in BACKLOG.md — manual inspection — PASS — 2026-06-09
  Security Considerations: none
  Technical Notes: One-line addition to /complete flow. Format: "Test evidence: [what] — [how] — [result] — [date]" | Complexity: XS

---

- [ ] STORY-006: Automated secret scanning — pre-commit hook with gitleaks or detect-secrets
  Priority: High
  Added by: po-agent on 2026-05-26 (PO review — security gap)

  As a developer using agile-team-skill on a project that handles real user data,
  I want a pre-commit secret scanner to run before any commit is made,
  So that API keys, tokens, and credentials are blocked at the source before they ever reach the repository.

  Acceptance Criteria:
    - Given a developer attempts to commit a file containing a pattern that matches a known secret format (API key, token, connection string), when the pre-commit hook runs, then the commit is blocked and the offending file:line is reported
    - Given a clean commit with no secrets, when the hook runs, then the commit proceeds without interruption
    - Given a developer needs to suppress a false positive, when they add an inline ignore comment, then the scanner skips that line and logs the suppression
    - Given the tool is not installed on the developer's machine, when the hook fires, then a clear installation instruction is shown rather than a silent failure

  Test Scenarios:
    - Happy path: clean commit, hook passes silently
    - Secret found: commit blocked, file:line shown, no partial commit
    - False positive suppression: inline ignore respected, suppression logged
    - Tool not installed: actionable install instruction displayed

  Definition of Done:
    - [ ] Secret scanning tool selected (gitleaks recommended — single binary, no Python dependency) and documented in DECISIONS.md as DEC-XXX
    - [ ] Pre-commit hook added to .claude/hooks/ or .git/hooks/ that calls the scanner
    - [ ] install.sh updated to install the scanner or warn if missing
    - [ ] README security section updated with one-line explanation of what's protected
    - [ ] False-positive suppression approach documented

  Security Considerations: The scanner must not log secret values — only file:line and pattern type. Scanner config must be committed to the repo so all users get the same baseline.
  Technical Notes: gitleaks is a single static binary, works cross-platform, no runtime dependency. detect-secrets requires Python but produces a baseline file useful for drift detection. Recommend gitleaks for DX simplicity. | Complexity: S

---

- [ ] STORY-007: Security review scheduling — track last scan date and prompt when overdue
  Priority: High
  Added by: po-agent on 2026-05-26 (PO review — security gap)

  As a developer running a project in production,
  I want the team to remind me when the last /security-review was run,
  So that I don't go months without a full codebase security audit without realising it.

  Acceptance Criteria:
    - Given /security-review completes, when the scan finishes, then the date is written to memory/STATE.md under a "Last security review:" field
    - Given /standup runs and the last security review was more than 30 days ago, when the standup report is generated, then security-analyst-agent flags it as overdue with the date of the last scan
    - Given no security review has ever been run, when /standup runs, then security-analyst-agent flags it as "never run" and recommends running /security-review before the sprint ends
    - Given a user runs /security-review, when it completes, then the findings summary is appended to memory/LEARNINGS.md under a "Security Scans" section so trends are visible over time

  Test Scenarios:
    - Happy path: review run today, no overdue flag in standup
    - Overdue: last review 35 days ago, standup flags with date
    - Never run: standup flags "never run"
    - Persistence: after two scans, LEARNINGS.md has two entries with dates and finding counts

  Definition of Done:
    - [ ] /security-review writes "Last security review: [date]" to STATE.md on completion
    - [ ] /standup security-analyst-agent step reads STATE.md and flags if overdue (>30 days) or never run
    - [ ] /security-review appends a one-line summary (date, finding counts by severity) to LEARNINGS.md
    - [ ] Threshold (30 days) documented in CLAUDE.md as configurable

  Security Considerations: none
  Technical Notes: STATE.md already has an agent notes section — add "Last security review:" as a tracked field. Overdue check is a simple date arithmetic calculation in the standup step. | Complexity: S

---

- [ ] STORY-011: pre-tool-use.sh secret write guard — extend to Write tool content scanning
  Priority: High
  Added by: po-agent on 2026-05-26 (PO review — security gap in hook)
  Promoted: retro 2026-06-09 — security-analyst-agent flagged hook gives false confidence (bash checked, Write tool not checked)

  As a developer using agile-team-skill where agents can write files,
  I want the pre-tool-use hook to scan Write tool content for secret patterns,
  So that an agent cannot accidentally write a hardcoded API key or token to a source file even if it bypasses the bash redirection check.

  Acceptance Criteria:
    - Given the Write tool is called with content that matches a known secret pattern (e.g. `sk-`, `ghp_`, `AKIA`, `Bearer [token]`, `-----BEGIN RSA PRIVATE KEY-----`), when the pre-tool-use hook evaluates the call, then the write is blocked and the pattern match is reported
    - Given the Write tool is called with normal source code containing no secret patterns, when the hook runs, then the write proceeds without interruption
    - Given the pattern list needs updating, when a new secret format is added to the hook's pattern list, then it applies immediately without requiring a restart
    - Given a false positive occurs on a legitimate code constant, when the developer needs to allow the write, then a documented override mechanism exists (comment or env var)

  Test Scenarios:
    - Happy path: write with clean content, passes
    - Secret in content: write blocked, pattern type reported (not the value)
    - Private key pattern: blocked
    - False positive override: mechanism works, override is logged not silently applied

  Definition of Done:
    - [x] pre-tool-use.sh Write/Edit block extended with a secret pattern grep on `.tool_input.content`
    - [x] Pattern list covers: OpenAI keys (sk-), GitHub tokens (ghp_, ghs_), AWS keys (AKIA), Bearer tokens, PEM private keys (high-entropy generic pattern excluded — false positive rate too high; documented in hook comment)
    - [x] Block message reports pattern type matched, never the matched value
    - [x] Override mechanism documented in CLAUDE.md
  Test evidence: 5 pattern regexes verified against AC pattern list; double-quote injection safety confirmed; SCAN_CONTENT never echoed; SKIP_SECRET_SCAN gate tested for unset/0/1 values; PEM regex cleaned up post-review — manual inspection — PASS — 2026-06-09
  Security Considerations: The hook must never log the matched secret value — only the pattern type and file path. Pattern list should be reviewed alongside /security-review cadence.
  Technical Notes: The current hook already has a bash-command secret check. This extends the same logic to the Write/Edit content field. jq is already used in the hook for input parsing. | Complexity: S

---

## Medium Priority

- [ ] STORY-003: Max diff threshold — escalate to human before review chain
  Priority: Medium
  Added by: po-agent on 2026-05-16
  Note: Completed Sprint 1 (2026-05-19). Definition of Done checkboxes updated by PO review 2026-05-26.

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
    - [x] Threshold check added to Step 0 of /new-task and /review
    - [x] Default thresholds documented in CLAUDE.md
    - [x] User confirmation prompt shows diff stats (lines changed, files changed)

  Test evidence: threshold check present in /new-task and /review Step 0; default values (500 lines, 20 files) confirmed in command text; confirmation prompt format verified — manual inspection — PASS — 2026-05-19
  Security Considerations: none
  Technical Notes: Use `git diff --stat` output for counts | Complexity: S

---

- [ ] STORY-004: Multi-model execution — configurable model per agent role
  Priority: Medium
  Added by: po-agent on 2026-05-16
  Note: Completed Sprint 1 (2026-05-16). Definition of Done checkboxes updated by PO review 2026-05-26.

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
    - [x] model field added to all 7 agent .md files with recommended defaults
    - [x] README documents the model-per-agent config
    - [x] Example config showing cost-optimized vs quality-optimized setup

  Test evidence: model: field verified in all 7 agent .md frontmatter files; README model config table and code example inspected — manual inspection — PASS — 2026-05-16
  Security Considerations: none
  Technical Notes: Claude Code already supports model frontmatter in agent files per SDK docs | Complexity: S

---

- [ ] STORY-008: Dependency vulnerability audit — automated scan in /security-review
  Priority: Medium
  Added by: po-agent on 2026-05-26 (PO review — security gap)

  As a developer running a project with third-party dependencies,
  I want /security-review to automatically run a dependency audit tool appropriate to my stack,
  So that known CVEs in my dependencies are surfaced without me having to remember to run a separate command.

  Acceptance Criteria:
    - Given /security-review runs on a Node.js project (package.json present), when the audit step runs, then `npm audit --json` is called and findings parsed into the output format
    - Given /security-review runs on a Python project (pyproject.toml or requirements.txt present), when the audit step runs, then `pip-audit` is called and findings parsed
    - Given the audit tool is not installed, when /security-review runs, then the dependency section shows "SKIPPED — [tool] not found. Install with: [command]" rather than failing silently
    - Given the audit completes, when findings are shown, then critical and high CVEs are listed as blocking findings and medium/low go to BACKLOG.md

  Test Scenarios:
    - Happy path: tool installed, no CVEs, section shows "CLEAN — 0 vulnerabilities"
    - CVEs found: critical/high listed with CVE-ID, package, version, fix version
    - Tool missing: skipped gracefully with install instruction, not an error
    - Mixed stack (monorepo): both npm and pip-audit run if both manifests present

  Definition of Done:
    - [ ] /security-review command updated with explicit stack detection logic (package.json / pyproject.toml / Cargo.toml / go.mod)
    - [ ] Each stack has a named audit command and a "not installed" fallback message
    - [ ] Output section added to /security-review output format: DEPENDENCY AUDIT with CVE count by severity
    - [ ] Critical/high CVEs from dependency audit are treated as blocking (same as CRITICAL/HIGH from agent checklist)

  Security Considerations: Audit tool output may contain package names from potentially compromised dependencies — do not run audit output through additional shell evaluation.
  Technical Notes: npm audit, pip-audit, cargo audit, govulncheck are the canonical tools per stack. All are free. pip-audit requires pip install pip-audit. | Complexity: S

---

- [ ] STORY-009: CONTRIBUTING.md — agent authoring guide and contribution standards
  Priority: Medium
  Added by: po-agent on 2026-05-26 (PO review — onboarding gap)

  As an open source contributor or team member wanting to extend agile-team-skill,
  I want a clear contribution guide that explains how to write agents, add commands, and run tests,
  So that I can contribute without having to reverse-engineer the existing files or ask basic questions.

  Acceptance Criteria:
    - Given a contributor wants to add a new agent, when they read CONTRIBUTING.md, then they find a step-by-step template showing required frontmatter fields (name, model, description, tools), the collaboration chain contract, and the ceremony participation requirements
    - Given a contributor wants to add a new command, when they read CONTRIBUTING.md, then they find the command structure requirements (Steps, output artifact, which agents participate)
    - Given a contributor wants to add a model field to an agent, when they read CONTRIBUTING.md, then they find the DEC-001 reference and the list of valid model values
    - Given a contributor opens a PR, when they read CONTRIBUTING.md, then they find the PR checklist (agent reviewed their own command, format matches existing commands, DECISIONS.md updated if architectural)

  Test Scenarios:
    - Happy path: new contributor follows guide and produces a valid agent file on first attempt
    - Edge case: contributor omits model field — guide warns this causes silent inheritance
    - Failure case: contributor adds a command without defining output artifact — guide flags this as a required field

  Definition of Done:
    - [ ] CONTRIBUTING.md created at repo root
    - [ ] Agent authoring section: frontmatter fields, ceremony participation table, collaboration chain contract
    - [ ] Command authoring section: step structure, output artifact requirement, checkpoint protocol reference
    - [ ] DEC-001 and DEC-002 referenced where relevant
    - [ ] PR checklist included

  Security Considerations: none
  Technical Notes: README already has a two-paragraph contributing section — CONTRIBUTING.md expands this, README links to it. | Complexity: S

---

- [ ] STORY-010: Security agent default model — upgrade to opus in default config
  Priority: Medium
  Added by: po-agent on 2026-05-26 (PO review — security gap)

  As a developer relying on security-analyst-agent to catch vulnerabilities in every review,
  I want the security agent to run on the most capable model by default,
  So that subtle security issues are not missed because a lighter model skipped a reasoning step.

  Acceptance Criteria:
    - Given the default installation of agile-team-skill, when security-analyst-agent runs, then its frontmatter model field reads `opus` not `sonnet`
    - Given the README model configuration table, when a user reads the "quality-first" recommendation, then the security-analyst-agent row already matches the installed default (no change needed)
    - Given a user explicitly wants to reduce cost, when they change security-analyst-agent model to `sonnet`, then the README documents this tradeoff clearly: "sonnet misses subtle issues — only use for low-risk projects"

  Test Scenarios:
    - Default install: security-analyst-agent frontmatter reads `model: opus`
    - README alignment: quality-first table and actual file match
    - Cost override: sonnet option documented with explicit tradeoff warning

  Definition of Done:
    - [ ] security-analyst-agent.md frontmatter changed from `model: sonnet` to `model: opus`
    - [ ] README "quality-first" table updated to reflect this is now the default
    - [ ] Cost-optimized table in README adds a warning note for security agent downgrade

  Security Considerations: This is a configuration change. No code risk. Opus costs more per review cycle — this is a documented tradeoff, not a bug.
  Technical Notes: Single line change in .claude/agents/security-analyst-agent.md | Complexity: XS

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

- [ ] STORY-012: Sprint health indicator — flag sprint goal at risk in standup
  Priority: Low
  Added by: po-agent on 2026-05-26 (PO review — process gap)

  As a developer or tech lead running a sprint,
  I want the standup to explicitly flag when the sprint goal is at risk,
  So that I notice early enough to descope or re-prioritise rather than discovering it at sprint close.

  Acceptance Criteria:
    - Given /standup runs and fewer than 50% of sprint stories are done with less than 3 days remaining, when pm-agent synthesises the standup, then a "SPRINT GOAL AT RISK" banner is shown with the specific gap (stories remaining, days left)
    - Given /standup runs and all stories are on track, when pm-agent synthesises, then no risk banner is shown
    - Given a blocker has been open for more than 2 standups without resolution, when pm-agent synthesises, then it is flagged as an escalation risk separate from the sprint goal health

  Test Scenarios:
    - Happy path: sprint on track, no banner
    - At risk: fewer than 50% done with 3 days left, banner shown with specific numbers
    - Chronic blocker: same blocker in STATE.md for 3 standups, escalation flag raised

  Definition of Done:
    - [ ] /standup pm-agent step reads sprint end date and story completion ratio from STATE.md
    - [ ] Risk threshold documented in CLAUDE.md (50% complete with <=3 days remaining)
    - [ ] Chronic blocker detection added (blocker present in 3 consecutive standup STATE.md snapshots)

  Security Considerations: none
  Technical Notes: Sprint end date is already in STATE.md. Story completion ratio is derivable from the sprint stories list. | Complexity: S

---

- [ ] STORY-013: /summary command — stakeholder-ready sprint update in one paragraph
  Priority: Low
  Added by: po-agent on 2026-05-26 (PO review — persona gap: engineering managers)

  As an engineering manager or tech lead running a team with agile-team-skill,
  I want a single command that produces a one-paragraph stakeholder update,
  So that I can share progress upstream without manually translating sprint state into plain English.

  Acceptance Criteria:
    - Given /summary is run during an active sprint, when po-agent generates the output, then it produces a 3-5 sentence paragraph covering: what was shipped this sprint, what is in progress, and what is planned next
    - Given /summary is run at sprint end, when it runs, then it also includes velocity (planned vs delivered) and any notable decisions or risks
    - Given the output, when a non-technical stakeholder reads it, then it contains no agent names, no story IDs, and no technical jargon — only user outcomes

  Test Scenarios:
    - Happy path: active sprint, paragraph produced with correct story count and outcomes
    - Sprint end: velocity included, carry-overs mentioned if any
    - Audience check: output contains no "STORY-XXX", no "dev-agent", no technical formatting

  Definition of Done:
    - [ ] /summary command file created at .claude/commands/summary.md
    - [ ] po-agent generates the paragraph using STATE.md and BACKLOG.md as source
    - [ ] Output is plain prose, no tables or code blocks
    - [ ] Command listed in README command table

  Security Considerations: none
  Technical Notes: po-agent already reads BACKLOG.md and STATE.md — this is a new output format for existing data. | Complexity: XS

---

- [ ] STORY-014: Threat model template — structured security design for auth and PII stories
  Priority: Low
  Added by: po-agent on 2026-05-26 (PO review — security gap: pre-implementation)

  As a developer writing a story that involves authentication, user data, or PII,
  I want security-analyst-agent to produce a structured threat model as part of /stories or /new-task,
  So that security risks are identified and designed around before implementation starts, not discovered during /review.

  Acceptance Criteria:
    - Given /stories or /new-task is run for a story with security-relevant keywords (auth, login, password, PII, payment, user data, token, session), when security-analyst-agent adds its section, then it produces a STRIDE-lite threat model (Spoofing, Tampering, Repudiation, Information Disclosure, Denial of Service, Elevation of Privilege) scoped to the story
    - Given the threat model identifies a CRITICAL threat, when the story is written, then the threat becomes an explicit acceptance criterion, not just a note
    - Given a story has no security-relevant keywords, when security-analyst-agent runs, then it confirms "N/A — no auth or data handling in scope" and adds no overhead

  Test Scenarios:
    - Happy path: non-security story, N/A confirmed, no output added
    - Auth story: STRIDE-lite table produced, at least one criterion promoted to AC
    - PII story: data minimisation and deletion rights flagged in security considerations

  Definition of Done:
    - [ ] security-analyst-agent.md /stories ceremony section updated with threat model trigger logic
    - [ ] STRIDE-lite template defined in the agent (6 rows, one line each, N/A allowed per row)
    - [ ] Promotion rule documented: CRITICAL threats become AC, not notes
    - [ ] /new-task chain updated to call security-analyst-agent for threat model when story has security keywords

  Security Considerations: The threat model output must be scoped to the story — not a generic OWASP dump. Over-broad threat models add noise without value.
  Technical Notes: STRIDE-lite is a lightweight version of Microsoft STRIDE. Six rows, each answered in one sentence. Total addition to a story: 6-8 lines. | Complexity: S

---

## Icebox

[Valid ideas with no near-term priority — revisit each sprint]

- /spike command — time-boxed research tasks that don't fit story format. Surface when team encounters unknowns that need investigation before estimation.
- Multi-developer support — STATE.md story assignment by human name. Needed when tech lead manages 2+ developers using the same team.
- Velocity trending — structured velocity data in LEARNINGS.md across sprints for trend analysis. Currently single-sprint only.
- /triage command — for open source maintainers handling incoming GitHub issues or PRs from external contributors.

---

## Bugs (found during review)

- [ ] STORY-BUG-001: Fix command count inconsistency (29 vs 30) in README — found during STORY-002
  The README badge, section heading, and "Multiple Projects" prose use 29 and 30 interchangeably.
  Fix: audit actual command count in .claude/commands/, update badge + all prose references to match.

- [ ] STORY-BUG-002: Add model ID maintenance reminder — found during STORY-004
  The valid model ID list in README "Model configuration" section will go stale when Anthropic
  releases new versions. Fix: add a maintenance note in DEC-001 or CONTRIBUTING that the
  model ID list must be updated on each Anthropic model release.

- [ ] STORY-BUG-003: Filename-based prompt injection via git diff --stat output — found during STORY-003
  A file committed with a manipulative name could appear in diff stat output read by agents.
  Pre-existing pattern (agents read git output everywhere), not introduced by STORY-003.
  Severity: MEDIUM (elevated from LOW-MEDIUM by PO review 2026-05-26 — affects all chains, not just STORY-003).
  Fix: investigate sanitising filenames from stat output before agent reads it. Consider allowlisting safe filename characters.

- [ ] STORY-BUG-004: No input validation on MAX_DIFF_LINES / MAX_DIFF_FILES env vars — found during STORY-003
  Values of "0" or "-1" would cause every diff to trigger the large-diff gate or bypass it.
  Fix: add validation rule in the diff check instruction (must be positive integer, else use default).

- [ ] STORY-BUG-007: pre-tool-use.sh sk- pattern also matches Stripe keys — document this is intentional coverage — found during STORY-011
  sk-[A-Za-z0-9]{20,} matches OpenAI AND Stripe secret keys (both use sk- prefix). This is correct behaviour but should be documented in the hook comment so future maintainers don't narrow the pattern. Fix: add "also covers Stripe sk- keys" to the comment block above the pattern.

- [ ] STORY-BUG-008: pre-tool-use.sh missing ghr_ (GitHub runner token) pattern — found during STORY-011
  GitHub Actions runner tokens use the ghr_ prefix. Current pattern covers ghp_ and ghs_ but not ghr_.
  Fix: extend gh[ps]_ pattern to gh[psr]_ or add a separate check.

- [ ] STORY-BUG-006: tech-lead-agent.md line 134 — sanitisation trigger list conflates shell output and env var reads — found during STORY-015
  "Reads shell command output (e.g. git diff, ls, env vars)" mixes two distinct input sources.
  Fix: split into two explicit bullets — "Reads shell command output" and "Reads env vars directly".

- [ ] STORY-BUG-005: CHECKPOINT.md Cycle: field undocumented in DEC-002 schema — found during STORY-001
  /review checkpoint format includes a `Cycle:` field not listed in DEC-002's required fields.
  DEC-002 defines minimums, not exhaustive schema — but optional fields should be documented.
  Fix: amend DEC-002 to list `Cycle:` as an optional field present in /review checkpoints only.

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
  Test evidence: [what was tested] — [method: manual inspection | automated | visual review] — [result] — [date]

  Security Considerations: [constraint or "none"]
  Technical Notes: [note] | Complexity: [XS/S/M/L/XL]
```
