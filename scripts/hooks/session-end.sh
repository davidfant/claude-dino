#!/usr/bin/env bash
set -euo pipefail

PLUGIN_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
source "$PLUGIN_DIR/scripts/utils/hook-json.sh"

INPUT=$(cat)
SESSION_ID="$(hook_json_field "$INPUT" "session_id")"
SESSION_ID="${SESSION_ID:-default}"

# Optionally clean up the pane
"$PLUGIN_DIR/scripts/utils/tmux-manager.sh" kill "$SESSION_ID" || true
