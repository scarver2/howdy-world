#!/usr/bin/env bash
# bin/contracts/root_required_files.sh

contract_run() {
  local root_dir
  root_dir="$(pwd)"

  local required=(
    .gitignore
    bin
    _infrastructure/proxy
    compose.yml
    ARCHITECTURE.md
    CITATIONS.md
    CONTRIBUTING.md
    LICENSE.md
    NOTES.md
    POLICY.md
    README.md
    TODO.md
  )

  for file in "${required[@]}"; do
    [[ -e "$file" ]] || \
      contract_error "Missing required file: $file"
  done
}
