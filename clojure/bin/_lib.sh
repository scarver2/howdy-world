#!/bin/bash
# clojure/bin/_lib.sh

# Resolve root _lib.sh relative to this endpoint
ROOT_LIB="$(cd "$(dirname "$0")/../../.." && pwd)/bin/_lib.sh"

if [[ -f "$ROOT_LIB" ]]; then
  # Load common libraries
  source "$ROOT_LIB"
else
  echo "Root _lib.sh not found. Endpoint may be detached."
  exit 1
fi
