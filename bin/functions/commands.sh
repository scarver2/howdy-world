#!/usr/bin/env bash
# bin/functions/commands.sh

abort() {
  echo "❌ $1"
  exit 1
}

require_command() {
  command -v "$1" >/dev/null 2>&1 || abort "Missing required command: $1"
}

install_command() {
  local cmd="$1"
  shift
  if command -v "$cmd" >/dev/null 2>&1; then
    echo "✅ $cmd is already installed"
  else
    echo "📦 Installing $cmd..."
    "$@"
  fi
}

outdated_command() {
  local formula="$1"

  require_command brew

  local brew_info="" installed="" latest=""

  # Capture to variable first to avoid SIGPIPE from piping brew info
  brew_info="$(brew info "$formula" 2>/dev/null)" \
    || abort "Unknown Homebrew formula: $formula"

  latest="$(grep -Eo 'stable [0-9][^ ,]+' <<< "$brew_info" | head -1 | awk '{print $2}')"

  if [[ -z "$latest" ]]; then
    abort "Could not determine latest version of $formula from Homebrew"
  fi

  # Prefer brew list for Homebrew-managed installs; fall back to the command
  # itself for tools managed outside Homebrew (mise, rbenv, nvm, etc.)
  # Note: brew list exits 1 when the formula is not installed — use `if` to
  # avoid triggering set -e through the pipeline assignment.
  if brew list --formula "$formula" &>/dev/null; then
    installed="$(brew list --versions "$formula" | awk '{print $NF}')"
  fi

  if [[ -z "$installed" ]] && command -v "$formula" >/dev/null 2>&1; then
    installed="$("$formula" --version 2>/dev/null | grep -Eo '[0-9]+\.[0-9]+\.[0-9]+' | head -1)"
    if [[ -z "$installed" ]]; then
      installed="$("$formula" -v 2>/dev/null | grep -Eo '[0-9]+\.[0-9]+\.[0-9]+' | head -1)"
    fi
  fi

  if [[ -z "$installed" ]]; then
    abort "$formula is not installed — run \`bin/setup\` to install"
  fi

  echo "$formula"
  echo "Installed : $installed"
  echo "Latest    : $latest"
  echo

  if [[ "$installed" == "$latest" ]]; then
    echo "✅ $formula is up to date"
  elif [[ "$(printf '%s\n%s\n' "$installed" "$latest" | sort -V | tail -1)" == "$latest" ]]; then
    echo "⬆️  $formula $latest is available — run \`bin/update\` to upgrade"
  else
    echo "✅ $formula $installed is newer than latest stable ($latest)"
  fi
}
