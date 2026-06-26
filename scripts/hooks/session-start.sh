#!/usr/bin/env bash
set -euo pipefail

PLUGIN_DIR="${CLAUDE_PLUGIN_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)}"
source "$PLUGIN_DIR/scripts/utils/hook-json.sh"

INPUT=$(cat)
SESSION_ID=$(hook_json_get "$INPUT" "session_id")
STATE_JSON=$(hook_state_json "idle" "$SESSION_ID")

mkdir -p "$HOME/.claude/dino-state/$SESSION_ID"
"$PLUGIN_DIR/scripts/utils/state-manager.sh" write "$SESSION_ID" "$STATE_JSON"
