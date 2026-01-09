Reset high scores and clear game state.

Deletes all saved high scores and state files for the current session.

Usage: `/dino-reset`

---exec
rm -rf ~/.claude/dino-state/"$SESSION_ID"
echo "High scores and state reset for session: $SESSION_ID"
---
