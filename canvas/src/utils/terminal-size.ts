export interface TerminalSize {
  columns: number;
  rows: number;
}

export function getTerminalSize(): TerminalSize {
  return {
    columns: process.stdout.columns || 80,
    rows: process.stdout.rows || 24,
  };
}
