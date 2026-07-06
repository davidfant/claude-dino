#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../utils/hook-json.sh
source "$SCRIPT_DIR/../utils/hook-json.sh"

PLUGIN_DIR="$(plugin_root)"
INPUT="$(</dev/stdin)"
SESSION_ID="$(json_field "$INPUT" "session_id")"

# Optionally clean up the pane
"$PLUGIN_DIR/scripts/utils/tmux-manager.sh" kill "$SESSION_ID" || true
