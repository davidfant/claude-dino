#!/usr/bin/env bash
set -euo pipefail

# Check tmux
if ! command -v tmux &> /dev/null; then
  echo "Error: tmux is not installed"
  echo "Install with: brew install tmux"
  exit 1
fi

# Check bun
if ! command -v bun &> /dev/null; then
  echo "Error: bun is not installed"
  echo "Install with: curl -fsSL https://bun.sh/install | bash"
  exit 1
fi

echo "All dependencies are installed"
