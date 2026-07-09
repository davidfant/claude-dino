#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLUGIN_DIR="${CLAUDE_PLUGIN_ROOT:-$(cd "$SCRIPT_DIR/../.." && pwd)}"
# shellcheck source=../utils/hook-json.sh
source "$PLUGIN_DIR/scripts/utils/hook-json.sh"

INPUT=$(cat)
SESSION_ID=$(json_field "$INPUT" "session_id")

"$PLUGIN_DIR/scripts/utils/state-manager.sh" write "$SESSION_ID" "$(state_json "stopped" "$SESSION_ID")"
