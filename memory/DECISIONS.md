# Architecture Decisions
# Owned by: tech-lead-agent
# Every DEC-XXX is permanent until explicitly superseded.
# Read this before any architecture work.
# New decisions are logged here by tech-lead-agent after team discussion.

---

## How to add a decision

```
## DEC-XXX — [Short Title]
Date: [date]
Status: ACTIVE | SUPERSEDED by DEC-YYY

Decision:
  [What was decided — one paragraph, plain language]

Rationale:
  [Why this choice was made — what problem it solves]

Alternatives considered:
  - [Option A] — rejected because [reason]
  - [Option B] — rejected because [reason]

Consequences:
  [What this enables or constrains going forward]
```

---

## DEC-001 — Per-agent model configuration via frontmatter
Date: 2026-05-16
Status: ACTIVE

Decision:
  Each agent is configured with its own Claude model via a `model:` field in the
  agent's .md frontmatter. There is no global model config — each of the 7 agent
  files sets its own model independently.

Rationale:
  Different agents have different cost-quality tradeoffs. Security review and
  architecture decisions benefit from maximum depth (Opus). Ceremony management
  (standup, state updates) runs fine on lighter models (Haiku). A per-agent field
  lets users tune each role without changing anything else. Claude Code supports
  this natively — no custom tooling needed.

Alternatives considered:
  - Single global model env var — rejected because it prevents per-role tuning
  - Config file (e.g. models.yaml) — rejected because Claude Code already reads
    agent frontmatter; adding a separate config layer adds complexity with no gain

Consequences:
  - README must be kept current with valid model IDs when Anthropic releases new versions
  - New agents added to .claude/agents/ must include a model: field or they inherit
    the session default silently — this should be documented in the contributing guide

---

## DEC-002 — CHECKPOINT.md schema and validity rules
Date: 2026-05-16
Status: ACTIVE

Decision:
  CHECKPOINT.md is the canonical crash-recovery file for all multi-step agent chains.
  A valid checkpoint must contain: `Command:`, `Story:`, `Started:`, `Last heartbeat:`,
  and a `Steps:` block with at least one entry. Any checkpoint that is empty, or missing
  any of these required fields, is treated as corrupt and discarded — the chain starts fresh.
  A checkpoint whose story ID already appears in the "Done This Sprint" list in STATE.md is
  treated as stale and discarded. CHECKPOINT.md is deleted by pm-agent immediately after the
  commit is written and confirmed. In the /review chain (which has no pm-agent step), deletion
  happens at the terminal success point before control returns to the user.

Rationale:
  Without explicit validity rules, agents have no consistent way to distinguish a
  recoverable mid-chain drop from a corrupt or leftover file. Two failure modes seen
  in practice: (1) a stale CHECKPOINT.md from a completed story surviving into the
  next run (STORY-003 incident), and (2) a partially written checkpoint causing an
  unrecoverable parse error. Defining the schema makes both detectable at Step 0.

Alternatives considered:
  - Delete CHECKPOINT.md at sprint-close only — rejected because stale files survive
    into the next story's run and cause false resume prompts
  - Validate only the Story: field — rejected because a file with just a Story: line
    but missing Steps: is not recoverable; partial validation gives false confidence

Consequences:
  - All commands using the checkpoint protocol must implement the validity check at Step 0
  - pm-agent is responsible for deletion after commit — not the user, not dev-agent
  - Any new required field added to the checkpoint schema must be documented here
