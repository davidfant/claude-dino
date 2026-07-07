#!/usr/bin/env bash
set -euo pipefail

PLUGIN_DIR="${CLAUDE_PLUGIN_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)}"
HOOK_JSON="$PLUGIN_DIR/scripts/utils/hook-json.sh"
INPUT=$(cat)
SESSION_ID=$("$HOOK_JSON" field "$INPUT" session_id)
TOOL_NAME=$("$HOOK_JSON" field "$INPUT" tool_name)

"$PLUGIN_DIR/scripts/utils/state-manager.sh" write "$SESSION_ID" "$("$HOOK_JSON" state busy "$SESSION_ID" "$TOOL_NAME")"
