#!/usr/bin/env bash
# bin/functions/contracts.sh

: "${ROOT_DIR:?ROOT_DIR must be set before sourcing contracts.sh}"

source "$ROOT_DIR/bin/functions/endpoints.sh"

# -----------------------------
# Global State
# -----------------------------

TOTAL_ERRORS=0
TOTAL_WARNINGS=0

CONTRACT_NAME=""
declare -a CONTRACT_MESSAGES=()

# -----------------------------
# Emitters
# -----------------------------

contract_abort() {
  CONTRACT_MESSAGES+=("ABORT|$1")
  ((TOTAL_ERRORS++))
  exit 1
}

contract_error() {
  CONTRACT_MESSAGES+=("ERROR|$1")
  ((TOTAL_ERRORS++))
}

contract_warn() {
  CONTRACT_MESSAGES+=("WARN|$1")
  ((TOTAL_WARNINGS++))
}

contract_info() {
  CONTRACT_MESSAGES+=("INFO|$1")
}

# -----------------------------
# Rendering
# -----------------------------

render_contract_messages() {
  (( ${#CONTRACT_MESSAGES[@]} == 0 )) && return

  echo
  echo "[$CONTRACT_NAME]"

  for msg in "${CONTRACT_MESSAGES[@]}"; do
    IFS="|" read -r level text <<< "$msg"

    case "$level" in
      ERROR)
        printf "✖ %s\n" "$text"
        if [[ "$GITHUB_ACTIONS" == "true" ]]; then
          echo "::error::$text"
        fi
        ;;
      WARN)
        printf "⚠ %s\n" "$text"
        if [[ "$GITHUB_ACTIONS" == "true" ]]; then
          echo "::warning::$text"
        fi
        ;;
      INFO)
        printf "• %s\n" "$text"
        ;;
    esac
  done
}

# -----------------------------
# Execution
# -----------------------------

run_contract() {
  local contract_file="$1"

  CONTRACT_MESSAGES=()
  CONTRACT_NAME="$(basename "$contract_file" .sh)"

  unset -f contract_run 2>/dev/null
  source "$contract_file"

  if ! declare -f contract_run >/dev/null; then
    echo "Contract $contract_file does not define contract_run"
    exit 2
  fi

  contract_run
  render_contract_messages
}

run_all_contracts() {
  for contract in "$ROOT_DIR/bin/contracts/"*.sh; do
    run_contract "$contract"
  done
}

contracts_exit_if_failed() {
  echo
  echo "Summary"
  echo "Errors:   $TOTAL_ERRORS"
  echo "Warnings: $TOTAL_WARNINGS"

  (( TOTAL_ERRORS > 0 )) && exit 1
  exit 0
}
