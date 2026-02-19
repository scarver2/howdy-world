#!/usr/bin/env bash
# bin/functions/colors.sh

GREEN="$(printf '\033[0;32m')"
YELLOW="$(printf '\033[0;33m')"
RED="$(printf '\033[0;31m')"
RESET="$(printf '\033[0m')"

ok()   { printf "%b✔%b %s\n" "$GREEN" "$RESET" "$1"; }
warn() { printf "%b~%b %s\n" "$YELLOW" "$RESET" "$1"; }
fail() { printf "%b✖%b %s\n" "$RED" "$RESET" "$1"; }
