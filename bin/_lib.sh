#!/usr/bin/env bash
# bin/_lib.sh

# Resolve bin directory (where _lib.sh lives)
BIN_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Project root is parent of bin/
ROOT_DIR="$(cd "$BIN_DIR/.." && pwd)"

# Export so child scripts can use it
export ROOT_DIR

# Load concerns relative to bin in this order.
source "$BIN_DIR/functions/env.sh"
source "$BIN_DIR/functions/colors.sh"
source "$BIN_DIR/functions/git.sh"
source "$BIN_DIR/functions/compose.sh"
source "$BIN_DIR/functions/endpoints.sh"
source "$BIN_DIR/functions/http.sh"
source "$BIN_DIR/functions/banner.sh"

HW_VERSION="$(git_version)"

print_available_commands() {
  for file in "$ROOT_DIR/bin/"*; do
    name="$(basename "$file")"
    [[ "$name" == _* ]] && continue
    [[ "$name" == "templates" ]] && continue
    [[ -d "$file" ]] && continue
    printf "  %-15s\n" "$name"
  done
}

require_endpoint_contract() {
  local endpoint_dir
  endpoint_dir="$(pwd)"

  local required=(
    Dockerfile
    compose.yml
    .dockerignore
    .gitignore
    README.md
    bin/setup
    bin/outdated
  )

  local missing=0

  for file in "${required[@]}"; do
    if [[ ! -e "$endpoint_dir/$file" ]]; then
      echo "Endpoint contract violation: missing $file"
      missing=1
    fi
  done

  if (( missing == 1 )); then
    echo
    echo "This directory does not satisfy the Howdy World endpoint contract."
    exit 1
  fi
}

banner
