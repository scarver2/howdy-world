#!/usr/bin/env bash
# bin/functions/endpoints.sh

discover_endpoints() {
  for dir in */ ; do
    dir="${dir%/}"
    [[ "$dir" == .* ]] && continue
    [[ "$dir" == _* ]] && continue

    skip=0
    for item in "${BLACKLIST[@]}"; do
      [[ "$dir" == "$item" ]] && skip=1
    done
    [[ "$skip" == "1" ]] && continue

    echo "$dir"
  done | sort
}
