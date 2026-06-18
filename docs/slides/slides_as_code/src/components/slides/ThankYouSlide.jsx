import { motion } from "framer-motion";
import { BookOpen, Heart } from "lucide-react";

const ThankYouSlide = () => (
  <div className="relative w-full h-full flex items-center justify-center">
    <motion.img
      src="/cat/cat_villager.webp"
      alt=""
      initial={{ y: 30, opacity: 0 }}
      animate={{ y: [0, -9, 0], opacity: 1 }}
      transition={{ opacity: { duration: 0.5, delay: 1.0 }, y: { duration: 2.8, repeat: Infinity, ease: "easeInOut", delay: 1.0 } }}
      className="absolute bottom-[3vh] left-[4vw] w-[10vw] h-auto drop-shadow-xl pointer-events-none"
    />
    <motion.img
      src="/dog/dog_villager.webp"
      alt=""
      initial={{ y: 30, opacity: 0 }}
      animate={{ y: [0, -7, 0], opacity: 1 }}
      transition={{ opacity: { duration: 0.5, delay: 1.2 }, y: { duration: 3.3, repeat: Infinity, ease: "easeInOut", delay: 1.2 } }}
      className="absolute bottom-[3vh] right-[4vw] w-[9vw] h-auto drop-shadow-xl pointer-events-none"
    />
    <motion.div
      initial={{ scale: 0.9, opacity: 0 }}
      animate={{ scale: 1, opacity: 1 }}
      transition={{ duration: 0.7 }}
      className="text-center z-10 flex flex-col items-center gap-[2.5vh] max-w-[78vw]"
    >
      <motion.h1
        initial={{ y: 30, opacity: 0 }}
        animate={{ y: 0, opacity: 1 }}
        transition={{ delay: 0.3 }}
        className="text-[6.5vw] font-black text-das-primary leading-tight"
        style={{
          textShadow: "0.1vw 0.1vw 0 #FFB3BA, -0.05vw -0.05vw 0 #FFB3BA",
        }}
      >
        Gracias por su atención
      </motion.h1>

      <motion.div
        initial={{ scale: 0.92, opacity: 0 }}
        animate={{ scale: 1, opacity: 1 }}
        transition={{ delay: 0.5, duration: 0.6 }}
        className="bg-das-primary px-[4vw] py-[3vh] rounded-3xl shadow-2xl border-4 border-das-light flex flex-col items-center gap-[1.2vh]"
      >
        <motion.div
          animate={{ scale: [1, 1.08, 1] }}
          transition={{ duration: 3, repeat: Infinity, ease: "easeInOut" }}
        >
          <BookOpen className="w-[3vw] h-[3vw] text-white/80" />
        </motion.div>

        <p
          className="text-[2.8vw] font-black text-white leading-tight"
          style={{ textShadow: "0 2px 20px rgba(0,0,0,0.2)" }}
        >
          Cada libro que no terminas
          <br />
          es una vida que no viviste.
        </p>

        <div className="w-[10vw] h-[0.3vh] bg-white/30 rounded-full" />

        <p className="text-[1.3vw] text-white/80 font-semibold">
          My Reading Village existe para cambiar eso.
        </p>
      </motion.div>

      <motion.div
        initial={{ y: 15, opacity: 0 }}
        animate={{ y: 0, opacity: 1 }}
        transition={{ delay: 0.85 }}
        className="bg-das-primary px-[3vw] py-[1.2vh] rounded-2xl shadow-xl inline-flex items-center gap-[0.7vw] border-2 border-das-light"
      >
        <Heart className="w-[1.2vw] h-[1.2vw] text-white" />
        <p className="text-[1.2vw] text-white font-bold">
          My Reading Village — Fernando Pinto Villarroel
        </p>
        <Heart className="w-[1.2vw] h-[1.2vw] text-white" />
      </motion.div>
    </motion.div>
  </div>
);

export default ThankYouSlide;
