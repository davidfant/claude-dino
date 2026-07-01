#!/usr/bin/env bash
set -euo pipefail

PLUGIN_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
source "$PLUGIN_DIR/scripts/utils/hook-json.sh"

INPUT=$(cat)
SESSION_ID=$(dino_json_field "$INPUT" "session_id")
STATE_JSON=$(dino_state_json "idle" "$SESSION_ID")

mkdir -p "$HOME/.claude/dino-state/$SESSION_ID"
"$PLUGIN_DIR/scripts/utils/state-manager.sh" write "$SESSION_ID" "$STATE_JSON"
