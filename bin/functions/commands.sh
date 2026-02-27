#!/usr/bin/env bash
# bin/functions/commands.sh

abort() {
  echo "❌ $1"
  exit 1
}

require_command() {
  command -v "$1" >/dev/null 2>&1 || abort "$1 is required. Run `bin/setup` to install."
}
