#!/usr/bin/env bash
# bin/functions/banner.sh

COMMAND_NAME="$(basename "${BASH_SOURCE[2]}")"

banner() {
  [[ "$HW_QUIET" == "1" ]] && return
  echo "Howdy World CLI"
  echo "Version: $HW_VERSION"
  echo "Root:    $ROOT_DIR"
  echo "Command: $COMMAND_NAME"

  # TODO: consider removing since it may just be noise.
  echo "Compose: $COMPOSE_FILE"
  echo
}
