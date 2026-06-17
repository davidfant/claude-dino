#!/usr/bin/env bash
set -euo pipefail

hook_json_field() {
  local payload="$1"
  local field="$2"

  HOOK_PAYLOAD="$payload" HOOK_FIELD="$field" python3 - <<'PY'
import json
import os
import sys

payload = os.environ.get("HOOK_PAYLOAD", "")
field = os.environ["HOOK_FIELD"]

try:
    value = json.loads(payload).get(field)
except json.JSONDecodeError:
    sys.exit(0)

if value is None:
    sys.exit(0)

print(value)
PY
}

hook_state_json() {
  local status="$1"
  local session_id="$2"
  local tool="${3:-}"

  HOOK_STATUS="$status" HOOK_SESSION_ID="$session_id" HOOK_TOOL="$tool" python3 - <<'PY'
import json
import os

state = {
    "status": os.environ["HOOK_STATUS"],
    "sessionId": os.environ["HOOK_SESSION_ID"],
}

tool = os.environ.get("HOOK_TOOL", "")
if tool:
    state["tool"] = tool

print(json.dumps(state, separators=(",", ":")))
PY
}
