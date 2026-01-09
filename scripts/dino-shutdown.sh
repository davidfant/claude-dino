#!/usr/bin/env bash
set -euo pipefail

SESSION_ID="${1:-default}"
PLUGIN_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

"$PLUGIN_DIR/scripts/utils/tmux-manager.sh" kill "$SESSION_ID"
