#!/usr/bin/env bash

read_hook_input() {
  local input
  input="$(cat)"
  printf '%s' "$input"
}

hook_json_value() {
  local input="$1"
  local key="$2"
  local default_value="${3:-}"

  HOOK_JSON_INPUT="$input" python3 - "$key" "$default_value" <<'PY'
import json
import os
import sys

key = sys.argv[1]
default_value = sys.argv[2]

try:
    payload = json.loads(os.environ.get("HOOK_JSON_INPUT", ""))
except json.JSONDecodeError:
    payload = {}
if not isinstance(payload, dict):
    payload = {}

value = payload.get(key, default_value)
if value is None:
    value = default_value

print(str(value), end="")
PY
}

hook_state_json() {
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

tool = os.environ.get("DINO_TOOL", "")
if tool:
    state["tool"] = tool

print(json.dumps(state, separators=(",", ":")), end="")
PY
}
