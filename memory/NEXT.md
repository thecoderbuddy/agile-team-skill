# Next Action
# Owned by: pm-agent (Scrum Master)
# Overwrite this at the end of every session with the single most specific next step.
# Written precisely enough that zero context is needed to continue.

Sprint: 3
Updated: 2026-06-09

Type: VERIFICATION
Story: N/A (PROCESS-001 — blocking pre-sprint gate)

## Exact Next Step
BLOCKING GATE — run /security-review before any Sprint 3 story moves to IN_PROGRESS.
This is PROCESS-001, the highest-priority retro action from Sprint 2. No story work starts
until this gate clears.

Steps in order:
1. Run /security-review now
2. After it completes, pm-agent writes "Last Security Review: 2026-06-09" to STATE.md
   and marks PROCESS-001 as CLEARED in STATE.md
3. First story to start after gate clears: BUG-009
   - Run /new-task for BUG-009
   - The fix is a single line in .claude/hooks/pre-commit.sh: replace
       --config .gitleaks.toml
     with
       --config "$(git rev-parse --show-toplevel)/.gitleaks.toml"
   - This is ELEVATED RISK — it must ship before any other sprint story that involves
     testing gitleaks behaviour

## Why
BUG-009 is a live defect: pre-commit.sh fails silently when git commit is run from any
subdirectory of the repo, rendering the gitleaks scanner non-functional for those users.
It is the first story in Sprint 3 execution order. PROCESS-001 gates everything because
no hook changes should be tested before the security baseline scan is on record.
