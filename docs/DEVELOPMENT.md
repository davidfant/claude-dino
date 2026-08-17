# Development Guide

## Setup

1. Install dependencies:
```bash
cd canvas
bun install
```

2. Build the canvas:
```bash
bun run build
```

3. Test standalone:
```bash
bun run start test-session
```

## Development Workflow

### Testing Canvas Locally

Run the canvas without Claude Code:

```bash
cd canvas
bun run dev test-session
```

This will:
- Use the session ID "test-session"
- Poll `~/.claude/dino-state/test-session/state.json`
- Allow you to manually edit state files to test different scenarios

### Testing State Changes

Create test state files:

```bash
mkdir -p ~/.claude/dino-state/test-session

# Test "thinking" state
echo '{"status":"thinking","sessionId":"test-session"}' > ~/.claude/dino-state/test-session/state.json

# Test "busy" state with tool
echo '{"status":"busy","tool":"Write","sessionId":"test-session"}' > ~/.claude/dino-state/test-session/state.json
```

### Testing Hooks

Test individual hooks:

```bash
echo '{"session_id":"test","tool_name":"Write"}' | ./scripts/hooks/pre-tool-use.sh
cat ~/.claude/dino-state/test/state.json
```

### Debugging

Add console.log statements in canvas code - they'll appear in the tmux pane.

## File Modification Guide

### Adding New Sprites

Edit `canvas/src/utils/sprite-data.ts`:

```typescript
export const MY_SPRITE = [
  'line1',
  'line2',
];
```

### Modifying Game Physics

Edit `canvas/src/game/GameEngine.ts`:

- `JUMP_DURATION` - Jump length in frames
- `JUMP_MAX_HEIGHT` - Maximum jump height
- `increaseSpeed()` - Speed progression curve

### Adding New Hooks

1. Create script in `scripts/hooks/my-hook.sh`
2. Register in `hooks/hooks.json`:
   ```json
   {
     "MyHookName": "scripts/hooks/my-hook.sh"
   }
   ```

### Modifying Collision Detection

Edit `canvas/src/game/CollisionDetector.ts`:

- `COLLISION_MARGIN` - Forgiveness pixels
- `DINO_X`, `DINO_WIDTH`, `DINO_HEIGHT` - Dino hitbox
- Update logic in `checkCollisionWithMargin()`

## Building for Distribution

```bash
cd canvas
bun run build
```

This creates:
- `canvas/dist/index.js` - Bundled application
- `canvas/dist/yoga.wasm` - Required for Ink layout

## Common Issues

### Canvas Won't Start

1. Check tmux is running: `echo $TMUX`
2. Check bun is installed: `bun --version`
3. Check build exists: `ls canvas/dist/index.js`

### Hooks Not Firing

1. Verify hooks are executable: `chmod +x scripts/**/*.sh`
2. Test hook manually (see above)
3. Check plugin is loaded: `/help` should show `/dino-*` commands

### State Not Updating

1. Check state file exists: `ls ~/.claude/dino-state/<session-id>/`
2. Verify atomic writes working (no .tmp files lingering)
3. Check canvas is polling (add console.log to StatePoller)

## Code Style

- **TypeScript**: Strict mode, explicit types
- **React**: Functional components with hooks
- **Shell**: Set `-euo pipefail`, use functions
- **Naming**: camelCase for TS/JS, kebab-case for files

## Performance Tips

- Keep hook execution under 50ms
- Avoid synchronous I/O in game loop
- Use object spread for state updates (React detection)
- Minimize re-renders with proper dependencies

## Testing Checklist

- [ ] Game starts in tmux
- [ ] Jump works (space, enter, up arrow)
- [ ] Obstacles spawn and scroll
- [ ] Collision detection accurate
- [ ] Score increments
- [ ] High score persists
- [ ] Game over + restart works
- [ ] All hooks update state
- [ ] Multiple sessions isolated
