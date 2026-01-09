import * as fs from 'fs';
import * as path from 'path';
import * as os from 'os';

interface ScoreData {
  highScore: number;
  games: Array<{ score: number; timestamp: number }>;
}

export class ScoreManager {
  private scoreFile: string;
  private data: ScoreData;

  constructor(sessionId: string) {
    const stateDir = path.join(os.homedir(), '.claude', 'dino-state', sessionId);
    this.scoreFile = path.join(stateDir, 'scores.json');
    
    // Ensure directory exists
    if (!fs.existsSync(stateDir)) {
      fs.mkdirSync(stateDir, { recursive: true });
    }

    // Load existing scores or initialize
    this.data = this.loadScores();
  }

  private loadScores(): ScoreData {
    try {
      if (fs.existsSync(this.scoreFile)) {
        const content = fs.readFileSync(this.scoreFile, 'utf-8');
        const data = JSON.parse(content);
        // Ensure games array exists (backward compatibility)
        if (!data.games) {
          data.games = [];
        }
        return data;
      }
    } catch (error) {
      console.error('Error loading scores:', error);
    }

    return { highScore: 0, games: [] };
  }

  private saveScores(): void {
    try {
      fs.writeFileSync(this.scoreFile, JSON.stringify(this.data, null, 2));
    } catch (error) {
      console.error('Error saving scores:', error);
    }
  }

  recordGame(score: number): void {
    this.data.games.push({
      score,
      timestamp: Date.now(),
    });

    if (score > this.data.highScore) {
      this.data.highScore = score;
    }

    this.saveScores();
  }

  getHighScore(): number {
    return this.data.highScore;
  }

  resetScores(): void {
    this.data = { highScore: 0, games: [] };
    this.saveScores();
  }
}
