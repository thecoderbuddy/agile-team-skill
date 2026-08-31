#!/bin/bash
set -e

# ─────────────────────────────────────────────────────────────────────────────
# Agile Team for Claude Code — Installer
# Usage: curl -fsSL https://raw.githubusercontent.com/thecoderbuddy/agile-team-skill/main/install.sh | bash
# Or locally: bash install.sh
# ─────────────────────────────────────────────────────────────────────────────

REPO_URL="https://raw.githubusercontent.com/thecoderbuddy/agile-team-skill/main"
TARGET_DIR="$(pwd)"

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BOLD='\033[1m'
NC='\033[0m'

print_step()  { echo -e "\n${BOLD}$1${NC}"; }
print_ok()    { echo -e "  ${GREEN}✓${NC} $1"; }
print_warn()  { echo -e "  ${YELLOW}!${NC} $1"; }
print_error() { echo -e "  ${RED}✗${NC} $1"; }

# ─────────────────────────────────────────────────────────────────────────────
# Header
# ─────────────────────────────────────────────────────────────────────────────

echo ""
echo -e "${BOLD}Agile Team for Claude Code${NC}"
echo "────────────────────────────────────────"
echo "Installing into: $TARGET_DIR"
echo ""

# ─────────────────────────────────────────────────────────────────────────────
# Safety checks
# ─────────────────────────────────────────────────────────────────────────────

print_step "Checking environment..."

# Must be run from inside a project directory, not from home or root
if [ "$TARGET_DIR" = "$HOME" ] || [ "$TARGET_DIR" = "/" ]; then
  print_error "Run this from inside your project directory, not from home or root."
  echo ""
  echo "  cd your-project"
  echo "  curl -fsSL $REPO_URL/install.sh | bash"
  echo ""
  exit 1
fi

# Warn if this doesn't look like a project (no recognisable files)
HAS_PROJECT_FILES=false
for f in package.json pyproject.toml Cargo.toml go.mod pom.xml build.gradle README.md .git; do
  [ -e "$TARGET_DIR/$f" ] && HAS_PROJECT_FILES=true && break
done

if [ "$HAS_PROJECT_FILES" = false ]; then
  print_warn "This directory doesn't look like a project yet (no package.json, README, .git, etc.)"
  echo ""
  printf "  Install here anyway? [y/N] "
  read -r CONFIRM
  [ "$CONFIRM" = "y" ] || [ "$CONFIRM" = "Y" ] || { echo "Aborted."; exit 0; }
fi

print_ok "Environment looks good"

# ─────────────────────────────────────────────────────────────────────────────
# Detect source: local (running from cloned repo) vs remote (curl)
# ─────────────────────────────────────────────────────────────────────────────

# If this script lives next to .claude/ and memory/, we're running locally
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" 2>/dev/null && pwd)"
if [ -d "$SCRIPT_DIR/.claude" ] && [ -d "$SCRIPT_DIR/memory" ]; then
  SOURCE_MODE="local"
  SOURCE_DIR="$SCRIPT_DIR"
else
  SOURCE_MODE="remote"
fi

# ─────────────────────────────────────────────────────────────────────────────
# Handle existing .claude/ directory
# ─────────────────────────────────────────────────────────────────────────────

print_step "Checking for existing files..."

if [ -d "$TARGET_DIR/.claude/agents" ]; then
  print_warn ".claude/agents/ already exists"
  echo ""
  printf "  Overwrite existing agents and commands? [y/N] "
  read -r OVERWRITE_CLAUDE
  if [ "$OVERWRITE_CLAUDE" != "y" ] && [ "$OVERWRITE_CLAUDE" != "Y" ]; then
    echo "  Skipping .claude/ — existing agents preserved."
    SKIP_CLAUDE=true
  fi
fi

if [ -d "$TARGET_DIR/memory" ]; then
  # Check if memory has real content (not just templates)
  MEMORY_HAS_CONTENT=false
  if grep -q "Sprint: [0-9]" "$TARGET_DIR/memory/STATE.md" 2>/dev/null; then
    MEMORY_HAS_CONTENT=true
  fi

  if [ "$MEMORY_HAS_CONTENT" = true ]; then
    print_warn "memory/ already has sprint data"
    echo ""
    printf "  Overwrite memory files? This will reset your sprint state. [y/N] "
    read -r OVERWRITE_MEMORY
    if [ "$OVERWRITE_MEMORY" != "y" ] && [ "$OVERWRITE_MEMORY" != "Y" ]; then
      echo "  Skipping memory/ — existing sprint state preserved."
      SKIP_MEMORY=true
    fi
  else
    print_ok "memory/ exists but is empty — will overwrite templates"
  fi
fi

if [ -f "$TARGET_DIR/CLAUDE.md" ]; then
  print_warn "CLAUDE.md already exists"
  echo ""
  printf "  Overwrite CLAUDE.md? [y/N] "
  read -r OVERWRITE_CLAUDE_MD
  if [ "$OVERWRITE_CLAUDE_MD" != "y" ] && [ "$OVERWRITE_CLAUDE_MD" != "Y" ]; then
    echo "  Skipping CLAUDE.md — existing file preserved."
    SKIP_CLAUDE_MD=true
  fi
fi

# ─────────────────────────────────────────────────────────────────────────────
# Install
# ─────────────────────────────────────────────────────────────────────────────

print_step "Installing..."

if [ "$SOURCE_MODE" = "local" ]; then
  # ── Local install (running from cloned repo) ──────────────────────────────

  if [ "$SKIP_CLAUDE" != "true" ]; then
    cp -r "$SOURCE_DIR/.claude" "$TARGET_DIR/"
    # Remove machine-specific files that shouldn't be carried over
    rm -f "$TARGET_DIR/.claude/settings.local.json"
    rm -rf "$TARGET_DIR/.claude/worktrees"
    rm -rf "$TARGET_DIR/.claude/skills"
    print_ok ".claude/ installed (agents + commands + hooks)"
  fi

  if [ "$SKIP_MEMORY" != "true" ]; then
    mkdir -p "$TARGET_DIR/memory"

    # Structural templates — copy from repo
    for mf in DECISIONS LEARNINGS TEAM; do
      [ -f "$SOURCE_DIR/memory/$mf.md" ] && cp "$SOURCE_DIR/memory/$mf.md" "$TARGET_DIR/memory/$mf.md"
    done

    # Ephemeral files — create blank templates; /init populates them
    cat > "$TARGET_DIR/memory/STATE.md" << 'EOF'
# Sprint State
# Owned by: pm-agent
# Updated at every ceremony. Source of truth for current sprint.

Sprint: —
Goal: —
Status: NOT STARTED

## Stories

(none yet — run /init to get started)

## Blockers

(none)
EOF

    cat > "$TARGET_DIR/memory/NEXT.md" << 'EOF'
# Next Action

Run `/init` to onboard the team and populate the backlog.
EOF

    cat > "$TARGET_DIR/memory/BACKLOG.md" << 'EOF'
# Product Backlog
# Owned by: po-agent
# Prioritized list of stories. Updated at every /backlog and /review.

(empty — run /init to populate)
EOF

    print_ok "memory/ installed (DECISIONS, LEARNINGS, TEAM + blank STATE, NEXT, BACKLOG)"
  fi

  if [ "$SKIP_CLAUDE_MD" != "true" ]; then
    cp "$SOURCE_DIR/CLAUDE.md" "$TARGET_DIR/CLAUDE.md"
    print_ok "CLAUDE.md installed"
  fi

else
  # ── Remote install (curl from GitHub) ────────────────────────────────────

  # Check curl is available
  if ! command -v curl &>/dev/null; then
    print_error "curl is required but not installed."
    exit 1
  fi

  AGENTS=(
    "po-agent" "pm-agent" "dev-agent" "qa-agent"
    "pr-reviewer-agent" "security-analyst-agent" "tech-lead-agent"
    "senior-engineer-agent" "principal-engineer-agent" "ai-engineer-agent"
    "design-lead-agent" "cto-agent" "ceo-agent"
  )

  COMMANDS=(
    "init" "standup" "sprint-plan" "sprint-close" "retro" "review"
    "stories" "backlog" "new-task" "status" "discover" "design"
    "complete" "bug" "idea" "missing" "arch-review" "ux-review"
    "security-review" "risk-review" "adr" "done" "checkpoint"
    "resume" "health-check" "logs" "po" "incident" "focus-group"
  )

  # DECISIONS, LEARNINGS, and TEAM are structural templates shipped with the repo.
  # STATE, NEXT, BACKLOG are ephemeral sprint state — created fresh for each project.
  MEMORY_TEMPLATE_FILES=(
    "DECISIONS" "LEARNINGS" "TEAM"
  )

  HOOKS=("post-tool-use" "stop")

  if [ "$SKIP_CLAUDE" != "true" ]; then
    mkdir -p "$TARGET_DIR/.claude/agents"
    mkdir -p "$TARGET_DIR/.claude/commands"
    mkdir -p "$TARGET_DIR/.claude/hooks"

    for agent in "${AGENTS[@]}"; do
      curl -fsSL "$REPO_URL/.claude/agents/$agent.md" -o "$TARGET_DIR/.claude/agents/$agent.md"
    done
    print_ok "Agents installed (${#AGENTS[@]})"

    for cmd in "${COMMANDS[@]}"; do
      curl -fsSL "$REPO_URL/.claude/commands/$cmd.md" -o "$TARGET_DIR/.claude/commands/$cmd.md"
    done
    print_ok "Commands installed (${#COMMANDS[@]})"

    for hook in "${HOOKS[@]}"; do
      curl -fsSL "$REPO_URL/.claude/hooks/$hook.sh" -o "$TARGET_DIR/.claude/hooks/$hook.sh"
      chmod +x "$TARGET_DIR/.claude/hooks/$hook.sh"
    done

    # Also download the pre-commit hook source (installed to .git/hooks/ below)
    curl -fsSL "$REPO_URL/.claude/hooks/pre-commit.sh" -o "$TARGET_DIR/.claude/hooks/pre-commit.sh"
    chmod +x "$TARGET_DIR/.claude/hooks/pre-commit.sh"

    curl -fsSL "$REPO_URL/.claude/settings.json" -o "$TARGET_DIR/.claude/settings.json"
    print_ok "Hooks and settings installed"
  fi

  if [ "$SKIP_MEMORY" != "true" ]; then
    mkdir -p "$TARGET_DIR/memory"

    for mf in "${MEMORY_TEMPLATE_FILES[@]}"; do
      curl -fsSL "$REPO_URL/memory/$mf.md" -o "$TARGET_DIR/memory/$mf.md"
    done

    # Ephemeral files — create blank templates; /init populates them
    cat > "$TARGET_DIR/memory/STATE.md" << 'EOF'
# Sprint State
# Owned by: pm-agent
# Updated at every ceremony. Source of truth for current sprint.

Sprint: —
Goal: —
Status: NOT STARTED

## Stories

(none yet — run /init to get started)

## Blockers

(none)
EOF

    cat > "$TARGET_DIR/memory/NEXT.md" << 'EOF'
# Next Action

Run `/init` to onboard the team and populate the backlog.
EOF

    cat > "$TARGET_DIR/memory/BACKLOG.md" << 'EOF'
# Product Backlog
# Owned by: po-agent
# Prioritized list of stories. Updated at every /backlog and /review.

(empty — run /init to populate)
EOF

    print_ok "memory/ installed"
  fi

  if [ "$SKIP_CLAUDE_MD" != "true" ]; then
    curl -fsSL "$REPO_URL/CLAUDE.md" -o "$TARGET_DIR/CLAUDE.md"
    print_ok "CLAUDE.md installed"
  fi
fi

# ─────────────────────────────────────────────────────────────────────────────
# Secret scanning — install gitleaks pre-commit hook
# ─────────────────────────────────────────────────────────────────────────────

print_step "Setting up secret scanning..."

# Install gitleaks config if not already present
if [ ! -f "$TARGET_DIR/.gitleaks.toml" ]; then
  curl -fsSL "$REPO_URL/.gitleaks.toml" -o "$TARGET_DIR/.gitleaks.toml"
  print_ok ".gitleaks.toml installed"
else
  print_ok ".gitleaks.toml already present — skipping"
fi

# Install pre-commit hook into .git/hooks/ if inside a git repo
if [ -d "$TARGET_DIR/.git" ]; then
  if [ -f "$TARGET_DIR/.claude/hooks/pre-commit.sh" ]; then
    cp "$TARGET_DIR/.claude/hooks/pre-commit.sh" "$TARGET_DIR/.git/hooks/pre-commit"
    chmod +x "$TARGET_DIR/.git/hooks/pre-commit"
    print_ok "pre-commit hook installed (.git/hooks/pre-commit)"
  fi
else
  print_warn "Not a git repo — skipping pre-commit hook installation"
fi

# Check if gitleaks is available
if command -v gitleaks &>/dev/null; then
  GITLEAKS_VERSION=$(gitleaks version 2>/dev/null || echo "installed")
  print_ok "gitleaks detected ($GITLEAKS_VERSION) — secret scanning active"
else
  print_warn "gitleaks not installed — hook installed but scanning will be skipped until gitleaks is available"
  echo ""
  echo "    Install gitleaks to activate secret scanning:"
  echo "      macOS:   brew install gitleaks"
  echo "      Linux:   https://github.com/gitleaks/gitleaks/releases"
  echo "      Windows: scoop install gitleaks"
  echo ""
fi

# ─────────────────────────────────────────────────────────────────────────────
# Done
# ─────────────────────────────────────────────────────────────────────────────

echo ""
echo -e "${BOLD}────────────────────────────────────────${NC}"
echo -e "${GREEN}${BOLD}Agile team installed.${NC}"
echo ""
echo "  What's installed:"
echo "    .claude/agents/    — 13 specialist agents (7 core + 6 roster-gated)"
echo "    .claude/commands/  — 29 slash commands"
echo "    .claude/hooks/     — safety gates + secret scanning
    .gitleaks.toml     — secret scanner config
    .git/hooks/        — pre-commit secret scan (active if gitleaks installed)"
echo "    memory/            — persistent team state"
echo "    CLAUDE.md          — project constitution"
echo ""
echo -e "  ${BOLD}Next steps:${NC}"
echo ""
echo "  1. Open Claude Code in this directory:"
echo "       claude"
echo ""
echo "  2. Run /init to onboard the team:"
echo "       /init \"describe what you're building\""
echo ""
echo "  3. Plan your first sprint:"
echo "       /sprint-plan"
echo ""
echo "  4. Begin:"
echo "       /standup"
echo ""
echo -e "────────────────────────────────────────"
echo ""
