#!/usr/bin/env bash
set -euo pipefail

PLUGIN_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
source "$PLUGIN_DIR/scripts/utils/hook-json.sh"

read_hook_input

SESSION_ID="$(hook_payload_string "session_id")"

"$PLUGIN_DIR/scripts/utils/tmux-manager.sh" kill "$SESSION_ID" || true
