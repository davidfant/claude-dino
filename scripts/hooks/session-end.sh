#!/usr/bin/env bash
set -euo pipefail

PLUGIN_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
INPUT=$(cat)
SESSION_ID=$(printf '%s' "$INPUT" | "$PLUGIN_DIR/scripts/utils/hook-json.sh" get session_id)

# Optionally clean up the pane
"$PLUGIN_DIR/scripts/utils/tmux-manager.sh" kill "$SESSION_ID" || true
