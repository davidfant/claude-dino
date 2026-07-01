#!/usr/bin/env bash
set -euo pipefail

STATE_DIR="$HOME/.claude/dino-state"

default_state_json() {
  local session_id="$1"

  python3 -c '
import json
import sys

payload = {
    "status": "idle",
    "sessionId": sys.argv[1],
}
print(json.dumps(payload, separators=(",", ":")))
' "$session_id"
}

write_state() {
  local session_id="$1"
  local json="$2"

  mkdir -p "$STATE_DIR/$session_id"

  # Atomic write using temp file + mv
  printf '%s\n' "$json" > "$STATE_DIR/$session_id/state.json.tmp"
  mv "$STATE_DIR/$session_id/state.json.tmp" "$STATE_DIR/$session_id/state.json"
}

read_state() {
  local session_id="$1"

  if [[ -f "$STATE_DIR/$session_id/state.json" ]]; then
    printf '%s\n' "$(< "$STATE_DIR/$session_id/state.json")"
  else
    default_state_json "$session_id"
  fi
}

# Handle command
case "${1:-}" in
  write)
    write_state "$2" "$3"
    ;;
  read)
    read_state "$2"
    ;;
  *)
    echo "Usage: $0 {write|read} <session_id> [json]"
    exit 1
    ;;
esac
