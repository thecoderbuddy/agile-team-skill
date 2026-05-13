# Agile Team for Claude Code

> An AI-powered agile team for any software project. Ship with the discipline of a senior team — even when you're building alone.

<p align="center">
  <a href="https://github.com/thecoderbuddy/agile-team-skill/blob/main/LICENSE">
    <img src="https://img.shields.io/badge/license-MIT-blue.svg" alt="MIT License" />
  </a>
  <a href="https://claude.ai/code">
    <img src="https://img.shields.io/badge/Claude_Code-compatible-blueviolet?logo=anthropic" alt="Claude Code compatible" />
  </a>
  <img src="https://img.shields.io/badge/agents-7-orange" alt="7 agents" />
  <img src="https://img.shields.io/badge/commands-29-green" alt="29 commands" />
  <img src="https://img.shields.io/badge/stack-any-lightgrey" alt="Works with any stack" />
</p>

<p align="center">
  <a href="#setup">Quick Start</a> •
  <a href="#the-7-agents">Agents</a> •
  <a href="#all-29-commands">Commands</a> •
  <a href="#contributing">Contributing</a>
</p>

---

## The problem it solves

Solo developers and small teams skip the things that matter most — not because they don't care, but because there's nobody to hold them to it.

No one reviews your PR critically. No one catches the security hole you didn't think of. Nobody asks "does this story actually have acceptance criteria?" Nobody remembers what you decided last sprint or why.

This gives you that team.

---

## What it actually does

Seven specialist agents collaborate on your project — each with one job, one area of authority. When you run `/review`, four agents read your diff from four different angles:

```
You run:  /review

  pr-reviewer  → correctness, style, edge cases, dead code
  security     → secrets, OWASP, CVEs, input validation, auth
  qa           → test coverage, acceptance criteria, missing states
  tech-lead    → architecture alignment, tech debt, patterns

  po           → collects all findings:
                   FIX NOW    → blocks merge
                   BACKLOG    → added to BACKLOG.md automatically
                   WON'T FIX  → documented with reasoning

You get:  APPROVED or CHANGES REQUESTED
          + every non-blocking issue in your backlog, not forgotten
```

That's the pattern for every command. Multiple specialists. One synthesizer. One artifact.

---

## Before and after

| Before | After |
|---|---|
| Commit and hope nothing breaks | 4 specialist agents review every diff |
| Security issues show up in production | Security reviewed on every commit — OWASP, secrets, CVEs |
| Lose context switching sessions | `NEXT.md` tells you exactly what to do, every session |
| Backlog is a pile of random notes | Stories written, groomed, and prioritized by a product owner |
| Tech debt accumulates silently | Tech debt gets a story the moment it's introduced |
| Ship without acceptance criteria | QA hard veto — nothing ships without passing tests |
| Retros never happen | Every sprint closes with a retro that produces real backlog items |

---

## The 7 Agents

| Agent | What they do for you |
|---|---|
| `po-agent` | Writes proper user stories with acceptance criteria. Prioritizes your backlog. Synthesizes all review findings into a verdict. |
| `pm-agent` | Keeps you focused. Owns the sprint state and NEXT.md. Makes sure nothing is blocked without a plan. |
| `dev-agent` | Implements stories, reports in standups, flags blockers early. |
| `qa-agent` | Adds test scenarios to every story. **Hard veto** — nothing ships without passing tests. No exceptions. |
| `pr-reviewer-agent` | Senior-level code review on every diff. Correctness, patterns, performance, maintainability. |
| `security-analyst-agent` | Scans every diff for OWASP issues, secrets, CVEs, auth holes. **Soft veto** — can block a PR. |
| `tech-lead-agent` | Tracks architecture decisions. Estimates complexity. Writes tech specs for complex work. Flags tech debt. |

---

## How a day works

```
First time only
  /init "I'm building a REST API for expense tracking"
  → agents scan your project, write real stories, set sprint goal

Every morning
  /standup
  → all agents report, blockers surfaced, today's focus confirmed

When you're ready to build
  /new-task
  → PO picks next story, tech-lead writes spec if needed, dev starts

Before you commit
  /review
  → 4 agents review your diff, PO gives verdict + backlogs non-blockers
  /complete STORY-001
  → mark done, commit

End of sprint
  /retro        → all agents reflect, actions become backlog stories
  /sprint-close → velocity, carry-overs, sprint closed
  /sprint-plan  → plan the next one
```

---

## Session Continuity

At the end of every session, `pm-agent` writes `memory/NEXT.md` — specific enough that zero context is needed to resume.

```
Next time you open Claude Code:
  /standup   → team picks up exactly where you left off
```

Five files persist your full project state across every session:

```
memory/
├── NEXT.md       Exact next step — specific file, function, outcome
├── STATE.md      Sprint goal, velocity, blockers, in-progress stories
├── BACKLOG.md    All stories — from /stories, /review, /retro
├── DECISIONS.md  Architecture decisions (DEC-001, DEC-002, ...)
└── LEARNINGS.md  Retro learnings — append-only, never deleted
```

---

## Setup

### Prerequisites

- [Claude Code](https://claude.ai/code) CLI or desktop app

### 1. Install inside your project

```bash
cd your-project
curl -fsSL https://raw.githubusercontent.com/thecoderbuddy/agile-team-skill/main/install.sh | bash
```

Or clone and install locally:

```bash
git clone https://github.com/thecoderbuddy/agile-team-skill.git
cd your-project
bash /path/to/agile-team-skill/install.sh
```

The installer asks before overwriting anything — safe to run on existing projects.

### 2. Open Claude Code

```bash
cd your-project
claude
```

### 3. Onboard the team

**New project:**
```
/init "I'm building a task manager CLI in Python"
```

**Existing project** — agents scan the codebase and infer what's built and missing:
```
/init
```

Agents will write real stories into `BACKLOG.md`, set a sprint goal in `STATE.md`, and tell you exactly what to do next.

### 4. Begin

```
/sprint-plan   ← agents plan your first sprint together
/standup       ← start
```

---

## All 29 Commands

| Group | Commands |
|---|---|
| Onboarding | `/init` |
| Core ceremonies | `/standup` `/sprint-plan` `/sprint-close` `/retro` `/review` `/stories` `/backlog` `/new-task` `/status` |
| Story lifecycle | `/discover` `/design` `/complete` `/bug` `/idea` `/missing` |
| Reviews & audits | `/arch-review` `/ux-review` `/security-review` `/risk-review` `/adr` |
| Session management | `/done` `/checkpoint` `/resume` `/health-check` `/logs` `/po` `/incident` `/focus-group` |

---

## Why agents collaborate instead of one agent doing everything

A single agent reviewing your PR has no tension. It wrote the advice, evaluated the security, and decided the verdict — same perspective all the way through.

Collaboration chains give each agent a narrower job and genuine constraints:

- The security analyst only cares about OWASP — not code style
- QA only cares whether acceptance criteria are met — not architecture
- The PO never writes findings — only synthesizes them and makes the call
- The Scrum Master never prioritizes — only ensures nothing is lost

Narrower job = deeper output.

---

## Project Structure

```
agile-team-skill/
├── install.sh                        ← one-command installer
├── CLAUDE.md                         ← project constitution
├── .claude/
│   ├── agents/                       ← 7 specialist agents
│   │   ├── po-agent.md
│   │   ├── pm-agent.md
│   │   ├── dev-agent.md
│   │   ├── qa-agent.md
│   │   ├── pr-reviewer-agent.md
│   │   ├── security-analyst-agent.md
│   │   └── tech-lead-agent.md
│   ├── commands/                     ← 29 slash commands
│   │   ├── init.md                   /init
│   │   ├── standup.md                /standup
│   │   ├── review.md                 /review
│   │   └── ...
│   └── hooks/                        ← session tracking
└── memory/                           ← persistent team state
    ├── NEXT.md
    ├── STATE.md
    ├── BACKLOG.md
    ├── DECISIONS.md
    └── LEARNINGS.md
```

---

## Multiple Projects

Install once per project. Each project gets its own `memory/` — completely separate sprint state, backlog, and decisions. Same 7 agents, same 29 commands, different context.

```
~/projects/
├── api/       ← .claude/ + memory/ + CLAUDE.md (sprint 3)
└── frontend/  ← .claude/ + memory/ + CLAUDE.md (sprint 1)
```

---

## Contributing

New agents, new ceremony commands, improvements to collaboration chains — all welcome.

- **Add an agent:** create `.claude/agents/your-agent.md`. Define its role in each ceremony — that's the collaboration chain contract.
- **Add a command:** create `.claude/commands/your-command.md`. Define which agents participate, in what order, and what artifact they produce.

---

## Release History

* **1.0.0** — Initial release. 7 agents, 29 commands, full agile lifecycle.

---

## License

MIT — use it, fork it, adapt it for your team.

---

*Built from experience running a 40-agent AI engineering team on a real product. Extracted and open-sourced for the developer community.*
