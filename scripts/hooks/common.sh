#!/usr/bin/env bash

HOOK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLUGIN_DIR="$(cd "$HOOK_DIR/../.." && pwd)"

read_hook_input() {
  local input
  input="$(cat)"
  printf '%s' "$input"
}

json_string_field() {
  local input="$1"
  local field="$2"

  if command -v python3 >/dev/null 2>&1; then
    FIELD="$field" python3 -c '
import json
import os
import sys

try:
    data = json.load(sys.stdin)
    value = data.get(os.environ["FIELD"], "")
except Exception:
    value = ""

if isinstance(value, str):
    print(value, end="")
elif value is not None:
    print(str(value), end="")
' <<<"$input"
    return 0
  fi

  printf '%s' "$input" |
    sed -nE 's/.*"'"$field"'"[[:space:]]*:[[:space:]]*"([^"]*)".*/\1/p' |
    sed -n '1p'
}

json_escape() {
  local value="$1"
  value=${value//\\/\\\\}
  value=${value//\"/\\\"}
  value=${value//$'\n'/\\n}
  value=${value//$'\r'/\\r}
  value=${value//$'\t'/\\t}
  printf '%s' "$value"
}

warn_missing_session_id() {
  echo "Claude Dino: missing session_id in hook input" >&2
}

write_dino_state() {
  local session_id="$1"
  local status="$2"
  local tool="${3-}"

  if [[ -z "$session_id" ]]; then
    warn_missing_session_id
    return 0
  fi

  local escaped_session_id
  local escaped_status
  escaped_session_id="$(json_escape "$session_id")"
  escaped_status="$(json_escape "$status")"

  local json
  if [[ $# -ge 3 ]]; then
    local escaped_tool
    escaped_tool="$(json_escape "$tool")"
    json='{"status":"'"$escaped_status"'","tool":"'"$escaped_tool"'","sessionId":"'"$escaped_session_id"'"}'
  else
    json='{"status":"'"$escaped_status"'","sessionId":"'"$escaped_session_id"'"}'
  fi

  "$PLUGIN_DIR/scripts/utils/state-manager.sh" write "$session_id" "$json"
}
