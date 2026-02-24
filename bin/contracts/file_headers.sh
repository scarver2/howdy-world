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

  local failures=0
  local files_checked=0
  local root="$ROOT_DIR"

  report_missing_header() {
    local rel="$1"
    local type="$2"
    printf 'Missing filepath header (%s): %s\n' "$type" "$rel"
  }

  is_binary_file() {
    LC_ALL=C grep -Iq . "$1"
    [[ $? -ne 0 ]]
  }

  is_excluded_extension() {
    case "$1" in
      .DS_Store|*.exe|*.gif|*.jpeg|*.jpg|*.json|*.md|*.mp3|*.mp4|*.pdf|*.png|*.svg|*.tar|*.tar.gz|*.wav|*.webm|*.zip)
        return 0 ;;
    esac
    return 1
  }

  is_prolog_line() {
    case "$1" in
      "#!"*|\
      "<?php"*|\
      "<?xml"*|\
      "<!DOCTYPE"*)
        return 0 ;;
    esac
    return 1
  }

  enforce_header_policy() {
    local base="$1"
    local first_line="$2"
    local rel="$3"
    local second_line="$4"

    local comment_line="$first_line"

    # Prolog detection (shebang, XML declaration, PHP open tag, DOCTYPE)
    if is_prolog_line "$first_line"; then
      comment_line="$second_line"
    fi

    case "$base" in

      # Clojure
      *.clj)
        [[ "$comment_line" == ";; $rel" ]] && return 0
        report_missing_header "$rel" "Clojure"
        return 1
        ;;

      # CSS
      *.css)
        [[ "$comment_line" == "/* $rel */" ]] && return 0
        report_missing_header "$rel" "CSS"
        return 1
        ;;

      # ERB
      *.erb)
        [[ "$comment_line" == "<%# $rel %>" ]] && return 0
        report_missing_header "$rel" "ERB"
        return 1
        ;;

      # HTML
      *.htm|*.html)
        [[ "$comment_line" == "<!-- $rel -->" ]] && return 0
        report_missing_header "$rel" "HTML"
        return 1
        ;;

      # Slash-style languages
      *.go|*.js|*.mod|*.php|*.ts|*.zig)
        [[ "$comment_line" == "// $rel" ]] && return 0
        report_missing_header "$rel" "SlashComment"
        return 1
        ;;

      # XML
      *.xml)
        [[ "$comment_line" == "<!-- $rel -->" ]] && return 0
        report_missing_header "$rel" "XML"
        return 1
        ;;

      # Default (hash-style)
      *)
        [[ "$comment_line" == "# $rel" ]] && return 0
        report_missing_header "$rel" "HashComment"
        return 1
        ;;
    esac
  }

  while IFS= read -r -d '' file; do
    local base
    local first_line=""
    local rel
    local second_line=""

    rel="${file#$root/}"
    base="${file##*/}"

    is_excluded_extension "$base" && continue
    is_binary_file "$file" && continue

    ((files_checked++))

    {
      IFS= read -r first_line
      IFS= read -r second_line
    } < "$file"

    if ! enforce_header_policy "$base" "$first_line" "$rel" "$second_line"; then
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
         -o -path "*/node_modules/*" \
         -o -path "*/obj/*" \
         -o -path "*/priv/*" \
         -o -path "*/public/*" \
         -o -path "*/target/*" \
         -o -path "*/vendor/*" \
      \) -prune \
      -o -type f -print0
  )

  if (( failures == 0 )); then
    printf '✔ File header contract: %d file(s) checked, no violations found.\n' "$files_checked"
    return 0
  else
    printf '✖ File header contract: %d violation(s) across %d file(s).\n' "$failures" "$files_checked"
    return 1
  fi
}
