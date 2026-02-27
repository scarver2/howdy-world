#!/usr/bin/env bash
# bin/_lib.sh

# Exit immediately if a command exits with a non-zero status.
# Treat unset variables as an error when substituting.
# Cause a pipeline to return the exit status of the last command in the pipeline that failed.
# Print commands and their arguments as they are executed.
set -euo pipefail

# Resolve bin directory (where _lib.sh lives)
BIN_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Project root is parent of bin/
ROOT_DIR="$(cd "$BIN_DIR/.." && pwd)"

# Export so child scripts can use it
export ROOT_DIR

# Load concerns relative to bin in this order.
source "$BIN_DIR/functions/env.sh"
source "$BIN_DIR/functions/colors.sh"
source "$BIN_DIR/functions/contracts.sh"
source "$BIN_DIR/functions/git.sh"
source "$BIN_DIR/functions/compose.sh"
source "$BIN_DIR/functions/endpoints.sh"
source "$BIN_DIR/functions/http.sh"
source "$BIN_DIR/functions/banner.sh"
source "$BIN_DIR/functions/prompt.sh"
source "$BIN_DIR/functions/yaml.sh"
source "$BIN_DIR/functions/commands.sh"

print_available_commands() {
  for file in "$ROOT_DIR/bin/"*; do
    name="$(basename "$file")"
    [[ "$name" == _* ]] && continue
    [[ "$name" == "templates" ]] && continue
    [[ -d "$file" ]] && continue
    printf "  %-15s\n" "$name"
  done
}

ensure_root_context() {
  if [[ "$PWD" != "$ROOT_DIR" ]]; then
    cd "$ROOT_DIR"
  fi
}

ensure_endpoint_context() {
  if [[ ! -f "compose.yml" || ! -f "Dockerfile" ]]; then
    echo "Not in a valid endpoint directory."
    exit 1
  fi
}

HW_VERSION="$(git_version)"
