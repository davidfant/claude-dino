#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../utils/hook-json.sh"

PLUGIN_DIR="$(resolve_plugin_dir)"
INPUT="$(cat)"
SESSION_ID="$(printf '%s' "$INPUT" | json_get_field session_id)"

# Optionally clean up the pane
"$PLUGIN_DIR/scripts/utils/tmux-manager.sh" kill "$SESSION_ID" || true
