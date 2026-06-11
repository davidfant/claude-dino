#!/usr/bin/env bash
set -euo pipefail

read_hook_input() {
  local input
  input="$(</dev/stdin)"
  printf '%s' "$input"
}

hook_json_field() {
  local input="$1"
  local field="$2"

  printf '%s' "$input" | python3 -c '
import json
import sys

try:
    data = json.load(sys.stdin)
except json.JSONDecodeError:
    sys.exit(0)

value = data.get(sys.argv[1], "")
if value is None:
    value = ""
print(value)
' "$field"
}

hook_state_json() {
  local session_id="$1"
  local status="$2"
  local tool="${3:-}"

  SESSION_ID="$session_id" STATUS="$status" TOOL="$tool" python3 -c '
import json
import os

payload = {
    "status": os.environ["STATUS"],
    "sessionId": os.environ["SESSION_ID"],
}

tool = os.environ.get("TOOL", "")
if tool:
    payload["tool"] = tool

print(json.dumps(payload, separators=(",", ":")))
'
}
