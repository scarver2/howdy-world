#!/usr/bin/env bash
# bin/contracts/endpoints.sh

contract_run() {
  : "${ROOT_DIR:?ROOT_DIR must be set}"

  local required=(
    .dockerignore
    .gitignore
    # FUTURE: bin/outdated
    # FUTURE: bin/setup
    # FUTURE: bin/up, down, restart, etc.
    compose.yml
    Dockerfile
    README.md
  )

  endpoints=()
  while IFS= read -r endpoint; do
    endpoints+=("$endpoint")
  done < <(discover_endpoints)

  for endpoint in "${endpoints[@]}"; do
    validate_endpoint "$endpoint" "${required[@]}"
  done
}

validate_endpoint() {
  local endpoint="$1"
  shift
  local required=("$@")

  for file in "${required[@]}"; do
    if [[ ! -e "$ROOT_DIR/$endpoint/$file" ]]; then
      contract_error "Missing required file: $endpoint/$file"
    fi
  done
}
