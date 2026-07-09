#!/usr/bin/env bash
set -euo pipefail

PLUGIN_DIR="${CLAUDE_PLUGIN_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)}"
HOOK_JSON="$PLUGIN_DIR/scripts/utils/hook-json.sh"
INPUT=$(cat)
SESSION_ID=$(printf '%s' "$INPUT" | "$HOOK_JSON" field session_id)
TOOL_NAME=$(printf '%s' "$INPUT" | "$HOOK_JSON" field tool_name)
STATE_JSON=$("$HOOK_JSON" state busy "$SESSION_ID" "$TOOL_NAME")

"$PLUGIN_DIR/scripts/utils/state-manager.sh" write "$SESSION_ID" "$STATE_JSON"
