#!/usr/bin/env bash
set -euo pipefail

PLUGIN_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
INPUT=$(cat)
SESSION_ID=$(printf '%s' "$INPUT" | "$PLUGIN_DIR/scripts/utils/hook-json.sh" get session_id)
TOOL_NAME=$(printf '%s' "$INPUT" | "$PLUGIN_DIR/scripts/utils/hook-json.sh" get tool_name)
STATE=$("$PLUGIN_DIR/scripts/utils/hook-json.sh" state busy "$SESSION_ID" "$TOOL_NAME")

"$PLUGIN_DIR/scripts/utils/state-manager.sh" write "$SESSION_ID" "$STATE"
