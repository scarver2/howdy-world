#!/usr/bin/env bash
# bin/contracts/proxy.sh

# #58: a stopped upstream must fail fast instead of stalling on nginx's 60s
# connect default. The proxy must set proxy_connect_timeout exactly once,
# directly in the http block of nginx.conf, as a canonical 2s-5s value.
# Negative controls: _infrastructure/proxy/nginx/test/proxy-contract-cases.sh
# Behavioural regression: _infrastructure/proxy/nginx/test/upstream-stall.sh

# List every proxy_connect_timeout statement in one nginx config file as
# "<block context><TAB><arguments><TAB><terminated 1|0>", one per line.
# Comments are stripped, statements are split on ";" "{" "}" (several per line
# are handled), and the context is the enclosing block names, e.g. "http".
proxy_connect_timeout_statements() {
  awk '
    { sub(/#.*/, ""); buf = buf $0 " " }
    function trim(s) { gsub(/^[ \t]+|[ \t]+$/, "", s); return s }
    function ctx(   s, k) { s = ""; for (k = 1; k <= depth; k++) s = s (k > 1 ? "/" : "") stack[k]; return s }
    function emit(stmt, terminated,   w, n, args, k) {
      n = split(trim(stmt), w, /[ \t]+/)
      if (w[1] != "proxy_connect_timeout") return
      args = ""; for (k = 2; k <= n; k++) args = args (k > 2 ? " " : "") w[k]
      printf "%s\t%s\t%d\n", ctx(), args, terminated
    }
    END {
      n = length(buf); stmt = ""; depth = 0
      for (i = 1; i <= n; i++) {
        c = substr(buf, i, 1)
        if (c == "{") { split(trim(stmt), w, /[ \t]+/); stack[++depth] = w[1]; stmt = "" }
        else if (c == "}") { emit(stmt, 0); if (depth > 0) depth--; stmt = "" }
        else if (c == ";") { emit(stmt, 1); stmt = "" }
        else stmt = stmt c
      }
      emit(stmt, 0)
    }
  ' "$1"
}

# Print one problem per line for the given nginx.conf and conf.d directory.
# Prints nothing when the timeout is set correctly.
proxy_connect_timeout_problems() {
  local conf="$1" confd="$2" f count=0 context args terminated

  if [[ -d "$confd" ]]; then
    for f in "$confd"/*.conf; do
      [[ -f "$f" ]] || continue
      [[ -n "$(proxy_connect_timeout_statements "$f")" ]] &&
        echo "$(basename "$f"): set proxy_connect_timeout once in nginx.conf, not per route in conf.d"
    done
  fi

  [[ -f "$conf" ]] || return 0
  while IFS=$'\t' read -r context args terminated; do
    count=$((count + 1))
    if [[ "$terminated" != 1 ]]; then
      echo "nginx.conf: proxy_connect_timeout statement is not terminated with ';'"
    elif [[ "$context" != "http" ]]; then
      echo "nginx.conf: proxy_connect_timeout must be directly in the http block (found in '${context:-main}')"
    elif ! [[ "$args" =~ ^[2-5]s$ ]]; then
      echo "nginx.conf: proxy_connect_timeout '$args' must be one value from 2s to 5s, written with an explicit 's'"
    fi
  done < <(proxy_connect_timeout_statements "$conf")

  if (( count == 0 )); then
    echo "nginx.conf: must set proxy_connect_timeout (2s-5s) so a stopped upstream fails fast"
  elif (( count > 1 )); then
    echo "nginx.conf: proxy_connect_timeout is set $count times; set it exactly once"
  fi
}

contract_run() {
  local base="$ROOT_DIR/_infrastructure/proxy/nginx" problem out

  [[ -f "$base/Dockerfile" ]] || contract_error "Missing nginx Dockerfile"
  [[ -f "$base/nginx.conf" ]] || contract_error "Missing nginx.conf"
  [[ -d "$base/conf.d" ]] || contract_error "Missing conf.d directory"

  while IFS= read -r problem; do
    [[ -n "$problem" ]] && contract_error "$problem"
  done < <(proxy_connect_timeout_problems "$base/nginx.conf" "$base/conf.d")

  # Validate the effective configuration with nginx itself when its image is
  # already present locally. Never pulls; skipped (with a note) otherwise.
  if command -v docker >/dev/null 2>&1 && docker image inspect nginx:alpine >/dev/null 2>&1; then
    if out="$(docker run --rm --network none \
        -v "$base/nginx.conf:/etc/nginx/nginx.conf:ro" \
        -v "$base/conf.d:/etc/nginx/conf.d:ro" \
        nginx:alpine nginx -t 2>&1)"; then
      contract_info "nginx -t: configuration is valid"
    else
      contract_error "nginx -t failed: $(grep -m1 'emerg' <<<"$out" | sed 's/^.*\[emerg\] [0-9#]*: //')"
    fi
  else
    contract_info "nginx -t skipped (nginx:alpine image not present locally)"
  fi
}
