# Set up completion for shell jj aliases
# This file dynamically sets up compdef for all jj* shell aliases

if (( $+commands[jj] )); then
  # Dynamically generate compdef for all jj* shell aliases
  for alias_name in ${(k)aliases[(I)jj*]}; do
    compdef "$alias_name=jj"
  done

  # Set up jj command itself to use our wrapper
  compdef _jj jj
fi
