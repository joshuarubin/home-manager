# Set Description

Ensure the current revision has a proper commit description.

## Steps

1. **Check description**: Use `jj log -r @ --no-graph -T 'description'` to see current commit message
   - If description is empty or is a placeholder (like "checkpoint", "wip", etc.):
     - Analyze changes in current revision with `jj diff -r @`
     - Generate a conventional commit message describing all changes in this revision
   - If a description exists and looks intentional:
     - Analyze changes in current revision with `jj diff -r @` to verify accuracy
     - Generate what you think the conventional commit message should be for all changes in this revision
     - **IMPORTANT**: When generating the suggested message, consider BOTH the code changes AND the existing description
       - The existing description may contain important context, intent, or reasoning that isn't obvious from code alone
       - Preserve valuable context from the original while ensuring accuracy to the actual changes
       - Don't discard meaningful details that explain the "why" behind the changes
     - If your suggested message is sufficiently different from the existing one (not just minor wording):
       - Use AskUserQuestion with exactly 2 options:
         1. Current description
         2. Your suggested description
   - Update description with `jj describe -m "<message>"` if needed

2. **Commit message format**:
   - First line: Terse yet descriptive conventional commit format
     - Format: `type(scope): description`
     - type: feat, fix, refactor, docs, test, chore, etc.
     - scope: optional, the area of code affected
     - description: lowercase, no period at end
     - Example: `feat(agent): add context caching for database queries`
   - Additional lines (optional): Add if they provide value
     - Blank line after first line
     - Additional context, reasoning, breaking changes, etc.
     - Keep concise but informative

## Important

- Always use `jj` commands, never `git`
- Description is for CURRENT COMMIT ONLY, not a summary of all commits
- First line must be conventional commit format and terse yet descriptive
- Multi-line messages are OK if they add value
- Only show 2 options in user choice: current vs suggested
