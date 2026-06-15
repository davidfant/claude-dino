#!/usr/bin/env bash
set -euo pipefail

PLUGIN_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
source "$PLUGIN_DIR/scripts/utils/hook-json.sh"

INPUT="$(cat)"
SESSION_ID="$(hook_session_id "$INPUT")"
TOOL_NAME="$(json_get_string "$INPUT" "tool_name")"
STATE="$(state_json "busy" "$SESSION_ID" "$TOOL_NAME")"

"$PLUGIN_DIR/scripts/utils/state-manager.sh" write "$SESSION_ID" "$STATE"
