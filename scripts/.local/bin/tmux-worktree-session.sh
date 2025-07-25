#!/bin/bash

# Git Worktree + Tmux Session Creator
# Creates a new git worktree and sets up a tmux session for development

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if we're in a git repository
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo -e "${RED}Error: Not in a git repository${NC}"
    exit 1
fi

# Get the current repository name
REPO_NAME=$(basename "$(git rev-parse --show-toplevel)")

# Get branch name from parameter or prompt
if [[ -n "$1" ]]; then
    BRANCH_NAME="$1"
else
    echo -e "${YELLOW}Enter branch name for the new worktree:${NC}"
    read -r BRANCH_NAME
    
    if [[ -z "$BRANCH_NAME" ]]; then
        echo -e "${RED}Error: Branch name cannot be empty${NC}"
        exit 1
    fi
fi

# Sanitize branch name (replace spaces and special chars with hyphens)
BRANCH_NAME=$(echo "$BRANCH_NAME" | sed 's/[^a-zA-Z0-9._-]/-/g' | sed 's/--*/-/g')

# Set up worktree directory
WORKTREE_BASE="../worktrees"
WORKTREE_PATH="$WORKTREE_BASE/$BRANCH_NAME"

# Create worktrees directory if it doesn't exist
mkdir -p "$WORKTREE_BASE"

# Check if worktree already exists
if [[ -d "$WORKTREE_PATH" ]]; then
    echo -e "${RED}Error: Worktree directory '$WORKTREE_PATH' already exists${NC}"
    exit 1
fi

# Check if branch already exists
if git show-ref --verify --quiet "refs/heads/$BRANCH_NAME"; then
    echo -e "${RED}Error: Branch '$BRANCH_NAME' already exists${NC}"
    exit 1
fi

# Create the git worktree
echo -e "${GREEN}Creating git worktree for branch '$BRANCH_NAME'...${NC}"
git worktree add "$WORKTREE_PATH" -b "$BRANCH_NAME"

# Copy Claude-related files from the original repository
echo -e "${GREEN}Copying Claude configuration files...${NC}"
ORIGINAL_REPO=$(git rev-parse --show-toplevel)

# Copy .claude/settings.local.json if it exists
if [[ -f "$ORIGINAL_REPO/.claude/settings.local.json" ]]; then
    mkdir -p "$WORKTREE_PATH/.claude"
    cp "$ORIGINAL_REPO/.claude/settings.local.json" "$WORKTREE_PATH/.claude/"
    echo -e "${GREEN}✓ Copied .claude/settings.local.json${NC}"
fi

# Copy claude/.claude/mcp_servers.json if it exists
if [[ -f "$ORIGINAL_REPO/claude/.claude/mcp_servers.json" ]]; then
    mkdir -p "$WORKTREE_PATH/claude/.claude"
    cp "$ORIGINAL_REPO/claude/.claude/mcp_servers.json" "$WORKTREE_PATH/claude/.claude/"
    echo -e "${GREEN}✓ Copied claude/.claude/mcp_servers.json${NC}"
fi

# Change to the worktree directory
cd "$WORKTREE_PATH"

# Session name based on repo and branch
SESSION_NAME="${REPO_NAME}-${BRANCH_NAME}"

# Check if session already exists
if tmux has-session -t "$SESSION_NAME" 2>/dev/null; then
    echo -e "${YELLOW}Session '$SESSION_NAME' already exists. Attaching...${NC}"
    tmux attach-session -t "$SESSION_NAME"
    exit 0
fi

# Create new tmux session
echo -e "${GREEN}Creating tmux session: $SESSION_NAME${NC}"

# Create session and first window (nvim)
tmux new-session -d -s "$SESSION_NAME" -n "nvim"
tmux send-keys -t "$SESSION_NAME:1" "nvim ." Enter

# Create scripts window
tmux new-window -t "$SESSION_NAME" -n "scripts"

# Create claude window
tmux new-window -t "$SESSION_NAME" -n "claude"
tmux send-keys -t "$SESSION_NAME:3" "claude" Enter

# Select the scripts window by default
tmux select-window -t "$SESSION_NAME:2"

# Show worktree info
echo -e "${GREEN}Worktree created at: $WORKTREE_PATH${NC}"
echo -e "${GREEN}Branch: $BRANCH_NAME${NC}"
echo -e "${GREEN}Attaching to tmux session: $SESSION_NAME${NC}"

# Attach to the session
tmux attach-session -t "$SESSION_NAME"