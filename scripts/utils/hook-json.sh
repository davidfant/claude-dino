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
    payload = json.loads(os.environ["HOOK_JSON_INPUT"])
except json.JSONDecodeError:
    payload = {}

if not isinstance(payload, dict):
    payload = {}

value = payload.get(field, "")

if value is None:
    value = ""

print(value)
PY
}

dino_state_json() {
  local status="$1"
  local session_id="$2"
  local tool="${3:-}"

  DINO_STATUS="$status" DINO_SESSION_ID="$session_id" DINO_TOOL="$tool" python3 - <<'PY'
import json
import os

state = {
    "status": os.environ["DINO_STATUS"],
    "sessionId": os.environ["DINO_SESSION_ID"],
}
tool = os.environ["DINO_TOOL"]

if tool:
    state["tool"] = tool

print(json.dumps(state, separators=(",", ":")))
PY
}
