#!/bin/bash
# pre-commit — scans staged changes for secrets using gitleaks
# Installed to .git/hooks/pre-commit by install.sh
# Source of truth lives here; do not edit .git/hooks/pre-commit directly.
#
# False positive? Add '# gitleaks:allow' on the offending line.
# Emergency bypass: git commit --no-verify (document reason in commit message)

if ! command -v gitleaks &>/dev/null; then
  echo "⚠  gitleaks not installed — secret scanning skipped."
  echo "   Install: brew install gitleaks  (macOS)"
  echo "   Or see:  https://github.com/gitleaks/gitleaks/releases"
  exit 0
fi

REPO_ROOT=$(git rev-parse --show-toplevel)

if [ -z "$REPO_ROOT" ]; then
  echo "⚠  Could not determine repo root — skipping secret scan."
  exit 0
fi

# REPO_ROOT is used because git hooks do NOT guarantee CWD == repo root —
# running `git commit` from a subdirectory sets CWD to that subdirectory.
# The 2>/dev/null suppresses expected noise (progress output), NOT all errors —
# config-file absence is handled explicitly below before calling gitleaks.
GITLEAKS_CONFIG="$REPO_ROOT/.gitleaks.toml"
if [ ! -f "$GITLEAKS_CONFIG" ]; then
  echo "⚠  .gitleaks.toml not found at $REPO_ROOT — running with gitleaks default ruleset."
  GITLEAKS_CONFIG=""
fi

if [ -n "$GITLEAKS_CONFIG" ]; then
  gitleaks protect --staged --config "$GITLEAKS_CONFIG" 2>/dev/null && exit 0
else
  gitleaks protect --staged 2>/dev/null && exit 0
fi

echo ""
echo "BLOCKED: gitleaks detected a potential secret in staged files."
echo "  Review the findings above, remove the secret, and re-stage the file."
echo ""
echo "  False positive? Add '# gitleaks:allow' at the end of the offending line."
echo "  Emergency bypass: git commit --no-verify  (document reason in commit msg)"
exit 1
