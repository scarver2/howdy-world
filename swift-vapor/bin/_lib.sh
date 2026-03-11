#!/usr/bin/env bash
# swift-vapor/bin/_lib.sh

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENDPOINT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

if [[ -f "$ENDPOINT_DIR/../bin/_lib.sh" ]]; then
  source "$ENDPOINT_DIR/../bin/_lib.sh"
  # TODO: Is this needed?
  # require_endpoint_contract
fi

banner

swift --version

cd "$ENDPOINT_DIR"
