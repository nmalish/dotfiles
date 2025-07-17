#!/bin/bash

# Multi-Repository Tmux Session Creator
# Creates git worktrees for multiple repositories and sets up a tmux session with split panes

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Usage function
usage() {
    echo "Usage: $0 <branch-name> <repo1-path> <repo2-path> [repo3-path...]"
    echo "Example: $0 feature-auth ~/repos/frontend ~/repos/backend"
    exit 1
}

# Check arguments
if [[ $# -lt 3 ]]; then
    echo -e "${RED}Error: At least 3 arguments required (branch name + 2 repositories)${NC}"
    usage
fi

BRANCH_NAME="$1"
shift # Remove branch name from arguments, leaving repository paths

REPO_PATHS=("$@")
REPO_COUNT=${#REPO_PATHS[@]}

# Sanitize branch name
BRANCH_NAME=$(echo "$BRANCH_NAME" | sed 's/[^a-zA-Z0-9._-]/-/g' | sed 's/--*/-/g')

echo -e "${BLUE}Setting up multi-repository session for branch: ${YELLOW}$BRANCH_NAME${NC}"
echo -e "${BLUE}Repositories (${REPO_COUNT}):${NC}"

# Validate all repositories and collect info
REPO_NAMES=()
WORKTREE_PATHS=()

for i in "${!REPO_PATHS[@]}"; do
    REPO_PATH="${REPO_PATHS[$i]}"
    
    # Convert to absolute path
    REPO_PATH=$(cd "$REPO_PATH" && pwd)
    
    # Check if directory exists
    if [[ ! -d "$REPO_PATH" ]]; then
        echo -e "${RED}Error: Repository path '$REPO_PATH' does not exist${NC}"
        exit 1
    fi
    
    # Check if it's a git repository
    if ! git -C "$REPO_PATH" rev-parse --git-dir > /dev/null 2>&1; then
        echo -e "${RED}Error: '$REPO_PATH' is not a git repository${NC}"
        exit 1
    fi
    
    # Get repository name
    REPO_NAME=$(basename "$REPO_PATH")
    REPO_NAMES+=("$REPO_NAME")
    
    # Set up worktree path
    WORKTREE_BASE="$REPO_PATH/../worktrees"
    WORKTREE_PATH="$WORKTREE_BASE/$BRANCH_NAME"
    WORKTREE_PATHS+=("$WORKTREE_PATH")
    
    echo -e "  ${GREEN}$((i+1)). $REPO_NAME${NC} -> $WORKTREE_PATH"
    
    # Create worktrees directory if it doesn't exist
    mkdir -p "$WORKTREE_BASE"
    
    # Check if worktree already exists
    if [[ -d "$WORKTREE_PATH" ]]; then
        echo -e "${RED}Error: Worktree directory '$WORKTREE_PATH' already exists${NC}"
        exit 1
    fi
    
    # Check if branch already exists in this repo
    if git -C "$REPO_PATH" show-ref --verify --quiet "refs/heads/$BRANCH_NAME"; then
        echo -e "${RED}Error: Branch '$BRANCH_NAME' already exists in $REPO_NAME${NC}"
        exit 1
    fi
done

# Create worktrees for all repositories
echo -e "\n${GREEN}Creating worktrees...${NC}"
for i in "${!REPO_PATHS[@]}"; do
    REPO_PATH="${REPO_PATHS[$i]}"
    REPO_NAME="${REPO_NAMES[$i]}"
    WORKTREE_PATH="${WORKTREE_PATHS[$i]}"
    
    echo -e "  Creating worktree for ${YELLOW}$REPO_NAME${NC}..."
    git -C "$REPO_PATH" worktree add "$WORKTREE_PATH" -b "$BRANCH_NAME"
done

# Session name
SESSION_NAME="multi-$BRANCH_NAME"

# Check if session already exists
if tmux has-session -t "$SESSION_NAME" 2>/dev/null; then
    echo -e "${YELLOW}Session '$SESSION_NAME' already exists. Attaching...${NC}"
    tmux attach-session -t "$SESSION_NAME"
    exit 0
fi

echo -e "\n${GREEN}Creating tmux session: $SESSION_NAME${NC}"

# Create session with first window (nvim)
tmux new-session -d -s "$SESSION_NAME" -n "nvim" -c "${WORKTREE_PATHS[0]}"

# Set up nvim window with split panes
for i in "${!WORKTREE_PATHS[@]}"; do
    WORKTREE_PATH="${WORKTREE_PATHS[$i]}"
    REPO_NAME="${REPO_NAMES[$i]}"
    
    if [[ $i -eq 0 ]]; then
        # First pane is already created, just set title and start nvim
        tmux select-pane -t "$SESSION_NAME:1.0" -T "$REPO_NAME"
        tmux send-keys -t "$SESSION_NAME:1.0" "cd '$WORKTREE_PATH' && nvim ." Enter
    else
        # Create additional panes
        tmux split-window -t "$SESSION_NAME:1" -c "$WORKTREE_PATH"
        tmux select-pane -t "$SESSION_NAME:1.$i" -T "$REPO_NAME"
        tmux send-keys -t "$SESSION_NAME:1.$i" "nvim ." Enter
    fi
done

# Arrange layout for nvim window
if [[ $REPO_COUNT -eq 2 ]]; then
    tmux select-layout -t "$SESSION_NAME:1" even-horizontal
elif [[ $REPO_COUNT -eq 3 ]]; then
    tmux select-layout -t "$SESSION_NAME:1" main-horizontal
else
    tmux select-layout -t "$SESSION_NAME:1" tiled
fi

# Create scripts window with split panes
tmux new-window -t "$SESSION_NAME" -n "scripts" -c "${WORKTREE_PATHS[0]}"

for i in "${!WORKTREE_PATHS[@]}"; do
    WORKTREE_PATH="${WORKTREE_PATHS[$i]}"
    REPO_NAME="${REPO_NAMES[$i]}"
    
    if [[ $i -eq 0 ]]; then
        # First pane is already created, just set title
        tmux select-pane -t "$SESSION_NAME:2.0" -T "$REPO_NAME"
        tmux send-keys -t "$SESSION_NAME:2.0" "cd '$WORKTREE_PATH'" Enter
    else
        # Create additional panes
        tmux split-window -t "$SESSION_NAME:2" -c "$WORKTREE_PATH"
        tmux select-pane -t "$SESSION_NAME:2.$i" -T "$REPO_NAME"
    fi
done

# Arrange layout for scripts window
if [[ $REPO_COUNT -eq 2 ]]; then
    tmux select-layout -t "$SESSION_NAME:2" even-horizontal
elif [[ $REPO_COUNT -eq 3 ]]; then
    tmux select-layout -t "$SESSION_NAME:2" main-horizontal
else
    tmux select-layout -t "$SESSION_NAME:2" tiled
fi

# Create claude window (single pane)
tmux new-window -t "$SESSION_NAME" -n "claude" -c "${WORKTREE_PATHS[0]}"

# Build claude command with all worktree directories
CLAUDE_CMD="claude"
for i in "${!WORKTREE_PATHS[@]}"; do
    if [[ $i -gt 0 ]]; then  # Skip first directory (it's the working directory)
        CLAUDE_CMD="$CLAUDE_CMD --add-dir '${WORKTREE_PATHS[$i]}'"
    fi
done

tmux send-keys -t "$SESSION_NAME:3" "$CLAUDE_CMD" Enter

# Select scripts window by default
tmux select-window -t "$SESSION_NAME:2"

# Show summary
echo -e "\n${GREEN}Multi-repository session created successfully!${NC}"
echo -e "${GREEN}Session: $SESSION_NAME${NC}"
echo -e "${GREEN}Branch: $BRANCH_NAME${NC}"
echo -e "${GREEN}Repositories:${NC}"
for i in "${!REPO_NAMES[@]}"; do
    echo -e "  ${YELLOW}${REPO_NAMES[$i]}${NC} at ${WORKTREE_PATHS[$i]}"
done

echo -e "\n${BLUE}Tmux session layout:${NC}"
echo -e "  Window 1 (nvim): Split panes with nvim for each repository"
echo -e "  Window 2 (scripts): Split panes with shells for each repository"
echo -e "  Window 3 (claude): Single pane for claude code"

echo -e "\n${GREEN}Attaching to session...${NC}"
tmux attach-session -t "$SESSION_NAME"