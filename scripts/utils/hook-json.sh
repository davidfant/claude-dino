#!/usr/bin/env bash

read_hook_json() {
  local input
  input="$(cat)"
  printf '%s' "$input"
}

json_field() {
  local input="$1"
  local field="$2"

  python3 -c '
import json
import sys

data = json.load(sys.stdin)
value = data.get(sys.argv[1], "")
if value is None:
    value = ""
print(value)
' "$field" <<< "$input"
}

state_json() {
  local status="$1"
  local session_id="$2"
  local tool="${3-}"

  if [[ $# -ge 3 ]]; then
    python3 -c '
import json
import sys

payload = {
    "status": sys.argv[1],
    "tool": sys.argv[3],
    "sessionId": sys.argv[2],
}
print(json.dumps(payload, separators=(",", ":")))
' "$status" "$session_id" "$tool"
  else
    python3 -c '
import json
import sys

payload = {
    "status": sys.argv[1],
    "sessionId": sys.argv[2],
}
print(json.dumps(payload, separators=(",", ":")))
' "$status" "$session_id"
  fi
}
