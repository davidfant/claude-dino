#!/usr/bin/env bash
set -euo pipefail

PLUGIN_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
source "$PLUGIN_DIR/scripts/utils/hook-json.sh"

INPUT=$(cat)
SESSION_ID=$(extract_json_string_field "session_id" "$INPUT")
TOOL_NAME=$(extract_json_string_field "tool_name" "$INPUT")
SESSION_ID=${SESSION_ID:-default}
ESCAPED_SESSION_ID=$(json_escape "$SESSION_ID")
ESCAPED_TOOL_NAME=$(json_escape "$TOOL_NAME")

"$PLUGIN_DIR/scripts/utils/state-manager.sh" write "$SESSION_ID" '{"status":"busy","tool":"'"$ESCAPED_TOOL_NAME"'","sessionId":"'"$ESCAPED_SESSION_ID"'"}'
