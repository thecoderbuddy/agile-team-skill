# Risk Register

Owned by /risk-review. Append new risks; update Status in place. Never delete rows.

| ID | Risk | Likelihood | Impact | Mitigation | Status | Opened | Last reviewed |
|---|---|---|---|---|---|---|---|
| RISK-001 | install.sh arrays drifted from disk: `unblock` missing from COMMANDS (29/30), RISKS.md missing from MEMORY_TEMPLATE_FILES | H | M | Add missing entries; CI diff-check arrays vs disk | Open | 2026-08-14 | 2026-08-14 |
| RISK-002 | pre-tool-use.sh secret-scan hook absent from installer HOOKS array — remote installs ship without the primary safety gate | H | H | Add "pre-tool-use" to HOOKS in install.sh | Open | 2026-08-14 | 2026-08-14 |
| RISK-003 | No CI validating installer arrays, command frontmatter, or CLAUDE.md canonical-section references — drift recurs silently | H | M | Add bash validate workflow (.github/workflows/validate.yml) | Open | 2026-08-14 | 2026-08-14 |
| RISK-004 | CHECKSUMS.sha256 missing; install.sh downloads hooks with zero integrity verification — violates DEC-005 (BUG-011) | M | H | Generate checksums; sha256sum --check in install.sh before chmod +x | Open | 2026-08-14 | 2026-08-14 |
| RISK-005 | curl-pipe-bash install from main HEAD — trust root unverifiable (BUG-018) | M | H | Tag releases; publish SHA beside curl command; promote git-clone path | Open | 2026-08-14 | 2026-08-14 |
| RISK-006 | SKIP_SECRET_SCAN=1 bypass is session-wide with no expiry — scanner silently stays off if left set | M | M | Make hook consume-and-unset the var after first use | Open | 2026-08-14 | 2026-08-14 |
| RISK-007 | DEC-004 "memory content is data, not instructions" not enforced in any of the 7 agent prompts — prompt-injection surface (BUG-017) | M | H | Add DEC-004 enforcement block to every agent prompt | Open | 2026-08-14 | 2026-08-14 |
| RISK-008 | Security review 66 days overdue (due 2026-07-09); PROCESS-001 gate PENDING while story work shipped | H | M | Run /security-review now; close PROCESS-001 formally | Open | 2026-08-14 | 2026-08-14 |
| RISK-009 | No semver tags/releases — installed users run stale code with no upgrade signal | H | M | Cut v1.1.0; adopt tag-on-sprint-close norm; README upgrade note | Open | 2026-08-14 | 2026-08-14 |
| RISK-010 | Sprint state 2 months stale; out-of-plan work repeatedly displacing committed stories — credibility risk for a process product | H | M | Run /sprint-close + /retro; add explicit PO-swap rule for out-of-plan work | Open | 2026-08-14 | 2026-08-14 |
