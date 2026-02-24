#!/usr/bin/env bash
# bin/contracts/proxy.sh

contract_run() {
  local base="$ROOT_DIR/_infrastructure/proxy/nginx"

  [[ -f "$base/Dockerfile" ]] || contract_error "Missing nginx Dockerfile"
  [[ -f "$base/nginx.conf" ]] || contract_error "Missing nginx.conf"
  [[ -d "$base/conf.d" ]] || contract_error "Missing conf.d directory"
}
