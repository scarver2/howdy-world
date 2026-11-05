#!/usr/bin/env bash
# _infrastructure/proxy/nginx/test/upstream-stall.sh
#
# Regression for #58: once nginx has resolved an upstream, stopping that
# upstream must make the next request fail fast (bounded 502/504) instead of
# stalling; other upstreams must keep working; and the stopped upstream must
# route again soon after it restarts (normally on a new address).
#
# Builds the proxy image and runs it with two throwaway upstreams ("php" is
# stopped, "go" stays healthy) on a private Docker network. Nothing is
# published to the host. Needs Docker and bash 5.
#
# Usage: _infrastructure/proxy/nginx/test/upstream-stall.sh
# Env:   STALL_LIMIT (seconds, default 5), RECOVER_LIMIT (seconds, default 5)

set -uo pipefail

(( BASH_VERSINFO[0] >= 5 )) || { echo "needs bash 5 (EPOCHREALTIME)"; exit 2; }

HERE="$(cd "$(dirname "$0")/.." && pwd)"
STALL_LIMIT="${STALL_LIMIT:-5}"
RECOVER_LIMIT="${RECOVER_LIMIT:-5}"
ID="hw-stall-$$"
NET="$ID-net"
IMG="$ID-proxy"
PROXY="$ID-proxy"
UPSTREAM_IMAGE="busybox:1.37"

cleanup() {
  docker stop -t 1 "$PROXY" "$ID-php" "$ID-go" >/dev/null 2>&1
  docker network rm "$NET" >/dev/null 2>&1
  docker image rm "$IMG" >/dev/null 2>&1
}
trap cleanup EXIT

fails=0
pass() { printf 'PASS  %s\n' "$1"; }
fail() { printf 'FAIL  %s\n' "$1"; fails=$((fails + 1)); }
now() { echo "$EPOCHREALTIME"; }
since() { awk -v a="$1" -v b="$(now)" 'BEGIN{printf "%.2f", b - a}'; }
le() { awk -v a="$1" -v b="$2" 'BEGIN{exit !(a <= b)}'; }

# Request a path through the proxy from inside the proxy container.
# Prints "<http code> <seconds>"; 000 means no response within the limit.
probe() {
  local path="$1" limit="$2" t0 code
  t0=$(now)
  code=$(docker exec "$PROXY" wget -q -S -O /dev/null -T "$limit" "http://127.0.0.1$path" 2>&1 \
    | awk '/^  HTTP\//{c=$2} END{printf "%03d", c+0}')
  echo "$code $(since "$t0")"
}

# start_upstream <alias> <docroot path>
start_upstream() {
  docker run -d --rm --name "$ID-$1" --network "$NET" --network-alias "$1" "$UPSTREAM_IMAGE" \
    sh -c "mkdir -p /www$2 && echo Howdy > /www$2/index.html && exec httpd -f -p 8080 -h /www" >/dev/null
}

docker build -q -t "$IMG" "$HERE" >/dev/null || { echo "FAIL  proxy image build"; exit 1; }
docker network create "$NET" >/dev/null || exit 1
start_upstream php /php || exit 1   # php.conf keeps the /php/ prefix
start_upstream go / || exit 1       # go.conf strips the /go/ prefix
docker run -d --rm --name "$PROXY" --network "$NET" "$IMG" >/dev/null || exit 1

# Wait until both routes work. This also makes nginx cache the php address.
for _ in $(seq 1 40); do
  read -r cp _ <<<"$(probe /php/ 2)"; read -r cg _ <<<"$(probe /go/ 2)"
  [[ "$cp" == 200 && "$cg" == 200 ]] && break; sleep 0.25
done
if [[ "$cp" == 200 && "$cg" == 200 ]]; then pass "both upstreams route (200)"
else fail "upstreams did not come up (php $cp, go $cg)"; exit 1; fi

probe /php/ 2 >/dev/null              # refresh the cached address right before the stop
docker stop -t 1 "$ID-php" >/dev/null

# First request after the upstream disappears: bounded failure, not a stall.
read -r c t <<<"$(probe /php/ 30)"
if [[ "$c" == 502 || "$c" == 504 ]] && le "$t" "$STALL_LIMIT"; then
  pass "first request after upstream stop fails fast ($c in ${t}s, limit ${STALL_LIMIT}s)"
else
  fail "first request after upstream stop: got $c in ${t}s (limit ${STALL_LIMIT}s)"
fi

# The healthy upstream is unaffected.
read -r c t <<<"$(probe /go/ 5)"
[[ "$c" == 200 ]] && pass "healthy route unaffected (/go/ 200 in ${t}s)" || fail "healthy route affected (/go/ got $c)"

# Recovery after restart.
start_upstream php /php || exit 1
t0=$(now); c=000
while le "$(since "$t0")" "$(( RECOVER_LIMIT + 2 ))"; do
  read -r c _ <<<"$(probe /php/ 2)"; [[ "$c" == 200 ]] && break; sleep 0.25
done
t=$(since "$t0")
if [[ "$c" == 200 ]] && le "$t" "$RECOVER_LIMIT"; then
  pass "upstream routes again after restart (${t}s, limit ${RECOVER_LIMIT}s)"
else
  fail "upstream did not recover within ${RECOVER_LIMIT}s (last $c after ${t}s)"
fi

if (( fails == 0 )); then echo "OK"; else echo "$fails check(s) failed"; fi
exit $(( fails > 0 ))
