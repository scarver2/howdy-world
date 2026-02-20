#!/usr/bin/env bash
# bin/contracts/file_headers.sh

# ----------------------------
# Configuration
# ----------------------------
# FIXME: Add json and php files
# "*.json"
# "*.php"

HEADER_POSITIVE_PATTERNS=(
  "*.clj"
  "*.conf"
  "*.go"
  "*.js"
  "*.py"
  "*.rb"
  "*.sh"
  "*.ts"
  "*.yaml"
  "*.yml"
  "Dockerfile*"
)

HEADER_NEGATIVE_PATTERNS=(
  "*.html"
  "*.json"
  "*.md"
  "*.php"
)

HEADER_NEGATIVE_DIRS=(
  ".git"
  ".idea"
  ".vscode"
  "build"
  "coverage"
  "debug"
  "Debug"
  "deps"
  "dist"
  "node_modules"
  "obj"
  "priv"
  "public"
  "target"
  "vendor"
)

# ----------------------------
# Enforcement
# ----------------------------

require_file_headers() {
  local failures=0

  matches_positive() {
    local file="$1"
    for pattern in "${HEADER_POSITIVE_PATTERNS[@]}"; do
      [[ "$file" == $pattern ]] && return 0
    done
    return 1
  }

  matches_negative_pattern() {
    local file="$1"
    for pattern in "${HEADER_NEGATIVE_PATTERNS[@]}"; do
      [[ "$file" == $pattern ]] && return 0
    done
    return 1
  }

  matches_negative_dir() {
    local file="$1"
    for dir in "${HEADER_NEGATIVE_DIRS[@]}"; do
      [[ "$file" == *"/$dir/"* ]] && return 0
    done
    return 1
  }

  while IFS= read -r -d '' file; do

    # Skip directories and excluded dirs
    matches_negative_dir "$file" && continue

    # Apply positive filter
    matches_positive "$file" || continue

    # Apply negative file patterns
    matches_negative_pattern "$file" && continue

    # Skip binaries
    if file "$file" | grep -q "binary"; then
      continue
    fi

    local first_line
    first_line="$(head -n 1 "$file")"

    if [[ "$first_line" == "#!"* ]]; then
      first_line="$(sed -n '2p' "$file")"
    fi

    case "$first_line" in
      "# "* | "// "* | "-- "* | ";; "*)
        ;;
      *)
        echo "Missing filepath header: $file"
        failures=$((failures + 1))
        ;;
    esac

  done < <(find "$ROOT_DIR" -type f -print0)

  if [[ $failures -gt 0 ]]; then
    fail "$failures file(s) missing filepath header."
  fi
}