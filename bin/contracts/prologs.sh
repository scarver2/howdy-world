#!/usr/bin/env bash
# bin/contracts/prologs.sh

contract_run() {
  : "${ROOT_DIR:?ROOT_DIR must be set}"

  local root="$ROOT_DIR"

  while IFS= read -r -d '' file; do
    local rel="${file#$root/}"
    local base="${file##*/}"

    should_skip_file "$file" "$base" && continue

    read_first_two_lines "$file"

    adjust_for_shebang

    enforce_policy "$base" "$rel" "$FIRST_LINE" "$SECOND_LINE"

  done < <(contract_file_list "$root")
}

# -----------------------------
# Helpers (pure functions)
# -----------------------------

should_skip_file() {
  local file="$1"
  local base="$2"

  case "$base" in
    .DS_Store|*.exe|*.gif|*.jpeg|*.jpg|*.json|*.md|*.mp3|*.mp4|*.pdf|*.png|*.svg|*.tar|*.tar.gz|*.wav|*.webm|*.zip)
      return 0 ;;
  esac

  LC_ALL=C grep -Iq . "$file" || return 0
  return 1
}

read_first_two_lines() {
  FIRST_LINE=""
  SECOND_LINE=""

  {
    IFS= read -r FIRST_LINE
    IFS= read -r SECOND_LINE
  } < "$1"
}

adjust_for_shebang() {
  if [[ "$FIRST_LINE" == "#!"* ]]; then
    FIRST_LINE="$SECOND_LINE"
    IFS= read -r SECOND_LINE < <(sed -n '3p' "$file" 2>/dev/null)
  fi
}

enforce_policy() {
  local base="$1"
  local rel="$2"
  local first="$3"
  local second="$4"

  case "$base" in
    *.erb)   [[ "$first" == "<%# $rel %>" ]] || contract_error "Missing prolog (ERB): $rel" ;;
    *.html|*.htm) [[ "$first" == "<!-- $rel -->" ]] || contract_error "Missing prolog (HTML): $rel" ;;
    *.xml)
      [[ "$first" == "<?xml"* ]] && first="$second"
      [[ "$first" == "<!-- $rel -->" ]] || contract_error "Missing prolog (XML): $rel"
      ;;
    *.css)   [[ "$first" == "/* $rel"* ]] || contract_error "Missing prolog (CSS): $rel" ;;
    *.clj)   [[ "$first" == ";; $rel" ]] || contract_error "Missing prolog (Clojure): $rel" ;;
    *.go|*.js|*.mod|*.ts|*.zig) [[ "$first" == "// $rel" ]] || contract_error "Missing prolog (Slash): $rel" ;;
    *.php)
      [[ "$first" == "<?php"* && "$second" == "// $rel" ]] || contract_error "Missing prolog (PHP): $rel"
      ;;
    *)
      [[ "$first" == "# $rel" ]] || contract_error "Missing prolog (Hash): $rel"
      ;;
  esac
}

contract_file_list() {
  find "$1" \
    \( -path "*/.claude/*" \
         -o -path "*/.cursor/*" \
         -o -path "*/.git/*" \
         -o -path "*/.idea/*" \
         -o -path "*/.lein-failures" \
         -o -path "*/.lein-repl-history" \
         -o -path "*/.vscode/*" \
         -o -path "*/*.lock" \
         -o -path "*/bin/templates/*" \
         -o -path "*/_build/*" \
         -o -path "*/build/*" \
         -o -path "*/coverage/*" \
         -o -path "*/debug/*" \
         -o -path "*/Debug/*" \
         -o -path "*/deps/*" \
         -o -path "*/dist/*" \
         -o -path "*/node_modules/*" \
         -o -path "*/obj/*" \
         -o -path "*/priv/*" \
         -o -path "*/public/*" \
         -o -path "*/target/*" \
         -o -path "*/vendor/*" \
    \) -prune \
    -o -type f -print0
}
