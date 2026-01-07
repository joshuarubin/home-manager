# Dynamically generate shell aliases from jj config aliases
# This creates shell aliases like jjd -> "jj d" for all jj config aliases

if (( $+commands[jj] )); then
  # Parse jj config aliases and create corresponding shell aliases
  local alias_name alias_value
  while IFS='=' read -r alias_name alias_value; do
    [[ -z "$alias_name" ]] && continue
    # Skip the 'aliases' alias itself
    [[ "$alias_name" == "aliases" ]] && continue

    # Create global alias (-g makes it expand anywhere, but we want command position only)
    # Use regular alias which expands in command position
    alias "jj${alias_name}=jj ${alias_name}"
  done < <(jj aliases 2>/dev/null)

fi
