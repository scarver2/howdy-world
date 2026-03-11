#!/usr/bin/env bash
# bin/functions/git.sh

create_endpoint_branch() {
  local branch="$1"

  if git_branch_exists "$branch"; then
    echo
    echo "Branch '$branch' already exists."
    echo "Please delete or choose another endpoint name."
    echo
    exit 1
  fi

  git checkout -b "$branch"
}

ensure_clean_working_tree() {
  if ! git diff --quiet || ! git diff --cached --quiet; then
    echo
    echo "Working tree is not clean."
    echo "Please commit or stash changes before running scaffold."
    echo
    git status --short
    echo
    exit 1
  fi
}

ensure_master_branch() {
  local branch
  branch="$(git_current_branch)"

  if [[ "$branch" != "master" ]]; then
    echo
    echo "Scaffold must be run on the 'master' branch."
    echo "Current branch: $branch"
    echo
    exit 1
  fi
}

ensure_master_up_to_date() {
  echo "Fetching origin..."
  git fetch origin master >/dev/null 2>&1

  local local_sha remote_sha base_sha

  local_sha="$(git rev-parse master)"
  remote_sha="$(git rev-parse origin/master)"
  base_sha="$(git merge-base master origin/master)"

  if [[ "$local_sha" != "$remote_sha" ]]; then
    if [[ "$local_sha" == "$base_sha" ]]; then
      echo
      echo "Local master is behind origin/master."
      echo "Please run: git pull --ff-only"
      echo
      exit 1
    elif [[ "$remote_sha" == "$base_sha" ]]; then
      echo
      echo "Local master is ahead of origin/master."
      echo "Please push changes before scaffolding."
      echo
      exit 1
    else
      echo
      echo "Local and origin/master have diverged."
      echo "Resolve divergence before running scaffold."
      echo
      exit 1
    fi
  fi
}

git_branch_exists() {
  local branch="$1"
  git show-ref --verify --quiet "refs/heads/$branch"
}

git_commit_endpoint() {
  local endpoint="$1"

  git add "$endpoint" compose.yml nginx/conf.d/"$endpoint".conf
  git commit -m "Add $endpoint endpoint"
}

git_commit_endpoint_if_new() {
  local endpoint="$1"

  if git ls-files --error-unmatch "$endpoint" >/dev/null 2>&1; then
    echo "Endpoint already tracked. Skipping git commit."
    return
  fi

  git add "$endpoint" compose.yml
  git commit -m "Add $endpoint endpoint"
}

git_current_branch() {
  git rev-parse --abbrev-ref HEAD
}

git_version() {
  if command -v git >/dev/null 2>&1 && \
     git -C "$ROOT_DIR" rev-parse --is-inside-work-tree >/dev/null 2>&1; then

    local sha branch date dirty
    sha="$(git -C "$ROOT_DIR" rev-parse --short HEAD 2>/dev/null || echo unknown)"
    branch="$(git -C "$ROOT_DIR" rev-parse --abbrev-ref HEAD 2>/dev/null || echo unknown)"
    date="$(git -C "$ROOT_DIR" show -s --format=%cs HEAD 2>/dev/null || echo unknown)"
    dirty="$(git -C "$ROOT_DIR" status --porcelain 2>/dev/null | wc -l | tr -d ' ')"

    local suffix=""
    [[ "$dirty" != "0" ]] && suffix=" dirty"

    echo "${branch}@${sha} (${date})${suffix}"
  else
    echo "no-git"
  fi
}

git_current_branch() {
  git rev-parse --abbrev-ref HEAD
}

ensure_master_branch() {
  local branch
  branch="$(git_current_branch)"

  if [[ "$branch" != "master" ]]; then
    echo
    echo "Scaffold must be run on the 'master' branch."
    echo "Current branch: $branch"
    echo
    exit 1
  fi
}
