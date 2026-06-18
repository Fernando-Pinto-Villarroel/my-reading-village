const VideoSlide = ({ videoSrc = null, caption = "Demo del App" }) => {
  if (!videoSrc) return null;

  return (
    <div className="relative w-full h-screen flex flex-col items-center justify-center z-10 gap-[1.5vh]">
      <video
        src={videoSrc}
        controls
        controlsList="nodownload"
        className="max-h-[88vh] w-auto max-w-[90vw] rounded-2xl shadow-2xl border-2 border-das-light"
      />
      {caption && (
        <p className="text-[1.2vw] font-bold text-das-text/70">{caption}</p>
      )}
    </div>
  );
};

export default VideoSlide;
