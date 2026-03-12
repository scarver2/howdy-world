#!/usr/bin/env bash
# python-fastapi/bin/_lib.sh

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENDPOINT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

if [[ -f "$ENDPOINT_DIR/../bin/_lib.sh" ]]; then
  source "$ENDPOINT_DIR/../bin/_lib.sh"
fi

cd "$ENDPOINT_DIR"


set -euo pipefail

howdy_root() {
  cd "$(dirname "${BASH_SOURCE[0]}")/.." >/dev/null 2>&1
  pwd
}

howdy_os() {
  uname -s
}

howdy_require_brew_if_macos() {
  if [[ "$(howdy_os)" == "Darwin" ]]; then
    if ! command -v brew >/dev/null 2>&1; then
      echo "ERROR: Homebrew is required on macOS. Install it from https://brew.sh/ and try again." >&2
      exit 1
    fi
  fi
}

howdy_require_docker() {
  if ! command -v docker >/dev/null 2>&1; then
    echo "ERROR: docker not found. Install Docker Desktop and try again." >&2
    exit 1
  fi
  if ! docker info >/dev/null 2>&1; then
    echo "ERROR: Docker daemon not available. Is Docker Desktop running?" >&2
    exit 1
  fi
}

howdy_compose() {
  # Prefer `docker compose` (v2). Fallback to `docker-compose` if present.
  if docker compose version >/dev/null 2>&1; then
    echo "docker compose"
    return 0
  fi

  if command -v docker-compose >/dev/null 2>&1; then
    echo "docker-compose"
    return 0
  fi

  echo "ERROR: Docker Compose not available (need 'docker compose' or 'docker-compose')." >&2
  exit 1
}

howdy_compose_file() {
  echo "compose.yml"
}

howdy_echo() {
  echo "==> $*"
}
