# /missing — Quick Feature Gap Scan

Scans the codebase and project roadmap to find what's missing or incomplete.

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

4. **po-agent scans for gaps:**
   - Roadmap items not started
   - Partially built features (code exists but incomplete)
   - Stories in BACKLOG.md that have been deprioritised too long
   - Missing tests
   - Docs gaps

5. Show the gap report:

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
