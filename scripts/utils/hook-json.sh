#!/usr/bin/env bash
set -euo pipefail

json_get() {
  local field="$1"

  python3 -c '
import json
import sys

field = sys.argv[1]

try:
    payload = json.load(sys.stdin)
except json.JSONDecodeError:
    sys.exit(0)

value = payload.get(field, "")
if value is None:
    value = ""

print(value)
' "$field"
}

json_state() {
  local status="$1"
  local session_id="$2"
  local tool="${3:-}"

  python3 - "$status" "$session_id" "$tool" <<'PY'
import json
import sys

status, session_id, tool = sys.argv[1], sys.argv[2], sys.argv[3]
payload = {
    "status": status,
    "sessionId": session_id,
}

if tool:
    payload["tool"] = tool

print(json.dumps(payload, separators=(",", ":")))
PY
}
