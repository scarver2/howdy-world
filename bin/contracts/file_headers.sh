#!/usr/bin/env bash
# bin/contracts/file_headers.sh

# Enforces filepath header contracts across the repository.
#
# Design goals:
# - Single file read per file
# - No subshell forks inside main loop
# - Deterministic policy dispatch via case
# - Compiler-accurate comment styles
# - Self-describing function names

# Maintenance instructions
# 1. To include: Update the matches_positive function to include new file extensions
# 2. To exclude: Update the matches_negative_pattern function to include new file extensions
# 3. To use double semicolon comment style: Update the matches_double_semicolon function to include new file extensions
# 4. To use double slash comment style: Update the matches_double_slash function to include new file extensions
# 5. To use XML comment style: Update the matches_xml_comment_style function to include new file extensions

require_file_headers() {
  : "${ROOT_DIR:?ROOT_DIR must be set}"

  local root="$ROOT_DIR"
  local failures=0

  # ----------------------------------------
  # Reporting
  # ----------------------------------------

  report_missing_header() {
    local rel="$1"
    local type="$2"
    printf 'Missing filepath header (%s): %s\n' "$type" "$rel"
  }

  is_binary_file() {
    LC_ALL=C grep -Iq . "$1"
    [[ $? -ne 0 ]]
  }

  # ----------------------------------------
  # Exclusion Rules (non-policy files)
  # ----------------------------------------

  is_excluded_extension() {
    case "$1" in
      .DS_Store|*.exe|*.gif|*.jpeg|*.jpg|*.json|*.md|*.mp3|*.mp4|*.pdf|*.png|*.svg|*.tar.gz|*.tar|*.wav|*.webm|*.zip)
        return 0 ;;
    esac
    return 1
  }

  # ----------------------------------------
  # Comment Style Enforcement
  # ----------------------------------------

  enforce_header_policy() {
    local base="$1"
    local rel="$2"
    local first_line="$3"
    local second_line="$4"

    case "$base" in

      # ----------------------------------
      # ERB (non-rendering Ruby comment)
      # ----------------------------------
      *.erb)
        if [[ "$first_line" != "<%# $rel %>" ]]; then
          report_missing_header "$rel" "ERB"
          return 1
        fi
        return 0
        ;;

      # ----------------------------------
      # HTML (first-line markup comment)
      # ----------------------------------
      *.html|*.htm)
        if [[ "$first_line" != "<!-- $rel -->" ]]; then
          report_missing_header "$rel" "HTML"
          return 1
        fi
        return 0
        ;;

      # ----------------------------------
      # XML (second line if declaration present)
      # ----------------------------------
      *.xml)
        local target="$first_line"

        if [[ "$first_line" == "<?xml"* ]]; then
          target="$second_line"
        fi

        if [[ "$target" != "<!-- $rel -->" ]]; then
          report_missing_header "$rel" "XML"
          return 1
        fi
        return 0
        ;;

      # ----------------------------------
      # CSS
      # ----------------------------------
      *.css)
        if [[ "$first_line" != "/* $rel"* ]]; then
          report_missing_header "$rel" "CSS"
          return 1
        fi
        return 0
        ;;

      # ----------------------------------
      # Clojure
      # ----------------------------------
      *.clj)
        if [[ "$first_line" != ";; $rel" ]]; then
          report_missing_header "$rel" "Clojure"
          return 1
        fi
        return 0
        ;;

      # ----------------------------------
      # Slash-style languages
      # ----------------------------------
      *.go|*.js|*.mod|*.ts|*.zig)
        if [[ "$first_line" != "// $rel" ]]; then
          report_missing_header "$rel" "SlashComment"
          return 1
        fi
        return 0
        ;;

      # ----------------------------------
      # PHP (second-line slash comment)
      # ----------------------------------
      *.php)
        if [[ "$first_line" != "<?php"* ]] || [[ "$second_line" != "// $rel" ]]; then
          report_missing_header "$rel" "PHP"
          return 1
        fi
        return 0
        ;;

      # ----------------------------------
      # Default: Hash-style languages
      # ----------------------------------
      *)
        if [[ "$first_line" != "# $rel" ]]; then
          report_missing_header "$rel" "HashComment"
          return 1
        fi
        return 0
        ;;
    esac
  }

  # ----------------------------------------
  # Main Scan Loop
  # ----------------------------------------

  while IFS= read -r -d '' file; do
    rel="${file#$root/}"
    base="${file##*/}"

    # Skip excluded binary/non-policy extensions
    is_excluded_extension "$base" && continue

    # TODO: unnecessary if build artifacts are in dist folder
    is_binary_file "$file" && continue

    # Single file read
    local first_line=""
    local second_line=""

    {
      IFS= read -r first_line
      IFS= read -r second_line
    } < "$file"

    # Allow shebang skip
    if [[ "$first_line" == "#!"* ]]; then
      first_line="$second_line"
      IFS= read -r second_line < <(sed -n '3p' "$file" 2>/dev/null)
    fi

    # Enforce policy
    if ! enforce_header_policy "$base" "$rel" "$first_line" "$second_line"; then
      ((failures++))
    fi

  done < <(
    find "$root" \
      \( -path "*/.git/*" \
         -o -path "*/.idea/*" \
         -o -path "*/.vscode/*" \
         -o -path "*/bin/templates/*" \
         -o -path "*/build/*" \
         -o -path "*/coverage/*" \
         -o -path "*/debug/*" \
         -o -path "*/Debug/*" \
         -o -path "*/deps/*" \
         -o -path "*/dist/*" \
         -o -path "*/Properties/*" \
         -o -path "*/node_modules/*" \
         -o -path "*/obj/*" \
         -o -path "*/priv/*" \
         -o -path "*/public/*" \
         -o -path "*/target/*" \
         -o -path "*/vendor/*" \
      \) -prune \
      -o -type f -print0
  )
}
