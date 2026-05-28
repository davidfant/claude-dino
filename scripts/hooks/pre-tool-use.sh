#!/usr/bin/env bash
set -euo pipefail

PLUGIN_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
source "$PLUGIN_DIR/scripts/utils/json.sh"

INPUT=$(cat)
SESSION_ID=$(require_json_string_field "$INPUT" "session_id") || exit 0
TOOL_NAME=$(json_string_field "$INPUT" "tool_name")
SESSION_JSON=$(json_escape_string "$SESSION_ID")
TOOL_JSON=$(json_escape_string "$TOOL_NAME")

"$PLUGIN_DIR/scripts/utils/state-manager.sh" write "$SESSION_ID" '{"status":"busy","tool":"'"$TOOL_JSON"'","sessionId":"'"$SESSION_JSON"'"}'
