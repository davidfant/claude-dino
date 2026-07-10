#!/usr/bin/env bash
set -euo pipefail

STATE_DIR="$HOME/.claude/dino-state"
PLUGIN_DIR="${CLAUDE_PLUGIN_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)}"
. "$PLUGIN_DIR/scripts/utils/hook-json.sh"

write_state() {
  local session_id="$1"
  local json="$2"
  local tmp_file
  
  mkdir -p "$STATE_DIR/$session_id"
  
  # Atomic write using temp file + mv
  tmp_file="$(mktemp "$STATE_DIR/$session_id/state.json.XXXXXX")"
  printf '%s\n' "$json" > "$tmp_file"
  mv "$tmp_file" "$STATE_DIR/$session_id/state.json"
}

read_state() {
  local session_id="$1"
  
  if [[ -f "$STATE_DIR/$session_id/state.json" ]]; then
    cat "$STATE_DIR/$session_id/state.json"
  else
    json_state idle "$session_id"
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
