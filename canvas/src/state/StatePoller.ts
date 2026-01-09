import * as fs from 'fs';
import * as path from 'path';
import * as os from 'os';
import { DinoState } from '../types.js';

export class StatePoller {
  private stateFile: string;
  private lastState: DinoState;

  constructor(sessionId: string) {
    const stateDir = path.join(os.homedir(), '.claude', 'dino-state', sessionId);
    this.stateFile = path.join(stateDir, 'state.json');
    
    // Initialize with idle state
    this.lastState = {
      status: 'idle',
      sessionId,
    };

    // Ensure directory exists
    if (!fs.existsSync(stateDir)) {
      fs.mkdirSync(stateDir, { recursive: true });
    }
  }

  poll(): DinoState {
    try {
      if (fs.existsSync(this.stateFile)) {
        const content = fs.readFileSync(this.stateFile, 'utf-8');
        const state = JSON.parse(content) as DinoState;
        this.lastState = state;
        return state;
      }
    } catch (error) {
      // Ignore errors, return last known state
    }
    
    return this.lastState;
  }

  getLastState(): DinoState {
    return this.lastState;
  }
}
