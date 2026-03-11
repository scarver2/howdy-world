#!/usr/bin/env bash
# bin/functions/compose.sh

compose() {
  docker compose -f "$COMPOSE_FILE" "$@"
}

compose_add_service_from_template() {
  local endpoint="$1"
  local port="$2"

  tmp="$(mktemp)"
  cp "$ROOT_DIR/bin/templates/compose_service.yml" "$tmp"

  sed -i.bak \
    -e "s/__ENDPOINT__/$endpoint/g" \
    -e "s/__PORT__/$port/g" \
    "$tmp"

  rm -f "$tmp.bak"

  yaml_merge_block ".services" "$tmp" compose.yml
  rm "$tmp"
}

compose_service_exists() {
  local service="$1"
  yaml_has ".services" "$service" compose.yml
}

compose_sort_services() {
  local tmp
  tmp="$(mktemp)"

  # Extract sorted services into temp
  yq e '.services |= (to_entries | sort_by(.key) | from_entries)' compose.yml > "$tmp"

  mv "$tmp" compose.yml
}

insert_service_alphabetically() {
  # Extract services section
  tmp="$(mktemp)"

  awk '
    BEGIN { in_services=0 }
    /^services:/ { print; in_services=1; next }
    in_services && /^[^ ]/ { in_services=0 }
    { print }
  ' compose.yml > "$tmp"

  # Append new service block
  echo "$SERVICE_BLOCK" >> "$tmp"

  # Sort services (excluding dashboard + infrastructure)
  enforce_service_ordering "$tmp"

  mv "$tmp" compose.yml
}

services() {
  compose config --services
}

validate_service() {
  local svc="$1"
  local svc_list
  svc_list="$(services)"
  if ! grep -qx "$svc" <<< "$svc_list"; then
    fail "Unknown service: $svc"
    exit 2
  fi
}
