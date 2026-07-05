#!/usr/bin/env bash
set -euo pipefail

if [[ -n "${CLAUDE_PLUGIN_ROOT:-}" ]]; then
  PLUGIN_DIR="$CLAUDE_PLUGIN_ROOT"
else
  PLUGIN_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
fi

source "$PLUGIN_DIR/scripts/utils/hook-json.sh"

INPUT="$(cat)"
SESSION_ID="$(json_get "$INPUT" "session_id")"
TOOL_NAME="$(json_get "$INPUT" "tool_name")"

"$PLUGIN_DIR/scripts/utils/state-manager.sh" write "$SESSION_ID" "$(json_state "busy" "$SESSION_ID" "$TOOL_NAME")"
