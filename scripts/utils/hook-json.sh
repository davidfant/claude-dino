#!/usr/bin/env bash
set -euo pipefail

usage() {
  echo "Usage: $0 {field <name>|state <status> <session_id> [tool_name]}" >&2
  exit 1
}

read_field() {
  local field_name="$1"
  local input

  input=$(cat)

  FIELD_NAME="$field_name" INPUT_JSON="$input" python3 - <<'PY'
import json
import os
import sys

field_name = os.environ["FIELD_NAME"]
input_json = os.environ["INPUT_JSON"]

try:
    payload = json.loads(input_json)
except json.JSONDecodeError:
    sys.exit(0)

value = payload.get(field_name, "")
if value is None:
    value = ""

if isinstance(value, str):
    print(value)
else:
    print(json.dumps(value, separators=(",", ":")))
PY
}

write_state() {
  local status="$1"
  local session_id="$2"
  local tool_name="${3-}"

  STATUS="$status" SESSION_ID="$session_id" TOOL_NAME="$tool_name" python3 - <<'PY'
import json
import os

state = {
    "status": os.environ["STATUS"],
    "sessionId": os.environ["SESSION_ID"],
}

tool_name = os.environ["TOOL_NAME"]
if tool_name:
    state["tool"] = tool_name

print(json.dumps(state, separators=(",", ":")))
PY
}

case "${1:-}" in
  field)
    [[ $# -eq 2 ]] || usage
    read_field "$2"
    ;;
  state)
    [[ $# -eq 3 || $# -eq 4 ]] || usage
    write_state "$2" "$3" "${4-}"
    ;;
  *)
    usage
    ;;
esac
