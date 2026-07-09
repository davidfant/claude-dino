#!/usr/bin/env bash

hook_json_field() {
  local input="$1"
  local field="$2"

  RAW_JSON="$input" FIELD_NAME="$field" python3 - <<'PY'
import json
import os

raw_json = os.environ["RAW_JSON"]
field_name = os.environ["FIELD_NAME"]

try:
    payload = json.loads(raw_json)
except json.JSONDecodeError:
    payload = {}

if isinstance(payload, dict):
    value = payload.get(field_name, "")
else:
    value = ""

if value is None:
    print("")
elif isinstance(value, (dict, list)):
    print(json.dumps(value, separators=(",", ":")))
else:
    print(str(value))
PY
}

hook_state_json() {
  local status="$1"
  local session_id="$2"
  local tool_name="${3:-}"

  HOOK_STATUS="$status" HOOK_SESSION_ID="$session_id" HOOK_TOOL_NAME="$tool_name" python3 - <<'PY'
import json
import os

state = {
    "status": os.environ["HOOK_STATUS"],
    "sessionId": os.environ["HOOK_SESSION_ID"],
}

tool_name = os.environ.get("HOOK_TOOL_NAME", "")
if tool_name:
    state["tool"] = tool_name

print(json.dumps(state, separators=(",", ":")))
PY
}
