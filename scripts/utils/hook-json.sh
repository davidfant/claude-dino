#!/usr/bin/env bash
set -euo pipefail

json_get() {
  local json="$1"
  local key="$2"

  HOOK_JSON="$json" python3 - "$key" <<'PY'
import json
import os
import sys

key = sys.argv[1]

try:
    value = json.loads(os.environ["HOOK_JSON"])
except json.JSONDecodeError:
    sys.exit(0)

for part in key.split("."):
    if not isinstance(value, dict) or part not in value:
        sys.exit(0)
    value = value[part]

if value is None:
    sys.exit(0)

if isinstance(value, (dict, list)):
    print(json.dumps(value, separators=(",", ":")))
else:
    print(value)
PY
}

json_build_state() {
  local status="$1"
  local session_id="$2"
  local tool="${3:-}"

  STATUS="$status" SESSION_ID="$session_id" TOOL="$tool" python3 - <<'PY'
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
PY
}

hook_session_id() {
  local input="$1"
  local session_id

  session_id="$(json_get "$input" "session_id")"
  printf '%s\n' "${session_id:-default}"
}
