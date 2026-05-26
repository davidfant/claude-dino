#!/usr/bin/env bash

json_string_field() {
  local input="$1"
  local field="$2"

  printf '%s\n' "$input" \
    | sed -nE "s/.*\"${field}\"[[:space:]]*:[[:space:]]*\"([^\"]*)\".*/\1/p" \
    | sed -n '1p'
}

require_json_string_field() {
  local input="$1"
  local field="$2"
  local value

  value=$(json_string_field "$input" "$field")
  if [[ -z "$value" ]]; then
    echo "Missing required JSON string field: $field" >&2
    return 1
  fi

  printf '%s' "$value"
}
