#!/bin/bash
# stop.sh — Fires after every Claude response
# Passive checks: state file health
# Exit 0 always (monitoring only, never blocks responses)

PROJECT_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
MEMORY_DIR="$PROJECT_ROOT/memory"

# ─────────────────────────────────────
# STATE FILE HEALTH CHECK
# ─────────────────────────────────────
if [ -d "$MEMORY_DIR" ]; then
  # Warn if NEXT.md is empty — session continuity at risk
  if [ ! -s "$MEMORY_DIR/NEXT.md" ]; then
    echo "STATE WARNING: memory/NEXT.md is empty. Run /checkpoint to save session state."
  fi
fi

exit 0
