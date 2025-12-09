# New Revision Since Push

Create a new child revision and move all changes made since the last push into it, leaving the pushed revision clean.

## Steps

1. **Check for bookmark on current revision**:
   - Run `jj log -r @ -T 'bookmarks'` to get bookmarks on current revision
   - If output is empty, return error: "Error: No bookmark found on current revision. Use `jj bookmark create <name>` to create one."
   - Extract the bookmark name

2. **Check if there are changes since push**:
   - Run `jj diff -r '<bookmark-name>@origin..@' --stat`
   - If output is empty (no changes since push):
     - Simply run `jj new` to create a new child revision
     - Report: "No changes since last push. Created new child revision."
     - Stop here

3. **Move post-push changes to new revision**:
   - Get the current revision ID: `jj log -r @ -T 'commit_id' --no-graph`
   - Get the old bookmark commit ID: `jj log -r <bookmark-name> -T 'commit_id' --no-graph`
   - Move the bookmark back to origin: `jj bookmark set <bookmark-name> -r <bookmark-name>@origin --allow-backwards`
   - Create new child revision: `jj new <bookmark-name>`
   - Restore changes from the saved current revision ID: `jj restore --from <current-rev-id>`
   - Abandon the old bookmark commit: `jj abandon <old-bookmark-commit-id>`
   - Report: "Moved post-push changes to new child revision. Parent revision now matches remote."

## Important

- Always use `jj` commands, never `git`
- The bookmark name should be the local bookmark (without `@origin`)
- If multiple bookmarks exist on the current revision, use the first one found
- The `--allow-backwards` flag is required when moving a bookmark to an ancestor
- The old bookmark commit is abandoned after moving to prevent divergent revisions
