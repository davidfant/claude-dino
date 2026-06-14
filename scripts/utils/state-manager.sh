#!/usr/bin/env bash
set -euo pipefail

STATE_DIR="$HOME/.claude/dino-state"

default_state_json() {
  local session_id="$1"

  if command -v python3 >/dev/null 2>&1; then
    SESSION_ID="$session_id" python3 -c '
import json
import os

print(json.dumps({"status": "idle", "sessionId": os.environ["SESSION_ID"]}, separators=(",", ":")))
'
    return
  fi

  local escaped_session_id
  escaped_session_id=${session_id//\\/\\\\}
  escaped_session_id=${escaped_session_id//\"/\\\"}
  printf '{"status":"idle","sessionId":"%s"}\n' "$escaped_session_id"
}

write_state() {
  local session_id="$1"
  local json="$2"
  
  mkdir -p "$STATE_DIR/$session_id"
  
  # Atomic write using temp file + mv
  echo "$json" > "$STATE_DIR/$session_id/state.json.tmp"
  mv "$STATE_DIR/$session_id/state.json.tmp" "$STATE_DIR/$session_id/state.json"
}

read_state() {
  local session_id="$1"
  
  if [[ -f "$STATE_DIR/$session_id/state.json" ]]; then
    cat "$STATE_DIR/$session_id/state.json"
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
