#!/usr/bin/env bash
set -euo pipefail

HOOK_INPUT=""

read_hook_input() {
  HOOK_INPUT="$(python3 -c 'import sys; print(sys.stdin.read(), end="")')"
}

hook_payload_string() {
  local field="$1"

  HOOK_JSON_PAYLOAD="$HOOK_INPUT" python3 - "$field" <<'PY'
import json
import os
import sys

field = sys.argv[1]
payload = json.loads(os.environ["HOOK_JSON_PAYLOAD"])
value = payload.get(field, "")

if isinstance(value, str):
    print(value)
PY
}

hook_state_json() {
  local status="$1"
  local session_id="$2"
  local tool_name="${3:-}"

  python3 - "$status" "$session_id" "$tool_name" <<'PY'
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
