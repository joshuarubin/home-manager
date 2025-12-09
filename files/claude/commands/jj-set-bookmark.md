# Set Bookmark

Ensure the current revision has a bookmark.

## Steps

1. **Determine bookmark prefix**:
   - Check if the project has a `CLAUDE.md` file at the repository root
   - Look for a line matching `## JJ Bookmark Prefix: <prefix>` (e.g., `## JJ Bookmark Prefix: joshua/`)
   - If found, extract the prefix (including trailing slash if present)
   - If not found, use no prefix (bookmark will be just the topic name)

2. **Find branch point**: Use `jj log -r 'ancestors(@) & bookmarks() & ~remote_bookmarks()' -n 1` to find the first local bookmarked ancestor (the branch point), excluding remote tracking bookmarks

3. **Check for bookmark**: Use `jj log -r @ -T 'bookmarks'` to see if current revision has a bookmark
   - If no bookmark exists:
     - Analyze ALL changes from branch point to current with `jj diff -r '<branch-point>::@'`
     - Review all commit messages in this range with `jj log -r '<branch-point>::@' --no-graph -T 'description'`
     - Create a bookmark name with format `<prefix><topic>` where topic is a short kebab-case description of the overall changes
     - Set the bookmark with `jj bookmark set <name>`

## Important

- Always use `jj` commands, never `git`
- Bookmark prefix is determined from CLAUDE.md in the repository root
- If no prefix is configured, use just the topic name
