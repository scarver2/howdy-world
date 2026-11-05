#!/usr/bin/env bash
# bin/contracts/proxy.sh

contract_run() {
  local base="$ROOT_DIR/_infrastructure/proxy/nginx"

  [[ -f "$base/Dockerfile" ]] || contract_error "Missing nginx Dockerfile"
  [[ -f "$base/nginx.conf" ]] || contract_error "Missing nginx.conf"
  [[ -d "$base/conf.d" ]] || contract_error "Missing conf.d directory"

  # #58: a stopped upstream must fail fast, not stall on nginx's 60s connect default.
  # Behavioural regression: _infrastructure/proxy/nginx/test/upstream-stall.sh
  if [[ -f "$base/nginx.conf" ]]; then
    local t
    t="$(sed -nE 's/^[[:space:]]*proxy_connect_timeout[[:space:]]+([0-9]+)s?;.*/\1/p' "$base/nginx.conf" | head -1)"
    if [[ -z "$t" ]]; then
      contract_error "nginx.conf must set proxy_connect_timeout (seconds, at most 5) so a stopped upstream fails fast"
    elif (( t > 5 )); then
      contract_error "nginx.conf proxy_connect_timeout is ${t}s; keep it at most 5s so a stopped upstream fails fast"
    fi
  fi
  if [[ -d "$base/conf.d" ]] && grep -lq 'proxy_connect_timeout' "$base"/conf.d/*.conf 2>/dev/null; then
    contract_error "Set proxy_connect_timeout once in nginx.conf, not per route in conf.d"
  fi
}
