#!/usr/bin/env bash
set -euo pipefail

SESSION_ID="${1:-default}"
PLUGIN_DIR="${CLAUDE_PLUGIN_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"
CANVAS_DIR="$PLUGIN_DIR/canvas"

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
  (
    cd "$CANVAS_DIR"
    bun install
    bun run build
  )
fi

# Create tmux pane with canvas
printf -v QUOTED_CANVAS_DIR "%q" "$CANVAS_DIR"
printf -v QUOTED_SESSION_ID "%q" "$SESSION_ID"
CANVAS_CMD="cd $QUOTED_CANVAS_DIR && bun run dist/index.js $QUOTED_SESSION_ID"
"$PLUGIN_DIR/scripts/utils/tmux-manager.sh" create "$SESSION_ID" "$CANVAS_CMD"

echo "Dino game started in split pane for session: $SESSION_ID"
