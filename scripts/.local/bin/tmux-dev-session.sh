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
tmux new-session -d -s "$SESSION_NAME" -n "nvim"

# Send nvim command to the first window
tmux send-keys -t "$SESSION_NAME:1" "nvim ." Enter

# Create second window named "scripts"
tmux new-window -t "$SESSION_NAME" -n "scripts"

# Create third window named "claude"
tmux new-window -t "$SESSION_NAME" -n "claude"

# Select the scripts window (window 2)
tmux select-window -t "$SESSION_NAME:2"

# Attach to the session
tmux attach-session -t "$SESSION_NAME"
