#!/usr/bin/env bash
set -euo pipefail

read_hook_input() {
  local input
  input="$(</dev/stdin)"
  printf '%s' "$input"
}

hook_json_field() {
  local input="$1"
  local field="$2"

  if command -v python3 >/dev/null 2>&1; then
    printf '%s' "$input" | python3 -c '
import json
import sys

try:
    data = json.load(sys.stdin)
except json.JSONDecodeError:
    sys.exit(0)

value = data.get(sys.argv[1], "")
if value is None:
    value = ""
print(value)
' "$field"
    return
  fi

  printf '%s' "$input" | sed -nE 's/.*"'"$field"'"[[:space:]]*:[[:space:]]*"([^"]*)".*/\1/p'
}

json_escape() {
  local value="$1"

  if command -v python3 >/dev/null 2>&1; then
    JSON_VALUE="$value" python3 -c '
import json
import os

print(json.dumps(os.environ["JSON_VALUE"])[1:-1], end="")
'
    return
  fi

  value=${value//\\/\\\\}
  value=${value//\"/\\\"}
  value=${value//$'\n'/\\n}
  value=${value//$'\r'/\\r}
  value=${value//$'\t'/\\t}

  printf '%s' "$value"
}

hook_state_json() {
  local session_id="$1"
  local status="$2"
  local tool="${3:-}"

  if command -v python3 >/dev/null 2>&1; then
    SESSION_ID="$session_id" STATUS="$status" TOOL="$tool" python3 -c '
import json
import os

payload = {
    "status": os.environ["STATUS"],
    "sessionId": os.environ["SESSION_ID"],
}

tool = os.environ.get("TOOL", "")
if tool:
    payload["tool"] = tool

print(json.dumps(payload, separators=(",", ":")))
'
    return
  fi

  local escaped_session_id
  local escaped_status
  escaped_session_id="$(json_escape "$session_id")"
  escaped_status="$(json_escape "$status")"

  if [[ -n "$tool" ]]; then
    local escaped_tool
    escaped_tool="$(json_escape "$tool")"
    printf '{"status":"%s","sessionId":"%s","tool":"%s"}\n' "$escaped_status" "$escaped_session_id" "$escaped_tool"
  else
    printf '{"status":"%s","sessionId":"%s"}\n' "$escaped_status" "$escaped_session_id"
  fi
}
