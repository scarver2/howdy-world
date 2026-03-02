#!/usr/bin/env bash
# __ENDPOINT__/bin/_lib.sh

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENDPOINT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

if [[ -f "$ENDPOINT_DIR/../bin/_lib.sh" ]]; then
  source "$ENDPOINT_DIR/../bin/_lib.sh"
  # TODO: Is this needed?
  # require_endpoint_contract
fi

cd "$ENDPOINT_DIR"
