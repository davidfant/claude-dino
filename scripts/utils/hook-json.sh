#!/usr/bin/env bash

dino_json_field() {
  local input="$1"
  local field="$2"

  DINO_JSON_INPUT="$input" python3 - "$field" <<'PY'
import json
import os
import sys

field = sys.argv[1]
payload = json.loads(os.environ["DINO_JSON_INPUT"])
value = payload.get(field, "")

if value is None:
    value = ""
elif not isinstance(value, str):
    value = str(value)

print(value)
PY
}

dino_state_json() {
  local status="$1"
  local session_id="$2"
  local tool="${3-}"

  if [[ $# -ge 3 ]]; then
    python3 - "$status" "$session_id" "$tool" <<'PY'
import json
import sys

print(json.dumps({
    "status": sys.argv[1],
    "tool": sys.argv[3],
    "sessionId": sys.argv[2],
}, separators=(",", ":")))
PY
  else
    python3 - "$status" "$session_id" <<'PY'
import json
import sys

print(json.dumps({
    "status": sys.argv[1],
    "sessionId": sys.argv[2],
}, separators=(",", ":")))
PY
  fi
}
