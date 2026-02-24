#!/usr/bin/env bash
# bin/functions/git.sh

git_version() {
  if command -v git >/dev/null 2>&1 && \
     git -C "$ROOT_DIR" rev-parse --is-inside-work-tree >/dev/null 2>&1; then

    local sha branch date dirty
    sha="$(git -C "$ROOT_DIR" rev-parse --short HEAD 2>/dev/null || echo unknown)"
    branch="$(git -C "$ROOT_DIR" rev-parse --abbrev-ref HEAD 2>/dev/null || echo unknown)"
    date="$(git -C "$ROOT_DIR" show -s --format=%cs HEAD 2>/dev/null || echo unknown)"
    dirty="$(git -C "$ROOT_DIR" status --porcelain 2>/dev/null | wc -l | tr -d ' ')"

    [[ "$dirty" != "0" ]] && dirty="yes" || dirty="no"

    echo "${branch}@${sha} (${date}) dirty:${dirty}"
  else
    echo "no-git"
  fi
}
