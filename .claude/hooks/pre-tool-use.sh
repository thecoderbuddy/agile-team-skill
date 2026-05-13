#!/bin/bash
# pre-tool-use.sh — Fires BEFORE every tool execution
# Guards against dangerous operations and DEC violations
# Exit 0 = allow, Exit 2 = block with message

# Read stdin JSON (Claude Code passes tool info this way)
INPUT_JSON=$(cat /dev/stdin 2>/dev/null || echo '{}')
TOOL_NAME=$(echo "$INPUT_JSON" | jq -r '.tool_name // empty' 2>/dev/null)
TOOL_INPUT=$(echo "$INPUT_JSON" | jq -r '.tool_input // empty' 2>/dev/null)

# ─────────────────────────────────────
# BASH SAFETY GATES
# ─────────────────────────────────────
if [ "$TOOL_NAME" = "Bash" ]; then
  COMMAND=$(echo "$INPUT_JSON" | jq -r '.tool_input.command // empty' 2>/dev/null)

  # Block destructive commands
  if echo "$COMMAND" | grep -qE 'rm\s+-rf\s+(src|electron|node_modules|\.next|\.claude)'; then
    echo "BLOCKED: Destructive rm -rf on critical directory. This would delete source code."
    exit 2
  fi

  # Block DROP TABLE / DROP DATABASE
  if echo "$COMMAND" | grep -qiE 'DROP\s+(TABLE|DATABASE|INDEX|SCHEMA)'; then
    echo "BLOCKED: DROP statement detected. Database schema changes require migration files."
    exit 2
  fi

  # Block force push to main/master
  if echo "$COMMAND" | grep -qE 'git\s+push\s+.*--force.*\s+(main|master)'; then
    echo "BLOCKED: Force push to main/master. This can destroy shared history."
    exit 2
  fi
  if echo "$COMMAND" | grep -qE 'git\s+push\s+-f\s+.*\s+(main|master)'; then
    echo "BLOCKED: Force push to main/master."
    exit 2
  fi

  # Block git reset --hard without explicit approval
  if echo "$COMMAND" | grep -qE 'git\s+reset\s+--hard'; then
    echo "BLOCKED: git reset --hard discards uncommitted work. Use git stash or commit first."
    exit 2
  fi

  # Block .env file writes via bash
  if echo "$COMMAND" | grep -qE '>\s*\.env'; then
    echo "BLOCKED: Direct .env write via bash. Edit .env manually to avoid leaking secrets."
    exit 2
  fi

  # Block secrets in echo/printf to files
  if echo "$COMMAND" | grep -qiE '(api_key|secret|password|token).*>'; then
    echo "BLOCKED: Possible secret being written to file. Handle secrets manually."
    exit 2
  fi
fi

# ─────────────────────────────────────
# WRITE/EDIT SAFETY GATES
# ─────────────────────────────────────
if [ "$TOOL_NAME" = "Write" ] || [ "$TOOL_NAME" = "Edit" ]; then
  FILE_PATH=$(echo "$INPUT_JSON" | jq -r '.tool_input.file_path // empty' 2>/dev/null)

  # Block .env writes
  if echo "$FILE_PATH" | grep -qE '\.env($|\.)'; then
    echo "BLOCKED: Cannot write to .env files. Secrets must be managed manually."
    exit 2
  fi

  # Block writing to COMPLETED.md directly (should go through /complete command)
  if echo "$FILE_PATH" | grep -qE 'COMPLETED\.md$'; then
    echo "WARNING: Direct write to COMPLETED.md. Use /complete command for proper task tracking."
  fi
fi

# ─────────────────────────────────────
# DEC-001 CHECK — No file contents in payloads
# ─────────────────────────────────────
if [ "$TOOL_NAME" = "Write" ] || [ "$TOOL_NAME" = "Edit" ]; then
  CONTENT=$(echo "$INPUT_JSON" | jq -r '.tool_input.content // .tool_input.new_string // empty' 2>/dev/null)

  # Check for file content patterns in API payloads/IPC messages
  if echo "$CONTENT" | grep -qiE '(file_contents|fileContents|raw_source|rawSource|document_text|documentText)\s*[:=]'; then
    echo "DEC-001 VIOLATION: Detected file contents in payload. Payloads must carry IDs and paths only — never file contents."
    exit 2
  fi
fi

# All checks passed
exit 0
