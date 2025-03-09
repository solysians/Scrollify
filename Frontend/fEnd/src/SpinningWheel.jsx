import React, { useState } from "react";
import "./SpinningWheel.css";

const SpinningWheel = ({ segments }) => {
  const [spinning, setSpinning] = useState(false);
  const [result, setResult] = useState(null);

  const spinWheel = () => {
    if (spinning) return; // Prevent multiple spins

    setSpinning(true);
    setResult(null);

    // Randomly determine the rotation angle
    const randomAngle = Math.floor(Math.random() * 360) + 1440; // 1440 = 4 full spins
    const selectedSegment = Math.floor((randomAngle % 360) / (360 / segments.length));

    // Apply the rotation to the wheel
    const wheel = document.querySelector(".wheel");
    wheel.style.transition = "transform 3s cubic-bezier(0.4, 0, 0.2, 1)";
    wheel.style.transform = `rotate(${randomAngle}deg)`;

    // Determine the result after the spin ends
    setTimeout(() => {
      setSpinning(false);
      setResult(segments[selectedSegment]);
      wheel.style.transition = "none";
      wheel.style.transform = `rotate(${randomAngle % 360}deg)`; // Reset to final position
    }, 3000);
  };

  return (
    <div className="spinning-wheel">
      <div className="wheel-container">
        <div className="wheel">
          {segments.map((segment, index) => (
            <div
              key={index}
              className="segment"
              style={{
                transform: `rotate(${(360 / segments.length) * index}deg)`,
                backgroundColor: `hsl(${(360 / segments.length) * index}, 70%, 50%)`,
              }}
            >
              <span>{segment}</span>
            </div>
          ))}
        </div>
        <div className="pointer"></div>
      </div>
      <button onClick={spinWheel} disabled={spinning}>
        {spinning ? "Spinning..." : "Spin"}
      </button>
      {result && <p className="result">You won: <strong>{result}</strong></p>}
    </div>
  );
};

export default SpinningWheel;