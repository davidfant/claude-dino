#!/usr/bin/env bash

extract_json_string() {
  local input="$1"
  local key="$2"
  local pattern="\"${key}\"[[:space:]]*:[[:space:]]*\"([^\"\\\\]*(\\\\.[^\"\\\\]*)*)\""

  if [[ "$input" =~ $pattern ]]; then
    printf '%s' "${BASH_REMATCH[1]}"
  fi
}

require_session_id() {
  local input="$1"
  local session_id
  session_id="$(extract_json_string "$input" "session_id")"

  if [[ -z "$session_id" ]]; then
    echo "claude-dino: missing session_id in hook input" >&2
    return 1
  fi

  printf '%s' "$session_id"
}
