# Git Commit Command

Create a meaningful git commit for the current staged changes with a concise summary and detailed description.

## Instructions

1. **Analyze Current Changes**
   - Run `git status` to see what files are modified, added, or deleted
   - Run `git diff --staged` to see the actual changes that are staged
   - If nothing is staged, run `git diff` to see unstaged changes and ask if they should be staged first

2. **Assess Change Complexity**
   - **Simple changes**: Single file, small diff (< 20 lines), config changes, typo fixes
   - **Complex changes**: Multiple files, large diffs, new features, architectural changes
   
3. **Generate Commit Message Structure**
   - Create a concise, descriptive commit summary (50 characters or less)
   - Use imperative mood (e.g., "add", "fix", "update", "remove")
   - Follow conventional commit format when applicable (feat:, fix:, docs:, config:, etc.)

4. **Create Description (Complex Changes Only)**
   - For simple changes: Use summary only
   - For complex changes: Add detailed explanation including:
     - What was changed and why
     - Any technical details worth noting
     - Impact on functionality or users
     - Reference any related issues or tickets

5. **Commit Guidelines**
   - Use present tense, imperative mood for the summary
   - Keep the summary under 50 characters
   - Wrap description lines at 72 characters (only for complex changes)
   - Do NOT include any references to "Claude Code", "Anthropic", or AI assistance
   - Make the commit message sound natural and human-written

6. **Execute Commit**
   - For simple changes: Use `git commit -m "summary"`
   - For complex changes: Use `git commit -m "summary" -m "detailed description"`
   - Show the proposed commit message for review
   - Ask for confirmation before committing

## Example Output Format

**Simple Change:**
```
config: disable file operation notifications
```

**Complex Change:**
```
feat: add user authentication middleware

Implement JWT-based authentication middleware for API routes.
The middleware validates tokens, handles expired sessions,
and provides user context to protected endpoints.

- Add token validation with proper error handling
- Include refresh token logic for seamless UX  
- Update route protection for admin endpoints
- Add comprehensive test coverage for auth flows

Resolves authentication requirements for user management system.
```

## Context Commands

Before creating the commit message, gather context with:
- `git status`
- `git diff --staged` (or `git diff` if nothing staged)
- `git branch --show-current` 
- `git log --oneline -3` (recent commits for context)

Focus on creating professional, clear commit messages that accurately describe the changes without any AI attribution. Use simple summary-only commits for straightforward changes and detailed descriptions only when the complexity warrants it.
