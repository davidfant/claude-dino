#!/usr/bin/env bash
set -euo pipefail

PLUGIN_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
INPUT="$(</dev/stdin)"
SESSION_ID="$(printf '%s' "$INPUT" | "$PLUGIN_DIR/scripts/utils/hook-json.sh" field session_id)"

if [[ -z "$SESSION_ID" ]]; then
  exit 0
fi

# Optionally clean up the pane
"$PLUGIN_DIR/scripts/utils/tmux-manager.sh" kill "$SESSION_ID" || true
