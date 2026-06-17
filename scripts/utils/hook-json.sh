#!/usr/bin/env bash
set -euo pipefail

json_get_field() {
  local json="$1"
  local field="$2"

  JSON_INPUT="$json" python3 - "$field" <<'PY'
import json
import os
import sys

field = sys.argv[1]
try:
    data = json.loads(os.environ.get("JSON_INPUT", "{}"))
except json.JSONDecodeError:
    print("")
    raise SystemExit(0)

value = data.get(field, "")
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

state = {
    "status": status,
    "sessionId": session_id,
}

if tool:
    state["tool"] = tool

print(json.dumps(state, separators=(",", ":")))
PY
}
