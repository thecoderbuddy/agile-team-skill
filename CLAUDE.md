# Agile Team — AI-Powered Scrum for Any Project

Drop this into any codebase. You get 7 specialist agents, collaborative agile ceremonies,
and persistent team memory. No lock-in. Works with any language or framework.

---

## What's Here

```
.claude/
├── agents/                    ← 7 specialist agents
│   ├── po-agent.md            Product Owner
│   ├── pm-agent.md            Scrum Master
│   ├── dev-agent.md           Developer
│   ├── qa-agent.md            QA Engineer
│   ├── pr-reviewer-agent.md   PR Reviewer
│   ├── security-analyst-agent.md  Security Analyst
│   └── tech-lead-agent.md     Tech Lead
└── commands/                  ← Agile ceremonies as slash commands

memory/                        ← Persistent team state
├── NEXT.md                    Exact next action (session continuity)
├── STATE.md                   Current sprint
├── BACKLOG.md                 Product backlog
├── DECISIONS.md               Architecture decisions
└── LEARNINGS.md               Team learnings (append-only)
```

---

## The Collaboration Principle: Nesting = Collaboration

No agent works alone. Every ceremony runs a **collaboration chain** — agents give their
perspective in sequence, then one agent synthesizes into a shared artifact.

```
/review chain:
  pr-reviewer  ──→  code quality findings
  security     ──→  vulnerability findings
  qa           ──→  test coverage findings
  tech-lead    ──→  architecture findings
  po           ──→  [SYNTHESIZES ALL] → APPROVED / CHANGES REQUESTED + BACKLOG items
```

The PO is the hub. Issues that don't block merge go straight to BACKLOG.md. Nothing is lost.

---

## The 7 Agents

| Agent | Role | Owns | Hard Veto |
|---|---|---|---|
| `po-agent` | Product Owner | BACKLOG.md, sprint goal, user stories | No |
| `pm-agent` | Scrum Master | STATE.md, NEXT.md, ceremonies | No |
| `dev-agent` | Developer | Code, implementation | No |
| `qa-agent` | QA Engineer | Test strategy, acceptance criteria | YES — no ship without tests |
| `pr-reviewer-agent` | PR Reviewer | Code review, merge gate | Soft — can block PR |
| `security-analyst-agent` | Security | Vulnerability scan, risk register | Soft — can block PR |
| `tech-lead-agent` | Tech Lead | DECISIONS.md, architecture, estimates | No |

---

## Ceremony Map

| Command | Collaboration Chain | Output Artifact |
|---|---|---|
| `/standup` | dev → qa → security → pm synthesizes → po notes | STATE.md updated |
| `/sprint-plan` | po proposes → tech-lead estimates → qa adds AC → security flags → pm finalizes | Sprint in STATE.md |
| `/sprint-close` | pm reads velocity → po reviews stories → all agents reflect | COMPLETED log |
| `/retro` | all agents reflect → pm facilitates → po backlogs actions → learnings logged | LEARNINGS.md |
| `/review` | pr-reviewer → security → qa → tech-lead → po synthesizes | Verdict + BACKLOG.md |
| `/stories` | po writes → qa adds test scenarios → security adds constraints → tech-lead adds notes | BACKLOG.md entry |
| `/backlog` | po leads → tech-lead estimates → qa validates AC → security flags risk | BACKLOG.md prioritized |
| `/new-task` | po selects → tech-lead specs → pm assigns | IN_PROGRESS in STATE.md |
| `/status` | pm reads state → all agents report health | Full project picture |

---

## Session Protocol

**Start of session:**
```
cat memory/NEXT.md     # exact pickup point — always start here
cat memory/STATE.md    # sprint status
```

**Then:**
- Start of day → `/standup`
- Need next work → `/new-task`
- Before committing → `/review`
- End of sprint → `/retro` then `/sprint-close`

**End of session:**
- Always overwrite `memory/NEXT.md` with the exact next action
- One commit per completed story: `feat(area): description — closes STORY-XXX`

---

## Iron Rules

1. **Tests first.** `qa-agent` has a hard veto. No story is done without passing tests.
2. **Human approval.** Always show diffs before applying changes.
3. **Backlog everything.** Review findings that don't block merge → BACKLOG.md. Never lost.
4. **Decisions logged.** Every architecture choice → DECISIONS.md with a DEC-XXX number.
5. **NEXT.md is sacred.** End every session with the single most specific next action written.
6. **Append-only memory.** LEARNINGS.md and completed stories are never deleted.

---

## Setup

1. Copy `.claude/` and `memory/` into your project root
2. Edit `memory/STATE.md` — set your project name and first sprint goal
3. Edit `memory/BACKLOG.md` — add your first 3-5 stories
4. Run `/status` — verify all agents load
5. Run `/standup` — begin

The team is ready when `/standup` shows all 7 agents reporting.
