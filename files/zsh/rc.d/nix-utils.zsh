# Nix utility functions

# Nix cleanup function - keep last N generations
nix-clean() {
  local keep=${1:-5}
  local gens=$(home-manager generations | awk '{print $5}' | sort -rn)
  local total=$(echo "$gens" | wc -l | tr -d ' ')
  local to_remove=$(echo "$gens" | tail -n +$((keep + 1)))

  if [[ $total -le $keep ]]; then
    echo "Only $total generations exist, keeping all"
  else
    echo "Removing $((total - keep)) old generations (keeping last $keep)"
    echo "$to_remove" | xargs -r home-manager remove-generations
  fi

  nix-collect-garbage -d
  nix-store --optimise
}

# Light version without optimize
nix-clean-light() {
  local keep=${1:-5}
  local gens=$(home-manager generations | awk '{print $5}' | sort -rn)
  local total=$(echo "$gens" | wc -l | tr -d ' ')
  local to_remove=$(echo "$gens" | tail -n +$((keep + 1)))

  if [[ $total -le $keep ]]; then
    echo "Only $total generations exist, keeping all"
  else
    echo "Removing $((total - keep)) old generations (keeping last $keep)"
    echo "$to_remove" | xargs -r home-manager remove-generations
  fi

  nix-collect-garbage -d
}
