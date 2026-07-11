#!/usr/bin/env bash
set -euo pipefail

hook_json_field() {
  local input="$1"
  local field="$2"

  HOOK_JSON_INPUT="$input" python3 - "$field" <<'PY'
import json
import os
import sys

field = sys.argv[1]
payload = os.environ.get("HOOK_JSON_INPUT", "")
data = json.loads(payload or "{}")
value = data.get(field, "")
if value is None:
    value = ""
elif not isinstance(value, str):
    value = str(value)
sys.stdout.write(value)
PY
}

hook_state_json() {
  local status="$1"
  local session_id="$2"
  local tool_name="${3-}"

  python3 - "$status" "$session_id" "$tool_name" <<'PY'
import json
import sys

status, session_id, tool_name = sys.argv[1:4]
state = {
    "status": status,
    "sessionId": session_id,
}
if tool_name:
    state["tool"] = tool_name
sys.stdout.write(json.dumps(state, separators=(",", ":")))
PY
}
