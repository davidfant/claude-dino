---
description: Stop the Dino game and close the tmux pane
---

# Stop Dino Game

Gracefully shut down the canvas process and close the split pane.

## Your Task

Execute the following bash command:

```bash
cd ~/.claude/plugins/claude-dino && ./scripts/dino-shutdown.sh "$SESSION_ID"
```

This will kill the dino pane for the current session and clean up the tmux split.

After executing, confirm to the user that the game has been stopped.
