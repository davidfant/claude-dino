#!/usr/bin/env bash
set -euo pipefail

PLUGIN_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
INPUT="$(</dev/stdin)"
SESSION_ID="$(printf '%s' "$INPUT" | "$PLUGIN_DIR/scripts/utils/hook-json.sh" field session_id)"
TOOL_NAME="$(printf '%s' "$INPUT" | "$PLUGIN_DIR/scripts/utils/hook-json.sh" field tool_name)"

if [[ -z "$SESSION_ID" ]]; then
  exit 0
fi

STATE_JSON="$("$PLUGIN_DIR/scripts/utils/hook-json.sh" state busy "$SESSION_ID" "$TOOL_NAME")"
"$PLUGIN_DIR/scripts/utils/state-manager.sh" write "$SESSION_ID" "$STATE_JSON"
