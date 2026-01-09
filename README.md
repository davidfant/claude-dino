# Claude Dino Canvas

A Chrome Dino-style runner game that runs in your terminal alongside Claude Code sessions. Built with Ink, React, and Bun.

## Features

- 🦖 Full Dino runner game with smooth jump physics and collision detection
- 🎮 Play during Claude's idle time or whenever you want
- 📊 High score tracking across sessions
- 🎨 Animated ASCII art with scrolling ground
- ⚡ Real-time synchronization with Claude's activity
- 🖥️ Runs in a tmux split pane below your main session

## Requirements

- **tmux** >= 3.0
- **bun** >= 1.0
- **Claude Code** CLI

## Installation

1. Clone or copy the plugin to `~/.claude/plugins/`:

```bash
ln -s /path/to/claude-dino ~/.claude/plugins/claude-dino
```

2. Install canvas dependencies:

```bash
cd ~/.claude/plugins/claude-dino/canvas
bun install
bun run build
```

3. Restart Claude Code to load the plugin.

## Usage

### Starting the Game

From within a Claude Code session (in tmux):

```
/dino-start
```

This creates a split pane below (30% height) with the game running.

### Controls

- **SPACE**, **ENTER**, or **UP ARROW**: Jump / Restart after game over
- The game runs continuously while you work with Claude

### Other Commands

- `/dino-stop` - Stop the game and close the pane
- `/dino-status` - Check if game is running
- `/dino-reset` - Reset high scores

## How It Works

1. **Hooks**: Plugin hooks capture Claude events (prompts, tool use, etc.)
2. **State Files**: Hooks write JSON state to `~/.claude/dino-state/<session-id>/`
3. **Canvas**: Bun process polls state files and updates game animation
4. **tmux**: Game runs in a persistent split pane below your session

## Development

```bash
# Test the canvas standalone
cd canvas
bun run start test-session

# Build after changes
bun run build
```

## Architecture

- **Canvas**: Ink + React for terminal UI
- **Game Engine**: 60 FPS game loop with parabolic jump physics
- **State Management**: JSON file-based IPC
- **Hooks**: Shell scripts triggered by Claude events
- **Display**: tmux split pane integration

## License

MIT
