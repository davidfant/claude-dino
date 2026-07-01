#!/usr/bin/env bash

json_field() {
  local input="$1"
  local field="$2"

  JSON_INPUT="$input" python3 - "$field" <<'PY'
import json
import os
import sys

try:
    data = json.loads(os.environ["JSON_INPUT"])
except json.JSONDecodeError:
    print("")
    raise SystemExit(0)

value = data.get(sys.argv[1], "")
if value is None:
    print("")
elif isinstance(value, str):
    print(value)
else:
    print(json.dumps(value, separators=(",", ":")))
PY
}

state_json() {
  local status="$1"
  local session_id="$2"
  local tool="${3-}"
  local argc="$#"

  STATUS="$status" SESSION_ID="$session_id" TOOL="$tool" python3 - "$argc" <<'PY'
import json
import os
import sys

payload = {"status": os.environ["STATUS"]}
if int(sys.argv[1]) >= 3:
    payload["tool"] = os.environ["TOOL"]
payload["sessionId"] = os.environ["SESSION_ID"]

print(json.dumps(payload, separators=(",", ":")))
PY
}
