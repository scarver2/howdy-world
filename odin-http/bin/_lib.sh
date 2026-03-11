#!/usr/bin/env bash
# odin-http/bin/_lib.sh

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENDPOINT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

if [[ -f "$ENDPOINT_DIR/../bin/_lib.sh" ]]; then
  source "$ENDPOINT_DIR/../bin/_lib.sh"
fi

cd "$ENDPOINT_DIR"


set -euo pipefail

# --- paths ---
bin_dir() { cd "$(dirname "${BASH_SOURCE[0]}")" && pwd; }
endpoint_root() { cd "$(bin_dir)/.." && pwd; }

# --- output helpers ---
hr() { printf '%s
' "------------------------------------------------------------"; }

# FIXME: meh. need better descriptors and less duplication.
log() { printf '%s
' "$*"; }
status() { printf '%s' "$*"; }
success() { printf 'SUCCESS: %s
' "$*"; }
info() { printf 'INFO: %s
' "$*"; }
warn() { printf 'WARN: %s
' "$*" >&2; }
die() { printf 'ERROR: %s
' "$*" >&2; exit 1; }

# --- guards ---
require_command() {
  local cmd="$1"
  command -v "$cmd" >/dev/null 2>&1 || die "Missing required command: $cmd"
}

is_docker() { [ -f "/.dockerenv" ] || grep -qaE '(docker|containerd|kubepods)' /proc/1/cgroup 2>/dev/null; }

require_brew() {
  if is_docker; then return 0; fi
  # Project standard: scripts abort if Homebrew is missing or OS unsupported.
  require_command brew
}

# --- git helpers ---
is_git_repo() { git -C "$1" rev-parse --is-inside-work-tree >/dev/null 2>&1; }

is_submodule() {
  local path="$1"
  # Submodule marker: .git file with "gitdir: ..."
  [ -f "$path/.git" ] && grep -q '^gitdir:' "$path/.git" 2>/dev/null
}

submodules_init() {
  local root="$1"
  if [ -f "$root/.gitmodules" ] && command -v git >/dev/null 2>&1 && is_git_repo "$root"; then
    info "Initializing git submodules"
    git -C "$root" submodule update --init --recursive
  fi
}

# --- version/info helpers ---
print_tool_versions() {
  if command -v odin >/dev/null 2>&1; then
    log "$(odin version || true)"
  else
    warn "odin: not found in PATH"
  fi

  if command -v llvm-config >/dev/null 2>&1; then
    log "llvm-config: $(llvm-config --version)"
  elif command -v llvm-config-21 >/dev/null 2>&1; then
    log "llvm-config-21: $(llvm-config-21 --version)"
  elif command -v llvm-config-20 >/dev/null 2>&1; then
    log "llvm-config-20: $(llvm-config-20 --version)"
  else
    warn "llvm-config: not found"
  fi
}

odin_with_deps() {
  odin "$@" -collection:deps=./deps
}
