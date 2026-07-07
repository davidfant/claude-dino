#!/usr/bin/env bash

hook_json_field() {
  local payload="$1"
  local field="$2"

  HOOK_JSON_PAYLOAD="$payload" HOOK_JSON_FIELD="$field" python3 - <<'PY'
import json
import os
import sys

try:
    payload = json.loads(os.environ.get("HOOK_JSON_PAYLOAD", "{}"))
except json.JSONDecodeError:
    sys.exit(0)

value = payload.get(os.environ["HOOK_JSON_FIELD"], "")
if value is None:
    value = ""

print(value)
PY
}

hook_state_json() {
  python3 - "$@" <<'PY'
import json
import sys

args = sys.argv[1:]
if len(args) % 2 != 0:
    raise SystemExit("hook_state_json requires key/value pairs")

state = {}
for index in range(0, len(args), 2):
    state[args[index]] = args[index + 1]

print(json.dumps(state, separators=(",", ":")))
PY
}
