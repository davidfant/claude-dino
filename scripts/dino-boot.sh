#!/usr/bin/env bash
set -euo pipefail

SESSION_ID="${1:-default}"
PLUGIN_DIR="${CLAUDE_PLUGIN_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"
CANVAS_DIR="$PLUGIN_DIR/canvas"

shell_quote() {
  printf '%q' "$1"
}

# Check if in tmux
if [[ -z "${TMUX:-}" ]]; then
  echo "Error: Not in a tmux session. Please run tmux first."
  exit 1
fi

# Check dependencies
"$PLUGIN_DIR/scripts/check-deps.sh"

# Build canvas if needed
if [[ ! -f "$CANVAS_DIR/dist/index.js" ]]; then
  echo "Building canvas..."
  cd "$CANVAS_DIR"
  bun install
  bun run build
fi

# Create tmux pane with canvas
CANVAS_CMD="cd $(shell_quote "$CANVAS_DIR") && bun run dist/index.js $(shell_quote "$SESSION_ID")"
"$PLUGIN_DIR/scripts/utils/tmux-manager.sh" create "$SESSION_ID" "$CANVAS_CMD"

echo "Dino game started in split pane for session: $SESSION_ID"
