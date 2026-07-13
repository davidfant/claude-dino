#!/usr/bin/env bash

hook_json_get() {
  local input="$1"
  local field="$2"

  HOOK_JSON_INPUT="$input" python3 - "$field" <<'PY'
import json
import os
import sys

field = sys.argv[1]
raw_input = os.environ.get("HOOK_JSON_INPUT", "")

try:
    payload = json.loads(raw_input)
except json.JSONDecodeError:
    print("")
    sys.exit(0)

value = payload.get(field, "")
if value is None:
    print("")
elif isinstance(value, str):
    print(value)
else:
    print(json.dumps(value, separators=(",", ":")))
PY
}

hook_state_json() {
  local status="$1"
  local session_id="$2"
  local tool="${3:-}"

  HOOK_STATE_STATUS="$status" \
    HOOK_STATE_SESSION_ID="$session_id" \
    HOOK_STATE_TOOL="$tool" \
    python3 - <<'PY'
import json
import os

payload = {
    "status": os.environ["HOOK_STATE_STATUS"],
    "sessionId": os.environ["HOOK_STATE_SESSION_ID"],
}

tool = os.environ.get("HOOK_STATE_TOOL", "")
if tool:
    payload["tool"] = tool

print(json.dumps(payload, separators=(",", ":")))
PY
}
