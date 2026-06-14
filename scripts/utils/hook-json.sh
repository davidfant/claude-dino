#!/usr/bin/env bash
set -euo pipefail

json_field() {
  local input="$1"
  local field="$2"

  python3 -c '
import json
import sys

try:
    data = json.loads(sys.stdin.read() or "{}")
except json.JSONDecodeError:
    data = {}

value = data.get(sys.argv[1], "")
if value is None:
    value = ""
print(value)
' "$field" <<< "$input"
}

state_json() {
  local status="$1"
  local session_id="$2"
  local tool="${3:-}"

  python3 -c '
import json
import sys

status, session_id, tool = sys.argv[1:4]
state = {
    "status": status,
    "sessionId": session_id,
}
if tool:
    state["tool"] = tool
print(json.dumps(state, separators=(",", ":")))
' "$status" "$session_id" "$tool"
}
