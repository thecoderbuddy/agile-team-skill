# Team Roster

Read by ceremony orchestrators before running any chain.

- **Core** agents always participate in their ceremonies.
- **Extended** agents join their listed ceremonies only while `Status: ACTIVE`.
- **ON-DEMAND** agents never join chains automatically — they are invoked explicitly
  for escalations and consultations, regardless of project.

## Core (always active)

po-agent · pm-agent · dev-agent · qa-agent · pr-reviewer-agent · security-analyst-agent · tech-lead-agent

## Extended

| Agent | Status | Activate when | Ceremonies joined when ACTIVE |
|---|---|---|---|
| senior-engineer-agent | DORMANT | L/XL stories in sprint; dev blocked twice on the same thing; hardest bugs; perf/DX/refactoring work needed | /new-task, /standup, /unblock, /bug (hard diagnosis), /review (depth consult), /retro |
| ai-engineer-agent | DORMANT | Project calls LLM/ML APIs, contains prompts, embeddings, vector stores, evals, or model code | /review (AI lens), /stories, /sprint-plan, /standup, /retro |
| design-lead-agent | DORMANT | Project has a user-facing UI | /stories, /review (UX lens), /sprint-plan, /ux-review, /focus-group, /design, /retro |
| principal-engineer-agent | ON-DEMAND | XL design review gate, migrations, build-vs-buy, standards/golden paths, scalability & SLO reviews, consistency audits, spike definitions, hardest SEV-1s, tech radar, technical dispute below CTO | Consulted explicitly — never in daily chains |
| cto-agent | ON-DEMAND | Veto overrides, platform/vendor decisions, technical deadlock, SEV-1 sign-off, tech roadmap, engineering health metrics, security posture, vendor/spend review, due diligence, arch health check, roster changes | Escalation only |
| ceo-agent | ON-DEMAND | Vision/strategy checks, outcome framework, MISSED metrics (iterate/pivot/kill), priority deadlock, epic challenges, market signal, pricing/positioning, external commitments, capacity allocation, risk appetite, release-notes review | Escalation only |

## Changing the roster

- `/init` proposes initial statuses from the project scan — user confirms before writing.
- Flip a `Status` here any time; ceremonies pick it up on their next run.
- pm-agent proposes activation during /standup or /retro when an "Activate when" signal appears.
- ON-DEMAND is fixed for principal/cto/ceo — they are pull-based by design.
