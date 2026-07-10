#!/usr/bin/env bash
set -euo pipefail

PLUGIN_DIR="${CLAUDE_PLUGIN_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)}"
. "$PLUGIN_DIR/scripts/utils/hook-json.sh"

INPUT=$(cat)
SESSION_ID=$(printf '%s' "$INPUT" | json_get_field session_id)
TOOL_NAME=$(printf '%s' "$INPUT" | json_get_field tool_name)

"$PLUGIN_DIR/scripts/utils/state-manager.sh" write "$SESSION_ID" "$(json_state busy "$SESSION_ID" "$TOOL_NAME")"
