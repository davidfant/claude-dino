#!/usr/bin/env bash
set -euo pipefail

json_get() {
  local key="$1"

  python3 -c '
import json
import sys

key = sys.argv[1]
payload = json.load(sys.stdin)
value = payload.get(key, "")
if value is None:
    value = ""
print(value)
' "$key"
}

json_state() {
  local status="$1"
  local session_id="$2"

  if [[ $# -ge 3 ]]; then
    local tool="$3"
    python3 -c '
import json
import sys

status = sys.argv[1]
session_id = sys.argv[2]
tool = sys.argv[3]
print(json.dumps({"status": status, "tool": tool, "sessionId": session_id}, separators=(",", ":")))
' "$status" "$session_id" "$tool"
  else
    python3 -c '
import json
import sys

status = sys.argv[1]
session_id = sys.argv[2]
print(json.dumps({"status": status, "sessionId": session_id}, separators=(",", ":")))
' "$status" "$session_id"
  fi
}
