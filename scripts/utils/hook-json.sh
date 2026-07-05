#!/usr/bin/env bash
set -euo pipefail

json_get() {
  local json="$1"
  local field="$2"

  JSON_FIELD="$field" python3 -c '
import json
import os
import sys

value = json.load(sys.stdin).get(os.environ["JSON_FIELD"], "")
if value is None:
    value = ""
print(value)
' <<< "$json"
}

json_state() {
  local status="$1"
  local session_id="$2"
  local tool="${3:-}"

  JSON_STATUS="$status" JSON_SESSION_ID="$session_id" JSON_TOOL="$tool" python3 - <<'PY'
import json
import os

state = {
    "status": os.environ["JSON_STATUS"],
    "sessionId": os.environ["JSON_SESSION_ID"],
}

tool = os.environ.get("JSON_TOOL", "")
if tool:
    state["tool"] = tool

print(json.dumps(state, separators=(",", ":")))
PY
}
