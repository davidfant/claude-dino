---
description: Reset high scores and clear game state
---

# Reset Dino High Scores

Deletes all saved high scores and state files for the current session.

## Your Task

Execute the following bash command:

```bash
session_id="${CLAUDE_CODE_SESSION_ID:-${SESSION_ID:-default}}"
rm -rf "$HOME/.claude/dino-state/$session_id" && echo "High scores and state reset for session: $session_id"
```

## What This Deletes

- High scores
- Game history
- State files

The next time the game starts, it will begin with a fresh slate.

After executing, confirm to the user that their scores have been reset.
