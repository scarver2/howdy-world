#!/usr/bin/env bash
# bin/contracts/file_headers.sh

# ----------------------------
# Configuration
# ----------------------------
# FIXME: Add detection for these files
# "*.css"
# "*.php"
# "*.xml"

HEADER_POSITIVE_PATTERNS=(
  ".dockerignore"
  ".gitignore"
  "*.clj"
  "*.conf"
  "*.exs"
  "*.go"
  "*.js"
  "*.py"
  "*.rb"
  "*.sh"
  "*.toml"
  "*.ts"
  "*.yaml"
  "*.yml"
  "Dockerfile*"
  "Gemfile"
)

HEADER_NEGATIVE_PATTERNS=(
  "*.css"
  "*.exe"
  "*.gif"
  "*.html"
  "*.jpeg"
  "*.jpg"
  "*.json"
  "*.md"
  "*.mp3"
  "*.mp4"
  "*.pdf"
  "*.php"
  "*.png"
  "*.svg"
  "*.tar.gz"
  "*.tar"
  "*.wav"
  "*.webm"
  "*.zip"
)

HEADER_NEGATIVE_DIRS=(
  ".git"
  ".idea"
  ".vscode"
  "bin/templates"
  "build"
  "coverage"
  "debug"
  "Debug"
  "deps"
  "dist"
  "Properties"
  "node_modules"
  "obj"
  "priv"
  "public"
  "target"
  "vendor"
)

DOUBLE_SEMICOLON_PATTERNS=("*.clj")
DOUBLE_SLASH_PATTERNS=("*.go" "*.js" "*.ts")

# ----------------------------------
# Enforcement of filepath in headers
# ----------------------------------

require_file_headers() {
  : "${ROOT_DIR:?ROOT_DIR must be set}"

  local root="$ROOT_DIR"
  local failures=0

  file_exists() {
    local f="$1"
    [[ -f "$f" ]]
  }

  matches_positive() {
    local base="$1"
    local pattern
    for pattern in "${HEADER_POSITIVE_PATTERNS[@]}"; do
      [[ "$base" == $pattern ]] && return 0
    done
    return 1
  }

  matches_negative_pattern() {
    local base="$1"
    local pattern
    for pattern in "${HEADER_NEGATIVE_PATTERNS[@]}"; do
      [[ "$base" == $pattern ]] && return 0
    done
    return 1
  }

  matches_negative_dir() {
    local path="$1"
    local dir
    for dir in "${HEADER_NEGATIVE_DIRS[@]}"; do
      [[ "$path" == *"/$dir/"* ]] && return 0
    done
    return 1
  }

  matches_binary() {
    local f="$1"

    # -I : treat binary files as non-matching
    # -q : quiet
    # .  : match any character
    grep -Iq . "$f"
    [[ $? -ne 0 ]]
  }

  matches_double_semicolon() {
    local file="$1"
    for pattern in "${DOUBLE_SEMICOLON_PATTERNS[@]}"; do
      [[ "$file" == $pattern ]] && return 0
    done
    return 1
  }

  matches_double_slash() {
    local file="$1"
    for pattern in "${DOUBLE_SLASH_PATTERNS[@]}"; do
      [[ "$file" == $pattern ]] && return 0
    done
    return 1
  }

  while IFS= read -r -d '' file; do
    local rel="${file#$root/}"
    local base
    base="$(basename "$file")"

    file_exists "$file" || continue
    matches_negative_dir "$file" && continue
    matches_positive "$base" || continue
    matches_negative_pattern "$base" && continue
    # Enable? matches_binary "$file" && continue

    local first_line
    first_line="$(sed -n '1p' "$file")"

    # Allow shebang
    if [[ "$first_line" == "#!"* ]]; then
      first_line="$(sed -n '2p' "$file")"
    fi

    # Special case: PHP (only if you later move it into positive)
    if [[ "$base" == *.php ]]; then
      local line1 line2
      line1="$(sed -n '1p' "$file")"
      line2="$(sed -n '2p' "$file")"
      if [[ "$line1" != "<?php"* ]] || [[ "$line2" != "// $rel" ]]; then
        echo "Missing filepath header (PHP): $rel"
        failures=$((failures + 1))
      fi
      continue
    fi

    # Special case: Clojure
    if matches_double_semicolon "$base"; then
      if [[ "$first_line" != ";; $rel" ]]; then
        echo "Missing filepath header: $rel"
        failures=$((failures + 1))
      fi
      continue
    fi

    # Slasher files
    if matches_double_slash "$base"; then
      if [[ "$first_line" != "// $rel" ]]; then
        echo "Missing filepath header: $rel"
        failures=$((failures + 1))
      fi
      continue
    fi

  if [[ "$base" == *.css ]]; then
    if [[ "$first_line" != "/* $rel"* ]]; then
      echo "Missing filepath header (CSS): $rel"
      failures=$((failures + 1))
    fi
  fi

    # Default enforcement for everything else
    if [[ "$first_line" != "# $rel" ]]; then
      echo "Missing filepath header: $rel"
      failures=$((failures + 1))
    fi

  done < <(find "$root" -type f -print0)

  if (( failures > 0 )); then
    fail "$failures file(s) missing filepath header."
  fi
}
