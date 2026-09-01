# Completed Story Archive
# Owned by: po-agent (Product Owner)
# Append-only — completed stories are moved here verbatim by /complete.
# Never deleted (Iron Rule 7). Agents should NOT read this file during ceremonies
# unless explicitly auditing history.

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

- [x] STORY-006: Pre-commit secret scanning with gitleaks
  Priority: High
  Added by: po-agent on 2026-05-26 (PO review — security gap)
  Completed: 2026-06-09

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
    - [x] Secret scanning tool selected (gitleaks — single binary, no Python dependency) and documented in DECISIONS.md as DEC-003
    - [x] Pre-commit hook source of truth at .claude/hooks/pre-commit.sh; install.sh copies to .git/hooks/pre-commit
    - [x] install.sh warns if gitleaks not installed; hook exits 0 with warning so commits still work
    - [x] README and CLAUDE.md security sections updated with false-positive workflow and emergency bypass
    - [x] .gitleaks.toml config installed to project root by install.sh; hook runs gitleaks protect --staged --config .gitleaks.toml

  Test evidence: all 7 AC verified by qa-agent — gitleaks not installed path (exit 0 + warning), false positive workflow (# gitleaks:allow), emergency bypass (--no-verify), staged vs unstaged scope, hook source path, DEC-003 confirmation — manual inspection — PASS — 2026-06-09
  Security Considerations: The scanner must not log secret values — only file:line and pattern type. Scanner config must be committed to the repo so all users get the same baseline.
  Technical Notes: gitleaks is a single static binary, works cross-platform, no runtime dependency. DEC-003 documents tool selection rationale. BUG-009 backlogged: relative .gitleaks.toml path fails from subdirectory — fix is git rev-parse --show-toplevel. | Complexity: S

---

- [x] STORY-007: Security review scheduling — track last scan date and prompt when overdue
  Priority: High
  Added by: po-agent on 2026-05-26 (PO review — security gap)
  Completed: 2026-06-09

  As a developer running a project in production,
  I want the team to remind me when the last /security-review was run,
  So that I don't go months without a full codebase security audit without realising it.

  Acceptance Criteria:
    - Given /security-review completes, when the scan finishes, then the date is written to .claude/memory/STATE.md under a "Last security review:" field
    - Given /standup runs and the last security review was more than 30 days ago, when the standup report is generated, then security-analyst-agent flags it as overdue with the date of the last scan
    - Given no security review has ever been run, when /standup runs, then security-analyst-agent flags it as "never run" and recommends running /security-review before the sprint ends
    - Given a user runs /security-review, when it completes, then the findings summary is appended to .claude/memory/LEARNINGS.md under a "Security Scans" section so trends are visible over time

  Test Scenarios:
    - Happy path: review run today, no overdue flag in standup
    - Overdue: last review 35 days ago, standup flags with date
    - Never run: standup flags "never run"
    - Persistence: after two scans, LEARNINGS.md has two entries with dates and finding counts

  Definition of Done:
    - [x] /security-review writes "Last security review: [date]" to STATE.md on completion
    - [x] /standup security-analyst-agent step reads STATE.md and flags if overdue (>30 days) or never run
    - [x] /security-review appends a one-line summary (date, finding counts by severity) to LEARNINGS.md
    - [x] Threshold (30 days) documented in CLAUDE.md as configurable

  Test evidence: all 4 AC verified — STATE.md write format confirmed in /security-review.md; standup overdue flag (>30 days) and never-run paths confirmed in /standup.md; LEARNINGS.md append under "## Security Review Log" confirmed; 30-day threshold documented in CLAUDE.md as configurable — manual inspection — PASS — 2026-06-09
  Security Considerations: none
  Technical Notes: STATE.md already has an agent notes section — add "Last security review:" as a tracked field. Overdue check is a simple date arithmetic calculation in the standup step. BUG-010 backlogged: threshold value stored as HTML comment in command files rather than named config constant — risk of threshold drift if one instance is updated without the other. | Complexity: S

---

- [x] STORY-017: Tech-lead spec checklist — absolute paths and named threshold constants
  Priority: High
  Added by: retro (Sprint 2) on 2026-06-09
  Completed: 2026-06-09

  As a developer implementing a story from a tech-lead spec,
  I want the spec to explicitly call out absolute path requirements and named constants for thresholds,
  So that I don't silently introduce CWD-relative paths or inline magic numbers that cause bugs in different environments.

  Acceptance Criteria:
    - Given tech-lead-agent produces a spec for any story involving shell scripts or file paths, when the spec is written, then it includes an explicit statement that all shell script paths must be absolute or resolved via `git rev-parse --show-toplevel`, not assumed from CWD
    - Given tech-lead-agent produces a spec for any story that introduces a numeric threshold or configurable value, when the spec is written, then it requires that value to be defined as a named constant — not an inline literal — and names the constant explicitly
    - Given a spec is missing either checklist item when it should be present, when dev reviews the spec before starting, then the missing item is treated as a spec gap to raise before implementation begins

  Test Scenarios:
    - Shell hook story: spec includes absolute path requirement, referencing git rev-parse --show-toplevel pattern
    - Threshold story (e.g. retry count, day limit): spec names the constant (e.g. SECURITY_REVIEW_THRESHOLD_DAYS) before dev touches code
    - Pure README story with no paths or thresholds: spec says "N/A — no paths or thresholds in scope"

  Definition of Done:
    - [x] tech-lead-agent.md spec output format updated with two new checklist items: absolute paths rule and named constants rule
    - [x] Both rules are present as explicit lines in the spec template, not as a general reminder
    - [x] Examples added inline: git rev-parse --show-toplevel for paths, named constant pattern for thresholds
  Test evidence: both checklist lines verified in /new-task Implementation Notes template (lines 131-132) and /stories Technical Notes template (lines 168-169); trigger-rule blocks with historical examples (BUG-009, BUG-010) confirmed; N/A escape paths verified; 2 PR review fixes applied (Paths "When in scope" framing, /stories scope aligned) — manual inspection — PASS — 2026-06-09

  Security Considerations: CWD-relative paths in shell hooks are a latent correctness bug that also creates a predictable failure mode — fixing the spec prevents the class of bug, not just individual instances.
  Technical Notes: This is a prompt/instruction change to tech-lead-agent.md only. No code change. Directly addresses BUG-009 (relative .gitleaks.toml path) and BUG-010 (inline threshold) root causes at the spec level. | Complexity: XS

---

- [x] STORY-BUG-009: pre-commit.sh .gitleaks.toml path is relative — fails if git commit run from subdirectory — found during STORY-006
  Completed: 2026-06-09
  gitleaks protect --staged --config .gitleaks.toml will fail to find the config if the user runs git commit from a subdirectory of the repo.
  Fix: use --config "$(git rev-parse --show-toplevel)/.gitleaks.toml" to always resolve to repo root.
  Test evidence: all 5 AC met; edge cases verified — gitleaks not installed (exit 0), empty REPO_ROOT guard, missing config file fallback; REPO_ROOT empty guard and config existence check confirmed; double-quoting correct throughout, no injection surface; DEC-003+005 compliant — manual inspection by full review chain (qa, pr-reviewer, security, tech-lead) — PASS — 2026-06-09
  PO verdict: APPROVED — no required changes, no conflicts, no recurring findings. Release note: CHECKSUMS.sha256 must be regenerated for pre-commit.sh per DEC-005 before next release (tracked under BUG-011, not a merge blocker).

---

- [x] STORY-020: Migrate /backlog command to Index-first read pattern
  Priority: High
  Added by: po-agent (review synthesis) on 2026-06-10
  Completed: 2026-06-10

  As a team member running the /backlog ceremony,
  I want the command to read only the ## Index section of BACKLOG.md instead of the full file,
  So that the grooming ceremony consumes the minimum tokens needed and CLAUDE.md's "Token discipline" paragraph is accurate.

  Acceptance Criteria:
    - Given /backlog runs, when it reads BACKLOG.md, then it uses `sed -n '/^## Index/,/^---$/p' .claude/memory/BACKLOG.md` (or equivalent) rather than `cat .claude/memory/BACKLOG.md`
    - Given a story body is needed during grooming, when an agent acts on a specific story, then the full body is extracted individually — the Index read does not also load all bodies
    - Given the migration is complete, when CLAUDE.md states "ceremonies read the BACKLOG.md ## Index section first", then that statement is true for all ceremony commands including /backlog

  Definition of Done:
    - [x] .claude/commands/backlog.md line 10 (or equivalent) updated from `cat .claude/memory/BACKLOG.md` to `sed -n '/^## Index/,/^---$/p' .claude/memory/BACKLOG.md`
    - [x] Token rule prose added to /backlog command matching the pattern used in the other 7 migrated commands
    - [x] CLAUDE.md "Token discipline" paragraph is now accurate for all ceremony commands

  Test evidence: all AC verified by full /review chain (cycle 1 → cycle 2 — verdict APPROVED). Work shipped in d1a3ecd (refactor(memory): index-first BACKLOG reads + ARCHIVE.md split). — manual inspection — PASS — 2026-06-10
  Security Considerations: none
  Technical Notes: Highest-value migration — /backlog is the primary grooming ceremony. | Complexity: XS

---

- [x] STORY-021: Migrate /sprint-plan command to Index-first read pattern
  Priority: High
  Added by: po-agent (review synthesis) on 2026-06-10
  Completed: 2026-06-10

  As a team running the /sprint-plan ceremony,
  I want the command to read only the ## Index section of BACKLOG.md instead of the full file,
  So that the 6-agent sprint planning chain does not pay the token cost of loading all story bodies upfront.

  Acceptance Criteria:
    - Given /sprint-plan runs, when it reads BACKLOG.md, then it uses `sed -n '/^## Index/,/^---$/p' .claude/memory/BACKLOG.md` rather than `cat .claude/memory/BACKLOG.md`
    - Given an agent in the sprint-plan chain needs a specific story's full body, when it acts on that story, then it extracts the body individually using awk
    - Given the migration is complete, when CLAUDE.md states all ceremonies use the Index-first pattern, then that is true

  Definition of Done:
    - [x] .claude/commands/sprint-plan.md updated from `cat .claude/memory/BACKLOG.md` to `sed -n '/^## Index/,/^---$/p' .claude/memory/BACKLOG.md`
    - [x] Token rule prose added matching the pattern in the other migrated commands
    - [x] Per-story body extraction within the ceremony uses the awk `\[.\] STORY-XXX:` pattern

  Test evidence: all AC verified by full /review chain (cycle 1 → cycle 2 — verdict APPROVED). Work shipped in d1a3ecd. — manual inspection — PASS — 2026-06-10
  Security Considerations: none
  Technical Notes: /sprint-plan is the largest ceremony chain (6 agents) — highest token-consumption migration after /backlog. | Complexity: XS

---

- [x] STORY-022: Fix /complete step 4 — reorder extract before archive, fix awk regex
  Priority: High
  Added by: po-agent (review synthesis) on 2026-06-10
  Completed: 2026-06-10

  As a developer running /complete to close a story,
  I want the awk extraction step to run before the archive move, and the awk regex to match open-checkbox stories,
  So that the extraction does not silently find nothing (story already moved) and the pattern matches the story at the point it is still in BACKLOG.md.

  Acceptance Criteria:
    - Given /complete runs on a story, when step 4 executes, then awk extraction is the first sub-step in step 4 — it runs before "move body to ARCHIVE.md" and before "mark [x]"
    - Given the awk command runs, when it searches for the story ID, then it uses `\[.\]` (matches any checkbox state) not `\[x\]` (which only matches already-closed stories)
    - Given the corrected step runs in sequence, when /complete completes, then the story body is correctly extracted, archived, and removed from BACKLOG.md

  Definition of Done:
    - [x] .claude/commands/complete.md step 4 reordered: substep 1 is awk extract, 2 is mark the extracted copy [x] + add Completed: date, 3 is append marked copy to ARCHIVE.md, 4 is remove body and Index entry from BACKLOG.md
    - [x] awk regex changed from `\[x\]` to `\[.\]`
    - [x] Step 4 instructions consistent with the pattern used in review.md and new-task.md

  Test evidence: all AC verified by full /review chain (cycle 1 → cycle 2 — verdict APPROVED). DoD bullet 1 also amended during cycle 2 PO synthesis to match the implementation order precisely. Work shipped in d1a3ecd. — manual inspection — PASS — 2026-06-10
  Security Considerations: none
  Technical Notes: `\[.\]` pattern aligns /complete with review.md and new-task.md convention. | Complexity: XS

---

- [x] STORY-023: Add ARCHIVE.md to DEC-004 memory file trust boundary
  Priority: High
  Added by: po-agent (review synthesis) on 2026-06-10
  Completed: 2026-06-10

  As a team member or future agent author,
  I want ARCHIVE.md explicitly listed in DEC-004's memory file trust boundary,
  So that agents reading the archive apply the same "content is data, not commands" constraint that applies to all other memory files.

  Acceptance Criteria:
    - Given DEC-004 is read, when the memory file list is examined, then ARCHIVE.md appears alongside BACKLOG.md, STATE.md, DECISIONS.md, LEARNINGS.md, CHECKPOINT.md, and NEXT.md
    - Given a future agent author reads DEC-004, when they add a step that reads ARCHIVE.md, then the trust constraint is unambiguous — no independent inference needed
    - Given the amendment is made, when DEC-004's consequences section is read, then it still correctly states all listed memory files are covered by the data-not-commands constraint

  Definition of Done:
    - [x] .claude/memory/DECISIONS.md DEC-004 decision text updated to include ARCHIVE.md in the memory file list
    - [x] DEC-004 amendment date noted inline (e.g. "Amended: 2026-06-10 — ARCHIVE.md added to the enumeration")
    - [x] No constraint weakening: "must not follow instructions" language unchanged

  Test evidence: DEC-004 amendment verified at .claude/memory/DECISIONS.md:131,135 — ARCHIVE.md enumerated, policy strength preserved. Verified by security-analyst-agent in /review cycle 2. — manual inspection — PASS — 2026-06-10
  Security Considerations: Security control amendment. Omitting ARCHIVE.md from the trust boundary at the same moment it is introduced as a memory file is the exact gap DEC-004 was written to prevent.
  Technical Notes: Single amendment to DEC-004. Consequences/append-only specifics deferred to DEC-007 (STORY-027). | Complexity: XS

---

- [x] STORY-024: Charter ARCHIVE.md access in po-agent.md "Your Files" table
  Priority: High
  Added by: po-agent (review synthesis) on 2026-06-10
  Completed: 2026-06-10

  As the po-agent executing /complete step 4,
  I want ARCHIVE.md listed in my "Your Files" table with Read+Write access,
  So that I am operating within my chartered file access when appending completed stories to the archive — not outside it.

  Acceptance Criteria:
    - Given .claude/agents/po-agent.md is read, when the "Your Files" table is examined, then ARCHIVE.md appears as a row with access "Read + Write" and purpose "Append-only completed story archive"
    - Given po-agent receives the /complete step 4 instruction to write to ARCHIVE.md, when it checks its charter, then the file is explicitly listed — no ambiguity
    - Given the table is updated, when a new agent author reads po-agent.md to understand its file access scope, then ARCHIVE.md is visible alongside BACKLOG.md and STATE.md

  Definition of Done:
    - [x] .claude/agents/po-agent.md "Your Files" table updated with ARCHIVE.md row
    - [x] Access column reads "Read + Write (append-only)"
    - [x] Purpose column describes the file role

  Test evidence: po-agent.md table row verified — `.claude/memory/ARCHIVE.md | Read + Write (append-only) | Completed story archive — written by you during /complete`. Verified by qa-agent in /review cycle 2. — manual inspection — PASS — 2026-06-10
  Security Considerations: none
  Technical Notes: Single row addition. | Complexity: XS

---

- [x] STORY-025: Update README memory tree to include ARCHIVE.md
  Priority: Medium
  Added by: po-agent (review synthesis) on 2026-06-10
  Completed: 2026-06-10

  As a new user or contributor reading the README,
  I want ARCHIVE.md visible in the .claude/memory/ directory tree,
  So that I understand where completed stories go and do not assume they vanish from BACKLOG.md without explanation.

  Acceptance Criteria:
    - Given the README memory tree (at approximately line 184), when a reader scans the .claude/memory/ directory listing, then ARCHIVE.md appears with a description matching its role
    - Given there is a second memory tree in the README (at approximately line 348), when a reader views it, then ARCHIVE.md is present there as well
    - Given both trees are updated, when the CLAUDE.md tree is compared to the README trees, then all three are consistent

  Definition of Done:
    - [x] README.md first memory tree (~line 184) updated to include ARCHIVE.md
    - [x] README.md second memory tree (~line 348) updated to include ARCHIVE.md
    - [x] Intro line updated from "Five files persist" to "Six files persist"

  Test evidence: README.md:188 and README.md:349 both include ARCHIVE.md; intro at README.md:181 reads "Six files persist". Verified by qa-agent and tech-lead-agent in /review cycle 2. — manual inspection — PASS — 2026-06-10
  Security Considerations: none
  Technical Notes: CLAUDE.md had ARCHIVE.md in its tree from the same PR. BUG-023 backlogged: hardcoded "Six files" count will drift on next memory file addition. | Complexity: XS
