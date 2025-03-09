import React from "react";
import SpinningWheel from "./SpinningWheel";

const App = () => {
  // Define the segments (e.g., prizes or options)
  const segments = ["Prize 1", "Prize 2", "Prize 3", "Prize 4", "Prize 5", "Prize 6"];

  return (
    <div className="App">
      <h1>Spinning Wheel Game</h1>
      <SpinningWheel segments={segments} />
    </div>
  );
};

export default App;