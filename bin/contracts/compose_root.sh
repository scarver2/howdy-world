#!/usr/bin/env bash
# bin/contracts/compose_root.sh

contract_run() {
  : "${ROOT_DIR:?ROOT_DIR must be set}"

  local compose="$ROOT_DIR/compose.yml"

  validate_required_tools_installed
  validate_docker_compose_file_exists "$compose"
  validate_docker_compose_file_structure "$compose"
  validate_services "$compose"
  validate_endpoint_services "$compose"
  validate_service_symmetry "$compose"
  validate_service_order "$compose"
}

mapfile_services() {
  SERVICES=()

  while IFS= read -r svc; do
    SERVICES+=("$svc")
  done < <(yq '.services | keys | .[]' "$1")
}

validate_docker_compose_file_exists() {
  local compose="$1"

  if [[ ! -f "$compose" ]]; then
    contract_abort "Missing root compose.yml"
  fi
}

validate_docker_compose_file_structure() {
  local compose="$1"

  if ! docker compose config --quiet; then
    contract_abort "$compose is invalid"
  fi
}

validate_endpoint_services() {
  local compose="$1"

  # get endpoint list from canonical discovery
  local endpoints=()
  while IFS= read -r ep; do
    endpoints+=("$ep")
  done < <(discover_endpoints)

  for ep in "${endpoints[@]}"; do

    # ensure service exists
    if ! yq ".services.$ep" "$compose" >/dev/null 2>&1; then
      contract_error "Missing service for endpoint: $ep"
      continue
    fi

    # enforce short build form
    build_type=$(yq ".services.$ep.build | type" "$compose")

    if [[ "$build_type" != "!!str" ]]; then
      contract_error "Service '$ep' must use short-form build: build: ./$ep"
    else
      build_value=$(yq ".services.$ep.build" "$compose")
      if [[ "$build_value" != "./$ep" ]]; then
        contract_error "Service '$ep' build must be './$ep'"
      fi
    fi

    # enforce no ports:
    if yq ".services.$ep.ports" "$compose" >/dev/null 2>&1; then
      contract_error "Service '$ep' must not define 'ports:' (use expose only)"
    fi

    # require expose
    if ! yq ".services.$ep.expose" "$compose" >/dev/null 2>&1; then
      contract_error "Service '$ep' must define 'expose:'"
    fi
  done
}

validate_required_tools_installed() {
  if ! command -v yq >/dev/null 2>&1; then
    contract_abort "yq required for compose contract"
  fi

  if ! command -v docker >/dev/null 2>&1; then
    contract_abort "docker required for compose contract"
  fi
}

validate_service() {
  local compose="$1"
  local svc="$2"

  # build must be ./svc
  expected="./$svc"
  build=$(yq ".services.$svc.build" "$compose")

  if [[ "$build" != "$expected" ]]; then
    contract_error "Service '$svc' build must be '$expected'"
  fi

  # container_name must equal service name
  cname=$(yq ".services.$svc.container_name" "$compose")

  if [[ "$cname" != "$svc" ]]; then
    contract_error "Service '$svc' container_name must equal '$svc'"
  fi

  # expose must exist
  if ! yq ".services.$svc.expose" "$compose" >/dev/null 2>&1; then
    contract_error "Service '$svc' missing expose section"
  fi
}

validate_services() {
  local compose="$1"

  # Get service names
  mapfile_services "$compose"

  for service in "${SERVICES[@]}"; do
    validate_service "$compose" "$service"
  done
}

validate_service_symmetry() {
  local compose="$1"

  # collect compose services
  local services=()
  while IFS= read -r svc; do
    services+=("$svc")
  done < <(yq '.services | keys | .[]' "$compose")

  # get endpoints
  local endpoints=()
  while IFS= read -r ep; do
    endpoints+=("$ep")
  done < <(discover_endpoints)

  for svc in "${services[@]}"; do

    # skip infrastructure
    if [[ "$svc" == _* ]]; then
      continue
    fi

    found=0
    for ep in "${endpoints[@]}"; do
      [[ "$svc" == "$ep" ]] && found=1
    done

    if [[ "$found" -eq 0 ]]; then
      contract_error "Service '$svc' has no matching endpoint directory"
    fi
  done
}

validate_service_order() {
  local compose="$1"

  local actual=()
  while IFS= read -r svc; do
    [[ "$svc" == _* ]] && continue
    actual+=("$svc")
  done < <(yq '.services | keys | .[]' "$compose")

  sorted=($(printf "%s\n" "${actual[@]}" | sort))

  for i in "${!actual[@]}"; do
    if [[ "${actual[$i]}" != "${sorted[$i]}" ]]; then
      contract_error "Services must be alphabetically ordered (endpoint services only)"
      return
    fi
  done
}
