#!/bin/bash
# Updates the pixel office to the latest published version.
# Usage: bash .claude/office/update.sh
set -euo pipefail
cd "$(dirname "$0")"
B="https://raw.githubusercontent.com/thecoderbuddy/agile-team-skill/main/.claude/office"

echo "Updating pixel office from $B ..."
for f in index.html logic.js pixi-legacy.min.js serve.sh demo.sh update.sh \
         tiles.png agents.png map.json; do
  curl -fsSL "$B/$f" -o "$f.tmp" && mv "$f.tmp" "$f"
  echo "  ✓ $f"
done
curl -fsSL "$B/assets/CREDITS.md" -o assets/CREDITS.md 2>/dev/null || mkdir -p assets && curl -fsSL "$B/assets/CREDITS.md" -o assets/CREDITS.md
chmod +x serve.sh demo.sh update.sh

# the event hook lives next door — refresh it too
HOOK="../hooks/office-event.sh"
if [ -f "$HOOK" ]; then
  curl -fsSL "https://raw.githubusercontent.com/thecoderbuddy/agile-team-skill/main/.claude/hooks/office-event.sh" -o "$HOOK.tmp" && mv "$HOOK.tmp" "$HOOK" && chmod +x "$HOOK"
  echo "  ✓ hooks/office-event.sh"
fi

echo "Done — hard-refresh the office in your browser (Cmd+Shift+R)."
