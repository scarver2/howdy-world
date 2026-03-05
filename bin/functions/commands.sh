#!/usr/bin/env bash
# bin/functions/commands.sh

abort() {
  echo "❌ $1"
  exit 1
}

install_command() {
  brew install "$1"
}

require_command() {
  local cmd="$1"
  command -v "$cmd" >/dev/null 2>&1 || abort "Missing required command: $cmd"
}
