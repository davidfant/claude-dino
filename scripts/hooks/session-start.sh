#!/usr/bin/env bash
set -euo pipefail

PLUGIN_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
source "$PLUGIN_DIR/scripts/utils/hook-json.sh"

INPUT="$(read_hook_input)"
SESSION_ID="$(hook_json_field "$INPUT" "session_id")"

if [[ -z "$SESSION_ID" ]]; then
  exit 0
fi

STATE_JSON="$(hook_state_json "$SESSION_ID" "idle")"
"$PLUGIN_DIR/scripts/utils/state-manager.sh" write "$SESSION_ID" "$STATE_JSON"
