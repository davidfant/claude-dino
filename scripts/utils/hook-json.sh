#!/usr/bin/env bash
set -euo pipefail

json_get_field() {
  local field="$1"
  local input="$2"

  python3 - "$field" "$input" <<'PY'
import json
import sys

field = sys.argv[1]
data = json.loads(sys.argv[2])
value = data.get(field, "")
if value is None:
    value = ""

if isinstance(value, (dict, list)):
    print(json.dumps(value, separators=(",", ":")))
else:
    print(value)
PY
}

json_make_state() {
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
