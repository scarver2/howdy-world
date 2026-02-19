#!/usr/bin/env bash
# bin/functions/http.sh

CURL_COMMON=(-sS -L --max-time 8 -o /dev/null -w "%{http_code}")

http_code() {
  curl "${CURL_COMMON[@]}" "$1" 2>/dev/null || true
}
