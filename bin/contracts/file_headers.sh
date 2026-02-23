#!/usr/bin/env bash
# bin/contracts/file_headers.sh

# Maintenance instructions
# 1. To include: Update the matches_positive function to include new file extensions
# 2. To exclude: Update the matches_negative_pattern function to include new file extensions
# 3. To use double semicolon comment style: Update the matches_double_semicolon function to include new file extensions
# 4. To use double slash comment style: Update the matches_double_slash function to include new file extensions
# 5. To use XML comment style: Update the matches_xml_comment_style function to include new file extensions

# ----------------------------------
# Enforcement of filepath in headers
# ----------------------------------

require_file_headers() {
  : "${ROOT_DIR:?ROOT_DIR must be set}"

  local root="$ROOT_DIR"
  local failures=0

  # ----------------------------
  # Fast matchers using case
  # ----------------------------

  matches_positive() {
    case "$1" in
      .dockerignore|.gitignore|*.clj|*.conf|*.css|*.exs|*.go|*.js|*.php|*.py|*.rb|*.sh|*.toml|*.ts|*.xml|*.yaml|*.yml|Dockerfile*|Gemfile)
        return 0
        ;;
    esac
    return 1
  }

  matches_negative_pattern() {
    case "$1" in
      *.exe|*.gif|*.html|*.jpeg|*.jpg|*.json|*.md|*.mp3|*.mp4|*.pdf|*.png|*.svg|*.tar.gz|*.tar|*.wav|*.webm|*.zip)
        return 0
        ;;
    esac
    return 1
  }

  matches_double_semicolon() {
    case "$1" in
      *.clj) return 0 ;;
    esac
    return 1
  }

  matches_double_slash() {
    case "$1" in
      *.go|*.js|*.ts) return 0 ;;
    esac
    return 1
  }

  matches_xml_comment_style() {
    case "$1" in
      *.xml) return 0 ;;
    esac
    return 1
  }

  # ----------------------------
  # Pruned find (huge speed win)
  # ----------------------------

  while IFS= read -r -d '' file; do
    rel="${file#$root/}"
    base="${file##*/}"

    matches_positive "$base" || continue
    matches_negative_pattern "$base" && continue

    # ----------------------------
    # Read first line (no sed)
    # ----------------------------

    IFS= read -r first_line < "$file" || true

    # Allow shebang
    if [[ "$first_line" == "#!"* ]]; then
      {
        IFS= read -r _
        IFS= read -r first_line
      } < "$file"
    fi

    # ----------------------------
    # PHP special case
    # ----------------------------

    if [[ "$base" == *.php ]]; then
      {
        IFS= read -r line1
        IFS= read -r line2
      } < "$file"

      if [[ "$line1" != "<?php"* ]] || [[ "$line2" != "// $rel" ]]; then
        echo "Missing filepath header (PHP): $rel"
        ((failures++))
      fi
      continue
    fi

    # ----------------------------
    # Clojure
    # ----------------------------

    if matches_double_semicolon "$base"; then
      if [[ "$first_line" != ";; $rel" ]]; then
        echo "Missing filepath header: $rel"
        ((failures++))
      fi
      continue
    fi

    # ----------------------------
    # Slasher files
    # ----------------------------

    if matches_double_slash "$base"; then
      if [[ "$first_line" != "// $rel" ]]; then
        echo "Missing filepath header: $rel"
        ((failures++))
      fi
      continue
    fi

    # ----------------------------
    # CSS special case
    # ----------------------------

    if [[ "$base" == *.css ]]; then
      if [[ "$first_line" != "/* $rel"* ]]; then
        echo "Missing filepath header (CSS): $rel"
        ((failures++))
      fi
      continue
    fi

    # ----------------------------
    # XML use case
    # ----------------------------

    if matches_xml_comment_style "$base"; then
      {
        IFS= read -r _
        IFS= read -r xml_comment
      } < "$file"

      if [[ "$xml_comment" != "<!-- $rel -->" ]]; then
        echo "Missing filepath header (XML): $rel"
        ((failures++))
      fi
      continue
    fi

    # ----------------------------
    # Default enforcement
    # ----------------------------

    if [[ "$first_line" != "# $rel" ]]; then
      echo "Missing filepath header: $rel"
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

  if (( failures > 0 )); then
    fail "$failures file(s) missing filepath header."
  fi
}
