#!/usr/bin/env bash
set -euo pipefail

PLUGIN_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
source "$PLUGIN_DIR/scripts/utils/hook-json.sh"

INPUT="$(</dev/stdin)"
SESSION_ID="$(hook_json_get_field "$INPUT" "session_id")"
STATE_JSON="$(hook_json_state "idle" "$SESSION_ID")"

"$PLUGIN_DIR/scripts/utils/state-manager.sh" write "$SESSION_ID" "$STATE_JSON"
