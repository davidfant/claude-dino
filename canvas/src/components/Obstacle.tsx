import { Box, Text } from "ink";
import React from "react";

interface ObstacleProps {
  x: number;
  type: "cactus";
  sprite: string[];
}

const Obstacle: React.FC<ObstacleProps> = ({ sprite }) => {
  return (
    <Box flexDirection="column">
      {sprite.map((line, i) => (
        <Text key={i} color="green">
          {line}
        </Text>
      ))}
    </Box>
  );
};

export default Obstacle;
