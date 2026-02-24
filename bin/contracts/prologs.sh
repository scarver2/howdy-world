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

    # Enforce strict bin policy first
    case "$rel" in
      bin/*|*/bin/*)
        enforce_bin_policy "$rel" "$FIRST_LINE" "$SECOND_LINE"
        continue
        ;;
    esac

    # For non-bin files only, allow shebang skipping
    adjust_for_shebang

    enforce_policy "$base" "$rel" "$FIRST_LINE" "$SECOND_LINE"

  done < <(contract_file_list "$root")
}

# -----------------------------
# Helpers (pure functions)
# -----------------------------

enforce_bin_policy() {
  local rel="$1"
  local first="$2"
  local second="$3"

  # Strip CR if present
  first="${first%$'\r'}"
  second="${second%$'\r'}"

  # 1️⃣ Require shebang on first line
  if [[ ! "$first" =~ ^#! ]]; then
    contract_error "Missing shebang in bin script: $rel"
    return
  fi

  # 2️⃣ Require prolog on second line
  if [[ ! "$second" =~ ^#[[:space:]]+$rel[[:space:]]*$ ]]; then
    contract_error "Missing prolog after shebang in bin script: $rel"
  fi
}

should_skip_file() {
  local file="$1"
  local base="$2"

  case "$base" in
    .DS_Store|*.enc|*.exe|*.gif|*.jpeg|*.jpg|*.json|*.log|*.md|*.mp3|*.mp4|*.pdf|*.png|*.svg|*.tar|*.tar.gz|*.wav|*.webm|*.zip|Caddyfile)
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
    .dockerignore|.gitignore|Dockerfile*|*.conf|*.py|*.rb|*.ru|*.sh|*.yml|Gemfile|Rakefile)
      [[ "$first" == "# $rel" ]] || contract_error "Missing prolog (Hash): $rel" ;;
    *.css)
      [[ "$first" == "/* $rel"* ]] || contract_error "Missing prolog (CSS): $rel" ;;
    *.clj)
      [[ "$first" == ";; $rel" ]] || contract_error "Missing prolog (Clojure): $rel" ;;
    *.erb)
      [[ "$first" == "<%# $rel %>" ]] || contract_error "Missing prolog (ERB): $rel" ;;
    *.ex|*.exs)
      [[ "$first" == "# $rel" ]] || contract_error "Missing prolog (Elixir): $rel" ;;
    *.cs|*.go|*.java|*.js|*.jsx|*.mod|*.odin|*.rs|*.ts|*.zig)
      [[ "$first" == "// $rel" ]] || contract_error "Missing prolog (Slash): $rel" ;;
    *.html|*.htm)
      [[ "$first" == "<!-- $rel -->" ]] || contract_error "Missing prolog (HTML): $rel" ;;
    *.php)
      [[ "$first" == "<?php"* && "$second" == "// $rel" ]] || contract_error "Missing prolog (PHP): $rel" ;;
    *.xml)
      [[ "$first" == "<?xml"* ]] && first="$second"
      [[ "$first" == "<!-- $rel -->" ]] || contract_error "Missing prolog (XML): $rel" ;;
    Caddyfile)
      [[ "$first" == "# $rel" ]] || contract_error "Missing prolog (Caddy): $rel" ;;
    *)
      contract_warn "Unknown filetype: $rel" ;;
  esac
}

contract_file_list() {
  find "$1" \
    \( -path "*/.claude/*" \
         -o -path "*/.cursor/*" \
         -o -path "*/.git/*" \
         -o -path "*/.gitmodules" \
         -o -path "*/.idea/*" \
         -o -path "*/.lein-failures" \
         -o -path "*/.lein-repl-history" \
         -o -path "*/.ruby-version" \
         -o -path "*/.vscode/*" \
         -o -path "*/*.csproj" \
         -o -path "*/*.enc" \
         -o -path "*/*.eex" \
         -o -path "*/*.key" \
         -o -path "*/*.lock" \
         -o -path "*/*.log" \
         -o -path "*/*.toml" \
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
         -o -path "*/.DS_Store" \
    \) -prune \
    -o -type f -print0
}
