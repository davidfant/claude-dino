---
description: Start the Dino runner game in a tmux split pane
---

# Start Dino Game

Launch the Claude Dino canvas game in a new tmux pane below your current session.

## Your Task

Execute the following bash command:

```bash
cd ~/.claude/plugins/claude-dino && ./scripts/dino-boot.sh "$SESSION_ID"
```

## What This Does

The game will:

- Display in a split pane below (40 lines tall)
- Run continuously while Claude is active
- Animate based on Claude's status (thinking, busy, idle)
- Track high scores across sessions

## Controls

- **SPACE**, **ENTER**, or **UP ARROW**: Jump / Restart after game over

## Requirements

- Must be running inside a tmux session
- Bun runtime must be installed
- Canvas must be built

After executing, inform the user the game has started successfully.
