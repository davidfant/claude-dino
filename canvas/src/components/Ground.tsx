import { Box, Text } from "ink";
import React from "react";
import { GROUND_LINES } from "../utils/sprite-data.js";

interface GroundProps {
  groundDistance: number;
  width: number;
}

const Ground: React.FC<GroundProps> = ({ groundDistance, width }) => {
  return (
    <Box flexDirection="column">
      {GROUND_LINES.map((line, index) => {
        // Scrolling effect based on accumulated distance
        // Use accumulated distance directly (matches obstacle movement)
        const scrollOffset = Math.floor(groundDistance % line.length);
        // Repeat line enough times to ensure we always have scrollOffset + width chars
        // Need at least line.length + width characters (worst case: scrollOffset = line.length - 1)
        const repeatsNeeded = Math.ceil((line.length + width) / line.length);
        const repeatedLine = line.repeat(repeatsNeeded);
        const visibleLine = repeatedLine.slice(
          scrollOffset,
          scrollOffset + width
        );

        return (
          <Text key={index} color="#ba9b6a">
            {visibleLine}
          </Text>
        );
      })}
    </Box>
  );
};

export default Ground;
