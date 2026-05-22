#!/usr/bin/env bash
# WorktreeRemove hook: tear down a worktree created by worktree-create.sh.
# Reads the worktree path from stdin (accepts snake_case or camelCase).
set -euo pipefail

input=$(cat)
dir=$(printf '%s' "$input" | jq -r '.worktree_path // .worktreePath // .path // empty')
[ -z "$dir" ] && exit 0
[ -d "$dir" ] || exit 0

# Find the main repo so `git worktree remove` runs from there, then fall back to rm.
common=$(git -C "$dir" rev-parse --git-common-dir 2>/dev/null || true)
if [ -n "$common" ]; then
  main=$(cd "$dir" && cd "$(dirname "$common")" && pwd)
  git -C "$main" worktree remove --force "$dir" >&2 2>/dev/null || rm -rf "$dir"
else
  rm -rf "$dir"
fi
