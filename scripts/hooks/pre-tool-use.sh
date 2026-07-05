#!/usr/bin/env bash
set -euo pipefail

PLUGIN_DIR="${CLAUDE_PLUGIN_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)}"
source "$PLUGIN_DIR/scripts/utils/hook-json.sh"

INPUT="$(cat)"
SESSION_ID="$(json_get "$INPUT" session_id)"
SESSION_ID="${SESSION_ID:-default}"
TOOL_NAME="$(json_get "$INPUT" tool_name)"

"$PLUGIN_DIR/scripts/utils/state-manager.sh" write "$SESSION_ID" "$(json_state busy "$SESSION_ID" "$TOOL_NAME")"
