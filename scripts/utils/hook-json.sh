#!/usr/bin/env bash
set -euo pipefail

json_get_field() {
  local field="$1"
  local payload
  payload="$(</dev/stdin)"

  JSON_PAYLOAD="$payload" python3 - "$field" <<'PY'
import json
import os
import sys

field = sys.argv[1]

try:
    payload = json.loads(os.environ.get("JSON_PAYLOAD", ""))
except json.JSONDecodeError:
    sys.exit(0)

value = payload.get(field, "")
if value is None:
    sys.exit(0)

print(value)
PY
}

json_state() {
  local status="$1"
  local session_id="$2"
  local tool="${3:-}"

  python3 - "$status" "$session_id" "$tool" <<'PY'
import json
import sys

status, session_id, tool = sys.argv[1], sys.argv[2], sys.argv[3]

state = {
    "status": status,
    "sessionId": session_id,
}
if tool:
    state["tool"] = tool

print(json.dumps(state, separators=(",", ":")))
PY
}
