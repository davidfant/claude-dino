import { Box, Text } from "ink";
import React from "react";
import { DinoState } from "../types.js";
import { getClaudeStatusColor } from "../utils/colors.js";

interface StatusBarProps {
  score: number;
  claudeState: DinoState;
  speed: number;
  gameOver: boolean;
}

const StatusBar: React.FC<StatusBarProps> = ({
  score,
  claudeState,
  speed,
  gameOver,
}) => {
  const statusColor = getClaudeStatusColor(claudeState.status);

  return (
    <Box justifyContent="space-between">
      <Box>
        <Text color={gameOver ? "red" : "cyan"}>
          {gameOver ? "💀 " : ""}Score: {score}
        </Text>
      </Box>
      <Box>
        <Text color={statusColor}>{claudeState.status}</Text>
        {claudeState.tool && (
          <Text dimColor> ({claudeState.tool})</Text>
        )}
      </Box>
      <Box>
        <Text dimColor>Speed: {speed.toFixed(1)}x</Text>
      </Box>
    </Box>
  );
};

export default StatusBar;
