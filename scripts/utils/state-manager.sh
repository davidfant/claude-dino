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
    python3 - "$STATE_DIR/$session_id/state.json" <<'PY'
from pathlib import Path
import sys

print(Path(sys.argv[1]).read_text(), end="")
PY
  else
    python3 - "$session_id" <<'PY'
import json
import sys

print(json.dumps({"status": "idle", "sessionId": sys.argv[1]}, separators=(",", ":")))
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
