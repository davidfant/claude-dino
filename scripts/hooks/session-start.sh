#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../utils/hook-json.sh
source "$SCRIPT_DIR/../utils/hook-json.sh"

PLUGIN_DIR="$(plugin_root)"
INPUT="$(</dev/stdin)"
SESSION_ID="$(json_field "$INPUT" "session_id")"

"$PLUGIN_DIR/scripts/utils/state-manager.sh" write "$SESSION_ID" "$(state_json "idle" "$SESSION_ID")"
