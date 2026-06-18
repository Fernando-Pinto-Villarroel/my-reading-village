import { motion } from "framer-motion";
import { BookOpen, Home, Star, Sparkles, BookMarked } from "lucide-react";

const ICONS = [BookOpen, Home, Star, Sparkles, BookMarked];

const FloatingIcon = ({ size, top, delay, duration, opacity, rotation, iconIndex }) => {
  const Icon = ICONS[iconIndex % ICONS.length];
  const colors = [
    "text-das-primary/60",
    "text-das-accent/60",
    "text-das-gold/60",
    "text-das-mint/80",
    "text-das-lavender/70",
  ];
  const color = colors[iconIndex % colors.length];

  return (
    <motion.div
      className="absolute"
      style={{
        width: `${size}px`,
        height: `${size}px`,
        top,
        left: 0,
        opacity,
        rotate: rotation,
      }}
      initial={{ x: "-150vw" }}
      animate={{ x: "150vw" }}
      transition={{
        duration,
        delay,
        repeat: Infinity,
        ease: "linear",
      }}
    >
      <Icon className={`w-full h-full ${color}`} />
    </motion.div>
  );
};

export default FloatingIcon;
