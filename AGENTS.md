# AGENTS.md

## Cloud-specific instructions

### Project overview

Claude Dino is a Chrome Dino-style terminal runner game built with Bun, React, and Ink. It renders in a tmux split pane and visualizes Claude Code activity. See `README.md` for full details.

### Prerequisites

- **Bun** (JS/TS runtime) — installed via `curl -fsSL https://bun.sh/install | bash`; binary lands in `~/.bun/bin/bun`.
- **tmux** (>=3.0) — pre-installed on the VM.

Bun is added to PATH via `~/.bashrc`. If running commands in a non-login shell, ensure `~/.bun/bin` is on PATH:
```
export PATH="$HOME/.bun/bin:$PATH"
```

### Key commands

| Task | Command | Working directory |
|---|---|---|
| Install deps | `bun install` | `canvas/` |
| Dev mode | `bun run dev <session-id>` | `canvas/` |
| Build | `bun run build` | `canvas/` |
| Run built app | `bun run start <session-id>` | `canvas/` |
| Type check | `npx tsc --noEmit` | `canvas/` |

Root `package.json` also has convenience scripts: `install-canvas`, `build-canvas`, `test-canvas`.

### Caveats

- **Ink requires a TTY for keyboard input.** Running `bun run dev` outside tmux or a real terminal will render the initial frame but crash with "Raw mode is not supported." This is expected. Always test interactively inside a tmux session.
- **No ESLint or Prettier** is configured; the only lint-style check is `npx tsc --noEmit` for TypeScript type checking.
- **State polling:** The game reads JSON state from `~/.claude/dino-state/<session-id>/state.json`. To test without Claude Code, create a mock state file:
  ```
  mkdir -p ~/.claude/dino-state/test-session
  echo '{"status":"thinking","sessionId":"test-session"}' > ~/.claude/dino-state/test-session/state.json
  ```
- **No lockfile** exists in the repo. `bun install` resolves latest compatible versions each time.
