#!/usr/bin/env bash
set -euo pipefail

STATE_DIR="$HOME/.claude/dino-state"

json_escape() {
  local value="${1:-}"
  value="${value//\\/\\\\}"
  value="${value//\"/\\\"}"
  value="${value//$'\n'/\\n}"
  value="${value//$'\r'/\\r}"
  value="${value//$'\t'/\\t}"
  printf '%s' "$value"
}

write_state() {
  local session_id="$1"
  local json="$2"

  mkdir -p "$STATE_DIR/$session_id"

  # Atomic write using temp file + mv
  echo "$json" > "$STATE_DIR/$session_id/state.json.tmp"
  mv "$STATE_DIR/$session_id/state.json.tmp" "$STATE_DIR/$session_id/state.json"
}

write_status() {
  local session_id="$1"
  local status="$2"
  local tool="${3:-}"
  local json

  if [[ -n "$tool" ]]; then
    json='{"status":"'"$(json_escape "$status")"'","tool":"'"$(json_escape "$tool")"'","sessionId":"'"$(json_escape "$session_id")"'"}'
  else
    json='{"status":"'"$(json_escape "$status")"'","sessionId":"'"$(json_escape "$session_id")"'"}'
  fi

  write_state "$session_id" "$json"
}

read_state() {
  local session_id="$1"

  if [[ -f "$STATE_DIR/$session_id/state.json" ]]; then
    cat "$STATE_DIR/$session_id/state.json"
  else
    echo '{"status":"idle","sessionId":"'"$(json_escape "$session_id")"'"}'
  fi
}

# Handle command
case "${1:-}" in
  write)
    write_state "$2" "$3"
    ;;
  status)
    write_status "$2" "$3" "${4:-}"
    ;;
  read)
    read_state "$2"
    ;;
  *)
    echo "Usage: $0 {write|status|read} <session_id> [json|status] [tool]"
    exit 1
    ;;
esac
