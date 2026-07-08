#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/hook-json.sh"

STATE_DIR="$HOME/.claude/dino-state"

write_state() {
  local session_id="$1"
  local json="$2"
  local session_dir="$STATE_DIR/$session_id"
  local tmp_file
  
  mkdir -p "$session_dir"
  
  # Atomic write using temp file + mv
  tmp_file="$(mktemp "$session_dir/state.json.tmp.XXXXXX")"
  printf '%s\n' "$json" > "$tmp_file"
  mv "$tmp_file" "$session_dir/state.json"
}

read_state() {
  local session_id="$1"
  
  if [[ -f "$STATE_DIR/$session_id/state.json" ]]; then
    cat "$STATE_DIR/$session_id/state.json"
  else
    json_make_state idle "$session_id"
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
