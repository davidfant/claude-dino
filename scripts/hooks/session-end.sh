#!/usr/bin/env bash
set -euo pipefail

PLUGIN_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
source "$PLUGIN_DIR/scripts/utils/hook-json.sh"

INPUT="$(read_hook_input)"
SESSION_ID="$(hook_json_value "$INPUT" "session_id" "default")"

# Optionally clean up the pane
"$PLUGIN_DIR/scripts/utils/tmux-manager.sh" kill "$SESSION_ID" || true
