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
