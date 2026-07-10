#!/usr/bin/env bash
set -euo pipefail

json_field() {
  local json="$1"
  local field="$2"

  printf '%s' "$json" | python3 -c '
import json
import sys

field = sys.argv[1]

try:
    payload = json.load(sys.stdin)
except json.JSONDecodeError:
    sys.exit(0)

value = payload.get(field, "")
if value is None:
    value = ""
elif not isinstance(value, str):
    value = str(value)

print(value)
' "$field"
}

state_json() {
  local status="$1"
  local session_id="$2"
  local tool="${3-}"

  if [[ $# -ge 3 ]]; then
    python3 -c '
import json
import sys

status, session_id, tool = sys.argv[1:4]
print(json.dumps({"status": status, "tool": tool, "sessionId": session_id}, separators=(",", ":")))
' "$status" "$session_id" "$tool"
  else
    python3 -c '
import json
import sys

status, session_id = sys.argv[1:3]
print(json.dumps({"status": status, "sessionId": session_id}, separators=(",", ":")))
' "$status" "$session_id"
  fi
}
