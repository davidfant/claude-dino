# Claude Dino

A fun Chrome Dino-style game that runs in your terminal while using Claude Code. Jump over obstacles and rack up your high score!

**Note:** This is a proof of concept and is unsupported.

![Claude Dino Demo](assets/claude-dino.mp4)

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

## License

MIT
