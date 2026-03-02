#!/usr/bin/env bash
# bin/functions/endpoints.sh

discover_endpoints() {
  for dir in */ ; do
    dir="${dir%/}"
    [[ "$dir" == .* ]] && continue
    [[ "$dir" == _* ]] && continue
    [[ "$dir" == bin ]] && continue

    if [[ -f "$dir/.disabled" ]]; then
      continue
    fi

    skip=0
    for item in "${BLACKLIST[@]}"; do
      [[ "$dir" == "$item" ]] && skip=1
    done
    [[ "$skip" == "1" ]] && continue

    echo "$dir"
  done | sort
}

replace_placeholders_in_directory() {
  local dir="$1"
  local endpoint="$2"
  local port="$3"

  find "$dir" -type f | while read -r file; do
    sed -i.bak \
      -e "s/__ENDPOINT__/$endpoint/g" \
      -e "s/__PORT__/$port/g" \
      -e "s/__CONTAINER__/$endpoint/g" \
      "$file"

    rm -f "${file}.bak"
  done
}
