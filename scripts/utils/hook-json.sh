#!/usr/bin/env bash
set -euo pipefail

json_field() {
  local input="$1"
  local field="$2"

  JSON_INPUT="$input" python3 - "$field" <<'PY'
import json
import os
import sys

field = sys.argv[1]

try:
    payload = json.loads(os.environ.get("JSON_INPUT", "{}"))
except json.JSONDecodeError:
    print("")
    sys.exit(0)

value = payload.get(field, "")
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

status = sys.argv[1]
session_id = sys.argv[2]
tool = sys.argv[3]

payload = {
    "status": status,
    "sessionId": session_id,
}

if tool:
    payload["tool"] = tool

print(json.dumps(payload, separators=(",", ":")))
PY
}
