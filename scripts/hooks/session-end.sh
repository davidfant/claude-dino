#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
UTILS_DIR="$(cd "$SCRIPT_DIR/../utils" && pwd)"

. "$UTILS_DIR/hook-json.sh"

INPUT=$(cat)
SESSION_ID="$(hook_json_get "$INPUT" "session_id")"

if [[ -z "$SESSION_ID" ]]; then
  exit 0
fi

# Optionally clean up the pane
"$UTILS_DIR/tmux-manager.sh" kill "$SESSION_ID" || true
