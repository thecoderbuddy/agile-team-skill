#!/bin/bash
# Feeds a scripted day-in-the-office into events.jsonl so you can watch the team
# animate without running real ceremonies. Usage: bash office/demo.sh
cd "$(dirname "$0")"
E=events.jsonl
ev() { echo "{\"ts\":$(date +%s),$1}" >> "$E"; }

# ── /review chain: agents work at their desks ────────────────────────────
ev '"event":"UserPromptSubmit","desc":"run /review on STORY-012"'
sleep 3
ev '"event":"PreToolUse","tool":"Agent","agent_type":"qa-agent","desc":"quality gate: tests + AC"'
sleep 4
ev '"event":"PostToolUse","tool":"Bash","desc":"npm test"'
sleep 3
ev '"event":"PreToolUse","tool":"Agent","agent_type":"security-analyst-agent","desc":"vulnerability scan"'
sleep 4
ev '"event":"PostToolUse","tool":"Grep","desc":"scanning for secrets"'
sleep 3
ev '"event":"PostToolUse","tool":"Agent","agent_type":"security-analyst-agent"'
ev '"event":"SubagentStop"'
sleep 4
ev '"event":"PostToolUse","tool":"Agent","agent_type":"qa-agent"'
ev '"event":"SubagentStop"'
sleep 5
ev '"event":"PreToolUse","tool":"Agent","agent_type":"dev-agent","desc":"fix review findings"'
sleep 4
ev '"event":"PostToolUse","tool":"Edit","desc":"src/auth.js"'
sleep 3
ev '"event":"PostToolUse","tool":"Agent","agent_type":"dev-agent"'
sleep 4
ev '"event":"Stop"'
sleep 6

# ── /standup: the whole team gathers in the conference room ─────────────
ev '"event":"UserPromptSubmit","desc":"/standup — daily sync"'
sleep 2
for a in dev-agent qa-agent security-analyst-agent tech-lead-agent pm-agent po-agent \
         cto-agent principal-engineer-agent senior-engineer-agent \
         ai-engineer-agent design-lead-agent pr-reviewer-agent; do
  ev "\"event\":\"PreToolUse\",\"tool\":\"Agent\",\"agent_type\":\"$a\",\"desc\":\"standup report\""
  sleep 2
done
sleep 8
for a in dev-agent qa-agent security-analyst-agent tech-lead-agent pm-agent po-agent \
         cto-agent principal-engineer-agent senior-engineer-agent \
         ai-engineer-agent design-lead-agent pr-reviewer-agent; do
  ev "\"event\":\"PostToolUse\",\"tool\":\"Agent\",\"agent_type\":\"$a\""
done
sleep 4
ev '"event":"Stop"'
echo "demo complete"
