#!/usr/bin/env bash
set -euo pipefail

STATE_DIR="$HOME/.claude/dino-state"

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
    cat "$STATE_DIR/$session_id/state.json"
  else
    DINO_SESSION_ID="$session_id" python3 - <<'PY'
import json
import os

print(json.dumps({"status": "idle", "sessionId": os.environ["DINO_SESSION_ID"]}, separators=(",", ":")))
PY
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
