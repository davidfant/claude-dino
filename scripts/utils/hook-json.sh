#!/usr/bin/env bash

json_field() {
  local input="$1"
  local field="$2"

  HOOK_INPUT="$input" python3 - "$field" <<'PY'
import json
import os
import sys

try:
    payload = json.loads(os.environ.get("HOOK_INPUT", "{}"))
except json.JSONDecodeError:
    payload = {}

value = payload.get(sys.argv[1], "")
if value is None:
    value = ""

print(value)
PY
}

state_json() {
  local status="$1"
  local session_id="$2"
  local tool="${3:-}"

  python3 - "$status" "$session_id" "$tool" <<'PY'
import json
import sys

payload = {
    "status": sys.argv[1],
    "sessionId": sys.argv[2],
}

if len(sys.argv) > 3 and sys.argv[3]:
    payload["tool"] = sys.argv[3]

print(json.dumps(payload, separators=(",", ":")))
PY
}
