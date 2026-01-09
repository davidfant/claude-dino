---
description: Check if the Dino game is currently running
---

# Check Dino Game Status

Shows the status of the canvas process and tmux pane.

## Your Task

Execute the following bash command:

```bash
cd ~/.claude/plugins/claude-dino && ./scripts/utils/tmux-manager.sh check "$SESSION_ID"
```

This will report whether the dino pane is currently running for this session.

After executing, relay the status information to the user.
