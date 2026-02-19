#!/usr/bin/env bash
# bin/_lib.sh
set -euo pipefail

# Resolve bin directory (where _lib.sh lives)
BIN_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Project root is parent of bin/
ROOT_DIR="$(cd "$BIN_DIR/.." && pwd)"

# Export so child scripts can use it
export ROOT_DIR

# Load concerns relative to bin/
source "$BIN_DIR/functions/env.sh"
source "$BIN_DIR/functions/colors.sh"
source "$BIN_DIR/functions/git.sh"
source "$BIN_DIR/functions/compose.sh"
source "$BIN_DIR/functions/endpoints.sh"
source "$BIN_DIR/functions/http.sh"
source "$BIN_DIR/functions/banner.sh"

HW_VERSION="$(git_version)"

banner
