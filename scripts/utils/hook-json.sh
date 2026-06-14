#!/usr/bin/env bash

json_get_field() {
  local field="$1"

  python3 -c 'import json
import sys

field = sys.argv[1]
try:
    payload = json.load(sys.stdin)
except json.JSONDecodeError:
    sys.exit(0)

value = payload.get(field, "")
if value is None:
    value = ""

print(str(value), end="")' "$field"
}

json_build_state() {
  local status="$1"
  local session_id="$2"
  local tool="${3-}"

  if [[ $# -ge 3 ]]; then
    python3 -c 'import json
import sys

status, session_id, tool = sys.argv[1:4]
print(json.dumps(
    {"status": status, "tool": tool, "sessionId": session_id},
    separators=(",", ":"),
))' "$status" "$session_id" "$tool"
  else
    python3 -c 'import json
import sys

status, session_id = sys.argv[1:3]
print(json.dumps(
    {"status": status, "sessionId": session_id},
    separators=(",", ":"),
))' "$status" "$session_id"
  fi
}
