#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../utils/hook-json.sh
source "$SCRIPT_DIR/../utils/hook-json.sh"

PLUGIN_DIR="$(plugin_root)"
INPUT="$(</dev/stdin)"
SESSION_ID="$(json_field "$INPUT" "session_id")"
TOOL_NAME="$(json_field "$INPUT" "tool_name")"

"$PLUGIN_DIR/scripts/utils/state-manager.sh" write "$SESSION_ID" "$(state_json "busy" "$SESSION_ID" "$TOOL_NAME")"
