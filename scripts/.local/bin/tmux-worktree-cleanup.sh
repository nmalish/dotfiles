#!/bin/bash

# Git Worktree + Tmux Session Cleanup
# Removes a git worktree and kills the associated tmux session

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

# Get branch name from parameter or current branch
if [[ -n "$1" ]]; then
    BRANCH_NAME="$1"
else
    # Try to get current branch name from worktree
    CURRENT_DIR=$(pwd)
    if [[ "$CURRENT_DIR" =~ worktrees/([^/]+) ]]; then
        BRANCH_NAME="${BASH_REMATCH[1]}"
    else
        echo -e "${YELLOW}Enter branch name of the worktree to remove:${NC}"
        read -r BRANCH_NAME
    fi
    
    if [[ -z "$BRANCH_NAME" ]]; then
        echo -e "${RED}Error: Branch name cannot be empty${NC}"
        exit 1
    fi
fi

# Sanitize branch name (same as in creation script)
BRANCH_NAME=$(echo "$BRANCH_NAME" | sed 's/[^a-zA-Z0-9._-]/-/g' | sed 's/--*/-/g')

# Set up paths
WORKTREE_BASE="../worktrees"
WORKTREE_PATH="$WORKTREE_BASE/$BRANCH_NAME"
SESSION_NAME="${REPO_NAME}-${BRANCH_NAME}"

# Get absolute path of worktree
WORKTREE_ABS_PATH=$(cd "$(git rev-parse --show-toplevel)" && cd "$WORKTREE_PATH" 2>/dev/null && pwd) || true

# Check if worktree exists
if ! git worktree list | grep -q "$BRANCH_NAME"; then
    echo -e "${RED}Error: Worktree for branch '$BRANCH_NAME' not found${NC}"
    echo -e "Available worktrees:"
    git worktree list
    exit 1
fi

# Kill tmux session if it exists
if tmux has-session -t "$SESSION_NAME" 2>/dev/null; then
    echo -e "${YELLOW}Killing tmux session: $SESSION_NAME${NC}"
    tmux kill-session -t "$SESSION_NAME"
    echo -e "${GREEN}✓ Tmux session killed${NC}"
else
    echo -e "${YELLOW}No tmux session found for: $SESSION_NAME${NC}"
fi

# Change to main worktree before removing
cd "$(git rev-parse --show-toplevel)"

# Remove the worktree
echo -e "${YELLOW}Removing worktree at: $WORKTREE_PATH${NC}"
if git worktree remove "$WORKTREE_PATH" 2>/dev/null; then
    echo -e "${GREEN}✓ Worktree removed successfully${NC}"
else
    # Try force remove if regular remove fails
    echo -e "${YELLOW}Regular remove failed, trying force remove...${NC}"
    if git worktree remove --force "$WORKTREE_PATH"; then
        echo -e "${GREEN}✓ Worktree force removed successfully${NC}"
    else
        echo -e "${RED}Error: Failed to remove worktree${NC}"
        exit 1
    fi
fi

# Prune any stale worktree administrative files
git worktree prune

# Ask about branch deletion
echo -e "${YELLOW}Do you want to delete the branch '$BRANCH_NAME'? (y/N)${NC}"
read -r DELETE_BRANCH

if [[ "$DELETE_BRANCH" =~ ^[Yy]$ ]]; then
    # Check if branch has been merged
    if git branch --merged | grep -q "$BRANCH_NAME"; then
        git branch -d "$BRANCH_NAME"
        echo -e "${GREEN}✓ Branch deleted (was merged)${NC}"
    else
        echo -e "${YELLOW}Branch has not been merged. Force delete? (y/N)${NC}"
        read -r FORCE_DELETE
        if [[ "$FORCE_DELETE" =~ ^[Yy]$ ]]; then
            git branch -D "$BRANCH_NAME"
            echo -e "${GREEN}✓ Branch force deleted${NC}"
        else
            echo -e "${YELLOW}Branch kept: $BRANCH_NAME${NC}"
        fi
    fi
else
    echo -e "${YELLOW}Branch kept: $BRANCH_NAME${NC}"
fi

echo -e "${GREEN}Cleanup complete!${NC}"