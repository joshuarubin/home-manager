# Set up completion for shell jj aliases
# This file dynamically sets up compdef for all jj* shell aliases

if (( $+commands[jj] )); then
  # For shell aliases like jjbm, just delegate to jj completion
  # The completion system will use the alias expansion automatically
  for alias_name in ${(k)aliases[(I)jj*]}; do
    # Skip the plain 'jj' alias if it exists
    [[ "$alias_name" == "jj" ]] && continue

    # Simply make the alias complete like jj
    # Zsh will automatically expand the alias and use those words
    compdef _jj "$alias_name"
  done

  # Set up jj command itself to use our wrapper
  compdef _jj jj
fi
