#!/usr/bin/env bash
set -euo pipefail

SESSION_ID="${1:-default}"
PLUGIN_DIR="${CLAUDE_PLUGIN_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"

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
printf -v CANVAS_DIR '%q' "$PLUGIN_DIR/canvas"
printf -v SESSION_ARG '%q' "$SESSION_ID"
CANVAS_CMD="cd $CANVAS_DIR && bun run dist/index.js $SESSION_ARG"
"$PLUGIN_DIR/scripts/utils/tmux-manager.sh" create "$SESSION_ID" "$CANVAS_CMD"

echo "Dino game started in split pane for session: $SESSION_ID"
