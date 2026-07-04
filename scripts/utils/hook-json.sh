#!/usr/bin/env bash
set -euo pipefail

json_field() {
  local payload="$1"
  local field="$2"

  JSON_PAYLOAD="$payload" python3 - "$field" <<'PY'
import json
import os
import sys

payload = os.environ.get("JSON_PAYLOAD", "")
data = json.loads(payload) if payload else {}
value = data.get(sys.argv[1], "")

if value is None:
    value = ""

print(value)
PY
}

json_state() {
  local status="$1"
  local session_id="$2"
  local tool="${3:-}"

  python3 - "$status" "$session_id" "$tool" <<'PY'
import json
import sys

state = {
    "status": sys.argv[1],
    "sessionId": sys.argv[2],
}

if sys.argv[3]:
    state["tool"] = sys.argv[3]

print(json.dumps(state, separators=(",", ":")))
PY
}
