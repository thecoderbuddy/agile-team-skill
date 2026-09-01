#!/bin/bash
# office-event.sh — Appends one compact JSON event per hook firing to office/events.jsonl
# Consumed by office/index.html (the pixel-office visualization). Never blocks: always exit 0.

INPUT_JSON=$(cat /dev/stdin 2>/dev/null || echo '{}')
PROJECT_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
EVENTS_FILE="$PROJECT_ROOT/office/events.jsonl"

[ -d "$PROJECT_ROOT/office" ] || exit 0
command -v jq >/dev/null 2>&1 || exit 0

echo "$INPUT_JSON" | jq -c --arg ts "$(date +%s)" '
  {
    ts: ($ts | tonumber),
    event: (.hook_event_name // "unknown"),
    session: (.session_id // "" | .[0:8]),
    tool: (.tool_name // null),
    agent_type: (.tool_input.subagent_type // null),
    desc: (
      .prompt
      // .tool_input.description
      // .tool_input.file_path
      // (.tool_input.command | if . then .[0:80] else null end)
      // .tool_input.pattern
      // null
    ),
    transcript: (.transcript_path // "" | split("/") | last)
  } | with_entries(select(.value != null))
' >> "$EVENTS_FILE" 2>/dev/null

exit 0
