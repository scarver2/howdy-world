#!/usr/bin/env bash
# bin/functions/prompt.sh

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
