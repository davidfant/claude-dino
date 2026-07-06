#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../utils/hook-json.sh"

PLUGIN_DIR="$(resolve_plugin_dir)"
INPUT="$(cat)"
SESSION_ID="$(printf '%s' "$INPUT" | json_get_field session_id)"
TOOL_NAME="$(printf '%s' "$INPUT" | json_get_field tool_name)"
STATE="$(json_state busy "$SESSION_ID" "$TOOL_NAME")"

"$PLUGIN_DIR/scripts/utils/state-manager.sh" write "$SESSION_ID" "$STATE"
