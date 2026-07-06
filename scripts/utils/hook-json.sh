#!/usr/bin/env bash
set -euo pipefail

plugin_root() {
  if [[ -n "${CLAUDE_PLUGIN_ROOT:-}" ]]; then
    printf '%s\n' "$CLAUDE_PLUGIN_ROOT"
    return 0
  fi

  cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd
}

json_field() {
  local input="$1"
  local field="$2"

  python3 -c '
import json
import sys

data = json.loads(sys.argv[1] or "{}")
value = data.get(sys.argv[2], "")
if value is None:
    value = ""
print(value)
' "$input" "$field"
}

state_json() {
  local status="$1"
  local session_id="$2"
  local tool="${3-}"

  python3 -c '
import json
import sys

status, session_id, tool = sys.argv[1], sys.argv[2], sys.argv[3]
state = {"status": status, "sessionId": session_id}
if tool:
    state["tool"] = tool
print(json.dumps(state, separators=(",", ":")))
' "$status" "$session_id" "$tool"
}
