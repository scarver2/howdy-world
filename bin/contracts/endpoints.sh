# bin/contracts/endpoints.sh

require_endpoint_contract() {
  local endpoint_dir
  endpoint_dir="$(pwd)"

  local required=(
    Dockerfile
    compose.yml
    .dockerignore
    .gitignore
    README.md
    bin/setup
    bin/outdated
  )

  local missing=0

  for file in "${required[@]}"; do
    if [[ ! -e "$endpoint_dir/$file" ]]; then
      echo "Endpoint contract violation: missing $file"
      missing=1
    fi
  done

  if (( missing == 1 )); then
    echo
    echo "This directory does not satisfy the Howdy World endpoint contract."
    exit 1
  fi
}
