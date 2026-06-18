#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STATE_DIR="$HOME/.claude/dino-state"
source "$SCRIPT_DIR/hook-json.sh"

write_state() {
  local session_id="$1"
  local json="$2"

  local session_dir="$STATE_DIR/$session_id"
  mkdir -p "$session_dir"

  # Atomic write using temp file + mv
  printf '%s\n' "$json" > "$session_dir/state.json.tmp"
  mv "$session_dir/state.json.tmp" "$session_dir/state.json"
}

read_state() {
  local session_id="$1"

  local session_dir="$STATE_DIR/$session_id"
  if [[ -f "$session_dir/state.json" ]]; then
    cat "$session_dir/state.json"
  else
    json_build_state "idle" "$session_id"
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
