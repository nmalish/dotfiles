#!/usr/bin/env bash
# WorktreeCreate hook: place worktrees in a sibling worktrees/ dir based on the
# project root. Reads {name, cwd} from stdin, prints the absolute worktree path
# on stdout (everything else goes to stderr). Replaces git's default placement.
set -euo pipefail

input=$(cat)
name=$(printf '%s' "$input" | jq -r '.name')
cwd=$(printf '%s' "$input" | jq -r '.cwd // empty')
[ -z "$cwd" ] && cwd="$PWD"

# Choose the worktrees root by matching the project root prefix.
case "$cwd/" in
  "$HOME"/Repos/*)    base="$HOME/Repos/worktrees" ;;
  "$HOME"/Lab/*)      base="$HOME/Lab/worktrees" ;;
  "$HOME"/Projects/*) base="$HOME/Projects/worktrees" ;;
  *)                  base="$HOME/.claude/worktrees" ;;
esac

dir="$base/$name"
mkdir -p "$base" >&2

# Create the worktree (and a branch named after it) from the repo at cwd.
git -C "$cwd" worktree add "$dir" >&2

printf '%s\n' "$dir"
