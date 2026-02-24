#!/usr/bin/env bash
# bin/functions/compose.sh

compose() {
  docker compose -f "$COMPOSE_FILE" "$@"
}

services() {
  compose config --services
}

validate_service() {
  local svc="$1"
  if ! services | grep -qx "$svc"; then
    fail "Unknown service: $svc"
    exit 2
  fi
}
