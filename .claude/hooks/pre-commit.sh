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

if gitleaks protect --staged --config .gitleaks.toml 2>/dev/null; then
  exit 0
fi

echo ""
echo "BLOCKED: gitleaks detected a potential secret in staged files."
echo "  Review the findings above, remove the secret, and re-stage the file."
echo ""
echo "  False positive? Add '# gitleaks:allow' at the end of the offending line."
echo "  Emergency bypass: git commit --no-verify  (document reason in commit msg)"
exit 1
