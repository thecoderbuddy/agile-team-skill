# GitHub Issues to Create

Create these at: https://github.com/thecoderbuddy/agile-team-skill/issues/new

---

## Issue 1 — feat: max diff size gate before running review chain

**Title:** `feat: max diff size gate before running review chain`
**Label:** `enhancement`

**Body:**
The review chain (`/review`, `/new-task`) runs unconditionally regardless of diff size. On large refactors (100+ files, 2000+ lines), agents receive a diff they cannot meaningfully review — producing low-quality findings and wasting context.

**Proposed solution:** Add a diff size gate at Step 0 of `/review` and `/new-task`:

If diff exceeds thresholds, pause before proceeding:
- Files changed > 20 → warn and ask to confirm
- Lines changed > 500 → warn and ask to confirm

Default output:
```
DIFF SIZE WARNING
─────────────────
Files changed: 47 (threshold: 20)
Lines changed: 1,843 (threshold: 500)

This diff is large. Review quality degrades at this size.
Options:
  1. Proceed anyway
  2. Split the PR and review each part separately
  3. Review specific files only: /review path/to/file

Proceed? [Y/N]
```

Thresholds should be configurable per project in CLAUDE.md.

---

## Issue 2 — feat: surface agent tool log in review verdict output

**Title:** `feat: surface agent tool log in review verdict output`
**Label:** `enhancement`

**Body:**
The PO verdict currently shows conclusions from each agent (PASS, CLEAN, ALIGNED) but not what tools or commands each agent actually ran. This makes it impossible to audit whether an agent genuinely checked something or just asserted it.

Claude Code natively logs tool use in its UI, but this isn't captured in the review output written to memory or shown in the final verdict block.

**Proposed solution:** Each agent in the review chain includes a `Commands run:` line in their output section:

```
QA GATE
───────────────────────────────
Tests:   PASS
AC met:  YES
Commands run:
  bash: pytest backend/tests/ -v → 9 passed in 0.92s
  grep: "def test_" backend/tests/test_cache.py → 9 matches
───────────────────────────────
```

This gives the PO (and the user) verifiable evidence of what was actually checked, not just what the agent concluded.

---

## Issue 3 — feat: structured NEXT.md type field for autonomous routing

**Title:** `feat: structured NEXT.md type field for autonomous routing`
**Label:** `enhancement`

**Body:**
`NEXT.md` currently writes a human-readable nudge like "Run /new-task to start STORY-010." This is useful for humans but not machine-parseable.

For autonomous session resumption and future hook/automation support, the next action should be classifiable as one of:

- `IMPLEMENTATION` — dev-agent writes or changes code (can run autonomously)
- `VERIFICATION` — qa or security runs checks (can run autonomously)
- `PRODUCT_JUDGMENT` — po or human makes a call (requires human input)
- `CEREMONY` — next action is a scrum ceremony

**Proposed `NEXT.md` format:**
```
Type: IMPLEMENTATION | VERIFICATION | PRODUCT_JUDGMENT | CEREMONY
Story: STORY-XXX

## Exact Next Step
[specific action]

## Why
[one sentence]
```

This allows a session start hook to immediately know whether to auto-proceed or pause for human input, without reading the full prose.

Note: `pm-agent` has already been updated to write this format — this issue tracks adding hook/automation support to consume the `Type` field.

---

## Issue 4 — feat: host sleep as first-class recoverable interruption

**Title:** `feat: host sleep detection and recovery in CHECKPOINT.md`
**Label:** `enhancement`

**Body:**
The current `CHECKPOINT.md` protocol handles rate-limit drops and session crashes mid-chain. But if the Mac sleeps while a background agent is running (lid close, auto-sleep), the chain dies silently — the checkpoint captures the last completed step but gives no indication of *why* the chain stopped or how long the host was unavailable.

**Proposed solution:** Add a `Last heartbeat` timestamp field to `CHECKPOINT.md`, updated after each agent step:

```
Command: /review
Story: STORY-XXX
Started: 2026-05-13T14:22:00
Last heartbeat: 2026-05-13T14:31:47 — Step 2 — pr-reviewer-agent
```

Then in `/resume`, classify the interruption by gap size:
- Gap < 2 min → likely rate limit reset — safe to resume
- Gap > 5 min → host sleep suspected — still safe to resume from CHECKPOINT, but flag it

This gives the user verifiable evidence of what happened, not just "chain stopped at Step N."

**Acceptance criteria:**
- [ ] `CHECKPOINT.md` includes `Last heartbeat: [timestamp] — Step N — [agent-name]` updated after each step
- [ ] `/resume` reads the gap between `Last heartbeat` and current time
- [ ] `/resume` outputs `Interruption: rate limit | host sleep suspected | unknown` based on gap
- [ ] Resume from checkpoint works correctly in both cases
