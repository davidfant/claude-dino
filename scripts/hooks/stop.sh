#!/usr/bin/env bash
set -euo pipefail

PLUGIN_DIR="${CLAUDE_PLUGIN_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)}"
# shellcheck source=../utils/hook-json.sh
source "$PLUGIN_DIR/scripts/utils/hook-json.sh"

INPUT=$(cat)
SESSION_ID=$(hook_json_field "$INPUT" "session_id")

"$PLUGIN_DIR/scripts/utils/state-manager.sh" write "$SESSION_ID" "$(hook_state_json "stopped" "$SESSION_ID")"
