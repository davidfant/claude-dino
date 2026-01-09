#!/usr/bin/env bun
import { render } from "ink";
import React from "react";
import App from "./App.js";

const sessionId = process.argv[2] || "default";

render(<App sessionId={sessionId} />);
