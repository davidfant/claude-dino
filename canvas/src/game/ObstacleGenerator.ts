import { Obstacle } from '../types.js';

export class ObstacleGenerator {
  private lastSpawnFrame: number = 0;
  private minSpawnInterval: number = 45; // ~0.75 seconds at 60fps
  private maxSpawnInterval: number = 90; // ~1.5 seconds
  private nextSpawnFrame: number;
  private screenWidth: number;

  constructor(screenWidth: number) {
    this.screenWidth = screenWidth;
    this.nextSpawnFrame = 30; // Start spawning after 0.5 seconds
  }

  private getRandomSpawnInterval(): number {
    return Math.floor(
      Math.random() * (this.maxSpawnInterval - this.minSpawnInterval) + this.minSpawnInterval
    );
  }

  shouldSpawn(frameCount: number): boolean {
    if (frameCount >= this.nextSpawnFrame) {
      this.lastSpawnFrame = frameCount;
      this.nextSpawnFrame = frameCount + this.getRandomSpawnInterval();
      return true;
    }
    return false;
  }

  generateObstacle(): Obstacle {
    // Spawn obstacles at the right edge of the screen
    const spawnX = this.screenWidth - 4;

    // Only generate cacti - vary size for variety
    const size = Math.random() > 0.5 ? 'large' : 'small';
    return {
      x: spawnX,
      y: 0, // Ground level
      width: size === 'large' ? 10 : 6,
      height: size === 'large' ? 5 : 5,
      type: 'cactus',
    };
  }

  adjustDifficulty(score: number) {
    // Increase spawn rate as score increases
    const difficultyFactor = Math.min(score / 500, 0.5);
    this.minSpawnInterval = Math.max(45, 70 - difficultyFactor * 25);
    this.maxSpawnInterval = Math.max(90, 135 - difficultyFactor * 45);
  }
}
