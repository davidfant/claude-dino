Start the Dino runner game in a tmux split pane.

Launches the Claude Dino canvas in a new tmux pane below your current session (30% height). The game animates based on Claude's real-time activity and allows you to play during idle moments.

Usage: `/dino-start`

Requirements:
- Must be running inside a tmux session
- Bun runtime must be installed

The game will:
- Display in a split pane below your current session
- Run continuously while Claude is active
- Animate the dino based on Claude's status (thinking, busy, idle)
- Track your high scores across sessions

Controls:
- SPACE, ENTER, or UP ARROW: Jump / Restart after game over

---exec
./scripts/dino-boot.sh "$SESSION_ID"
---
