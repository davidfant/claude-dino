#!/usr/bin/env bash

resolve_plugin_dir() {
  if [[ -n "${CLAUDE_PLUGIN_ROOT:-}" ]]; then
    printf '%s\n' "$CLAUDE_PLUGIN_ROOT"
    return
  fi

  cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd
}

json_get_field() {
  local field="$1"

  python3 -c '
import json
import sys

field = sys.argv[1]
payload = json.load(sys.stdin)
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

status, session_id, tool = sys.argv[1:4]
state = {
    "status": status,
    "sessionId": session_id,
}
if tool:
    state["tool"] = tool

print(json.dumps(state, separators=(",", ":")))
PY
}
