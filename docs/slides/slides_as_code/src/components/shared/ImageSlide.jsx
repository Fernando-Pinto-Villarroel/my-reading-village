import React, { useState, useRef } from "react";

const ImageSlide = ({ imageUrl, caption }) => {
  const [showCaption, setShowCaption] = useState(true);
  const [zoom, setZoom] = useState(1);
  const [pan, setPan] = useState({ x: 0, y: 0 });
  const [isPanning, setIsPanning] = useState(false);
  const [startPan, setStartPan] = useState({ x: 0, y: 0 });
  const [initialPan, setInitialPan] = useState({ x: 0, y: 0 });
  const imgRef = useRef(null);

  const handleWheel = (e) => {
    if (!showCaption) {
      e.preventDefault();
      const delta = e.deltaY > 0 ? -0.1 : 0.1;
      setZoom((prev) => Math.max(0.1, Math.min(5, prev + delta)));
    }
  };

  const handleMouseDown = (e) => {
    if (!showCaption) {
      setIsPanning(true);
      setStartPan({ x: e.clientX, y: e.clientY });
      setInitialPan(pan);
      document.addEventListener("mousemove", handleMouseMove);
      document.addEventListener("mouseup", handleMouseUp);
    }
  };

  const handleMouseMove = (e) => {
    if (isPanning && !showCaption) {
      const sensitivity = 0.3;
      const deltaX = (e.clientX - startPan.x) * sensitivity;
      const deltaY = (e.clientY - startPan.y) * sensitivity;
      setPan({
        x: initialPan.x + deltaX,
        y: initialPan.y + deltaY,
      });
    }
  };

  const handleMouseUp = () => {
    setIsPanning(false);
    document.removeEventListener("mousemove", handleMouseMove);
    document.removeEventListener("mouseup", handleMouseUp);
  };

  const toggleCaption = () => {
    setShowCaption(!showCaption);
    if (!showCaption) {
      setZoom(1);
      setPan({ x: 0, y: 0 });
    }
  };

  return (
    <div className="relative w-full h-screen overflow-hidden flex items-center justify-center z-50">
      <img
        ref={imgRef}
        src={imageUrl}
        alt={caption}
        className="max-w-[100vw] h-screen object-contain select-none text-white"
        style={{
          transform: `scale(${zoom}) translate(${pan.x}px, ${pan.y}px)`,
          transition: showCaption ? "transform 0.3s ease" : "none",
          cursor: !showCaption ? (isPanning ? "grabbing" : "grab") : "default",
        }}
        onWheel={handleWheel}
        onMouseDown={handleMouseDown}
        onMouseMove={handleMouseMove}
        onMouseUp={handleMouseUp}
        onMouseLeave={handleMouseUp}
        draggable={false}
      />
      <button
        onClick={toggleCaption}
        className="absolute top-4 left-4 bg-das-body hover:bg-das-accent text-white p-2 rounded-full shadow-lg z-60"
        title={showCaption ? "Hide Caption" : "Show Caption"}
      >
        <svg
          width="20"
          height="20"
          viewBox="0 0 24 24"
          fill="none"
          xmlns="http://www.w3.org/2000/svg"
        >
          <path
            d="M1 12C1 12 5 4 12 4C19 4 23 12 23 12C23 12 19 20 12 20C5 20 1 12 1 12Z"
            stroke="currentColor"
            strokeWidth="2"
            strokeLinecap="round"
            strokeLinejoin="round"
          />
          <circle cx="12" cy="12" r="3" stroke="currentColor" strokeWidth="2" />
          {!showCaption && (
            <line
              x1="1"
              y1="1"
              x2="23"
              y2="23"
              stroke="currentColor"
              strokeWidth="2"
              strokeLinecap="round"
            />
          )}
        </svg>
      </button>
      {showCaption && caption && (
        <div className="absolute bottom-[10vh] left-0 right-0 text-center z-50">
          <div className="bg-gradient-to-r from-das-primary to-das-accent backdrop-blur-md px-[2vw] py-[1.5vh] rounded-2xl inline-block border-2 border-white/30 shadow-lg shadow-das-primary/30">
            <p className="text-[1.5vw] font-bold text-white drop-shadow-lg">{caption}</p>
          </div>
        </div>
      )}
    </div>
  );
};

export default ImageSlide;
