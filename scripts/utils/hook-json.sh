#!/usr/bin/env bash
set -euo pipefail

read_field() {
  local field="$1"
  local input

  input="$(</dev/stdin)"

  HOOK_PAYLOAD="$input" python3 - "$field" <<'PY'
import json
import os
import sys

field = sys.argv[1]

try:
    payload = json.loads(os.environ.get("HOOK_PAYLOAD", ""))
except json.JSONDecodeError:
    sys.exit(0)

value = payload.get(field, "")
if not isinstance(value, str):
    value = ""

print(value)
PY
}

write_state() {
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
  field)
    read_field "$2"
    ;;
  state)
    write_state "$2" "$3" "${4:-}"
    ;;
  *)
    echo "Usage: $0 {field <name>|state <status> <session_id> [tool]}" >&2
    exit 1
    ;;
esac
