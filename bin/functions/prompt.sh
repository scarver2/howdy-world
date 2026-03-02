#!/usr/bin/env bash
# bin/functions/prompt.sh

confirm() {
  local message="$1"

  while true; do
    read -rp "$message [y/N]: " response
    case "$response" in
      y|Y|yes|YES)
        return 0
        ;;
      n|N|no|NO|"")
        return 1
        ;;
      *)
        echo "Please answer y or n."
        ;;
    esac
  done
}

# --------------------------------------------------
# Padding
# FIXEME: does not appear to be used
# --------------------------------------------------
pad_dots() {
  local label="$1"
  local max="$2"
  local len="${#label}"
  local dots=$(( max - len ))
  (( dots < 3 )) && dots=3
  printf "%s" "$label"
  printf '%*s' "$dots" '' | tr ' ' '.'
}
