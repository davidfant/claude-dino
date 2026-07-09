#!/usr/bin/env bash
set -euo pipefail

PLUGIN_DIR="${CLAUDE_PLUGIN_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)}"
HOOK_JSON="$PLUGIN_DIR/scripts/utils/hook-json.sh"
INPUT=$(cat)
SESSION_ID=$(printf '%s' "$INPUT" | "$HOOK_JSON" field session_id)
STATE_JSON=$("$HOOK_JSON" state thinking "$SESSION_ID")

"$PLUGIN_DIR/scripts/utils/state-manager.sh" write "$SESSION_ID" "$STATE_JSON"
