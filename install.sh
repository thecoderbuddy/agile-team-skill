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
    cp -r "$SOURCE_DIR/memory" "$TARGET_DIR/"
    print_ok "memory/ installed (STATE, BACKLOG, NEXT, DECISIONS, LEARNINGS)"
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
  )

  COMMANDS=(
    "init" "standup" "sprint-plan" "sprint-close" "retro" "review"
    "stories" "backlog" "new-task" "status" "discover" "design"
    "complete" "bug" "idea" "missing" "arch-review" "ux-review"
    "security-review" "risk-review" "adr" "done" "checkpoint"
    "resume" "health-check" "logs" "po" "incident" "focus-group"
  )

  MEMORY_FILES=(
    "STATE" "NEXT" "BACKLOG" "DECISIONS" "LEARNINGS"
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

    curl -fsSL "$REPO_URL/.claude/settings.json" -o "$TARGET_DIR/.claude/settings.json"
    print_ok "Hooks and settings installed"
  fi

  if [ "$SKIP_MEMORY" != "true" ]; then
    mkdir -p "$TARGET_DIR/memory"
    for mf in "${MEMORY_FILES[@]}"; do
      curl -fsSL "$REPO_URL/memory/$mf.md" -o "$TARGET_DIR/memory/$mf.md"
    done
    print_ok "memory/ installed"
  fi

  if [ "$SKIP_CLAUDE_MD" != "true" ]; then
    curl -fsSL "$REPO_URL/CLAUDE.md" -o "$TARGET_DIR/CLAUDE.md"
    print_ok "CLAUDE.md installed"
  fi
fi

# ─────────────────────────────────────────────────────────────────────────────
# Done
# ─────────────────────────────────────────────────────────────────────────────

echo ""
echo -e "${BOLD}────────────────────────────────────────${NC}"
echo -e "${GREEN}${BOLD}Agile team installed.${NC}"
echo ""
echo "  What's installed:"
echo "    .claude/agents/    — 7 specialist agents"
echo "    .claude/commands/  — 29 slash commands"
echo "    .claude/hooks/     — session tracking"
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
