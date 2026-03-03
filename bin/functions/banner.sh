#!/usr/bin/env bash
# bin/functions/banner.sh

detect_endpoint() {
  if [[ "$PWD" != "$ROOT_DIR" ]] && [[ -f "$PWD/Dockerfile" ]]; then
    basename "$PWD"
  fi
}

# COMMAND_NAME="$(basename "${BASH_SOURCE[3]}")"
COMMAND_NAME="$(basename "${BASH_SOURCE[3]:-$0}")"

ENDPOINT_NAME="$(detect_endpoint)"

banner() {
  [[ "$HW_QUIET" == "1" ]] && return
  echo "Howdy World CLI"
  echo "Version: $HW_VERSION"
  echo "Root:    $ROOT_DIR"
  if [[ -n "$ENDPOINT_NAME" ]]; then
    echo "Endpoint: $ENDPOINT_NAME"
  fi
  echo "Command: $COMMAND_NAME"
  # TODO: consider removing since it may just be noise.
  # echo "Compose: $COMPOSE_FILE"
  echo
}
