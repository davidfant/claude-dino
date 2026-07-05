#!/usr/bin/env bash

json_get() {
  local input="$1"
  local key="$2"

  JSON_INPUT="$input" JSON_KEY="$key" python3 - <<'PY'
import json
import os
import sys

try:
    payload = json.loads(os.environ["JSON_INPUT"])
except (KeyError, json.JSONDecodeError):
    sys.exit(0)

value = payload.get(os.environ["JSON_KEY"], "")
if value is None:
    sys.exit(0)
if isinstance(value, (dict, list)):
    print(json.dumps(value, separators=(",", ":")))
else:
    print(value)
PY
}

json_state() {
  local status="$1"
  local session_id="$2"
  local tool_name="${3:-}"

  STATUS="$status" SESSION_ID="$session_id" TOOL_NAME="$tool_name" python3 - <<'PY'
import json
import os

state = {
    "status": os.environ["STATUS"],
    "sessionId": os.environ["SESSION_ID"],
}

tool_name = os.environ.get("TOOL_NAME", "")
if tool_name:
    state["tool"] = tool_name

print(json.dumps(state, separators=(",", ":")))
PY
}
