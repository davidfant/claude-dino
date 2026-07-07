#!/usr/bin/env bash
set -euo pipefail

STATE_DIR="$HOME/.claude/dino-state"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HOOK_JSON="$SCRIPT_DIR/hook-json.sh"

write_state() {
  local session_id="$1"
  local json="$2"
  local session_dir="$STATE_DIR/$session_id"
  local temp_file
  
  mkdir -p "$session_dir"
  
  temp_file="$(mktemp "$session_dir/state.json.XXXXXX")"
  printf '%s\n' "$json" > "$temp_file"
  mv "$temp_file" "$session_dir/state.json"
}

read_state() {
  local session_id="$1"
  
  if [[ -f "$STATE_DIR/$session_id/state.json" ]]; then
    cat "$STATE_DIR/$session_id/state.json"
  else
    "$HOOK_JSON" state idle "$session_id"
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
