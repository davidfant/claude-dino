#!/usr/bin/env bash

hook_json_field() {
  local input="$1"
  local field="$2"

  HOOK_JSON_INPUT="$input" python3 - "$field" <<'PY'
import json
import os
import sys

field = sys.argv[1]
try:
    value = json.loads(os.environ["HOOK_JSON_INPUT"]).get(field, "")
except json.JSONDecodeError:
    value = ""

if value is None:
    value = ""

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
