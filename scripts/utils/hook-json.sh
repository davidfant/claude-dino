#!/usr/bin/env bash

extract_json_string_field() {
  local key="$1"
  local input="$2"

  if command -v python3 >/dev/null 2>&1; then
    JSON_INPUT="$input" JSON_KEY="$key" python3 - <<'PY'
import json
import os

try:
    data = json.loads(os.environ["JSON_INPUT"])
    value = data.get(os.environ["JSON_KEY"], "")
    if isinstance(value, str):
        print(value, end="")
except Exception:
    pass
PY
    return
  fi

  printf '%s' "$input" | sed -nE 's/.*"'"$key"'"[[:space:]]*:[[:space:]]*"([^"]*)".*/\1/p'
}

json_escape() {
  local value="$1"

  if command -v python3 >/dev/null 2>&1; then
    JSON_VALUE="$value" python3 - <<'PY'
import json
import os

print(json.dumps(os.environ["JSON_VALUE"])[1:-1], end="")
PY
    return
  fi

  value=${value//\\/\\\\}
  value=${value//\"/\\\"}
  value=${value//$'\n'/\\n}
  value=${value//$'\r'/\\r}
  value=${value//$'\t'/\\t}

  printf '%s' "$value"
}
