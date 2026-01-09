import { Box, Text, useInput } from "ink";
import React, { useEffect, useRef, useState } from "react";
import { GameEngine } from "../game/GameEngine.js";
import { ScoreManager } from "../game/ScoreManager.js";
import { DinoState, GameState } from "../types.js";
import { COLORS } from "../utils/colors.js";
import {
  CACTUS_LARGE,
  CACTUS_SMALL,
  DINO_FRAMES,
} from "../utils/sprite-data.js";
import Ground from "./Ground.js";
import Scoreboard from "./Scoreboard.js";

interface GameCanvasProps {
  claudeState: DinoState;
  width: number;
  height: number;
  sessionId: string;
}

const GameCanvas: React.FC<GameCanvasProps> = ({
  claudeState,
  width,
  height,
  sessionId,
}) => {
  const [gameState, setGameState] = useState<GameState>({
    dinoY: 0,
    isJumping: false,
    obstacles: [],
    score: 0,
    gameOver: false,
  });

  const [engine] = useState(() => new GameEngine(setGameState, width));
  const [scoreManager] = useState(() => new ScoreManager(sessionId));
  const [frameCount, setFrameCount] = useState(0);
  const [highScore, setHighScore] = useState(scoreManager.getHighScore());
  const [showGameOver, setShowGameOver] = useState(false);
  const [isNewHighScore, setIsNewHighScore] = useState(false);
  const [, forceUpdate] = useState(0);
  const gameOverTimestamp = useRef<number | null>(null);

  useEffect(() => {
    const interval = setInterval(() => {
      // Only update if game hasn't started yet OR if game is running (not game over)
      const isPaused = gameState.gameOver;
      engine.update(isPaused);
      setFrameCount(engine.getFrameCount());
    }, 16);

    return () => clearInterval(interval);
  }, [engine, gameState.gameOver]);

  useEffect(() => {
    if (gameState.gameOver && !showGameOver) {
      setShowGameOver(true);
      gameOverTimestamp.current = Date.now();

      // Check if it's a new high score BEFORE recording
      const isNew = gameState.score > highScore && gameState.score > 0;
      setIsNewHighScore(isNew);

      // Record the game and update high score
      scoreManager.recordGame(gameState.score);
      const newHighScore = scoreManager.getHighScore();
      setHighScore(newHighScore);
    }
  }, [
    gameState.gameOver,
    showGameOver,
    scoreManager,
    gameState.score,
    highScore,
  ]);

  // Force re-render during game over cooldown to update UI message
  useEffect(() => {
    if (showGameOver) {
      const interval = setInterval(() => {
        // Force re-render to update the canRestart calculation
        forceUpdate((n) => n + 1);
      }, 100);

      return () => clearInterval(interval);
    }
  }, [showGameOver]);

  useInput((input, key) => {
    if (key.return || key.upArrow || input === " ") {
      if (gameState.gameOver) {
        // Only allow restart after 1-second cooldown
        const timeSinceCrash = gameOverTimestamp.current
          ? Date.now() - gameOverTimestamp.current
          : Infinity;
        if (timeSinceCrash >= 1000) {
          // Reset engine first, then hide overlay to avoid visual glitch
          engine.reset();
          gameOverTimestamp.current = null;
          setIsNewHighScore(false);
          setShowGameOver(false);
        }
      } else {
        engine.jump();
      }
    }
  });

  // Dino runs whenever game is active (not game over)
  const isRunning = !gameState.gameOver;

  // Calculate if restart is allowed (1 second after crash)
  const timeSinceCrash = gameOverTimestamp.current
    ? Date.now() - gameOverTimestamp.current
    : Infinity;
  const canRestart = timeSinceCrash >= 1000;

  return (
    <Box flexDirection="column">
      {/* Header with scoreboard */}
      <Box justifyContent="space-between" marginBottom={1}>
        <Text bold color="gray">
          CLAUDE DINO
        </Text>
        <Scoreboard
          currentScore={gameState.score}
          highScore={highScore}
          isNewHighScore={isNewHighScore}
        />
      </Box>

      {/* Game area - simplified without absolute positioning */}
      <Box flexDirection="column">
        <Box flexDirection="column">
          {/* Render obstacles and dino together - use absolute positioning */}
          <Box flexDirection="column">
            {/* Create a container with space characters for absolute positioning */}
            {(() => {
              const trackWidth = width - 4;
              const lines: Array<
                Array<string | { char: string; color: string }>
              > = Array(15)
                .fill(null)
                .map(() => new Array(trackWidth).fill(" "));

              // Position dino at x=5
              const dinoSprite = (() => {
                // Get dino sprite lines based on state (copied from Dino.tsx logic)
                const MAX_JUMP_LINES = 6;
                const targetHeight = Math.abs(gameState.dinoY);
                const roundedHeight = Math.round(targetHeight * 2) / 2;
                const isHalfPosition = roundedHeight % 1 !== 0;
                const linesUp = Math.min(
                  Math.floor(roundedHeight),
                  MAX_JUMP_LINES
                );
                const paddingAbove = Math.max(0, MAX_JUMP_LINES - linesUp);

                let frameName;
                if (gameState.gameOver) {
                  frameName = "dead";
                } else if (gameState.isJumping) {
                  frameName = isHalfPosition ? "standingHalf" : "standing";
                } else if (isRunning) {
                  const animationSpeed = 15 / engine.getScrollSpeed();
                  frameName =
                    Math.floor(frameCount / animationSpeed) % 2 === 0
                      ? "running1"
                      : "running2";
                } else {
                  frameName = "standing";
                }

                const sprite =
                  DINO_FRAMES[frameName as keyof typeof DINO_FRAMES];
                return { sprite, paddingAbove };
              })();

              // Render dino at x=5
              const dinoX = 5;
              const dinoColor = gameState.gameOver
                ? COLORS.dino.dead
                : COLORS.dino.alive;
              dinoSprite.sprite.forEach((line, lineIdx) => {
                const y = dinoSprite.paddingAbove + lineIdx;
                for (
                  let i = 0;
                  i < line.length && dinoX + i < trackWidth;
                  i++
                ) {
                  if (line[i] !== " ") {
                    lines[y][dinoX + i] = { char: line[i], color: dinoColor };
                  }
                }
              });

              // Render cacti at their absolute positions
              gameState.obstacles.forEach((obs) => {
                const obsX = Math.floor(obs.x);
                if (obsX >= 0 && obsX < trackWidth) {
                  const cactusSprite =
                    obs.width > 6 ? CACTUS_LARGE : CACTUS_SMALL;
                  const paddingAbove = 10;

                  cactusSprite.forEach((line, lineIdx) => {
                    const y = paddingAbove + lineIdx;
                    for (
                      let i = 0;
                      i < line.length && obsX + i < trackWidth;
                      i++
                    ) {
                      if (line[i] !== " ") {
                        lines[y][obsX + i] = {
                          char: line[i],
                          color: COLORS.obstacle.cactus,
                        };
                      }
                    }
                  });
                }
              });

              return lines.map((line, lineIdx) => {
                // Group consecutive characters by color
                const segments: Array<{ text: string; color?: string }> = [];
                let currentSegment = {
                  text: "",
                  color: undefined as string | undefined,
                };

                line.forEach((cell) => {
                  const char = typeof cell === "string" ? cell : cell.char;
                  const color =
                    typeof cell === "string" ? undefined : cell.color;

                  if (color === currentSegment.color) {
                    currentSegment.text += char;
                  } else {
                    if (currentSegment.text) segments.push(currentSegment);
                    currentSegment = { text: char, color };
                  }
                });
                if (currentSegment.text) segments.push(currentSegment);

                return (
                  <Text key={lineIdx}>
                    {segments.map((seg, i) =>
                      seg.color ? (
                        <Text key={i} color={seg.color}>
                          {seg.text}
                        </Text>
                      ) : (
                        <React.Fragment key={i}>{seg.text}</React.Fragment>
                      )
                    )}
                  </Text>
                );
              });
            })()}
          </Box>
        </Box>

        <Box>
          <Ground groundDistance={engine.getGroundDistance()} width={width - 4} />
        </Box>

        {/* Game Over overlay */}
        {showGameOver ? (
          <Box
            borderStyle="double"
            borderColor="red"
            marginTop={4}
            padding={2}
            justifyContent="center"
            alignItems="center"
          >
            <Box flexDirection="column" alignItems="center">
              <Text bold color="red">
                💀 GAME OVER 💀
              </Text>
              <Text> </Text>
              <Box>
                <Text>Final Score: </Text>
                <Text bold color="cyan">
                  {gameState.score}
                </Text>
              </Box>
              {isNewHighScore && (
                <>
                  <Text> </Text>
                  <Text bold color="green">
                    🌟 NEW HIGH SCORE! 🌟
                  </Text>
                </>
              )}
              <Text> </Text>
              <Text dimColor>
                {canRestart
                  ? "Press ENTER, SPACE or UP ARROW to restart!"
                  : "Wait to restart..."}
              </Text>
            </Box>
          </Box>
        ) : (
          <Box marginTop={4} justifyContent="center">
            <Text dimColor>
              Controls: ENTER, SPACE or UP ARROW to jump | Claude Status:{" "}
              {claudeState.status}
            </Text>
          </Box>
        )}
      </Box>
    </Box>
  );
};

export default GameCanvas;
