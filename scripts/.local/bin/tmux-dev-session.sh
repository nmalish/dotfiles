#!/bin/bash

# Get the current directory name for session naming
SESSION_NAME=$(basename "$PWD")

# Check if session already exists
if tmux has-session -t "$SESSION_NAME" 2>/dev/null; then
    echo "Session '$SESSION_NAME' already exists. Attaching..."
    tmux attach-session -t "$SESSION_NAME"
    exit 0
fi

# Create new session with the folder name
echo "Creating new tmux session: $SESSION_NAME"

# Create session and first window (detached)
tmux new-session -d -s "$SESSION_NAME" -n "dev"

# Split window 0 into two panes
tmux split-window -h -t "$SESSION_NAME:0"

# Send nvim command to the left pane (pane 0)
tmux send-keys -t "$SESSION_NAME:0.0" "nvim ." Enter

# Create second window named "claude"
tmux new-window -t "$SESSION_NAME" -n "claude"

# Select the first window and right pane (console)
tmux select-window -t "$SESSION_NAME:0"
tmux select-pane -t "$SESSION_NAME:0.1"

# Attach to the session
tmux attach-session -t "$SESSION_NAME"
