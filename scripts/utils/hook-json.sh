#!/usr/bin/env bash
set -euo pipefail

HOOK_PAYLOAD=""

read_hook_payload() {
  HOOK_PAYLOAD="$(cat)"
  export HOOK_PAYLOAD
}

hook_json_get() {
  local key="$1"

  python3 - "$key" <<'PY'
import json
import os
import sys

key = sys.argv[1]
payload = os.environ.get("HOOK_PAYLOAD", "")

try:
    data = json.loads(payload) if payload else {}
except json.JSONDecodeError:
    data = {}

value = data.get(key, "")
if value is None:
    value = ""

print(str(value), end="")
PY
}

hook_state_json() {
  local status="$1"
  local session_id="$2"
  local tool="${3:-}"

  STATUS="$status" SESSION_ID="$session_id" TOOL_NAME="$tool" python3 <<'PY'
import json
import os

state = {
    "status": os.environ["STATUS"],
    "sessionId": os.environ["SESSION_ID"],
}

tool = os.environ.get("TOOL_NAME", "")
if tool:
    state["tool"] = tool

print(json.dumps(state, separators=(",", ":")))
PY
}

write_hook_state() {
  local session_id="$1"
  local status="$2"
  local tool="${3:-}"

  if [[ -z "$session_id" ]]; then
    return 0
  fi

  "$PLUGIN_DIR/scripts/utils/state-manager.sh" write "$session_id" "$(hook_state_json "$status" "$session_id" "$tool")"
}
