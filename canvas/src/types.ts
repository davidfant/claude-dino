export interface DinoState {
  status: string;
  tool?: string;
  sessionId: string;
}

export interface GameState {
  dinoY: number;
  isJumping: boolean;
  jumpStartFrame?: number;
  obstacles: Obstacle[];
  score: number;
  gameOver: boolean;
}

export interface Obstacle {
  x: number;
  y: number;
  width: number;
  height: number;
  type: 'cactus';
}
