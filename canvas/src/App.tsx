import { Box, Text } from "ink";
import React, { useEffect, useState } from "react";
import GameCanvas from "./components/GameCanvas.js";
import { StatePoller } from "./state/StatePoller.js";
import { DinoState } from "./types.js";
import { getTerminalSize } from "./utils/terminal-size.js";

interface AppProps {
  sessionId: string;
}

const App: React.FC<AppProps> = ({ sessionId }) => {
  const [statePoller] = useState(() => new StatePoller(sessionId));
  const [claudeState, setClaudeState] = useState<DinoState>(
    statePoller.getLastState()
  );
  const [terminalSize, setTerminalSize] = useState(getTerminalSize());

  // Poll for Claude state changes
  useEffect(() => {
    const interval = setInterval(() => {
      const newState = statePoller.poll();
      setClaudeState(newState);
    }, 100);

    return () => clearInterval(interval);
  }, [statePoller]);

  // Update terminal size on resize
  useEffect(() => {
    const handleResize = () => {
      setTerminalSize(getTerminalSize());
    };

    process.stdout.on("resize", handleResize);
    return () => {
      process.stdout.off("resize", handleResize);
    };
  }, []);

  return (
    <Box flexDirection="column" padding={1}>
      <GameCanvas
        claudeState={claudeState}
        width={terminalSize.columns}
        height={terminalSize.rows}
        sessionId={sessionId}
      />
    </Box>
  );
};

export default App;
