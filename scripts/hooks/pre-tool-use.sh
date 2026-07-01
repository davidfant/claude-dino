#!/usr/bin/env bash
set -euo pipefail

PLUGIN_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
source "$PLUGIN_DIR/scripts/utils/hook-json.sh"

INPUT=$(cat)
SESSION_ID=$(json_field "$INPUT" "session_id")
TOOL_NAME=$(json_field "$INPUT" "tool_name")

"$PLUGIN_DIR/scripts/utils/state-manager.sh" write "$SESSION_ID" "$(state_json "busy" "$SESSION_ID" "$TOOL_NAME")"
