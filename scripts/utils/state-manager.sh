#!/usr/bin/env bash
set -euo pipefail

STATE_DIR="$HOME/.claude/dino-state"

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
    python3 -c '
import json
import sys

session_id = sys.argv[1]
state = {"status": "idle", "sessionId": session_id}

print(json.dumps(state, separators=(",", ":")))
' "$session_id"
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
