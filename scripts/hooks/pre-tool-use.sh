#!/usr/bin/env bash
set -euo pipefail

PLUGIN_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
source "$PLUGIN_DIR/scripts/utils/hook-json.sh"

INPUT="$(</dev/stdin)"
SESSION_ID="$(json_get_field session_id <<< "$INPUT")"
SESSION_ID="${SESSION_ID:-default}"
TOOL_NAME="$(json_get_field tool_name <<< "$INPUT")"

"$PLUGIN_DIR/scripts/utils/state-manager.sh" write "$SESSION_ID" "$(json_state busy "$SESSION_ID" "$TOOL_NAME")"
