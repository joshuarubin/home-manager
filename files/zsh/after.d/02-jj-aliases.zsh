# Dynamically generate shell aliases from jj config aliases
# This creates shell aliases like jjd -> "jj d" for all jj config aliases

if (( $+commands[jj] )); then
  # Cache jj aliases to avoid slow startup
  # Cache file stores the alias list and is invalidated when config changes
  local cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
  local cache_file="$cache_dir/jj-aliases.cache"
  local config_file="${XDG_CONFIG_HOME:-$HOME/.config}/jj/config.toml"

  # Create cache directory if it doesn't exist
  [[ ! -d "$cache_dir" ]] && mkdir -p "$cache_dir"

  # Check if cache is valid (exists and is newer than config file)
  local use_cache=0
  if [[ -f "$cache_file" ]]; then
    if [[ -f "$config_file" ]]; then
      # Cache is valid if it's newer than the config file
      [[ "$cache_file" -nt "$config_file" ]] && use_cache=1
    else
      # No config file, cache is valid if it exists
      use_cache=1
    fi
  fi

  # Generate or use cached aliases
  if (( use_cache )); then
    # Use cached aliases
    local alias_name
    while IFS= read -r alias_name; do
      [[ -z "$alias_name" ]] && continue
      alias "jj${alias_name}=jj ${alias_name}"
    done < "$cache_file"
  else
    # Generate aliases and update cache
    local alias_name alias_value
    : > "$cache_file"  # Clear cache file
    while IFS='=' read -r alias_name alias_value; do
      [[ -z "$alias_name" ]] && continue
      # Skip the 'aliases' alias itself
      [[ "$alias_name" == "aliases" ]] && continue

      # Create shell alias
      alias "jj${alias_name}=jj ${alias_name}"
      # Save to cache (just the alias name)
      echo "$alias_name" >> "$cache_file"
    done < <(jj aliases 2>/dev/null)
  fi
fi
