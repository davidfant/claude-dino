#!/usr/bin/env bash
set -euo pipefail

PLUGIN_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
source "$PLUGIN_DIR/scripts/utils/hook-json.sh"

INPUT=$(cat)
SESSION_ID="$(printf '%s' "$INPUT" | json_get_field session_id)"

if [[ -z "$SESSION_ID" ]]; then
  exit 0
fi

STATE_JSON="$(json_build_state waiting_permission "$SESSION_ID")"
"$PLUGIN_DIR/scripts/utils/state-manager.sh" write "$SESSION_ID" "$STATE_JSON"
