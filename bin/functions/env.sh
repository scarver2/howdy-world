#!/usr/bin/env bash
# bin/functions/env.sh

COMPOSE_FILE="${COMPOSE_FILE:-compose.yml}"
BASE_URL="${BASE_URL:-http://howdy.localhost}"

HW_DEBUG="${HW_DEBUG:-0}"
HW_STRICT="${HW_STRICT:-0}"
HW_QUIET="${HW_QUIET:-0}"

BLACKLIST=(
  _infrastructure
  ada
  angie
  bash
  bin
  docker
  nginx
  odin-http
)
