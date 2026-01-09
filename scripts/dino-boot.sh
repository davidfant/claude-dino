#!/usr/bin/env bash
set -euo pipefail

SESSION_ID="${1:-default}"
PLUGIN_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Check if in tmux
if [[ -z "${TMUX:-}" ]]; then
  echo "Error: Not in a tmux session. Please run tmux first."
  exit 1
fi

# Check dependencies
"$PLUGIN_DIR/scripts/check-deps.sh"

# Build canvas if needed
if [[ ! -f "$PLUGIN_DIR/canvas/dist/index.js" ]]; then
  echo "Building canvas..."
  cd "$PLUGIN_DIR/canvas"
  bun install
  bun run build
fi

# Create tmux pane with canvas
CANVAS_CMD="cd $PLUGIN_DIR/canvas && bun run dist/index.js $SESSION_ID"
"$PLUGIN_DIR/scripts/utils/tmux-manager.sh" create "$SESSION_ID" "$CANVAS_CMD"

echo "Dino game started in split pane for session: $SESSION_ID"
