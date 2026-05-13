# Agile Team for Claude Code

> Drop 7 specialist AI agents into any project. Get a full agile team — standup, sprint planning, PR review, retrospectives, backlog, security analysis — all collaborating like a real team.

Works with any language. Works with any framework. Zero config beyond copying two folders.

---

## What is this?

A set of Claude Code agents and slash commands that give you an AI-powered agile team for your software project.

Not one assistant that tries to do everything. Seven specialists that collaborate with each other — each with a defined role, authority, and output — the same way a real scrum team would.

```
You run:  /review

What happens:
  pr-reviewer  → reads the diff, checks correctness, style, performance
  security     → scans for secrets, OWASP issues, vulnerable dependencies
  qa           → checks test coverage, validates acceptance criteria
  tech-lead    → checks architecture alignment, flags tech debt
  po           → collects all findings, gives verdict, adds issues to backlog

You get:  APPROVED or CHANGES REQUESTED + backlog items from everything that wasn't blocking
```

Nothing is lost. Issues that don't block the merge go straight to the backlog. Every ceremony produces a real artifact.

---

## The Collaboration Principle

**Nesting = Collaboration.** Every command is a choreographed chain of agents. Each agent adds their perspective. One agent synthesizes.

```
/sprint-plan
  po          ──→  proposes sprint goal + stories from backlog
  tech-lead   ──→  estimates complexity, flags dependencies
  qa          ──→  validates acceptance criteria, flags untestable stories
  security    ──→  flags elevated-risk stories
  pm          ──→  [SYNTHESIZES] → finalizes sprint, writes STATE.md + NEXT.md

/standup
  dev         ──→  done / doing / blocked
  qa          ──→  done / doing / blocked
  security    ──→  active concerns
  tech-lead   ──→  architectural blockers
  pm          ──→  [SYNTHESIZES] → updates STATE.md, owns blockers
  po          ──→  notes scope drift, flags sprint goal risk

/retro
  dev         ──→  what slowed me down / what worked
  qa          ──→  quality gaps, late AC changes
  security    ──→  issues caught late
  tech-lead   ──→  tech debt accumulated
  pm          ──→  [FACILITATES] → velocity, action items
  po          ──→  converts action items to backlog stories, nothing drops

/stories [feature]
  po          ──→  writes user story + acceptance criteria
  qa          ──→  adds test scenarios + definition of done
  security    ──→  adds security constraints
  tech-lead   ──→  adds technical notes + complexity estimate
                   → story added to BACKLOG.md, ready to sprint
```

---

## The 7 Agents

| Agent | Role | What they own | Hard veto? |
|---|---|---|---|
| `po-agent` | Product Owner | BACKLOG.md, sprint goal, story format | No |
| `pm-agent` | Scrum Master | STATE.md, NEXT.md, ceremonies | No |
| `dev-agent` | Developer | Implementation, code | No |
| `qa-agent` | QA Engineer | Test strategy, acceptance criteria | **Yes** — nothing ships without tests |
| `pr-reviewer-agent` | PR Reviewer | Code quality, merge gate | Soft — can block PR |
| `security-analyst-agent` | Security Analyst | Vulnerability scan, secrets, OWASP | Soft — can block PR |
| `tech-lead-agent` | Tech Lead | DECISIONS.md, architecture, estimates | No |

**Hard veto** means qa-agent can block a story from being marked done — no exceptions. Tests must pass. Acceptance criteria must be met. The only override is an explicit exception logged in DECISIONS.md with a follow-up story in the backlog.

---

## Ceremonies

| Command | What happens | Output |
|---|---|---|
| `/standup` | All agents report. PM synthesizes. PO notes. | STATE.md updated |
| `/sprint-plan` | PO proposes. Team challenges. PM finalizes. | Sprint in STATE.md |
| `/sprint-close` | PM reads velocity. PO confirms stories. | Sprint closed |
| `/retro` | All agents reflect. PM facilitates. PO backlogs actions. | LEARNINGS.md |
| `/review` | 4 agents review. PO gives verdict + backlogs issues. | Verdict + BACKLOG.md |
| `/stories [feature]` | PO writes. QA tests. Security constrains. Tech Lead estimates. | BACKLOG.md |
| `/backlog` | PO prioritizes. Tech Lead estimates. QA validates AC. Security flags risk. | BACKLOG.md |
| `/new-task` | PO selects. Tech Lead specs. PM assigns. Dev starts. | NEXT.md + STATE.md |
| `/status` | All agents report health. Full project picture. | Project status |

---

## Memory System

Five files that persist state across sessions. Agents read and write these — you never need to manage them manually.

```
memory/
├── NEXT.md        The single most specific next action. Overwritten every session end.
│                  Written precisely enough that zero context is needed to resume.
│
├── STATE.md       Current sprint: goal, status, in-progress stories, velocity, blockers.
│                  Owned by pm-agent. Updated after every standup.
│
├── BACKLOG.md     All stories. Written by /stories. Enriched by /backlog.
│                  Issues from /review go here. Retro actions go here. Nothing is lost.
│
├── DECISIONS.md   Architecture decisions (DEC-001, DEC-002, ...).
│                  Owned by tech-lead-agent. Read by all agents before architecture work.
│
└── LEARNINGS.md   Retro learnings. Append-only, never deleted.
                   Agents read this to avoid repeating past mistakes.
```

**Session continuity:** at the start of every session, read `memory/NEXT.md`. That's your pickup point. At the end of every session, pm-agent overwrites it with the next exact step.

---

## Setup

**Requirements:** Claude Code CLI or desktop app.

### 1. Run the installer inside your project

```bash
cd your-project
curl -fsSL https://raw.githubusercontent.com/thecoderbuddy/agile-team-skill/main/install.sh | bash
```

Or if you cloned the repo locally:

```bash
cd your-project
bash /path/to/agile-team/install.sh
```

The installer handles existing files safely — it asks before overwriting anything.

### 2. Open Claude Code

```bash
claude
```

### 3. Run /init

```
/init "describe what you're building in one sentence"
```

The agents will scan your project (or use your description), write real stories into `BACKLOG.md`, set a sprint goal in `STATE.md`, and tell you exactly what to do next.

**Existing project with no description?** Just run `/init` with no argument — agents scan the codebase, infer what's built and what's missing, and bootstrap the backlog from that.

### 4. Start your first sprint

```
/sprint-plan     ← agents plan the sprint together
/standup         ← begin
```

---

## How a typical day looks

```
First time (run once)
  /init "I'm building a ..."   ← agents set up backlog, sprint goal, next action
  /sprint-plan                 ← plan sprint 1

Every morning
  /standup          ← all agents report, blockers surfaced, focus confirmed

During the day
  /new-task         ← pick next story, get tech spec, begin implementation

Before committing
  /review           ← 4-agent review, verdict, backlog intake
  /complete STORY-XXX ← mark done, commit

End of sprint
  /retro            ← all agents reflect, actions → backlog
  /sprint-close     ← velocity, carry-overs, close
  /sprint-plan      ← plan next sprint
```

---

## What agents check in /review

**pr-reviewer-agent** — Code quality
- Does the code do what it claims? Edge cases handled?
- Matches existing patterns? No dead code, unrelated changes?
- No hardcoded secrets (first pass)?

**security-analyst-agent** — Security
- Secrets scan: API keys, tokens, passwords in code or config
- Input validation: user input reaching the system without sanitisation?
- Dependencies: new packages with known CVEs?
- Data handling: sensitive data logged or stored insecurely?
- Auth: endpoints accessible without proper checks?

**qa-agent** — Quality gate
- Tests exist for the changed code?
- Acceptance criteria from the story are met?
- All states handled: loading, empty, error, success?

**tech-lead-agent** — Architecture
- Consistent with established patterns in DECISIONS.md?
- New patterns introduced? Should they be logged as a DEC?
- Tech debt introduced? Acceptable and backlogged?

**po-agent** — Synthesis
- Collects all findings
- FIX NOW: blocks merge
- BACKLOG: added to BACKLOG.md automatically
- WON'T FIX: documented with reasoning
- Final verdict: APPROVED or CHANGES REQUESTED

---

## Iron Rules

These are not preferences. They are enforced by agent design.

1. **Tests first.** `qa-agent` hard veto. No story is done without passing tests and met acceptance criteria.

2. **Human approval.** Diffs are always shown before changes are applied. No agent applies code changes without your explicit approval.

3. **Backlog everything.** Review findings that don't block merge go to BACKLOG.md immediately. Nothing is forgotten.

4. **Decisions logged.** Every architecture choice goes into DECISIONS.md with rationale and alternatives. `tech-lead-agent` owns this.

5. **NEXT.md is sacred.** End every session by writing the single most specific next action. Zero context should be needed to resume.

6. **Append-only memory.** LEARNINGS.md and completed stories are never deleted. The team learns from history.

---

## Project Structure

```
agile-team/
├── CLAUDE.md                         ← Project constitution (read first)
│
├── .claude/
│   ├── agents/
│   │   ├── po-agent.md               Product Owner
│   │   ├── pm-agent.md               Scrum Master
│   │   ├── dev-agent.md              Developer
│   │   ├── qa-agent.md               QA Engineer
│   │   ├── pr-reviewer-agent.md      PR Reviewer
│   │   ├── security-analyst-agent.md Security Analyst
│   │   └── tech-lead-agent.md        Tech Lead
│   │
│   └── commands/
│       │
│       │   ── Onboarding ──
│       ├── init.md                   /init
│       │
│       │   ── Core ceremonies ──
│       ├── standup.md                /standup
│       ├── sprint-plan.md            /sprint-plan
│       ├── sprint-close.md           /sprint-close
│       ├── retro.md                  /retro
│       ├── review.md                 /review
│       ├── stories.md                /stories
│       ├── backlog.md                /backlog
│       ├── new-task.md               /new-task
│       ├── status.md                 /status
│       │
│       │   ── Story lifecycle ──
│       ├── discover.md               /discover
│       ├── design.md                 /design
│       ├── complete.md               /complete
│       ├── bug.md                    /bug
│       ├── idea.md                   /idea
│       ├── missing.md                /missing
│       │
│       │   ── Reviews & audits ──
│       ├── arch-review.md            /arch-review
│       ├── ux-review.md              /ux-review
│       ├── security-review.md        /security-review
│       ├── risk-review.md            /risk-review
│       ├── adr.md                    /adr
│       │
│       │   ── Session management ──
│       ├── done.md                   /done
│       ├── checkpoint.md             /checkpoint
│       ├── resume.md                 /resume
│       ├── health-check.md           /health-check
│       ├── logs.md                   /logs
│       ├── po.md                     /po
│       ├── incident.md               /incident
│       └── focus-group.md            /focus-group
│
└── memory/                           ← Persistent team memory
    ├── NEXT.md                       Exact next action
    ├── STATE.md                      Current sprint
    ├── BACKLOG.md                    Product backlog
    ├── DECISIONS.md                  Architecture decisions
    └── LEARNINGS.md                  Team learnings (append-only)
```

---

## Why collaboration chains?

Most AI agent setups give you one agent that switches modes. The problem: a single agent reviewing your PR is also the one that wrote the advice, evaluated the security, and decided on the verdict. There's no tension. No second opinion. No specialist depth.

Collaboration chains mean:

- The security analyst doesn't care about code style — they only care about OWASP
- The QA engineer doesn't care about architecture — they only care about whether the story's acceptance criteria are met
- The PO doesn't write any of the findings — they only synthesize them and make the call
- The Scrum Master doesn't prioritize — they only ensure the process works and nothing is lost

Each agent has a narrower job and does it better. The chain produces richer output than any single agent could.

---

## Multi-Project Setup

One developer. Multiple projects. One agile team.

```
Developer machine
├── project-a/
│   ├── .claude/        ← copy of agile-team/.claude/
│   ├── memory/         ← project-a's memory (STATE, BACKLOG, NEXT, etc.)
│   └── CLAUDE.md       ← project-a's constitution
│
└── project-b/
    ├── .claude/        ← copy of agile-team/.claude/
    ├── memory/         ← project-b's memory (completely separate)
    └── CLAUDE.md       ← project-b's constitution
```

The `memory/` folder lives inside each project. `STATE.md`, `BACKLOG.md`, and `NEXT.md` are always scoped to the project you're currently in. No cross-contamination.

The 7 agents and all ceremony commands stay identical across projects. Only the memory and project context change.

### Per-project CLAUDE.md

Each project has its own `CLAUDE.md` that sets project-specific context:

```markdown
# CLAUDE.md — Project B

Project: project-b
Stack: [your stack]

## What this project does
[one paragraph]

## Architecture decisions
See memory/DECISIONS.md

## Start of session
cat memory/NEXT.md
cat memory/STATE.md
```

---

## Contributing

This is an open-source framework, not a product. Contributions welcome:

- New agent definitions (designer, data engineer, DevOps, etc.)
- New ceremony commands
- Improvements to existing collaboration chains
- Translations to other languages

To add a new agent: create `.claude/agents/your-agent.md` following the existing format. Define the agent's role in each ceremony explicitly — that's the collaboration chain contract.

To add a new command: create `.claude/commands/your-command.md`. Define which agents participate, in what order, and what artifact they produce.

---

## License

MIT — use it, fork it, adapt it for your team.

---

Built from experience running a 40-agent AI engineering team on a real product. Extracted and open-sourced for the developer community.
