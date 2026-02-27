#!/usr/bin/env bash
# bin/functions/yaml.sh

yaml_get() {
  local path="$1"
  local file="$2"
  yq e "$path" "$file"
}

yaml_has() {
  local object_path="$1"
  local key="$2"
  local file="$3"

  # Scope into object, then check key
  [[ "$(yq e "$object_path | has(\"$key\")" "$file")" == "true" ]]
}

yaml_type() {
  local path="$1"
  local file="$2"
  yq e "$path | type" "$file"
}

yaml_length() {
  local path="$1"
  local file="$2"
  yq e "$path | length" "$file"
}

yaml_keys() {
  local path="$1"
  local file="$2"
  yq e "$path | keys | .[]" "$file"
}

