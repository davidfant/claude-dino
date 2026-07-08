#!/usr/bin/env bash
set -euo pipefail

PLUGIN_DIR="${CLAUDE_PLUGIN_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)}"
source "$PLUGIN_DIR/scripts/utils/hook-json.sh"

INPUT="$(cat)"
SESSION_ID="$(json_field "$INPUT" session_id)"

"$PLUGIN_DIR/scripts/utils/state-manager.sh" write "$SESSION_ID" "$(state_json thinking "$SESSION_ID")"
