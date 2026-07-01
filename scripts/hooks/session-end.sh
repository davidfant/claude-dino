#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLUGIN_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"
source "$PLUGIN_DIR/scripts/utils/hook-json.sh"

INPUT="$(read_hook_json)"
SESSION_ID="$(json_field "$INPUT" "session_id")"

"$PLUGIN_DIR/scripts/utils/tmux-manager.sh" kill "$SESSION_ID" || true
