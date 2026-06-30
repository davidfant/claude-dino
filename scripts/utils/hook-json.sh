#!/usr/bin/env bash

hook_json_get() {
  local input="$1"
  local field="$2"

  HOOK_JSON_INPUT="$input" python3 - "$field" <<'PY'
import json
import os
import sys

field = sys.argv[1]
payload = json.loads(os.environ["HOOK_JSON_INPUT"])
value = payload.get(field)

if value is None:
    sys.exit(f"Missing JSON field: {field}")

print(str(value), end="")
PY
}

hook_state_json() {
  local status="$1"
  local session_id="$2"
  local tool_name="${3-}"

  HOOK_STATUS="$status" HOOK_SESSION_ID="$session_id" HOOK_TOOL_NAME="$tool_name" python3 - <<'PY'
import json
import os

state = {
    "status": os.environ["HOOK_STATUS"],
    "sessionId": os.environ["HOOK_SESSION_ID"],
}

tool = os.environ.get("HOOK_TOOL_NAME")
if tool:
    state["tool"] = tool

print(json.dumps(state, separators=(",", ":")), end="")
PY
}
