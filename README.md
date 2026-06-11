# Agile Team for Claude Code

> An AI agentic team designed for your agile workflow. For anyone building a product independently — with the discipline of a real team behind every decision.

<p align="center">
  <a href="https://github.com/thecoderbuddy/agile-team-skill/blob/main/LICENSE">
    <img src="https://img.shields.io/badge/license-MIT-blue.svg" alt="MIT License" />
  </a>
  <a href="https://claude.ai/code">
    <img src="https://img.shields.io/badge/Claude_Code-compatible-blueviolet?logo=anthropic" alt="Claude Code compatible" />
  </a>
  <img src="https://img.shields.io/badge/agents-7-orange" alt="7 agents" />
  <img src="https://img.shields.io/badge/commands-30-green" alt="30 commands" />
  <img src="https://img.shields.io/badge/stack-any-lightgrey" alt="Works with any stack" />
</p>

<p align="center">
  <a href="#setup">Quick Start</a> •
  <a href="#the-7-agents">Agents</a> •
  <a href="#all-30-commands">Commands</a> •
  <a href="#contributing">Contributing</a>
</p>

<p align="center">
  <a href="https://buymeacoffee.com/sharvari">
    <img src="https://img.shields.io/badge/Buy%20Me%20a%20Coffee-support%20this%20project-FFDD00?style=for-the-badge&logo=buy-me-a-coffee&logoColor=black" alt="Buy Me a Coffee" />
  </a>
</p>

---

## The problem it solves

When you're building a product alone, you skip the things that matter most — not because you don't care, but because there's nobody to hold you to them.

You ship without a proper review. You make a product decision, forget the reasoning, then reverse it two weeks later. You write a story with no acceptance criteria and call it done anyway. Security holes slip through. Tech debt piles up quietly. You know what good process looks like — you just have no one to run it with.

It doesn't matter if you're a developer, a founder, or someone building with AI for the first time. The gap is the same: the work is solo, but the discipline that makes teams ship well — review loops, clear ownership, sprint memory — isn't.

This gives you that team. An AI agentic team designed around your agile workflow, not a single assistant trying to do everything at once.

---

## What it actually does

Seven agents. Each one has a single job and won't budge from it. When you run `/review`, QA checks first — if your code doesn't meet the acceptance criteria, the review stops there. No code review of broken code. If it passes, four agents process your diff in sequence, then the PO collects all findings and gives you one verdict:

```
You run:  /review

  qa           → tests pass? AC met? edge cases covered?
                 ↓ FAIL → stop here. back to dev. no exceptions.
                 ↓ PASS → proceed

  pr-reviewer  → correctness, style, edge cases, dead code
  security     → secrets, OWASP, CVEs, input validation, auth
  tech-lead    → architecture alignment, tech debt, patterns

  po           → collects all findings:
                   FIX NOW    → blocks merge
                   BACKLOG    → added to BACKLOG.md automatically
                   WON'T FIX  → documented with reasoning

You get:  APPROVED → run /complete to commit
          CHANGES REQUESTED → fix → /review again
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

<table>
  <tr>
    <td align="center" width="120"><img src="assets/po-agent.png" width="80"/><br/><b>po-agent</b></td>
    <td align="center" width="120"><img src="assets/pm-agent.png" width="80"/><br/><b>pm-agent</b></td>
    <td align="center" width="120"><img src="assets/dev-agent.png" width="80"/><br/><b>dev-agent</b></td>
    <td align="center" width="120"><img src="assets/qa-agent.png" width="80"/><br/><b>qa-agent</b></td>
    <td align="center" width="120"><img src="assets/pr-reviewer-agent.png" width="80"/><br/><b>pr-reviewer</b></td>
    <td align="center" width="120"><img src="assets/security-analyst-agent.png" width="80"/><br/><b>security</b></td>
    <td align="center" width="120"><img src="assets/tech-lead-agent.png" width="80"/><br/><b>tech-lead</b></td>
  </tr>
</table>

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

Sprint planning (start of sprint)
  /sprint-plan
  → PO proposes stories from backlog
  → dev commits capacity ("I can take 3 stories, STORY-001 is 2 days...")
  → tech-lead estimates complexity, flags dependencies
  → QA validates acceptance criteria
  → SM finalizes sprint in STATE.md

Every morning
  /standup
  → each agent reports: done / doing / blocked
  → blockers get an owner and mitigation
  → today's focus confirmed from NEXT.md

When you pick up a story
  /new-task
  → PO selects highest priority unblocked story
  → tech-lead writes spec if M+ complexity
  → dev confirms: AC clear, approach clear, ready to start

You implement the story, then...
  /review
  → QA validates first: tests pass? AC met? (hard stop if not)
  → code review: style, security, architecture
  → PO verdict: APPROVED or CHANGES REQUESTED

  If CHANGES REQUESTED → fix → /review again
  If APPROVED →

  /complete STORY-XXX "description"
  → commit with proper format
  → story closed in STATE.md
  → NEXT.md updated

  → more stories? /new-task
  → all done?    /sprint-close

If something is blocking you
  /unblock STORY-XXX "what was blocked and how it's resolved"
  → tech-lead confirms resolution
  → blocker cleared from STATE.md

End of sprint
  /sprint-close → velocity tallied, carry-overs moved to backlog
  /retro        → all agents reflect, actions become backlog stories
  /sprint-plan  → plan the next sprint
```

---

## Session Continuity

At the end of every session, `pm-agent` writes `memory/NEXT.md` — specific enough that zero context is needed to resume.

```
Next time you open Claude Code:
  /standup   → team picks up exactly where you left off
```

If a session drops mid-chain (rate limit, host sleep, lid close), the team writes a `CHECKPOINT.md` after every agent step. Run `/resume` and the chain picks up from exactly where it stopped — no repeated work, no lost progress. Corrupt or stale checkpoints are detected and discarded automatically.

Six files persist your full project state across every session:

```
memory/
├── NEXT.md       Exact next step — specific file, function, outcome
├── STATE.md      Sprint goal, velocity, blockers, in-progress stories
├── BACKLOG.md    Open stories — Index at top, bodies below
├── ARCHIVE.md    Completed stories — append-only, moved here by /complete
├── DECISIONS.md  Architecture decisions (DEC-001, DEC-002, ...)
└── LEARNINGS.md  Retro learnings — append-only, never deleted
```

---

## Model configuration

Each agent has a `model:` field in its frontmatter. Edit the agent file directly to change which model it uses — Claude Code picks it up automatically.

```yaml
# .claude/agents/security-analyst-agent.md
---
name: security-analyst-agent
model: sonnet    # change this to: sonnet | opus | haiku | inherit
---
```

Valid values: `sonnet`, `opus`, `haiku`, `inherit` (inherits the session default)

Most agents default to `sonnet`. `pm-agent` runs on `haiku` because its work is templated state writes — no deep reasoning needed. You can tune each agent independently:

**Default install** (balanced — calibrated for cost without losing review quality):

| Agent file | Model | Why |
|---|---|---|
| `pm-agent.md` | `haiku` | templated STATE.md / NEXT.md writes — frequent and lightweight |
| everything else | `sonnet` | code review, security checks, synthesis — sonnet is the right tier |

**Quality-first override** — bump the deep-reasoning agents to Opus for high-stakes projects:

| Agent file | Model | Why |
|---|---|---|
| `security-analyst-agent.md` | `opus` | catches subtle vulnerabilities sonnet may miss |
| `tech-lead-agent.md` | `opus` | architecture decisions where depth pays off |

**Cost-optimised** — Haiku across more roles, only review agents stay on Sonnet:

| Agent file | Model | Why |
|---|---|---|
| `pm-agent.md` | `haiku` | already default |
| `dev-agent.md` | `haiku` | capacity estimates, status reports |
| `po-agent.md` | `haiku` | backlog updates, ceremony output |
| `security-analyst-agent.md` | `sonnet` | already default — keep here, don't push to haiku |
| everything else | `sonnet` | review agents need the quality |

Edit each agent's `.md` file individually — there is no single config file.

---

## Setup

### Prerequisites — install Claude Code

Works on any [Claude Code](https://claude.ai/code) surface. Pick whichever fits your workflow:

| Surface | How to install |
|---|---|
| **Terminal CLI** | [`claude.ai/code`](https://claude.ai/code) → "Install CLI" |
| **Desktop app** (Mac / Windows) | [`claude.ai/code`](https://claude.ai/code) → "Download" |
| **VS Code** | Extensions panel → search **"Claude Code"** (by Anthropic) → Install |
| **JetBrains** (IntelliJ, PyCharm, GoLand, …) | Plugins → search **"Claude Code"** → Install |
| **Web** | open [`claude.ai/code`](https://claude.ai/code) in any browser |

The `/plugin` commands below work identically on every surface — they're a Claude Code feature, not surface-specific.

**Optional:** [gitleaks](https://github.com/gitleaks/gitleaks) for pre-commit secret scanning.

```bash
brew install gitleaks   # macOS
```

The installer warns if gitleaks is missing and skips scanning until it's available. Everything else works without it.

### Quick Start (brand-new project — copy/paste)

In your terminal:

```bash
mkdir my-project && cd my-project
git init
claude              # or open this folder in VS Code / Claude Code Desktop / claude.ai/code
```

Then inside Claude Code, type these slash commands one by one:

```
/plugin marketplace add thecoderbuddy/agile-team-skill
/plugin install agile-team@agile-team-marketplace
/init "I'm building a REST API for expense tracking"
/sprint-plan
/standup
```

That's the full zero-to-running flow. After `/init`, you'll see `memory/` and `CLAUDE.md` created in your project. After `/sprint-plan`, the team has a sprint goal and you're ready to ship.

The detailed sections below walk through each step — including the VS Code / JetBrains / web variants and the alternative `install.sh` path.

---

### 1. Install

Two paths — pick one:

#### Option A: Claude Code plugin (recommended)

Works in any Claude Code surface (CLI, desktop app, claude.ai/code in browser, or VS Code / JetBrains extension). Run these **inside Claude Code**:

```
/plugin marketplace add thecoderbuddy/agile-team-skill
/plugin install agile-team@agile-team-marketplace
```

That's it. The 7 agents, 30 commands, and safety hooks are available immediately. No files are written into your project — Claude Code holds the plugin centrally, and updates come through the marketplace.

Skip to **step 3** below to onboard a project.

#### Option B: Local install via script

Writes `.claude/` and the hooks directly into your project. Pick this if you want a tracked-in-repo install you can commit and customize per-project.

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

### 2. Open your project in Claude Code

| Surface | How |
|---|---|
| **CLI** | `cd your-project && claude` |
| **Desktop app** | Launch Claude Code → File → Open Folder → select your project |
| **VS Code** | Open the project in VS Code → click the Claude Code icon in the sidebar (or `Cmd/Ctrl+Shift+P` → **"Claude Code: Open"**) |
| **JetBrains** | Open the project → Tool Windows → **Claude Code** |
| **Web** | Open [`claude.ai/code`](https://claude.ai/code) → New session → connect your GitHub repo |

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

## All 30 Commands

| Group | Commands |
|---|---|
| Onboarding | `/init` |
| Core ceremonies | `/standup` `/sprint-plan` `/sprint-close` `/retro` `/review` `/stories` `/backlog` `/new-task` `/status` |
| Story lifecycle | `/discover` `/design` `/complete` `/unblock` `/bug` `/idea` `/missing` |
| Reviews & audits | `/arch-review` `/ux-review` `/security-review` `/risk-review` `/adr` |
| Session management | `/done` `/checkpoint` `/resume` `/health-check` `/logs` `/po` `/incident` `/focus-group` |

---

## Why this works when one agent doesn't

A single agent reviewing your PR has no tension. It helped write the code, evaluated the security, and decided the verdict — same context, same perspective, all the way through. It has no reason to push back hard.

These agents disagree with each other. Each one has a narrower job and genuine constraints the others don't share:

- QA has a **hard veto** — nothing ships without passing tests, no exceptions
- Security has a **soft veto** — can block a PR; findings never silently disappear
- The PO **never writes findings** — only synthesizes them and makes the call
- The Scrum Master **never prioritizes** — only ensures nothing is lost

When QA fails, the chain stops. When security finds a critical issue, it escalates — it doesn't suggest. When a finding doesn't block merge, it goes straight to the backlog, not into a chat message you'll scroll past and forget.

That's the difference between a team and a panel of assistants.

*Built from experience running a 40-agent AI engineering team on a real product.*

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
│   ├── commands/                     ← 30 slash commands
│   │   ├── init.md                   /init
│   │   ├── standup.md                /standup
│   │   ├── review.md                 /review
│   │   └── ...
│   └── hooks/                        ← safety gates + secret scanning
└── memory/                           ← persistent team state
    ├── NEXT.md
    ├── STATE.md
    ├── BACKLOG.md
    ├── ARCHIVE.md
    ├── DECISIONS.md
    └── LEARNINGS.md
```

---

## Multiple Projects

Install once per project. Each project gets its own `memory/` — completely separate sprint state, backlog, and decisions. Same 7 agents, same 30 commands, different context.

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

* **1.1.0** — Real scrum flow: dev capacity in sprint planning, QA gates code review, /unblock command, handoff lines throughout.
* **1.0.0** — Initial release. 7 agents, 30 commands, full agile lifecycle.

---

## Support

If this saves you time, consider buying me a coffee:

<a href="https://buymeacoffee.com/sharvari">
  <img src="https://www.buymeacoffee.com/assets/img/custom_images/orange_img.png" alt="Buy Me A Coffee" />
</a>

---

## License

MIT — use it, fork it, adapt it for your team.

---

