import { GameState, Obstacle } from "../types.js";

export class CollisionDetector {
  // Dino is at fixed x=5, has width ~15 chars, height 9 lines
  private static readonly DINO_X = 5;
  private static readonly DINO_WIDTH = 15;
  private static readonly DINO_HEIGHT = 9;

  // Collision margin for forgiveness (higher = more forgiving)
  private static readonly COLLISION_MARGIN = 3;

  static checkCollisionWithMargin(
    gameState: GameState,
    obstacles: Obstacle[]
  ): boolean {
    // Calculate dino bounding box matching the rendering logic in GameCanvas
    const MAX_JUMP_LINES = 6;
    const targetHeight = Math.abs(gameState.dinoY);
    const roundedHeight = Math.round(targetHeight * 2) / 2;
    const linesUp = Math.min(Math.floor(roundedHeight), MAX_JUMP_LINES);
    const paddingAbove = Math.max(0, MAX_JUMP_LINES - linesUp);

    const dinoTop = paddingAbove;
    const dinoBottom = paddingAbove + CollisionDetector.DINO_HEIGHT;
    const dinoLeft =
      CollisionDetector.DINO_X + CollisionDetector.COLLISION_MARGIN;
    const dinoRight =
      CollisionDetector.DINO_X +
      CollisionDetector.DINO_WIDTH -
      CollisionDetector.COLLISION_MARGIN;

    for (const obstacle of obstacles) {
      // Obstacle bounding box (ground level, extends upward)
      const obsTop = 10; // paddingAbove in GameCanvas rendering
      const obsBottom = obsTop + obstacle.height;
      const obsLeft =
        Math.floor(obstacle.x) + CollisionDetector.COLLISION_MARGIN;
      const obsRight =
        Math.floor(obstacle.x) +
        obstacle.width -
        CollisionDetector.COLLISION_MARGIN;

      // AABB collision detection
      const collisionX = dinoRight > obsLeft && dinoLeft < obsRight;
      const collisionY = dinoBottom > obsTop && dinoTop < obsBottom;

      if (collisionX && collisionY) {
        return true;
      }
    }

    return false;
  }
}
