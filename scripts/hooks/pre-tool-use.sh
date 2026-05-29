#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

INPUT="$(read_hook_input)"
SESSION_ID="$(json_string_field "$INPUT" session_id)"
TOOL_NAME="$(json_string_field "$INPUT" tool_name)"

write_dino_state "$SESSION_ID" "busy" "$TOOL_NAME"
