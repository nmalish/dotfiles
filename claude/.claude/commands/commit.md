# Git Commit Command (Short)

Create a concise git commit with a one-sentence summary for the current staged changes.

## Instructions

1. **Analyze Current Changes**
   - Run `git status` to see what files are modified, added, or deleted
   - Run `git diff --staged` to see the actual changes that are staged
   - If nothing is staged, run `git diff` to see unstaged changes and ask if they should be staged first

2. **Generate Commit Message**
   - Create a concise, descriptive commit summary (50 characters or less)
   - Use imperative mood (e.g., "add", "fix", "update", "remove")
   - Follow conventional commit format when applicable (feat:, fix:, docs:, config:, etc.)

3. **Commit Guidelines**
   - Use present tense, imperative mood
   - Keep the summary under 50 characters
   - Do NOT include any references to "Claude Code", "Anthropic", or AI assistance
   - Make the commit message sound natural and human-written

4. **Execute Commit**
   - Use `git commit -m "summary"` (summary only, no description)
   - Show the proposed commit message for review
   - Ask for confirmation before committing

## Example Output Format

```
config: disable file operation notifications
```

```
feat: add user authentication middleware
```

```
fix: resolve memory leak in data processing
```

## Context Commands

Before creating the commit message, gather context with:
- `git status`
- `git diff --staged` (or `git diff` if nothing staged)
- `git branch --show-current` 
- `git log --oneline -3` (recent commits for context)

Focus on creating professional, clear commit messages that accurately describe the changes in one concise sentence without any AI attribution.