#!/bin/bash
# post-tool-use.sh — Fires AFTER successful tool execution
# Runs checks, logs activity, catches issues early
# Exit 0 = continue, non-zero = warn (doesn't block)

# Read stdin JSON (Claude Code passes tool info this way)
INPUT_JSON=$(cat /dev/stdin 2>/dev/null || echo '{}')
TOOL_NAME=$(echo "$INPUT_JSON" | jq -r '.tool_name // empty' 2>/dev/null)
PROJECT_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"

# ─────────────────────────────────────
# FILE EDIT TRACKING
# ─────────────────────────────────────
if [ "$TOOL_NAME" = "Write" ] || [ "$TOOL_NAME" = "Edit" ]; then
  FILE_PATH=$(echo "$INPUT_JSON" | jq -r '.tool_input.file_path // empty' 2>/dev/null)

  # Log edited files to memory/ for session tracking
  LOGFILE="$PROJECT_ROOT/memory/.file-log"
  if [ -d "$PROJECT_ROOT/memory" ]; then
    echo "$(date '+%Y-%m-%d %H:%M') | $FILE_PATH" >> "$LOGFILE" 2>/dev/null
  fi
fi

# ─────────────────────────────────────
# GIT COMMIT TRACKING
# ─────────────────────────────────────
if [ "$TOOL_NAME" = "Bash" ]; then
  COMMAND=$(echo "$INPUT_JSON" | jq -r '.tool_input.command // empty' 2>/dev/null)

  if echo "$COMMAND" | grep -qE 'git\s+commit'; then
    LAST_COMMIT=$(cd "$PROJECT_ROOT" && git log --oneline -1 2>/dev/null)
    if [ -n "$LAST_COMMIT" ]; then
      echo "Commit logged: $LAST_COMMIT"
    fi
  fi
fi

exit 0
