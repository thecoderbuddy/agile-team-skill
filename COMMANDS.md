# Command Reference

What happens when you run each command. Grouped by when you'd use them.

---

## Start here

### `/init`
**When:** First time setting up the team on a project.

Agents scan your codebase (or use your description) and bootstrap everything.

```
po-agent      → identifies what's built, writes 3-5 real stories
tech-lead     → identifies stack, logs first architecture decision
security      → flags early risks to design around
pm-agent      → writes STATE.md, BACKLOG.md, NEXT.md
```

You get: populated memory files and a sprint goal. Then run `/sprint-plan`.

---

### `/status`
**When:** Start of any session — before standup, to get the full picture.

Every agent reports their health area in one pass.

```
pm-agent      → sprint progress, velocity, blockers
po-agent      → backlog health (ready vs needs grooming)
qa-agent      → open quality findings
security      → open security findings
tech-lead     → pending architecture decisions
```

You get: a dashboard — sprint health, in-progress stories, last 5 commits, exact next action.

---

## Daily flow

### `/standup`
**When:** Every morning, every session start.

```
dev-agent     → done / doing / blocked
qa-agent      → done / doing / blocked
security      → done / doing / blocked
tech-lead     → done / doing / blocked
pm-agent      → synthesizes blockers, assigns owners, updates STATE.md + NEXT.md
po-agent      → flags scope creep, notes priority shifts
```

You get: blocker list with owners, sprint goal health, today's focus from NEXT.md.

After: if next action is clear → start. If blocked → `/unblock`. If at risk → `/health-check`.

---

### `/new-task`
**When:** Ready to pick up the next story.

```
po-agent      → selects highest priority unblocked story
tech-lead     → writes tech spec if story is M or larger
pm-agent      → moves story to In Progress in STATE.md, writes NEXT.md
dev-agent     → confirms: AC clear, approach clear, ready to start
```

You get: story details, acceptance criteria, tech approach, files likely affected, exact first step.

After: implement, then run `/review`.

---

### `/review`
**When:** Done implementing — before any commit.

QA runs first. No code review of broken code.

```
qa-agent      → GATE: tests pass? AC met? edge cases covered?
                ↓ FAIL → stop. back to dev. no exceptions.
                ↓ PASS → proceed

pr-reviewer   → correctness, style, dead code, patterns
security      → secrets, OWASP, CVEs, input validation, auth
tech-lead     → architecture alignment, tech debt, DEC compliance
po-agent      → synthesizes all findings:
                  FIX NOW   → required change (blocks merge)
                  BACKLOG   → valid, not blocking → added to BACKLOG.md
                  WON'T FIX → documented with reasoning
```

You get: APPROVED or CHANGES REQUESTED + every non-blocking issue in your backlog.

After: `APPROVED` → `/complete STORY-XXX`. `CHANGES REQUESTED` → fix → `/review` again.

---

### `/complete STORY-XXX "description"`
**When:** After `/review` gives APPROVED.

```
pm-agent      → moves story to Done This Sprint in STATE.md
              → updates velocity count
              → writes NEXT.md with next action
```

Commits: `feat(area): description — closes STORY-XXX`

You get: commit hash, velocity update, what's next.

After: more stories → `/new-task`. Last story → `/sprint-close`.

---

### `/unblock STORY-XXX "what resolved it"`
**When:** A blocker logged in standup has been resolved.

```
tech-lead     → confirms the resolution, checks for new risk
              → logs DEC-XXX if a decision was made to unblock
pm-agent      → removes blocker from STATE.md, updates NEXT.md
```

You get: blocker cleared, NEXT.md pointing at the story again.

After: `/new-task` or continue directly if context is clear.

---

## Sprint ceremonies

### `/sprint-plan`
**When:** Start of every sprint.

```
po-agent      → proposes 5-7 stories from backlog with value justification
dev-agent     → commits capacity ("I can take X stories, STORY-001 is 2 days...")
tech-lead     → complexity estimates (XS/S/M/L/XL), dependencies, DEC constraints
qa-agent      → validates AC is testable — flags stories that can't start without criteria
security      → flags elevated-risk stories (auth, data, external APIs)
pm-agent      → adjusts scope to fit dev capacity, writes sprint to STATE.md + NEXT.md
```

You get: sprint with stories in execution order, complexity, AC, first task assigned.

After: `/standup` to begin.

---

### `/health-check`
**When:** Sprint midpoint — are we on track?

```
pm-agent      → velocity: on track / behind / ahead. Stalled stories?
po-agent      → sprint goal still achievable? Which stories to descope if behind?
qa-agent      → any AC quietly dropped? Quality risk if we rush?
```

You get: velocity status, stalled stories, descope candidates, recommendation.

After: on track → continue. Behind → `/backlog` to descope. Stalled → `/unblock`.

---

### `/sprint-close`
**When:** All stories done (or deciding to close with carryover).

```
qa-agent      → all tests passing? any quality concerns?
po-agent      → sprint goal met? carry-overs: backlog or next sprint?
tech-lead     → any tech debt introduced that needs a story?
pm-agent      → marks sprint CLOSED in STATE.md
              → moves carry-overs to top of BACKLOG.md
              → appends velocity to LEARNINGS.md
              → writes NEXT.md → /retro
```

You get: sprint summary — completed / carried / descoped, commits, sign-offs.

After: `/retro`.

---

### `/retro`
**When:** After sprint close.

```
dev/qa/security/tech  → each reflects: went well / improve / action item
pm-agent              → groups findings, calculates velocity, spots patterns
po-agent              → converts every action item into a backlog story or process change
                        nothing disappears — consciously kept or consciously dropped
pm-agent              → appends learnings to LEARNINGS.md
```

You get: what went well, what to improve, action items as real stories, velocity trend.

After: `/sprint-plan` for next sprint.

---

## Backlog work

### `/stories [feature]`
**When:** Writing new user stories.

```
po-agent      → writes story: persona, capability, outcome, acceptance criteria
qa-agent      → adds test scenarios, definition of done
security      → adds security constraints if needed
tech-lead     → adds technical notes, complexity estimate
```

You get: fully-formed story written to BACKLOG.md.

After: `/backlog` to groom and prioritize.

---

### `/backlog`
**When:** Grooming the backlog — before sprint planning or when it gets messy.

```
po-agent      → reprioritizes: high / medium / low / icebox with rationale
tech-lead     → rechecks estimates, finds stories that can be split
qa-agent      → flags stories without testable AC (can't enter sprint)
security      → flags elevated-risk stories for extra sprint time
```

You get: BACKLOG.md rewritten in new priority order, stories needing AC flagged.

After: `/sprint-plan` when ready to commit stories to a sprint.

---

### `/discover [feature]`
**When:** Before writing stories — understand the problem first.

```
po-agent      → who is this for? what problem? how do they solve it today?
              → smallest thing to validate? scope in/out? competitor research
tech-lead     → what exists already? what needs building? risks?
security      → early flags: auth, data, privacy concerns to design around
```

You get: persona, problem, competitive angle, scope, technical assessment, security flags.

After: `/stories` to write the backlog items, or `/design` for complex features.

---

### `/idea [rough idea]`
**When:** You have a rough idea and want to know if it's worth building.

```
po-agent      → evaluates: real user need? fits product direction? priority?
tech-lead     → effort, complexity, unknowns
security      → any elevated risk?
```

You get: APPROVED / DEFERRED / REJECTED with rationale and decomposed tasks if approved.

---

### `/missing`
**When:** Auditing what hasn't been built yet.

```
po-agent      → scans backlog vs codebase: what's incomplete, broken, or never started?
              → identifies stories sitting too long without progress
```

You get: feature gap scan — missing / incomplete / deprioritised, with recommendation.

---

### `/po`
**When:** Full product owner review — step back and see the whole product.

```
po-agent      → phase gate progress, feature completeness vs roadmap
              → persona check (does what's built serve the right users?)
              → backlog health, recommendations
```

You get: structured product review. Updates BACKLOG.md if stories need re-prioritisation.

---

## Reviews and audits

### `/arch-review`
**When:** Before building something complex, or after significant changes.

```
tech-lead     → stack compliance, DEC compliance, data flow, performance, code organisation
security      → security architecture, data handling, threat model
```

You get: architecture verdict (approve / needs changes / blocked) + new DEC-XXX if a decision is needed.

---

### `/design [feature]`
**When:** Complex feature that needs a full design before dev starts.

```
po-agent      → empathy map, user flow (ASCII), what success looks like
tech-lead     → technical spec, component breakdown, implementation approach
qa-agent      → testability review, acceptance criteria for the design
security      → security design review
```

You get: complete design doc — user flow, component spec, tech spec, all agents approved.

After: `/stories` to write the stories, then `/sprint-plan`.

---

### `/ux-review`
**When:** Reviewing existing UI for usability problems.

```
po-agent      → consistency, information hierarchy, cognitive load, user journey
qa-agent      → empty/error/loading states, accessibility, edge cases in UI
```

You get: UX rating per criterion (pass / needs work / fail), quick wins, verdict.

---

### `/security-review`
**When:** Before a release, or any time security needs a full pass.

```
security      → dependency audit, secrets scan, auth review, OWASP Top 10
tech-lead     → architecture-level security, data flow review
```

You get: findings by severity — CRITICAL/HIGH block release, MEDIUM/LOW go to backlog.

---

### `/risk-review`
**When:** Monthly or before major releases.

```
tech-lead     → technical risks (complexity, dependencies, unknowns)
security      → security risks (exposure, attack surface, compliance)
po-agent      → business risks (scope, priority, user impact)
```

You get: risk register — high / medium / low with owners and mitigation plans.

---

### `/adr [decision to record]`
**When:** You've made an architecture decision and need to log it formally.

```
tech-lead     → writes the ADR: context, decision, consequences, alternatives considered
po/security/qa → review and approve
```

You get: DEC-XXX appended to DECISIONS.md.

---

### `/focus-group [feature]`
**When:** Testing a feature against real user perspectives before shipping.

Simulates 5 personas experiencing the feature:

```
Power User        → keyboard shortcuts, speed, minimal clicks
New User          → needs guidance, clear labels, obvious next steps
Team Lead         → visibility, oversight, approval flows
Non-tech Stakeholder → plain English, no jargon
Security-conscious → what data is stored? reads every prompt
```

Then:
```
qa-agent      → do confusion points reveal missing edge cases or AC violations?
po-agent      → groups consensus issues (3+ personas), adds to backlog as stories, gives verdict
```

You get: SHIP or NEEDS WORK + issues added to BACKLOG.md.

---

### `/bug [description]`
**When:** Something is broken.

```
qa-agent      → classifies: bug / gap / regression, severity (SEV 1-4)
tech-lead     → root cause hypothesis, fix approach, complexity
```

You get: bug report. SEV-1/2 → fix now. SEV-3/4 → story added to backlog.

---

### `/incident SEV-[1-4] [description]`
**When:** Something broke in the running system.

```
security      → data breach? exposure risk? contains before fix?
tech-lead     → blast radius, root cause, fix plan or rollback option
pm-agent      → logs in STATE.md, coordinates response
```

You get: incident report with fix plan and rollback option.

SEV-1 → fix starts immediately without asking.

---

## Session management

### `/checkpoint`
**When:** Before a break, when context is getting large, or before a risky operation.

Saves exact state to NEXT.md — specific enough that the next session needs zero context to resume.

### `/done`
**When:** End of day / end of session.

Same as `/checkpoint` but also shows a session summary: what was completed, any uncommitted changes.

### `/resume`
**When:** Returning after a rate limit reset or long break.

Reads NEXT.md and STATE.md, then continues exactly where you left off. Never asks "what should we work on?"

### `/logs [optional: file]`
**When:** Want to see the memory files without navigating to them.

No argument → one-line summary of all 5 memory files.
With argument (`decisions`, `learnings`, `backlog`, `state`, `next`) → full contents of that file.

---

## Quick reference

```
First time     /init
Every morning  /standup
Pick up work   /new-task → implement → /review → /complete
Blocked        /unblock
Midpoint       /health-check
End of sprint  /sprint-close → /retro → /sprint-plan
Full picture   /status

Write stories  /discover → /stories → /backlog → /sprint-plan
Big feature    /discover → /design → /stories → /sprint-plan
Audit          /arch-review / /security-review / /ux-review / /risk-review
User test      /focus-group
Something broke /bug or /incident
Session end    /checkpoint or /done
Coming back    /resume
```
