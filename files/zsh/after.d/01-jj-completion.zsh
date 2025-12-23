# Enhanced jj completion setup
# This file sets up config alias support and smart revision completion for jj

# Only run if jj command exists
if ! (( $+commands[jj] )); then
  return
fi

# Load the original _jj completion function and its helpers
if [[ -f "$HOME/.zsh/functions/_jj_enhanced" ]]; then
  # Load the original _jj fully to populate helper functions
  autoload -Uz +X _jj
  # Save the fully loaded function
  functions[_jj_original]="$functions[_jj]"

  # Source our enhancements which will replace _jj
  source "$HOME/.zsh/functions/_jj_enhanced"

  # Patch the real _jj function to handle aliases and revisions
  # 1. Add config alias resolution before the case statement
  functions[_jj_original]="${functions[_jj_original]//case \$line\[1\] in/if (( \$+_jj_config_alias_map[\$line[1]] )); then line[1]="\$_jj_config_alias_map[\$line[1]]"; fi; case \$line[1] in}"

  # 2. Replace :_default with :_jj_revisions for REVSET/REVSETS parameters
  functions[_jj_original]="${functions[_jj_original]//]:REVSET:_default/]:REVSET:_jj_revisions}"
  functions[_jj_original]="${functions[_jj_original]//]:REVSETS:_default/]:REVSETS:_jj_revisions}"

  # 3. Replace :_default with :_jj_no_completion for NAME/NAMES parameters
  # This prevents file completion for bookmark names, tag names, etc.
  functions[_jj_original]="${functions[_jj_original]//]:NAME:_default/]:NAME:_jj_no_completion}"
  functions[_jj_original]="${functions[_jj_original]//]:NAMES:_default/]:NAMES:_jj_no_completion}"
  functions[_jj_original]="${functions[_jj_original]//:name:_default/:name:_jj_no_completion}"
  functions[_jj_original]="${functions[_jj_original]//:names:_default/:names:_jj_no_completion}"
  functions[_jj_original]="${functions[_jj_original]//::name:_default/::name:_jj_no_completion}"
  functions[_jj_original]="${functions[_jj_original]//::names:_default/::names:_jj_no_completion}"
  # Also handle variadic patterns like '*::names -- description:_default'
  # Bookmark create: no completion (creating new bookmark)
  functions[_jj_original]="${functions[_jj_original]//\*::names -- The bookmarks to create:_default/*::names -- The bookmarks to create:_jj_no_completion}"
  # Other bookmark commands: complete existing bookmarks
  functions[_jj_original]="${functions[_jj_original]//\*::names -- The bookmarks to delete:_default/*::names -- The bookmarks to delete:_jj_bookmarks}"
  functions[_jj_original]="${functions[_jj_original]//\*::names -- The bookmarks to forget:_default/*::names -- The bookmarks to forget:_jj_bookmarks}"
  functions[_jj_original]="${functions[_jj_original]//\*::names -- Show bookmarks whose local name matches:_default/*::names -- Show bookmarks whose local name matches:_jj_bookmarks}"
  functions[_jj_original]="${functions[_jj_original]//\*::names -- Move bookmarks matching the given name patterns:_default/*::names -- Move bookmarks matching the given name patterns:_jj_bookmarks}"

  # 4. Handle positional revision arguments
  functions[_jj_original]="${functions[_jj_original]//\*::revisions -- Parent\(s\) of the new change:_default/*::revisions -- Parent(s) of the new change:_jj_revisions}"
  functions[_jj_original]="${functions[_jj_original]//\*::revisions_pos -- The revision\(s\) to abandon \(default\: @\):_default/*::revisions_pos -- The revision(s) to abandon (default: @):_jj_revisions}"
  functions[_jj_original]="${functions[_jj_original]//:revision -- The commit to edit:_default/:revision -- The commit to edit:_jj_revisions}"
  functions[_jj_original]="${functions[_jj_original]//::revision -- Show changes in this revision, compared to its parent\(s\):_default/::revision -- Show changes in this revision, compared to its parent(s):_jj_revisions}"
  # Generic revision positional argument
  functions[_jj_original]="${functions[_jj_original]//:revision:_default/:revision:_jj_revisions}"
fi
