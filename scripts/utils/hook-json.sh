#!/usr/bin/env bash

hook_json_get_field() {
  local input="$1"
  local field="$2"

  HOOK_JSON_INPUT="$input" HOOK_JSON_FIELD="$field" python3 - <<'PY'
import json
import os
import sys

try:
    data = json.loads(os.environ["HOOK_JSON_INPUT"])
except json.JSONDecodeError:
    sys.exit(0)

value = data.get(os.environ["HOOK_JSON_FIELD"], "")
if value is None:
    value = ""

print(value)
PY
}

hook_json_state() {
  local status="$1"
  local session_id="$2"
  local tool="${3-}"

  DINO_STATUS="$status" DINO_SESSION_ID="$session_id" DINO_TOOL="$tool" python3 - <<'PY'
import json
import os

state = {
    "status": os.environ["DINO_STATUS"],
    "sessionId": os.environ["DINO_SESSION_ID"],
}

tool = os.environ.get("DINO_TOOL", "")
if tool:
    state["tool"] = tool

print(json.dumps(state, separators=(",", ":")))
PY
}
