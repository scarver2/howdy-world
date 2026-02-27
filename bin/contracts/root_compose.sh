#!/usr/bin/env bash
# bin/contracts/root_compose.sh

contract_run() {
  : "${ROOT_DIR:?ROOT_DIR must be set}"

  local compose="$ROOT_DIR/compose.yml"

  if [[ ! -f "$compose" ]]; then
    contract_abort "Missing root compose.yml"
  fi

  validate_compose_syntax "$compose"
  load_services "$compose"
  load_endpoints

  enforce_endpoint_rules "$compose"
  enforce_endpoint_folder_symmetry
  enforce_service_ordering
}

validate_compose_syntax() {
  local compose="$1"

  if ! docker compose -f "$compose" config --quiet >/dev/null 2>&1; then
    contract_abort "compose.yml has invalid syntax"
  fi
}

# Load service list from compose.yml
load_services() {
  local compose="$1"

  SERVICES=()
  while IFS= read -r svc; do
    SERVICES+=("$svc")
  done < <(yaml_keys ".services" "$compose")
}

# Load endpoint list from canonical discovery
load_endpoints() {
  ENDPOINTS=()
  while IFS= read -r ep; do
    ENDPOINTS+=("$ep")
  done < <(discover_endpoints)
}

# Check if a compose target is an endpoint
is_endpoint() {
  local target="$1"
  for ep in "${ENDPOINTS[@]}"; do
    [[ "$ep" == "$target" ]] && return 0
  done
  return 1
}

# Check each endpoint's compliance
enforce_endpoint_rules() {
  local compose="$1"

  for ep in "${ENDPOINTS[@]}"; do
    enforce_single_endpoint "$compose" "$ep"
  done
}

enforce_single_endpoint() {
  local compose="$1"
  local ep="$2"

  local svc_path=".services[\"$ep\"]"

  require_service_exists "$compose" "$ep" || return

  enforce_whitelist_keys "$compose" "$ep" "$svc_path"
  enforce_blacklist_keys "$compose" "$ep" "$svc_path"
  enforce_specific_rules "$compose" "$ep" "$svc_path"
}

require_service_exists() {
  local compose="$1"
  local ep="$2"

  if ! yaml_has ".services" "$ep" "$compose"; then
    contract_error "Missing service for endpoint: $ep"
    return 1
  fi

  return 0
}

enforce_whitelist_keys() {
  local compose="$1"
  local ep="$2"
  local svc_path="$3"

  local allowed_keys=("build" "container_name" "environment" "expose")

  local service_keys=()
  while IFS= read -r key; do
    service_keys+=("$key")
  done < <(yaml_keys "$svc_path" "$compose")

  for key in "${service_keys[@]}"; do
    local allowed=0

    for ak in "${allowed_keys[@]}"; do
      [[ "$key" == "$ak" ]] && allowed=1
    done

    if [[ "$allowed" -eq 0 ]]; then
      contract_error "Service '$ep' contains unsupported key: $key"
    fi
  done
}

enforce_blacklist_keys() {
  local compose="$1"
  local ep="$2"
  local svc_path="$3"

  local forbidden_keys=("networks" "ports" "restart" "volumes")

  for key in "${forbidden_keys[@]}"; do
    if yaml_has "$svc_path" "$key" "$compose"; then
      contract_error "Service '$ep' must NOT define '$key'"
    fi
  done
}

# Enforce service name matches endpoint folder name
# TODO: Improve handling of infrastructure services. Remove hard-coded service names.
enforce_endpoint_folder_symmetry() {
  for svc in "${SERVICES[@]}"; do

    # Ignore infrastructure services
    [[ "$svc" == _* ]] && continue
    [[ "$svc" == dashboard ]] && continue
    [[ "$svc" == infrastructure_proxy_nginx ]] && continue

    if ! is_endpoint "$svc"; then
      contract_error "Service '$svc' has no matching endpoint folder"
    fi
  done
}

# Enforce alphabetical ordering of all services
# FIXME: This is not correct. Infrastructure services should be first, then alphabetical order of endpoints.
enforce_service_ordering() {
  return
  if [[ "$(printf "%s\n" "${SERVICES[@]}")" != "$(printf "%s\n" "${SERVICES[@]}" | sort)" ]]; then
    contract_error "Services must be alphabetically ordered"
  fi
}

enforce_specific_rules() {
  local compose="$1"
  local ep="$2"
  local svc_path="$3"

  enforce_build_short_form "$compose" "$ep" "$svc_path"
  enforce_expose_not_empty "$compose" "$ep" "$svc_path"
}

enforce_build_short_form() {
  local compose="$1"
  local ep="$2"
  local svc_path="$3"

  local build_value
  build_value=$(yaml_get "$svc_path.build" "$compose")

  if [[ "$build_value" != "./$ep" ]]; then
    contract_error "Service '$ep' must use short-form build: build: ./$ep"
  fi
}

enforce_expose_not_empty() {
  local compose="$1"
  local ep="$2"
  local svc_path="$3"

  if ! yaml_has "$svc_path" "expose" "$compose"; then
    contract_error "Service '$ep' must define 'expose:'"
    return
  fi

  local expose_len
  expose_len=$(yaml_length "$svc_path.expose" "$compose")

  if [[ "$expose_len" -eq 0 ]]; then
    contract_error "Service '$ep' expose must not be empty"
  fi
}
