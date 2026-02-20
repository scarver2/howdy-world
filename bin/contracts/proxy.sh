#!/usr/bin/env bash
# bin/contracts/proxy.sh

require_proxy_contract() {
  local base="$ROOT_DIR/_infrastructure/proxy/nginx"

  [[ -f "$base/Dockerfile" ]] || fail "Missing nginx Dockerfile"
  [[ -f "$base/nginx.conf" ]] || fail "Missing nginx.conf"
  # FIXME: determine if a replacement for the default is needed.
  # [[ -f "$base/mime.types" ]] || fail "Missing mime.types"
  [[ -d "$base/conf.d" ]] || fail "Missing conf.d directory"
}

