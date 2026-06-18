import { motion } from "framer-motion";
import { Sparkles } from "lucide-react";

const TitleSlide = () => (
  <div className="relative w-full h-full flex items-center justify-center px-[2vw]">
    <motion.img
      src="/cat/cat_villager.webp"
      alt=""
      initial={{ y: 40, opacity: 0 }}
      animate={{ y: [0, -10, 0], opacity: 1 }}
      transition={{ opacity: { duration: 0.6, delay: 1.2 }, y: { duration: 2.6, repeat: Infinity, ease: "easeInOut", delay: 1.2 } }}
      className="absolute bottom-[3vh] left-[4vw] w-[13vw] h-auto drop-shadow-xl pointer-events-none"
    />
    <motion.img
      src="/dog/dog_villager.webp"
      alt=""
      initial={{ y: 40, opacity: 0 }}
      animate={{ y: [0, -8, 0], opacity: 1 }}
      transition={{ opacity: { duration: 0.6, delay: 1.4 }, y: { duration: 3.1, repeat: Infinity, ease: "easeInOut", delay: 1.4 } }}
      className="absolute bottom-[3vh] right-[4vw] w-[12vw] h-auto drop-shadow-xl pointer-events-none"
    />
    <motion.div
      initial={{ scale: 0, opacity: 0 }}
      animate={{ scale: 1, opacity: 1 }}
      transition={{ duration: 0.8, delay: 0.1 }}
      className="text-center z-10"
    >
      <motion.div
        animate={{ rotate: [0, 4, -4, 0] }}
        transition={{ duration: 5, repeat: Infinity, ease: "easeInOut" }}
        className="mb-[2vh] flex justify-center"
      >
        <img
          src="/logo-mrv.webp"
          alt="My Reading Village"
          className="w-[13vw] h-auto drop-shadow-xl"
        />
      </motion.div>

      <motion.h1
        initial={{ y: 40, opacity: 0 }}
        animate={{ y: 0, opacity: 1 }}
        transition={{ delay: 0.4 }}
        className="text-[5.2vw] font-black text-das-primary mb-[0.5vh] tracking-tight"
        style={{
          textShadow:
            "0.1vw 0.1vw 0 #FFB3BA, -0.05vw -0.05vw 0 #FFB3BA, 0.05vw -0.05vw 0 #FFB3BA, -0.05vw 0.05vw 0 #FFB3BA",
        }}
      >
        MY READING VILLAGE
      </motion.h1>

      <motion.p
        initial={{ y: 25, opacity: 0 }}
        animate={{ y: 0, opacity: 1 }}
        transition={{ delay: 0.6 }}
        className="text-[2.1vw] text-das-accent font-bold mb-[2.5vh]"
      >
        El juego donde leer construye tu aldea
      </motion.p>

      <motion.div
        initial={{ y: 20, opacity: 0 }}
        animate={{ y: 0, opacity: 1 }}
        transition={{ delay: 0.75 }}
        className="bg-white/70 backdrop-blur-sm rounded-2xl px-[2.5vw] py-[1.5vh] mb-[2vh] inline-block border border-das-light shadow-md"
      >
        <p className="text-[1.25vw] text-das-text font-semibold">
          Pitch de Inversión - CSRP-486 Software Projects & Startups
        </p>
      </motion.div>

      <motion.div
        initial={{ y: 15, opacity: 0 }}
        animate={{ y: 0, opacity: 1 }}
        transition={{ delay: 0.9 }}
        className="flex items-center justify-center gap-[1vw]"
      >
        <Sparkles className="w-[1.6vw] h-[1.6vw] text-das-primary" />
        <p className="text-[1.4vw] font-bold text-das-text">
          Fernando Pinto Villarroel
        </p>
        <Sparkles className="w-[1.6vw] h-[1.6vw] text-das-primary" />
      </motion.div>

      <motion.p
        initial={{ opacity: 0 }}
        animate={{ opacity: 1 }}
        transition={{ delay: 1.1 }}
        className="text-[1.05vw] text-das-text/50 mt-[1vh]"
      >
        Jala University - Junio 2026
      </motion.p>
    </motion.div>
  </div>
);

export default TitleSlide;
