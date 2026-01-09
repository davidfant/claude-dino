import { Box, Text } from "ink";
import React from "react";

interface ScoreboardProps {
  currentScore: number;
  highScore: number;
  isNewHighScore: boolean;
}

const Scoreboard: React.FC<ScoreboardProps> = ({
  currentScore,
  highScore,
  isNewHighScore,
}) => {
  return (
    <Box flexDirection="column" alignItems="flex-end">
      <Box>
        <Text dimColor>HI </Text>
        <Text bold color="cyan">
          {String(highScore).padStart(5, "0")}
        </Text>
      </Box>
      <Box>
        <Text dimColor>SC </Text>
        <Text bold color={isNewHighScore ? "green" : "cyan"}>
          {String(currentScore).padStart(5, "0")}
        </Text>
        {isNewHighScore && <Text color="green"> 🌟</Text>}
      </Box>
    </Box>
  );
};

export default Scoreboard;
