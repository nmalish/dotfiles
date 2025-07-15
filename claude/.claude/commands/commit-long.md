# Git Commit Command (Long)

Create a comprehensive git commit with both a summary and detailed description for complex changes.

## Instructions

1. **Analyze Current Changes**
   - Run `git status` to see what files are modified, added, or deleted
   - Run `git diff --staged` to see the actual changes that are staged
   - If nothing is staged, run `git diff` to see unstaged changes and ask if they should be staged first

2. **Assess Change Complexity**
   - This command is for complex changes: Multiple files, large diffs, new features, architectural changes
   - Use this when changes require detailed explanation beyond a simple summary

3. **Generate Commit Message Structure**
   - Create a concise, descriptive commit summary (50 characters or less)
   - Use imperative mood (e.g., "add", "fix", "update", "remove")
   - Follow conventional commit format when applicable (feat:, fix:, docs:, config:, etc.)

4. **Create Detailed Description**
   - Add comprehensive explanation including:
     - What was changed and why
     - Any technical details worth noting
     - Impact on functionality or users
     - Reference any related issues or tickets
     - Breaking changes or migration notes

5. **Commit Guidelines**
   - Use present tense, imperative mood for the summary
   - Keep the summary under 50 characters
   - Wrap description lines at 72 characters
   - Do NOT include any references to "Claude Code", "Anthropic", or AI assistance
   - Make the commit message sound natural and human-written

6. **Execute Commit**
   - Use `git commit -m "summary" -m "detailed description"`
   - Show the proposed commit message for review
   - Ask for confirmation before committing

## Example Output Format

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

```
refactor: restructure database connection management

Replace singleton pattern with dependency injection for better
testability and configuration flexibility. This change improves
connection pooling and error handling across the application.

- Extract connection factory into separate module
- Add connection health monitoring and retry logic
- Update all services to use injected connections
- Add integration tests for connection scenarios

Breaking change: Database service constructor now requires
connection factory parameter. Update service initialization
in main application entry point.
```

## Context Commands

Before creating the commit message, gather context with:
- `git status`
- `git diff --staged` (or `git diff` if nothing staged)
- `git branch --show-current` 
- `git log --oneline -3` (recent commits for context)

Focus on creating professional, detailed commit messages that thoroughly explain complex changes without any AI attribution. Use this command when the scope and complexity of changes warrant detailed explanation.