#!/bin/bash

# Read JSON input from stdin
INPUT=$(cat)

# Extract the current working directory
CWD=$(echo "$INPUT" | jq -r '.cwd // ""')

# Get project name from the current directory
if [ -n "$CWD" ]; then
  PROJECT_NAME=$(basename "$CWD")
else
  PROJECT_NAME=$(basename "$PWD")
fi

# Display notification with project name
osascript -e "display notification \"Needs your input\" with title \"Claude Code - $PROJECT_NAME\" sound name \"Ping\""

exit 0
