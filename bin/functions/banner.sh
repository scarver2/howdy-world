#!/usr/bin/env bash
# bin/functions/banner.sh

COMMAND_NAME="$(basename "${BASH_SOURCE[2]}")"

banner() {
  [[ "$HW_QUIET" == "1" ]] && return
  echo "Howdy World CLI"
  echo "Version: $HW_VERSION"
  echo "Command: $COMMAND_NAME"
  echo "Root:    $ROOT_DIR"

  # TODO: consider removing since it may just be noise.
  echo "Compose: $COMPOSE_FILE"
  echo
}
