#!/usr/bin/env bash
set -euo pipefail

SESSION_ID="${1:-default}"
if [[ -n "${CLAUDE_PLUGIN_ROOT:-}" ]]; then
  PLUGIN_DIR="$CLAUDE_PLUGIN_ROOT"
else
  PLUGIN_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
fi

"$PLUGIN_DIR/scripts/utils/tmux-manager.sh" kill "$SESSION_ID"
