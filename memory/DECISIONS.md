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
