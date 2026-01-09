import { Box, Text } from "ink";
import React from "react";
import { DINO_FRAMES } from "../utils/sprite-data.js";

interface DinoProps {
  isJumping: boolean;
  isRunning: boolean;
  frameCount: number;
  y: number;
  speed: number;
  gameOver?: boolean;
}

const Dino: React.FC<DinoProps> = ({
  isJumping,
  isRunning,
  frameCount,
  y,
  speed,
  gameOver,
}) => {
  let frame: keyof typeof DINO_FRAMES;

  // y is negative when jumping (going up), 0 when on ground
  // y is already in screen line units from parabola calculation
  const MAX_JUMP_LINES = 6;

  // Sub-line smoothing: round to nearest 0.5 for smoother animation
  const targetHeight = Math.abs(y);
  const roundedHeight = Math.round(targetHeight * 2) / 2; // Round to nearest 0.5
  const isHalfPosition = roundedHeight % 1 !== 0; // true if at .5 position
  const linesUp = Math.min(Math.floor(roundedHeight), MAX_JUMP_LINES);

  if (gameOver) {
    frame = "dead";
  } else if (isJumping) {
    // Use standingHalf for half positions (0.5 lines up), standing for whole positions
    frame = isHalfPosition ? "standingHalf" : "standing";
  } else if (isRunning) {
    // Only animate running when on ground - speed up animation as game speeds up
    const animationSpeed = 15 / speed;
    frame = Math.floor(frameCount / animationSpeed) % 2 === 0 ? "running1" : "running2";
  } else {
    // Idle
    frame = "standing";
  }

  const sprite = DINO_FRAMES[frame];

  // Calculate padding: when on ground (linesUp=0), all padding is ABOVE
  // When jumping (linesUp>0), move padding BELOW
  const paddingAbove = Math.max(0, MAX_JUMP_LINES - linesUp);
  const paddingBelow = Math.max(0, linesUp);

  return (
    <Box flexDirection="column">
      {/* Fixed padding above - decreases as dino jumps */}
      {Array(paddingAbove)
        .fill(null)
        .map((_, i) => (
          <Text key={`above-${i}`}> </Text>
        ))}

      {/* Render the dino sprite */}
      {sprite.map((line, i) => (
        <Text key={i} color={gameOver ? "red" : "green"}>
          {line}
        </Text>
      ))}

      {/* Padding below - increases as dino jumps */}
      {Array(paddingBelow)
        .fill(null)
        .map((_, i) => (
          <Text key={`below-${i}`}> </Text>
        ))}
    </Box>
  );
};

export default Dino;
