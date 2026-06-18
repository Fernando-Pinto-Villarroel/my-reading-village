import { useMemo } from "react";
import FloatingIcon from "./FloatingIcon";

const FloatingIconsBackground = () => {
  const icons = useMemo(
    () =>
      Array.from({ length: 60 }, (_, index) => {
        const row = Math.floor(index / 6);
        const col = index % 6;
        const baseTop = (row / Math.ceil(60 / 6)) * 100;
        const randomOffsetTop = (Math.random() - 0.5) * 15;
        const baseDelay = -(col * 15 + row * 10);
        const randomDelayOffset = Math.random() * 20;

        return {
          id: `icon-${index}`,
          iconIndex: index,
          size: 30 + Math.random() * 45,
          top: `${Math.min(Math.max(baseTop + randomOffsetTop, 0), 95)}%`,
          delay: baseDelay + randomDelayOffset,
          duration: 70 + Math.random() * 60,
          opacity: 0.08 + Math.random() * 0.14,
          rotation: Math.random() * 30 - 15,
        };
      }),
    [],
  );

  return (
    <div className="absolute inset-0 overflow-hidden pointer-events-none z-0">
      {icons.map((icon) => (
        <FloatingIcon key={icon.id} {...icon} />
      ))}
    </div>
  );
};

export default FloatingIconsBackground;
