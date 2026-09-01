#!/bin/bash
# Serves the pixel office (index.html polls events.jsonl in this dir).
# Usage: bash office/serve.sh [port]   (default 8123)
cd "$(dirname "$0")" && exec python3 -m http.server "${1:-8123}"
