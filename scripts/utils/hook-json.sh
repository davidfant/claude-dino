#!/usr/bin/env bash
set -euo pipefail

json_field() {
  local input="$1"
  local field="$2"

  python3 - "$field" "$input" <<'PY'
import json
import sys


def main() -> None:
    field = sys.argv[1]
    payload = json.loads(sys.argv[2])
    value = payload.get(field, "")
    if value is None:
        value = ""
    print(value)


main()
PY
}

state_json() {
  local status="$1"
  local session_id="$2"
  local tool="${3-}"

  python3 - "$status" "$session_id" "$tool" <<'PY'
import json
import sys


def main() -> None:
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


main()
PY
}

case "${1:-}" in
  field)
    json_field "$2" "$3"
    ;;
  state)
    state_json "$2" "$3" "${4-}"
    ;;
  *)
    echo "Usage: $0 {field <json> <field>|state <status> <session_id> [tool]}" >&2
    exit 1
    ;;
esac
