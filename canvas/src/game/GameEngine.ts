import { GameState, Obstacle as ObstacleType } from '../types.js';
import { ObstacleGenerator } from './ObstacleGenerator.js';
import { CollisionDetector } from './CollisionDetector.js';

export class GameEngine {
  private frameCount: number = 0;
  private scrollSpeed: number = 1;
  private groundDistance: number = 0; // Accumulated scroll distance for ground
  private gameState: GameState;
  private onUpdate: (state: GameState) => void;
  private obstacleGenerator: ObstacleGenerator;
  private screenWidth: number;

  // Jump animation constants
  private static readonly JUMP_DURATION = 30; // frames (0.5 seconds at 60fps)
  private static readonly JUMP_MAX_HEIGHT = 6; // screen lines

  constructor(onUpdate: (state: GameState) => void, screenWidth: number) {
    this.onUpdate = onUpdate;
    this.screenWidth = screenWidth;
    this.obstacleGenerator = new ObstacleGenerator(screenWidth);
    this.gameState = {
      dinoY: 0,
      isJumping: false,
      obstacles: [],
      score: 0,
      gameOver: false,
    };
  }

  update(isPaused: boolean = false) {
    // Don't update if game over or paused
    if (this.gameState.gameOver || isPaused) return;

    this.frameCount++;
    this.groundDistance += this.scrollSpeed; // Accumulate ground scroll distance

    // Update physics
    this.updatePhysics();

    // Spawn obstacles
    this.spawnObstacles();

    // Update obstacles
    this.updateObstacles();

    // Check collisions
    this.checkCollisions();

    // Update score
    if (this.frameCount % 10 === 0) {
      this.gameState.score++;

      // Gradually increase speed with each point
      this.increaseSpeed();

      // Adjust obstacle difficulty every 100 points
      if (this.gameState.score % 100 === 0) {
        this.obstacleGenerator.adjustDifficulty(this.gameState.score, this.scrollSpeed);
      }
    }

    this.onUpdate(this.gameState);
  }

  private updatePhysics() {
    if (this.gameState.isJumping && this.gameState.jumpStartFrame !== undefined) {
      const elapsed = this.frameCount - this.gameState.jumpStartFrame;
      const progress = elapsed / GameEngine.JUMP_DURATION;

      if (progress >= 1.0) {
        // Jump complete - land on ground
        this.gameState.dinoY = 0;
        this.gameState.isJumping = false;
        this.gameState.jumpStartFrame = undefined;
      } else {
        // Parabolic curve: y = -maxHeight * 4 * progress * (1 - progress)
        // This creates a smooth parabola that peaks at progress=0.5
        this.gameState.dinoY = -GameEngine.JUMP_MAX_HEIGHT * 4 * progress * (1 - progress);
      }
    }
  }

  private spawnObstacles() {
    if (this.obstacleGenerator.shouldSpawn(this.frameCount)) {
      const newObstacle = this.obstacleGenerator.generateObstacle();
      this.gameState.obstacles.push(newObstacle);
    }
  }

  private updateObstacles() {
    this.gameState.obstacles = this.gameState.obstacles
      .map(obs => ({ ...obs, x: obs.x - this.scrollSpeed }))
      .filter(obs => obs.x > -10);
  }

  private checkCollisions() {
    if (CollisionDetector.checkCollisionWithMargin(this.gameState, this.gameState.obstacles)) {
      // Create new object so React detects the state change
      this.gameState = { ...this.gameState, gameOver: true };
    }
  }

  jump() {
    if (!this.gameState.isJumping && !this.gameState.gameOver) {
      this.gameState.isJumping = true;
      this.gameState.jumpStartFrame = this.frameCount;
    }
  }

  getFrameCount(): number {
    return this.frameCount;
  }

  getScrollSpeed(): number {
    return this.scrollSpeed;
  }

  getGroundDistance(): number {
    return this.groundDistance;
  }

  increaseSpeed() {
    // Increase speed by 0.005 per point (0.5 per 100 points)
    this.scrollSpeed = Math.min(this.scrollSpeed + 0.005, 10);
  }

  getGameState(): GameState {
    return this.gameState;
  }

  reset() {
    this.frameCount = 0;
    this.scrollSpeed = 1;
    this.groundDistance = 0;
    // Reset the obstacle generator to start fresh
    this.obstacleGenerator = new ObstacleGenerator(this.screenWidth);
    this.gameState = {
      dinoY: 0,
      isJumping: false,
      obstacles: [],
      score: 0,
      gameOver: false,
    };
    this.onUpdate(this.gameState);
  }
}
