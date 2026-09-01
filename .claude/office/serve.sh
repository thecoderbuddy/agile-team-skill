#!/bin/bash
# Serves the pixel office (index.html polls events.jsonl in this dir).
# Usage: bash office/serve.sh [port]   (default: first free port from 8123)
cd "$(dirname "$0")"
if [ -n "$1" ]; then
  PORT="$1"
else
  PORT=8123
  while nc -z 127.0.0.1 "$PORT" 2>/dev/null; do PORT=$((PORT + 1)); done
fi
echo "pixel office → http://localhost:$PORT"
exec python3 -m http.server "$PORT"
