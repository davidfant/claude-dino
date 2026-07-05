# Claude Dino

A fun Chrome Dino-style game that runs in your terminal while using Claude Code. Jump over obstacles and rack up your high score!

https://github.com/user-attachments/assets/8e4a0218-0803-47fe-889e-ebdc2a6192b0

## Requirements

- [Bun](https://bun.sh) — used to run skill tools
- [tmux](https://github.com/tmux/tmux) — game spawns in a split pane

## Installation

Add this repository as a marketplace in Claude Code:

```
/plugin marketplace add davidfant/claude-dino
```

Then install the dino plugin:

```
/plugin install dino@claude-dino
```

## How to Play

**Important:** The game requires Claude Code to be running inside a tmux session. Start tmux first:

```bash
tmux
claude
```

Then start the game with:

```
/dino:start
```

Reset high scores with:

```
/dino:reset
```

## Plugin layout

- Plugin commands live in `canvas/commands` and are exposed as `/dino:start` and `/dino:reset`.
- Claude Code hooks are registered from `hooks/hooks.json` and execute scripts relative to `${CLAUDE_PLUGIN_ROOT}`.
- Runtime state is stored under `$HOME/.claude/dino-state/<session id>`.

## License

MIT
