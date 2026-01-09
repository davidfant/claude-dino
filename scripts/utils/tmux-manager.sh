#!/usr/bin/env bash
set -euo pipefail

PANE_NAME_PREFIX="dino-canvas"

get_pane_id() {
  local session_id="$1"
  local pane_name="${PANE_NAME_PREFIX}-${session_id}"
  
  tmux list-panes -a -F "#{pane_id} #{pane_title}" 2>/dev/null | \
    grep "$pane_name" | \
    awk '{print $1}' || true
}

create_pane() {
  local session_id="$1"
  local command="$2"
  local pane_name="${PANE_NAME_PREFIX}-${session_id}"
  
  # Check if pane already exists
  if [[ -n "$(get_pane_id "$session_id")" ]]; then
    echo "Dino pane already exists for session: $session_id"
    return 0
  fi
  
  # Create new pane (30% height below)
  tmux split-window -v -p 30 -P -F "#{pane_id}" "$command"
  
  # Set pane title (requires tmux 3.0+)
  tmux select-pane -T "$pane_name"
}

kill_pane() {
  local session_id="$1"
  local pane_id
  pane_id="$(get_pane_id "$session_id")"
  
  if [[ -n "$pane_id" ]]; then
    tmux kill-pane -t "$pane_id"
    echo "Killed dino pane: $pane_id"
  else
    echo "No dino pane found for session: $session_id"
  fi
}

check_pane() {
  local session_id="$1"
  local pane_id
  pane_id="$(get_pane_id "$session_id")"
  
  if [[ -n "$pane_id" ]]; then
    echo "Dino pane is running: $pane_id"
  else
    echo "Dino pane is not running"
  fi
}

# Handle command
case "${1:-}" in
  create)
    create_pane "$2" "$3"
    ;;
  kill)
    kill_pane "$2"
    ;;
  check)
    check_pane "$2"
    ;;
  get)
    get_pane_id "$2"
    ;;
  *)
    echo "Usage: $0 {create|kill|check|get} <session_id> [command]"
    exit 1
    ;;
esac
