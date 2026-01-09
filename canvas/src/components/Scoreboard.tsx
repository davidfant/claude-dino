import { Box, Text } from "ink";
import React from "react";

interface ScoreboardProps {
  currentScore: number;
  highScore: number;
}

const Scoreboard: React.FC<ScoreboardProps> = ({ currentScore, highScore }) => {
  return (
    <Box flexDirection="column" alignItems="flex-end">
      <Box>
        <Text dimColor>HI </Text>
        <Text bold color="magenta">
          {String(highScore).padStart(5, "0")}
        </Text>
      </Box>
      <Box>
        <Text dimColor>SC </Text>
        <Text bold color="cyan">
          {String(currentScore).padStart(5, "0")}
        </Text>
      </Box>
    </Box>
  );
};

export default Scoreboard;
