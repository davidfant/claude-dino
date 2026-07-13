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

"$UTILS_DIR/state-manager.sh" write "$SESSION_ID" "$(hook_state_json "stopped" "$SESSION_ID")"
