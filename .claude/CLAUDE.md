# Agile Team — AI-Powered Scrum for Any Project

Drop this into any codebase. You get 7 core specialist agents, 6 extended agents activated
per project need, collaborative agile ceremonies, and persistent team memory. No lock-in.
Works with any language or framework.

---

## What's Here

```
.claude/
├── agents/                    ← 7 core + 6 extended agents
│   ├── po-agent.md            Product Owner            (core)
│   ├── pm-agent.md            Scrum Master             (core)
│   ├── dev-agent.md           Developer                (core)
│   ├── qa-agent.md            QA Engineer              (core)
│   ├── pr-reviewer-agent.md   PR Reviewer              (core)
│   ├── security-analyst-agent.md  Security Analyst     (core)
│   ├── tech-lead-agent.md     Tech Lead                (core)
│   ├── senior-engineer-agent.md    Senior Engineer     (extended — roster-gated)
│   ├── ai-engineer-agent.md        AI Engineer         (extended — roster-gated)
│   ├── design-lead-agent.md        Design Lead UX/UI   (extended — roster-gated)
│   ├── principal-engineer-agent.md Principal Engineer  (on-demand consult)
│   ├── cto-agent.md                CTO                 (on-demand escalation)
│   └── ceo-agent.md                CEO                 (on-demand escalation)
├── commands/                  ← 30 slash commands
├── office/                    ← live pixel-office visualization (bash .claude/office/serve.sh)
└── memory/                    ← persistent team state (below)

.claude/memory/
├── NEXT.md                    Exact next action (session continuity)
├── STATE.md                   Current sprint
├── TEAM.md                    Team roster — which extended agents are ACTIVE
├── BACKLOG.md                 Product backlog (## Index at top — read index first)
├── ARCHIVE.md                 Completed stories (append-only — moved here by /complete)
├── DECISIONS.md               Architecture decisions
├── RISKS.md                   Risk register (RISK-XXX entries — owned by /risk-review)
└── LEARNINGS.md               Team learnings (append-only)
```

**Token discipline:** ceremonies read the BACKLOG.md `## Index` section first and extract a
single story body (`awk '/^- \[.\] STORY-XXX:/,/^---$/'`) only when acting on it. In chains,
the orchestrator extracts once and passes the story body in each agent's prompt — agents do
not re-read BACKLOG.md. ARCHIVE.md is never read during ceremonies, with one bounded
exception: the /sprint-close outcome review reads only the last 1–2 sprints' archived
entries (extract the specific stories — never the full file).

---

## The Collaboration Principle: Nesting = Collaboration

No agent works alone. Every ceremony runs a **collaboration chain** — agents give their
perspective in sequence, then one agent synthesizes into a shared artifact.

```
/review chain:
  qa           ──→  quality gate (tests + AC) — STOP if fail, no code review of broken code
  pr-reviewer  ──→  code quality findings
  security     ──→  vulnerability findings
  tech-lead    ──→  architecture findings
  [extended]   ──→  roster-gated lenses (TEAM.md): ai-engineer (AI surface), design-lead (UI)
  po           ──→  [SYNTHESIZES ALL] → APPROVED / CHANGES REQUESTED + BACKLOG items
```

The PO is the hub. Issues that don't block merge go straight to BACKLOG.md. Nothing is lost.

---

## The Dev Pipeline

Every story follows this exact flow:

```
/sprint-plan  po proposes → dev commits capacity → tech-lead estimates → qa validates AC → pm finalizes
      ↓
/standup      daily: done / doing / blocked — blockers get owner + mitigation
      ↓
/new-task     po selects story → tech-lead specs → dev confirms and starts
      ↓
[implement]
      ↓
/review       qa gate first → code review → security → tech-lead → po verdict
              APPROVED → /complete | CHANGES REQUESTED → fix → /review again
      ↓
/complete     commit + close story → /new-task (more stories) or /sprint-close (done)
      ↓
/sprint-close → /retro → /sprint-plan (next sprint)
```

If blocked at any point: `/unblock STORY-XXX "what resolved it"`

---

## The Agents

### Core (always active)

| Agent | Role | Owns | Hard Veto |
|---|---|---|---|
| `po-agent` | Product Owner | BACKLOG.md, sprint goal, user stories | No |
| `pm-agent` | Scrum Master | STATE.md, NEXT.md, TEAM.md, ceremonies | No |
| `dev-agent` | Developer | Code, implementation, capacity estimates | No |
| `qa-agent` | QA Engineer | Test strategy, acceptance criteria | YES — no ship without tests |
| `pr-reviewer-agent` | PR Reviewer | Code review, merge gate | Soft — can block PR |
| `security-analyst-agent` | Security | Vulnerability scan, risk register | Soft — can block PR |
| `tech-lead-agent` | Tech Lead | DECISIONS.md, architecture, estimates | No |

### Extended (roster-gated — see `.claude/memory/TEAM.md`)

Extended agents join ceremonies only while `.claude/memory/TEAM.md` marks them `ACTIVE`.
ON-DEMAND agents never join chains — they are invoked explicitly.

| Agent | Role | Scope | Default |
|---|---|---|---|
| `senior-engineer-agent` | Senior Engineer | L/XL stories, hardest bugs, perf profiling, refactoring roadmap, DX, deep test strategy, /unblock pairing | DORMANT |
| `ai-engineer-agent` | AI Engineer | AI review lens, eval infrastructure, AI architecture, model lifecycle, cost/latency observability, data hygiene, responsible AI | DORMANT |
| `design-lead-agent` | Design Lead (UX/UI) | UX review lens, design system, personas & research, IA/journey maps, UX metrics, copy & tone, /ux-review, /focus-group, /design | DORMANT |
| `principal-engineer-agent` | Principal Engineer | XL design gate, migrations, build-vs-buy, standards/golden paths, scalability & SLOs, consistency audits, spikes, tech radar, tie-breaks | ON-DEMAND |
| `cto-agent` | CTO | Veto overrides, platform decisions, tech roadmap, eng health metrics, security posture, vendor/spend, due diligence, SEV-1 sign-off | ON-DEMAND |
| `ceo-agent` | CEO | Vision/strategy, outcome framework, iterate/pivot/kill, priority deadlock, epic challenges, market signal, pricing, risk appetite | ON-DEMAND |

**Roster rule:** before running any ceremony chain, the orchestrator reads
`.claude/memory/TEAM.md`. Extended agents marked ACTIVE join the ceremonies listed in their
roster row; DORMANT agents are skipped entirely (zero token cost). `/init` proposes the
initial roster from the project scan; flip a Status in TEAM.md any time to change it.

**Escalation path:** agent dispute → po-agent synthesizes (product) / tech-lead decides
(technical) → principal-engineer (technical tie-break) → cto-agent (final technical) or
ceo-agent (final product/business).

---

## Ceremony Map

| Command | Collaboration Chain | Output Artifact |
|---|---|---|
| `/standup` | dev → qa → security → tech-lead → pm synthesizes → po notes | STATE.md updated |
| `/sprint-plan` | po proposes → dev estimates capacity → tech-lead complexity → qa validates AC → security flags → pm finalizes | Sprint in STATE.md |
| `/sprint-close` | pm tallies velocity → po reviews stories → dev/qa/tech-lead sign off | STATE.md CLOSED |
| `/retro` | dev/qa/security/tech-lead reflect → pm facilitates → po backlogs actions → learnings logged | LEARNINGS.md |
| `/review` | qa gate → pr-reviewer → security → tech-lead → po synthesizes | Verdict + BACKLOG.md |
| `/stories` | po writes → qa adds test scenarios → security adds constraints → tech-lead adds notes | BACKLOG.md entry |
| `/backlog` | po leads → tech-lead estimates → qa validates AC → security flags risk | BACKLOG.md prioritized |
| `/new-task` | po selects → tech-lead specs → pm assigns → dev confirms | IN_PROGRESS in STATE.md |
| `/status` | pm reads state → dev/qa/security/tech-lead report health → po assesses backlog | Full project picture |
| `/unblock` | tech-lead confirms resolution (senior-engineer pairs if ACTIVE) → pm clears STATE.md → NEXT.md updated | Blocker removed |

**Roster-gated additions:** ceremonies read `.claude/memory/TEAM.md` in Step 0. Extended agents
marked ACTIVE join at their designated hook: /review + /new-task get extended lenses
(ai-engineer, design-lead) before po synthesis; /standup and /retro add their reports;
/sprint-plan gets Step 5b inputs; /bug and /unblock route hard diagnosis to
senior-engineer; L stories route to senior-engineer in /new-task. ON-DEMAND agents
(principal-engineer, cto, ceo) are invoked explicitly at escalation points: XL design
gate (/sprint-plan), veto overrides (/review), SEV-1 escalation + postmortem sign-off
(/incident), MISSED-metric calls (/sprint-close).

**Built-in name collisions:** `/init`, `/review`, and `/security-review` shadow Claude Code
built-in skills of the same names. In this repo the project commands take precedence. If a
built-in fires instead, invoke the project version explicitly by describing the ceremony
("run the team review chain on STORY-XXX").

---

## Checkpoint Protocol (canonical — referenced by /bug, /review, /new-task, /resume)

Long chains write `.claude/memory/CHECKPOINT.md` after each completed step so `/resume` can recover
a dropped session. Single source of truth for the format:

```
# CHECKPOINT
Command: /review          ← the chain that wrote this
Story: STORY-012          ← or `Bug: [slug]` for /bug chains — both keys are valid
Step 1: DONE
Step 2: DONE
Step 3: SKIPPED (reason)  ← skipped ≠ pending; record why
Step 4: PENDING
```

**Lifecycle rules:**
- Written by `/bug`, `/review`, `/new-task` after each step completes
- A checkpoint is valid if it has `Command:` and either `Story:` or `Bug:`
- Deleted when the chain reaches its terminal state (`/review` APPROVED verdict written;
  `/bug` and `/new-task` story closed). Kept alive during CHANGES REQUESTED loops.
- `/resume` asks before deleting a checkpoint it considers stale or corrupt — never silently
- `/checkpoint` (the session-save command) and `CHECKPOINT.md` (this chain file) are
  unrelated. `/checkpoint` and `/done` must surface a live CHECKPOINT.md before ending
  a session so the user knows a chain is mid-flight.

---

## PR & Ticket Description Structure (canonical — used by /bug, /review, /complete, /stories)

Every bug ticket, PO review verdict, and PR/commit description follows this structure.
Sections marked **(bug)** apply to tickets, **(PR)** to pull-request/commit descriptions.
Skip sections that genuinely don't apply — never leave them empty.

1. **Description** — what's wrong / what changed. File:line references + the offending or changed code snippet.
2. **Severity & priority** (bug) — SEV level + one line justifying it.
3. **Impact** — who/what is affected. Call out silent or misleading failures explicitly: what the user *sees* vs what actually *happened*. List both what fails (❌) and what still appears to work (✅).
4. **Root cause** (bug) — the commit/PR that introduced it, and why review/tests missed it.
5. **Steps to reproduce** (bug) — numbered, including required data/config state. Then **Expected vs Actual**.
6. **Fix** — immediate change + follow-ups split as separate backlog items (STORY-XXX each).
7. **Test plan & evidence** (PR) — how it was verified, with observable proof (test output, logs, console screenshots) — not just "tests pass".
8. **Risk & rollback** (PR) — blast radius of the change *itself* and how to revert.
9. **Out of scope** (PR) — follow-ups explicitly NOT in this change.
10. **Reviewer notes** (PR) — where to focus scrutiny.
11. **Environment / deploy note** — anything unusual about prod state; per-host checks if deploys aren't atomic.
12. **Links** — ticket ↔ PR ↔ commits ↔ related items.
13. **Acceptance criteria** — checkboxes, each independently verifiable; include "production state verified" where relevant.
14. **Monitoring** — how we'll know it works after merge/deploy (log queries, alerts, dashboards).

---

## Session Protocol

**Start of session:**
```
cat .claude/memory/NEXT.md     # exact pickup point — always start here
cat .claude/memory/STATE.md    # sprint status
```

**Then:**
- Start of day → `/standup`
- Need next work → `/new-task`
- Story done → `/review` then `/complete STORY-XXX`
- Blocked → `/unblock STORY-XXX`
- End of sprint → `/sprint-close` then `/retro`

**End of session:**
- Always overwrite `.claude/memory/NEXT.md` with the exact next action
- One commit per completed story: `feat(area): description — closes STORY-XXX`

---

## Security Hook Configuration

### Pre-commit secret scanning (gitleaks)

The installer adds a pre-commit git hook that runs `gitleaks protect --staged`
before every commit. If a secret pattern is detected, the commit is blocked.

**False positive suppression:** Add `# gitleaks:allow` as an inline comment on
the offending line:

```python
TEST_API_KEY = "sk-test-placeholder"  # gitleaks:allow
```

**Emergency bypass** (use sparingly, document why in commit message):
```bash
git commit --no-verify -m "reason: ..."
```

**Not installed?** The hook exits 0 with a warning — commits still work.
Install gitleaks to activate: `brew install gitleaks`

---

### Secret scan override (Write/Edit tool)
The `pre-tool-use.sh` hook scans every Write and Edit tool call for known secret
patterns (OpenAI keys, GitHub tokens, AWS keys, Bearer tokens, PEM private keys).

If you hit a false positive on a legitimate code constant (e.g. a test fixture
with a placeholder key pattern), you can bypass the scan for a single session:

```bash
export SKIP_SECRET_SCAN=1
```

**Rules:**
- Document the reason in your commit message when bypassing
- Unset after use: `unset SKIP_SECRET_SCAN`
- Do not set this permanently in your shell profile
- Do not commit files with real secrets even with the override active

The override bypasses the scan only — it does not disable the `.env` write block
or the DEC-001 payload check. Those run regardless.

---

## Iron Rules

1. **Tests first.** `qa-agent` has a hard veto. No story is done without passing tests.
2. **QA before code review.** `/review` runs QA first — broken code doesn't get reviewed.
3. **Human approval.** Always show diffs before applying changes.
4. **Backlog everything.** Review findings that don't block merge → BACKLOG.md. Never lost.
5. **Decisions logged.** Every architecture choice → DECISIONS.md with a DEC-XXX number.
6. **NEXT.md is sacred.** End every session with the single most specific next action written.
7. **Append-only memory.** LEARNINGS.md and completed stories are never deleted.

---

## Security Review Cadence

The team tracks when `/security-review` was last run and flags it during `/standup` if overdue.

**Default:** 30 days (see `.claude/commands/standup.md` for the configured value — that file is the single source of truth)

**How to change the threshold:**
Edit the single value on the line marked `<!-- CONFIGURABLE: ... -->` in
`.claude/commands/standup.md`. That is the only integer you need to change — the logic
condition and flag message text both reference it as "the configured threshold".

**What triggers the flag:**
The `security-analyst-agent` standup block will set a `Blocked:` entry when either:
- The `## Last Security Review` line in `.claude/memory/STATE.md` reads `[Never run]`
- The date recorded there is more than the configured threshold (default: 30 days) before today

When within threshold, no flag is raised and the standup stays clean.

**Where review results are stored:**
- `.claude/memory/STATE.md` — `## Last Security Review` line (overwritten each run)
- `.claude/memory/LEARNINGS.md` — `## Security Review Log` section (append-only history)

---

## Setup

```bash
cd your-project
curl -fsSL https://raw.githubusercontent.com/thecoderbuddy/agile-team-skill/main/install.sh | bash
claude
```

Then run `/init` — agents scan your project (or use your description) and populate the memory files with real stories, a sprint goal, and your first next action.

The team is ready when `/init` writes to `.claude/memory/BACKLOG.md`.
