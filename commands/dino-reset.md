---
description: Reset high scores and clear game state
---

# Reset Dino High Scores

Deletes all saved high scores and state files for the current session.

## Your Task

Execute the following bash command:

```bash
rm -rf ~/.claude/dino-state/"$SESSION_ID" && echo "High scores and state reset for session: $SESSION_ID"
```

## What This Deletes

- High scores
- Game history
- State files

The next time the game starts, it will begin with a fresh slate.

After executing, confirm to the user that their scores have been reset.
