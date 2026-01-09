import { Obstacle } from "../types.js";

export class ObstacleGenerator {
  private lastSpawnFrame: number = 0;
  private minSpawnInterval: number = 45; // ~1.2 seconds at 60fps
  private maxSpawnInterval: number = 90; // ~2.25 seconds
  private nextSpawnFrame: number;
  private screenWidth: number;

  constructor(screenWidth: number) {
    this.screenWidth = screenWidth;
    this.nextSpawnFrame = 60; // Start spawning after 1 second
  }

  private getRandomSpawnInterval(): number {
    return Math.floor(
      Math.random() * (this.maxSpawnInterval - this.minSpawnInterval) +
        this.minSpawnInterval
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
    const size = Math.random() > 0.5 ? "large" : "small";
    return {
      x: spawnX,
      y: 0, // Ground level
      width: size === "large" ? 10 : 6,
      height: size === "large" ? 5 : 5,
      type: "cactus",
    };
  }

  adjustDifficulty(score: number, scrollSpeed: number) {
    // Scale spawn intervals inversely with speed to maintain obstacle density
    // As speed increases, we need to spawn more frequently to keep the same spacing
    const speedFactor = 1 / scrollSpeed;

    // Base intervals decrease with score
    const baseMin = 45;
    const baseMax = 90;
    const difficultyFactor = Math.min(score / 1000, 0.4);

    this.minSpawnInterval = Math.max(
      30,
      (baseMin - difficultyFactor * 30) * speedFactor
    );
    this.maxSpawnInterval = Math.max(
      50,
      (baseMax - difficultyFactor * 50) * speedFactor
    );
  }
}
