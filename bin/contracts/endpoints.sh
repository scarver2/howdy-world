#!/usr/bin/env bash
# bin/contracts/endpoints.sh

contract_run() {
  : "${ROOT_DIR:?ROOT_DIR must be set}"

  # FUTURE: detect bin scripts
  #   bin/build
  #   bin/clean
  #   bin/down
  #   bin/lint
  #   bin/outdated
  #   bin/restart
  #   bin/run
  #   bin/setup
  #   bin/start
  #   bin/stop
  #   bin/up
  #   bin/update
  #   bin/upgrade
  #   bin/version

  local required=(
    .dockerignore
    .gitignore
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
