#!/usr/bin/env bash
# bin/_lib.sh
set -euo pipefail

# --------------------------------------------------
# Root
# --------------------------------------------------

banner() {
  [[ -n "${HW_QUIET:-}" ]] && return

  echo "Howdy World CLI v: ${HW_VERSION}"
  echo "Command: ${COMMAND_NAME}"
  echo "Root:    $ROOT_DIR"
  echo "Compose: $COMPOSE_FILE"
  echo
}

git_version() {
  if command -v git >/dev/null 2>&1 && git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    local sha branch date dirty

    sha="$(git rev-parse --short HEAD 2>/dev/null || echo unknown)"
    branch="$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo unknown)"
    date="$(git show -s --format=%cs HEAD 2>/dev/null || echo unknown)"

    if [[ -n "$(git status --porcelain 2>/dev/null)" ]]; then
      dirty="yes"
    else
      dirty="no"
    fi

    echo "${branch}@${sha} (${date}) dirty:${dirty}"
  else
    echo "no-git"
  fi
}

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

BASE_URL="${BASE_URL:-http://howdy.localhost}"
COMMAND_NAME="$(basename "${BASH_SOURCE[1]}")"
COMPOSE_FILE="${COMPOSE_FILE:-compose.yml}"
HW_VERSION="$(git_version)"

cd "$ROOT_DIR"


# --------------------------------------------------
# Colors
# --------------------------------------------------

GREEN="$(printf '\033[0;32m')"
YELLOW="$(printf '\033[0;33m')"
RED="$(printf '\033[0;31m')"
RESET="$(printf '\033[0m')"

ok()   { printf "%b✔%b %s\n" "$GREEN" "$RESET" "$1"; }
warn() { printf "%b~%b %s\n" "$YELLOW" "$RESET" "$1"; }
fail() { printf "%b✖%b %s\n" "$RED" "$RESET" "$1"; }

# --------------------------------------------------
# Compose helpers
# --------------------------------------------------

compose() {
  docker compose -f "$COMPOSE_FILE" "$@"
}

services() {
  compose config --services
}

validate_service() {
  local svc="$1"
  if ! services | grep -qx "$svc"; then
    printf "%bUnknown service:%b %s\n" "$RED" "$RESET" "$svc"
    echo
    echo "Available services:"
    services | sed 's/^/  - /'
    exit 2
  fi
}

# --------------------------------------------------
# Curl helpers
# --------------------------------------------------

CURL_COMMON=(-sS -L --max-time 8 -o /dev/null -w "%{http_code}")

http_code() {
  curl "${CURL_COMMON[@]}" "$1" 2>/dev/null || true
}

# --------------------------------------------------
# Endpoint discovery
# --------------------------------------------------

BLACKLIST=(ada angie bash bin docker nginx odin-http)
REQUIRED_FILES=(Dockerfile compose.yml .dockerignore .gitignore README.md)
OPTIONAL_FILES=(Dockerfile.dev compose.dev.yml TODO.md NOTES.md)

discover_endpoints() {
  is_blacklisted() {
    local dir="$1"
    for item in "${BLACKLIST[@]}"; do
      [[ "$dir" == "$item" ]] && return 0
    done
    return 1
  }

  local eps=()
  for dir in */ ; do
    dir="${dir%/}"
    [[ "$dir" == .* ]] && continue
    [[ "$dir" == _* ]] && continue
    is_blacklisted "$dir" && continue
    eps+=("$dir")
  done

  printf "%s\n" "${eps[@]}" | sort
}

# --------------------------------------------------
# Padding
# --------------------------------------------------

pad_dots() {
  local label="$1"
  local max="$2"
  local len="${#label}"
  local dots=$(( max - len ))
  (( dots < 3 )) && dots=3
  printf "%s" "$label"
  printf '%*s' "$dots" '' | tr ' ' '.'
}

banner
