#!/usr/bin/env bash
set -euo pipefail

PLUGIN_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
source "$PLUGIN_DIR/scripts/utils/hook-json.sh"

INPUT="$(read_hook_input)"
SESSION_ID="$(hook_json_field "$INPUT" "session_id")"
TOOL_NAME="$(hook_json_field "$INPUT" "tool_name")"
STATE_JSON="$(hook_state_json "$SESSION_ID" "busy" "$TOOL_NAME")"

"$PLUGIN_DIR/scripts/utils/state-manager.sh" write "$SESSION_ID" "$STATE_JSON"
