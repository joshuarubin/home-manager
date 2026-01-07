# Set up completion for shell jj aliases
# This file dynamically sets up compdef for all jj* shell aliases

if (( $+commands[jj] )); then
  # Set up lazy completion for jj aliases
  # This defers the compdef setup until first use
  _jj_alias_completion_setup() {
    [[ -n "$_jj_alias_completion_setup_done" ]] && return
    _jj_alias_completion_setup_done=1

    # For shell aliases like jjbm, just delegate to jj completion
    # The completion system will use the alias expansion automatically
    for alias_name in ${(k)aliases[(I)jj*]}; do
      # Skip the plain 'jj' alias if it exists
      [[ "$alias_name" == "jj" ]] && continue

      # Simply make the alias complete like jj
      # Zsh will automatically expand the alias and use those words
      compdef _jj "$alias_name"
    done
  }

  # Create lazy wrappers for all jj aliases
  for alias_name in ${(k)aliases[(I)jj*]}; do
    [[ "$alias_name" == "jj" ]] && continue

    # Create a lazy wrapper for this alias
    eval "_${alias_name}_lazy() {
      _jj_alias_completion_setup
      unfunction _${alias_name}_lazy
      _jj \"\$@\"
    }"

    compdef "_${alias_name}_lazy" "$alias_name"
  done
fi
