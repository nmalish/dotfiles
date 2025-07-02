#!/bin/bash

# Read JSON input from stdin
input=$(cat)

# Extract the command from the JSON
command=$(echo "$input" | jq -r '.tool_input.command // empty')

# Check if the command contains git commit
if echo "$command" | grep -q 'git commit'; then
    # Extract all commit content (messages with -m and HEREDOC content)
    commit_content=""
    
    # Extract -m messages
    if echo "$command" | grep -q '\-m'; then
        commit_content=$(echo "$command" | sed -n "s/.*-m[[:space:]]*[\"']\\([^\"']*\\)[\"'].*/\\1/p")
    fi
    
    # Extract HEREDOC content (between <<'EOF' and EOF)
    if echo "$command" | grep -q "<<'EOF'"; then
        heredoc_content=$(echo "$command" | sed -n "/<<'EOF'/,/^EOF$/p" | sed '1d;$d')
        commit_content="$commit_content $heredoc_content"
    fi
    
    # Check if any commit content contains 'claude' (case insensitive)
    if echo "$commit_content" | grep -qi 'claude'; then
        # Determine where 'claude' was found for detailed feedback
        location=""
        if echo "$command" | grep -q '\-m' && echo "$command" | sed -n "s/.*-m[[:space:]]*[\"']\\([^\"']*\\)[\"'].*/\\1/p" | grep -qi 'claude'; then
            location="commit message (-m flag)"
        elif echo "$command" | grep -q "<<'EOF'" && echo "$command" | sed -n "/<<'EOF'/,/^EOF$/p" | sed '1d;$d' | grep -qi 'claude'; then
            location="commit description (HEREDOC)"
        else
            location="commit content"
        fi
        
        echo "{\"decision\": \"block\", \"reason\": \"Commit blocked: 'claude' found in $location. Please remove references to avoid exposing AI assistance in commit history.\"}"
        exit 2
    fi
fi