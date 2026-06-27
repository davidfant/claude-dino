#!/usr/bin/env bash

hook_json_get() {
  local input="$1"
  local field="$2"

  HOOK_JSON_INPUT="$input" python3 - "$field" <<'PY'
import json
import os
import sys

field = sys.argv[1]

try:
    payload = json.loads(os.environ.get("HOOK_JSON_INPUT", ""))
except json.JSONDecodeError:
    sys.exit(0)

value = payload.get(field, "")
if value is None:
    sys.exit(0)

if isinstance(value, (dict, list)):
    print(json.dumps(value, separators=(",", ":")))
else:
    print(value)
PY
}

hook_state_json() {
  local status="$1"
  local session_id="$2"
  local tool="${3:-}"

  python3 - "$status" "$session_id" "$tool" <<'PY'
import json
import sys

status, session_id, tool = sys.argv[1:4]
payload = {
    "status": status,
    "sessionId": session_id,
}

if tool:
    payload["tool"] = tool

print(json.dumps(payload, separators=(",", ":")))
PY
}
