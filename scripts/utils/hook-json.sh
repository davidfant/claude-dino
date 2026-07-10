#!/usr/bin/env bash

json_get_field() {
  local field="$1"

  python3 -c 'import json, sys
data = json.load(sys.stdin)
value = data.get(sys.argv[1], "")
print("" if value is None else value)' "$field"
}

json_state() {
  local status="$1"
  local session_id="$2"
  local tool="${3:-}"

  python3 -c 'import json, sys
status, session_id, tool = sys.argv[1], sys.argv[2], sys.argv[3]
state = {"status": status, "sessionId": session_id}
if tool:
    state["tool"] = tool
print(json.dumps(state, separators=(",", ":")))' "$status" "$session_id" "$tool"
}
