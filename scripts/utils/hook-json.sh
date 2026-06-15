#!/usr/bin/env bash

json_get_string() {
  local input="$1"
  local key="$2"

  python3 -c '
import json
import sys

key = sys.argv[1]
try:
    data = json.load(sys.stdin)
except json.JSONDecodeError:
    print("")
    sys.exit(0)

value = data.get(key, "")
print(value if isinstance(value, str) else "")
' "$key" <<< "$input"
}

hook_session_id() {
  local input="$1"
  local session_id

  session_id="$(json_get_string "$input" "session_id")"
  printf '%s\n' "${session_id:-default}"
}

state_json() {
  local status="$1"
  local session_id="$2"
  local tool="${3:-}"

  python3 -c '
import json
import sys

status, session_id, tool = sys.argv[1], sys.argv[2], sys.argv[3]
state = {"status": status, "sessionId": session_id}
if tool:
    state["tool"] = tool
print(json.dumps(state, separators=(",", ":")))
' "$status" "$session_id" "$tool"
}
