#!/usr/bin/env bash
set -euo pipefail

PLUGIN_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
source "$PLUGIN_DIR/scripts/utils/hook-json.sh"

INPUT=$(cat)
SESSION_ID="$(hook_json_get "$INPUT" session_id)"

if [[ -z "$SESSION_ID" ]]; then
  exit 0
fi

STATE_JSON="$(hook_state_json waiting_permission "$SESSION_ID")"
"$PLUGIN_DIR/scripts/utils/state-manager.sh" write "$SESSION_ID" "$STATE_JSON"
