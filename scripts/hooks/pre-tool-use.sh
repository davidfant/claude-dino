#!/usr/bin/env bash
set -euo pipefail

PLUGIN_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
source "$PLUGIN_DIR/scripts/utils/hook-json.sh"

INPUT=$(cat)
SESSION_ID=$(dino_json_field "$INPUT" "session_id")
TOOL_NAME=$(dino_json_field "$INPUT" "tool_name")
STATE_JSON=$(dino_state_json "busy" "$SESSION_ID" "$TOOL_NAME")

"$PLUGIN_DIR/scripts/utils/state-manager.sh" write "$SESSION_ID" "$STATE_JSON"
