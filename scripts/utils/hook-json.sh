#!/usr/bin/env bash
set -euo pipefail

hook_json_get() {
  local field="$1"

  python3 -c '
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

print(value)
' "$field"
}

hook_state_json() {
  local status="$1"
  local session_id="$2"
  local tool="${3:-}"

  python3 -c '
import json
import sys

status, session_id, tool = sys.argv[1:4]
state = {"status": status, "sessionId": session_id}

if tool:
    state["tool"] = tool

print(json.dumps(state, separators=(",", ":")))
' "$status" "$session_id" "$tool"
}
