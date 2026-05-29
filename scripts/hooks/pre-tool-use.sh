#!/usr/bin/env bash
set -euo pipefail

PLUGIN_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
source "$PLUGIN_DIR/scripts/utils/hook-input.sh"

INPUT=$(cat)
SESSION_ID="$(require_session_id "$INPUT")" || exit 0
TOOL_NAME="$(extract_json_string "$INPUT" "tool_name")"

"$PLUGIN_DIR/scripts/utils/state-manager.sh" status "$SESSION_ID" "busy" "$TOOL_NAME"
