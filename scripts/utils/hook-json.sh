#!/usr/bin/env bash
set -euo pipefail

get_field() {
  local field="$1"
  local payload

  payload=$(cat)

  HOOK_PAYLOAD="$payload" python3 - "$field" <<'PY'
import json
import os
import sys

field = sys.argv[1]
raw_payload = os.environ.get("HOOK_PAYLOAD", "")

try:
    payload = json.loads(raw_payload)
except json.JSONDecodeError:
    print("")
    sys.exit(0)

value = payload.get(field, "")
if value is None:
    value = ""

print(value)
PY
}

build_state() {
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

case "${1:-}" in
  get)
    get_field "${2:?field is required}"
    ;;
  state)
    build_state "${2:?status is required}" "${3:?session_id is required}" "${4:-}"
    ;;
  *)
    echo "Usage: $0 {get <field>|state <status> <session_id> [tool]}" >&2
    exit 1
    ;;
esac
