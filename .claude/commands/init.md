# /init — Project Onboarding

Usage: `/init ["describe your project"]`

Arguments: $ARGUMENTS

**Run this once when you first set up the agile team on a project.**
Populates STATE.md, BACKLOG.md, and NEXT.md so the team is ready to sprint.

Two modes:
- With argument: `"/init I'm building a CLI tool that converts markdown to PDF"`
- No argument: agents scan the existing codebase and infer

---

## Step 0 — Detect mode

If `$ARGUMENTS` is provided → **Description mode** (user told us what they're building).
If `$ARGUMENTS` is empty → **Scan mode** (infer from existing codebase).

---

## Step 1 — Gather context

**In Description mode**, use the provided description as the source of truth.

**In Scan mode**, read the project:
```bash
ls -la
cat README.md 2>/dev/null || echo "no README"
cat package.json 2>/dev/null || cat pyproject.toml 2>/dev/null || cat Cargo.toml 2>/dev/null || cat go.mod 2>/dev/null || echo "no package manifest"
git log --oneline -20 2>/dev/null || echo "no git history"
git status 2>/dev/null || echo "not a git repo"
ls src/ 2>/dev/null || ls app/ 2>/dev/null || ls lib/ 2>/dev/null || echo "no standard src dir"
```

---

## Step 2 — po-agent defines the project

**po-agent** answers:
- What is this project? (one sentence — what it does and who it's for)
- What's the primary user persona? (who will use this)
- What are the 3-5 most important things to build next?
  - In Description mode: derive from what the user described
  - In Scan mode: derive from what exists vs what's obviously missing

For each thing to build, draft a story:
```
STORY-00X: [title]
As a [persona], I want [capability], so that [outcome].
AC: Given [...], When [...], Then [...]
Priority: High | Medium | Low
```

---

## Step 3 — tech-lead-agent reads the codebase

**tech-lead-agent** scans for:
- What stack is this? (language, framework, key dependencies)
- What's already built and working?
- What's the first architectural decision worth logging? (DEC-001)
- Any risks or unknowns in the proposed stories?

In Description mode (empty or new project):
- What stack should be used based on the project description?
- What's the likely architecture?

---

## Step 4 — security-analyst-agent flags early

**security-analyst-agent** looks at the project type and flags:
- Any security concerns to design around from day one (auth, data handling, APIs)?
- Any stories that carry elevated security risk?

One paragraph maximum. This is early signal, not a full audit.

---

## Step 5 — pm-agent writes the state files

**pm-agent** takes all input and writes:

### Writes to memory/STATE.md:
```
Sprint: 1
Goal: [one sentence — the user outcome this first sprint delivers]
Status: PLANNING
Started: [today's date]
Ends: [today + 2 weeks]

## In Progress
[Nothing in progress yet — run /sprint-plan to begin]

## Done This Sprint
[Nothing done yet]

## Blockers
[None]

## Velocity
Stories planned: 0
Stories done: 0
```

### Writes to memory/BACKLOG.md:
Replaces the template placeholder with real stories from po-agent (Step 2).
Each story fully formed: title, user statement, AC, priority, complexity, security flag.

### Writes to memory/DECISIONS.md:
If tech-lead identified a first architectural decision, logs it as DEC-001.

### Writes to memory/NEXT.md:
```
Sprint: 1
Updated: [today]

## Exact Next Step
Run /sprint-plan to plan Sprint 1.
Stories are ready in BACKLOG.md — [n] stories waiting.

## Why
Project is initialized. The backlog has your first stories.
Sprint planning will assign estimates, validate AC, and produce an execution order.
```

---

## Final Output

```
PROJECT INITIALIZED
═══════════════════════════════════════════════════
Project:  [name]
Stack:    [detected or described]
Persona:  [primary user]

STORIES CREATED ([n] total)
  High:   [n stories]
  Medium: [n stories]
  Low:    [n stories]

  STORY-001: [title] — [complexity]
  STORY-002: [title] — [complexity]
  STORY-003: [title] — [complexity]
  ...

ARCHITECTURE
  Stack:   [language / framework]
  DEC-001: [first decision if any, or "none yet"]

SECURITY EARLY FLAGS
  [one paragraph or "none"]

FILES WRITTEN
  memory/STATE.md   ✓ Sprint 1 goal set
  memory/BACKLOG.md ✓ [n] stories ready
  memory/NEXT.md    ✓ → /sprint-plan
  memory/DECISIONS.md ✓ [n decision or "template only"]
═══════════════════════════════════════════════════
Team is ready. Run /sprint-plan to begin Sprint 1.
```
