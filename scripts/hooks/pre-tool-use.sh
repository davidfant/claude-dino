#!/usr/bin/env bash
set -euo pipefail

PLUGIN_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
source "$PLUGIN_DIR/scripts/utils/hook-json.sh"

read_hook_payload
SESSION_ID="$(hook_json_get session_id)"
TOOL_NAME="$(hook_json_get tool_name)"

write_hook_state "$SESSION_ID" busy "$TOOL_NAME"
