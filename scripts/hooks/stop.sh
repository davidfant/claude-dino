#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../utils/hook-json.sh"

PLUGIN_DIR="$(resolve_plugin_dir)"
INPUT="$(cat)"
SESSION_ID="$(printf '%s' "$INPUT" | json_get_field session_id)"
STATE="$(json_state stopped "$SESSION_ID")"

"$PLUGIN_DIR/scripts/utils/state-manager.sh" write "$SESSION_ID" "$STATE"
