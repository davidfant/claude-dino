#!/usr/bin/env bash
set -euo pipefail

json_get_field() {
  local field="$1"
  local input

  input="$(cat)"
  JSON_INPUT="$input" python3 - "$field" <<'PY'
import json
import os
import sys

field = sys.argv[1]

try:
    data = json.loads(os.environ.get("JSON_INPUT", ""))
except json.JSONDecodeError:
    print("", end="")
    sys.exit(0)

value = data.get(field, "")
if value is None:
    value = ""
elif not isinstance(value, str):
    value = str(value)

print(value, end="")
PY
}

state_json() {
  local status="$1"
  local session_id="$2"
  local tool="${3:-}"

  python3 - "$status" "$session_id" "$tool" <<'PY'
import json
import sys

status, session_id, tool = sys.argv[1:]
state = {
    "status": status,
    "sessionId": session_id,
}

if tool:
    state["tool"] = tool

print(json.dumps(state, separators=(",", ":")))
PY
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
  case "${1:-}" in
    get)
      json_get_field "$2"
      ;;
    state)
      state_json "$2" "$3" "${4:-}"
      ;;
    *)
      echo "Usage: $0 {get <field>|state <status> <session_id> [tool]}" >&2
      exit 1
      ;;
  esac
fi
