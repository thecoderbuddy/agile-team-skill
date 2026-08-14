---
description: Quick scan of codebase and roadmap for missing, incomplete, or broken features
argument-hint: [optional focus area]
---

# /missing — Quick Feature Gap Scan

Usage: `/missing [optional focus area]`

Arguments: $ARGUMENTS

Scans the codebase and project roadmap to find what's missing or incomplete.
If a focus area is given, limit the scan to that area.

## Steps

1. Read project roadmap from CLAUDE.md.

2. Read what's built:
   ```bash
   cat memory/STATE.md
   git log --oneline -30
   ```

3. Check actual codebase structure:
   ```bash
   ls -la
   git diff --stat HEAD~5 HEAD 2>/dev/null | head -30
   ```

4. Read the backlog overview — the `## Index` section of memory/BACKLOG.md only
   (never the full file):
   ```bash
   awk '/^## Index$/,/^---$/' memory/BACKLOG.md
   ```

5. **po-agent scans for gaps:**
   - Roadmap items not started
   - Partially built features (code exists but incomplete)
   - Stories in BACKLOG.md that have been deprioritised too long
   - Missing tests
   - Docs gaps

6. Show the gap report:

```
FEATURE GAP SCAN
═══════════════════════════════════════
PHASE GATE: [current phase] — [X/Y complete]

MISSING (not started)
  - [feature] — [story ref or roadmap item]
  ...

INCOMPLETE (partially built)
  - [feature] — [what's missing]
  ...

BROKEN (exists but not working)
  - [feature] — [what's wrong]
  ...

RECOMMENDATION
  [what to prioritise next]
═══════════════════════════════════════
```

7. **Persist findings (Iron Rule 4 — backlog everything):**
   - Ask the user: "Add the confirmed gaps to the backlog? [Y/N]"
   - On [Y], write each confirmed gap not already tracked as a story in
     memory/BACKLOG.md (next STORY number from the `## Index`, standard story
     format) and add a matching line to the `## Index`.
