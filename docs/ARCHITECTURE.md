# Architecture

## Overview

Claude Dino Canvas is a terminal-based game that visualizes Claude Code's activity through an interactive Dino runner. It uses a multi-process architecture with JSON-based IPC.

## Components

### 1. Plugin System
- **Location**: `.claude-plugin/plugin.json`
- **Purpose**: Registers commands and hooks with Claude Code
- **Commands**: `/dino-start`, `/dino-stop`, `/dino-status`, `/dino-reset`
- **Hooks**: 7 event handlers (prompt, tool use, session lifecycle)

### 2. Hooks (Shell Scripts)
- **Location**: `scripts/hooks/*.sh`
- **Purpose**: Capture Claude events and write state
- **Execution**: Non-blocking (<50ms), triggered by Claude Code
- **Output**: Writes JSON to `~/.claude/dino-state/<session-id>/state.json`

### 3. Canvas (Ink + React)
- **Location**: `canvas/src/`
- **Runtime**: Bun
- **Purpose**: Game rendering and logic
- **Components**:
  - `App.tsx` - Root component, manages state polling
  - `GameCanvas.tsx` - Main game rendering with absolute positioning
  - `GameEngine.ts` - 60 FPS game loop, physics, collision
  - `StatePoller.ts` - Polls state files every 100ms

### 4. tmux Integration
- **Purpose**: Display game in split pane
- **Manager**: `scripts/utils/tmux-manager.sh`
- **Behavior**: Creates 30% height pane below, idempotent

## Data Flow

```
Claude Event → Hook Script → Atomic State Write → Canvas Polls (100ms) → React Update
                                                     ↓
                                              Game Loop (60 FPS)
                                                     ↓
                                        Physics → Obstacles → Collision → Render
```

## State Management

### State File Format
```json
{
  "status": "thinking" | "busy" | "idle" | "waiting_permission" | "stopped",
  "tool": "optional tool name",
  "sessionId": "unique session identifier"
}
```

### Atomic Writes
```bash
echo "$json" > state.json.tmp
mv state.json.tmp state.json  # Atomic rename
```

## Game Engine

### Physics
- **Jump**: Parabolic motion with time-based formula
- **Duration**: 30 frames (0.5 seconds at 60 FPS)
- **Height**: 6 screen lines maximum
- **Formula**: `y = -maxHeight * 4 * progress * (1 - progress)`

### Scrolling
- **Ground**: Accumulated distance tracking
- **Obstacles**: Continuous x-position updates
- **Speed**: Starts at 1.0, increases by 0.005 per point (max 10x)

### Collision
- **Method**: AABB (Axis-Aligned Bounding Box)
- **Forgiveness**: 2-pixel margin on all sides
- **Detection**: Per-frame check against all visible obstacles

## Performance

- **Frame Rate**: 60 FPS (16ms per frame)
- **State Polling**: 100ms (10 Hz)
- **Hook Execution**: <50ms per event
- **Memory**: ~20MB for canvas process

## File Structure

```
claude-dino/
├── .claude-plugin/
│   └── plugin.json          # Plugin registration
├── canvas/
│   ├── src/
│   │   ├── components/      # React UI components
│   │   ├── game/            # Game logic (engine, collision, obstacles)
│   │   ├── state/           # State polling
│   │   └── utils/           # Sprites, colors, terminal size
│   └── package.json         # Ink + React dependencies
├── scripts/
│   ├── hooks/               # Event handlers
│   └── utils/               # State + tmux management
├── commands/                # Slash command definitions
└── hooks/
    └── hooks.json           # Hook registration
```
