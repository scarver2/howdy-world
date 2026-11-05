#!/usr/bin/env bash
# _infrastructure/proxy/nginx/test/proxy-contract-cases.sh
#
# Negative controls for the proxy_connect_timeout check in
# bin/contracts/proxy.sh (#58). Each case writes a small nginx.conf (and
# optionally a conf.d route) and asserts the check accepts or rejects it.
# No Docker needed; run by bin/ci.

set -uo pipefail

ROOT="$(cd "$(dirname "$0")/../../../.." && pwd)"
# shellcheck source=bin/contracts/proxy.sh
source "$ROOT/bin/contracts/proxy.sh"

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
fails=0

# check <accept|reject> <name> <http block body> [conf.d route body]
check() {
  local want="$1" name="$2" body="$3" route="${4:-}" got problems
  mkdir -p "$TMP/conf.d"; rm -f "$TMP/conf.d/"*.conf
  printf 'events {}\nhttp {\n  resolver 127.0.0.11 valid=10s;\n%b\n  server {\n    listen 80;\n    include /etc/nginx/conf.d/*.conf;\n  }\n}\n' "$body" > "$TMP/nginx.conf"
  [[ -n "$route" ]] && printf 'location ^~ /x/ {\n%b\n}\n' "$route" > "$TMP/conf.d/x.conf"
  problems="$(proxy_connect_timeout_problems "$TMP/nginx.conf" "$TMP/conf.d")"
  [[ -z "$problems" ]] && got=accept || got=reject
  if [[ "$got" == "$want" ]]; then
    printf 'PASS  %-6s %s\n' "$want" "$name"
  else
    printf 'FAIL  expected %s, got %s: %s\n' "$want" "$got" "$name"
    [[ -n "$problems" ]] && sed 's/^/        /' <<<"$problems"
    fails=$((fails + 1))
  fi
}

# Accepted
check accept "2s"                                   "  proxy_connect_timeout 2s;"
check accept "5s"                                   "  proxy_connect_timeout 5s;"
check accept "2s with trailing comment"             "  proxy_connect_timeout 2s;  # bounded (#58)"
check accept "tabs and extra spaces"                "\tproxy_connect_timeout\t  3s ;"
check accept "commented-out duplicate is ignored"   "  proxy_connect_timeout 2s;\n  # proxy_connect_timeout 60s;"

# Rejected: missing
check reject "missing"                              "  keepalive_timeout 65;"
check reject "only commented out"                   "  # proxy_connect_timeout 2s;"
# Rejected: units and range
check reject "bare number (implicit unit)"          "  proxy_connect_timeout 2;"
check reject "milliseconds"                         "  proxy_connect_timeout 2ms;"
check reject "2000ms"                               "  proxy_connect_timeout 2000ms;"
check reject "minutes"                              "  proxy_connect_timeout 1m;"
check reject "below range (1s)"                     "  proxy_connect_timeout 1s;"
check reject "above range (6s)"                     "  proxy_connect_timeout 6s;"
check reject "nginx default (60s)"                  "  proxy_connect_timeout 60s;"
check reject "leading zero (02s)"                   "  proxy_connect_timeout 02s;"
# Rejected: malformed
check reject "two values"                           "  proxy_connect_timeout 2s 3s;"
check reject "unknown unit"                         "  proxy_connect_timeout 2x;"
check reject "no semicolon (last statement)"        "  proxy_connect_timeout 2s"
# Rejected: duplicates and overrides
check reject "duplicate on the same line"           "  proxy_connect_timeout 2s; proxy_connect_timeout 60s;"
check reject "later duplicate in the same block"    "  proxy_connect_timeout 2s;\n  keepalive_timeout 65;\n  proxy_connect_timeout 60s;"
check reject "override in a server block"           "  proxy_connect_timeout 2s;\n  server { listen 81; proxy_connect_timeout 60s; }"
check reject "only in a server block"               "  server { listen 81; proxy_connect_timeout 2s; }"
check reject "per-route override in conf.d"         "  proxy_connect_timeout 2s;" "  proxy_connect_timeout 60s;"
check reject "per-route value in conf.d only"       "  keepalive_timeout 65;"     "  proxy_connect_timeout 2s;"

# The repository's real configuration must pass.
p="$(proxy_connect_timeout_problems "$ROOT/_infrastructure/proxy/nginx/nginx.conf" "$ROOT/_infrastructure/proxy/nginx/conf.d")"
if [[ -z "$p" ]]; then echo "PASS  accept repository nginx.conf"; else echo "FAIL  repository nginx.conf: $p"; fails=$((fails + 1)); fi

if (( fails == 0 )); then echo "OK"; else echo "$fails case(s) failed"; fi
exit $(( fails > 0 ))
