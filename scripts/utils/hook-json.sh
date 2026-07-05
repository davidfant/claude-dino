#!/usr/bin/env bash

json_get() {
  local payload="$1"
  local key="$2"

  JSON_PAYLOAD="$payload" JSON_KEY="$key" python3 - <<'PY'
import json
import os
import sys

try:
    data = json.loads(os.environ.get("JSON_PAYLOAD", "") or "{}")
except json.JSONDecodeError:
    sys.exit(0)

value = data.get(os.environ["JSON_KEY"], "")
if value is None:
    value = ""

if isinstance(value, (dict, list)):
    print(json.dumps(value, separators=(",", ":")))
else:
    print(str(value))
PY
}

json_state() {
  local status="$1"
  local session_id="$2"
  local tool="${3:-}"

  DINO_STATUS="$status" DINO_SESSION_ID="$session_id" DINO_TOOL_NAME="$tool" python3 - <<'PY'
import json
import os

state = {
    "status": os.environ["DINO_STATUS"],
    "sessionId": os.environ["DINO_SESSION_ID"],
}

tool = os.environ.get("DINO_TOOL_NAME", "")
if tool:
    state["tool"] = tool

print(json.dumps(state, separators=(",", ":")))
PY
}
