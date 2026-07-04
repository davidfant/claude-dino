#!/usr/bin/env bash
set -euo pipefail

json_get_field() {
  local field="$1"
  local input

  input="$(cat)"
  HOOK_JSON_INPUT="$input" HOOK_JSON_FIELD="$field" python3 - <<'PY'
import json
import os
import sys

try:
    payload = json.loads(os.environ["HOOK_JSON_INPUT"])
except json.JSONDecodeError:
    sys.exit(1)

value = payload.get(os.environ["HOOK_JSON_FIELD"], "")
if value is None:
    value = ""

print(value, end="")
PY
}

json_state() {
  local status="$1"
  local session_id="$2"
  shift 2

  python3 - "$status" "$session_id" "$@" <<'PY'
import json
import sys

payload = {
    "status": sys.argv[1],
    "sessionId": sys.argv[2],
}

if len(sys.argv) > 3:
    payload["tool"] = sys.argv[3]

print(json.dumps(payload, separators=(",", ":")))
PY
}
