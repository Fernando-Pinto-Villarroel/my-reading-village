import { motion } from "framer-motion";
import { Sparkles, BookOpen, Globe } from "lucide-react";

const QACoverSlide = () => (
  <div className="relative w-full h-full flex items-center justify-center">
    <motion.img
      src="/rabbit/rabbit_villager.webp"
      alt=""
      initial={{ y: 30, opacity: 0 }}
      animate={{ y: [0, -12, 0], opacity: 1 }}
      transition={{
        opacity: { duration: 0.5, delay: 0.9 },
        y: { duration: 2.2, repeat: Infinity, ease: "easeInOut", delay: 0.9 },
      }}
      className="absolute bottom-[3vh] right-[5vw] w-[11vw] h-auto drop-shadow-xl pointer-events-none"
    />
    <motion.div
      initial={{ scale: 0, opacity: 0 }}
      animate={{ scale: 1, opacity: 1 }}
      transition={{ duration: 0.8 }}
      className="text-center z-10"
    >
      <motion.div
        animate={{ rotate: [0, 5, -5, 0] }}
        transition={{ duration: 4, repeat: Infinity, ease: "easeInOut" }}
        className="flex justify-center mb-[1vh]"
      >
        <div className="bg-das-primary/10 p-[1.5vw] rounded-full">
          <BookOpen className="w-[4.5vw] h-[4.5vw] text-das-primary" />
        </div>
      </motion.div>

      <motion.h1
        initial={{ y: 50, opacity: 0 }}
        animate={{ y: 0, opacity: 1 }}
        transition={{ delay: 0.4 }}
        className="text-[11vw] font-black text-das-primary mb-[1vh]"
        style={{
          textShadow:
            "0.1vw 0.1vw 0 #FFB3BA, -0.05vw -0.05vw 0 #FFB3BA, 0.05vw -0.05vw 0 #FFB3BA, -0.05vw 0.05vw 0 #FFB3BA",
        }}
      >
        Q &amp; A
      </motion.h1>

      <motion.p
        initial={{ y: 20, opacity: 0 }}
        animate={{ y: 0, opacity: 1 }}
        transition={{ delay: 0.6 }}
        className="text-[2.2vw] text-das-accent font-bold mb-[4vh]"
      >
        Preguntas y Respuestas
      </motion.p>

      <motion.div
        initial={{ y: 15, opacity: 0 }}
        animate={{ y: 0, opacity: 1 }}
        transition={{ delay: 0.8 }}
        className="flex flex-col items-center gap-[1.2vh]"
      >
        <motion.div
          animate={{ y: [0, -8, 0] }}
          transition={{ duration: 2.5, repeat: Infinity }}
          className="bg-das-primary px-[3vw] py-[1.5vh] rounded-2xl shadow-xl inline-flex items-center gap-[0.7vw] border-2 border-das-light"
        >
          <Sparkles className="w-[1.4vw] h-[1.4vw] text-white" />
          <p className="text-[1.35vw] text-white font-bold">
            My Reading Village - Fernando Pinto Villarroel
          </p>
          <Sparkles className="w-[1.4vw] h-[1.4vw] text-white" />
        </motion.div>

        <a
          href="https://myreadingvillage.com"
          target="_blank"
          rel="noreferrer"
          className="inline-flex items-center gap-[0.4vw] text-das-primary hover:text-das-accent transition-colors group"
        >
          <Globe className="w-[1.1vw] h-[1.1vw] shrink-0" />
          <span className="text-[1.1vw] font-bold underline underline-offset-4 decoration-2 group-hover:decoration-das-accent">
            myreadingvillage.com
          </span>
        </a>
      </motion.div>
    </motion.div>
  </div>
);

export default QACoverSlide;
