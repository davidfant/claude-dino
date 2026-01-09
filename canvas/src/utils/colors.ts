export const COLORS = {
  dino: {
    alive: "default",
    dead: "gray",
  },
  obstacle: {
    cactus: "green",
  },
  ui: {
    primary: "cyan",
    secondary: "magenta",
    success: "green",
    warning: "yellow",
    danger: "red",
    muted: "gray",
  },
  claude: {
    idle: "cyan",
    thinking: "yellow",
    busy: "green",
    waiting: "magenta",
    stopped: "gray",
  },
};

export function getClaudeStatusColor(status: string): string {
  switch (status) {
    case "thinking":
      return COLORS.claude.thinking;
    case "busy":
      return COLORS.claude.busy;
    case "waiting_permission":
      return COLORS.claude.waiting;
    case "stopped":
      return COLORS.claude.stopped;
    default:
      return COLORS.claude.idle;
  }
}
