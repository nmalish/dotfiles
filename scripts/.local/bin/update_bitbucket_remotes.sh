#!/bin/bash

# Script to update Bitbucket remote URLs from sharecompany to biqh
# Usage: ./update_bitbucket_remotes.sh

OLD_ORG="sharecompany"
NEW_ORG="biqh"
REPOS_DIR="$HOME/Repos"

echo "Searching for git repositories in $REPOS_DIR..."
echo "Will update remotes from: git@bitbucket.org:$OLD_ORG/"
echo "                      to: git@bitbucket.org:$NEW_ORG/"
echo ""

# Counter for updated repos
updated_count=0
skipped_count=0

# Find all directories containing .git
while IFS= read -r -d '' git_dir; do
    repo_dir=$(dirname "$git_dir")
    repo_name=$(basename "$repo_dir")
    
    echo "-----------------------------------"
    echo "Checking: $repo_name"
    echo "Path: $repo_dir"
    
    cd "$repo_dir" || continue
    
    # Get current remote URL
    remote_url=$(git remote get-url origin 2>/dev/null)
    
    if [ -z "$remote_url" ]; then
        echo "  ⚠ No origin remote found, skipping"
        ((skipped_count++))
        continue
    fi
    
    echo "  Current remote: $remote_url"
    
    # Check if it's a Bitbucket URL with the old organization
    if [[ $remote_url == *"bitbucket.org:$OLD_ORG/"* ]]; then
        # Replace the organization name
        new_url="${remote_url//$OLD_ORG/$NEW_ORG}"
        
        echo "  New remote: $new_url"
        
        # Update the remote URL
        if git remote set-url origin "$new_url"; then
            echo "  ✓ Successfully updated remote URL"
            ((updated_count++))
        else
            echo "  ✗ Failed to update remote URL"
        fi
    else
        echo "  ℹ Not a $OLD_ORG Bitbucket repository, skipping"
        ((skipped_count++))
    fi
    
done < <(find "$REPOS_DIR" -type d -name ".git" -print0 2>/dev/null)

echo ""
echo "==================================="
echo "Summary:"
echo "  Updated: $updated_count repositories"
echo "  Skipped: $skipped_count repositories"
echo "==================================="
