#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

# Optionally clean up the pane
INPUT="$(read_hook_input)"
SESSION_ID="$(json_string_field "$INPUT" session_id)"

if [[ -z "$SESSION_ID" ]]; then
  warn_missing_session_id
  exit 0
fi

"$PLUGIN_DIR/scripts/utils/tmux-manager.sh" kill "$SESSION_ID" || true
