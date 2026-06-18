import { motion } from "framer-motion";
import { BookOpen, TrendingDown } from "lucide-react";

const HookSlide = () => (
  <div className="relative w-full h-full flex items-center justify-center px-[6vw] z-10">
    <div className="text-center max-w-[80vw]">
      <motion.div
        initial={{ scale: 0, opacity: 0 }}
        animate={{ scale: 1, opacity: 1 }}
        transition={{ duration: 0.5 }}
        className="flex justify-center mb-[2.5vh]"
      >
        <div className="bg-das-primary/10 p-[1.5vw] rounded-full">
          <BookOpen className="w-[4.5vw] h-[4.5vw] text-das-primary" />
        </div>
      </motion.div>

      <motion.p
        initial={{ y: -20, opacity: 0 }}
        animate={{ y: 0, opacity: 1 }}
        transition={{ delay: 0.2 }}
        className="text-[2vw] font-bold text-das-accent mb-[1.5vh] uppercase tracking-widest"
      >
        ¿Sabían que...?
      </motion.p>

      <motion.h1
        initial={{ y: 30, opacity: 0 }}
        animate={{ y: 0, opacity: 1 }}
        transition={{ delay: 0.4 }}
        className="text-[3.8vw] font-black text-das-text mb-[2.5vh] leading-tight"
      >
        Solo el{" "}
        <span
          className="text-das-primary"
          style={{ textShadow: "0 2px 16px #E8637A55" }}
        >
          50%
        </span>{" "}
        de los adultos comienza a leer
        <br />
        un libro al año...
      </motion.h1>

      <motion.div
        initial={{ scaleX: 0 }}
        animate={{ scaleX: 1 }}
        transition={{ delay: 0.7, duration: 0.4 }}
        className="h-[0.3vh] bg-gradient-to-r from-das-light via-das-primary to-das-light rounded-full mx-auto w-[40%] mb-[2.5vh]"
      />

      <motion.h2
        initial={{ y: 20, opacity: 0 }}
        animate={{ y: 0, opacity: 1 }}
        transition={{ delay: 0.85 }}
        className="text-[2.8vw] font-black text-das-text mb-[3vh] leading-tight"
      >
        ...y la mitad lo <span className="text-das-accent">abandona</span>
        <br />
        antes de las primeras 3 semanas.
      </motion.h2>

      <motion.div
        initial={{ y: 15, opacity: 0 }}
        animate={{ y: 0, opacity: 1 }}
        transition={{ delay: 1.1 }}
        className="inline-flex items-center gap-[0.8vw] bg-white/60 backdrop-blur-sm rounded-2xl px-[2vw] py-[1vh] border border-das-light/60 shadow-sm"
      >
        <TrendingDown className="w-[1.4vw] h-[1.4vw] text-das-primary shrink-0" />
        <p className="text-[1.1vw] text-das-text/70 font-semibold">
          El problema no es la voluntad. Es que la lectura está diseñada para
          perder.
        </p>
      </motion.div>

      <motion.p
        initial={{ opacity: 0 }}
        animate={{ opacity: 1 }}
        transition={{ delay: 1.3 }}
        className="text-[0.85vw] text-das-text/55 mt-[1.5vh]"
      >
        Fuente: Vega, F. (2020). Control [Libro]. ISBN-13: 978-6287878174 (2026)
      </motion.p>
    </div>
  </div>
);

export default HookSlide;
