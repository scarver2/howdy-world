#!/usr/bin/env bash
# ruby-webrick/bin/_lib.sh

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENDPOINT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

if [[ -f "$ENDPOINT_DIR/../bin/_lib.sh" ]]; then
  source "$ENDPOINT_DIR/../bin/_lib.sh"
fi

cd "$ENDPOINT_DIR"
