#!/usr/bin/env bash
set -euo pipefail

json_get_field() {
  local field="$1"

  python3 -c 'import json, sys; data = json.load(sys.stdin); value = data.get(sys.argv[1], ""); print("" if value is None else value)' "$field"
}

json_state() {
  local status="$1"
  local session_id="$2"
  shift 2

  python3 - "$status" "$session_id" "$@" <<'PY'
import json
import sys

payload = {
    "status": sys.argv[1],
    "sessionId": sys.argv[2],
}

if len(sys.argv) > 3:
    payload["tool"] = sys.argv[3]

print(json.dumps(payload, separators=(",", ":")))
PY
}
