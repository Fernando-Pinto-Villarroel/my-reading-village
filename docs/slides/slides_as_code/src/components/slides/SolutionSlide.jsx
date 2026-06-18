import { motion } from "framer-motion";
import { BookOpen, Coins, Home, ArrowRight } from "lucide-react";

const Step = ({ icon: Icon, label, sublabel, color, bg, delay }) => (
  <motion.div
    initial={{ scale: 0.7, opacity: 0 }}
    animate={{ scale: 1, opacity: 1 }}
    transition={{ delay, type: "spring", stiffness: 180 }}
    className="flex flex-col items-center gap-[0.8vh]"
  >
    <div
      className="w-[6.5vw] h-[6.5vw] rounded-3xl flex items-center justify-center shadow-lg border-2"
      style={{ backgroundColor: bg, borderColor: color }}
    >
      <Icon className="w-[3vw] h-[3vw]" style={{ color }} />
    </div>
    <span className="text-[1.2vw] font-black text-das-text text-center">
      {label}
    </span>
    <span className="text-[1.1vw] text-das-text/55 text-center max-w-[10vw] leading-snug">
      {sublabel}
    </span>
  </motion.div>
);

const SolutionSlide = () => (
  <div className="relative w-full h-full flex items-center justify-center px-[3vw] z-10">
    <div className="flex items-center gap-[2vw] w-full">
      <div className="flex-1 flex flex-col items-center justify-center">
        <motion.div
          initial={{ x: -20, opacity: 0 }}
          animate={{ x: 0, opacity: 1 }}
          transition={{ duration: 0.5 }}
          className="mb-[2.5vh] text-center"
        >
          <img
            src="/logo-mrv.webp"
            alt="My Reading Village"
            className="w-[8vw] h-auto mb-[1vh] mx-auto"
          />
          <h2 className="text-[3.3vw] font-black text-das-primary leading-tight">
            My Reading Village
          </h2>
          <p className="text-[1.35vw] text-das-text/65 mt-[0.6vh] max-w-[28vw]">
            Un juego de construcción de aldea donde la{" "}
            <strong className="text-das-primary">lectura real</strong> es la
            única moneda de progresión.
          </p>
        </motion.div>

        <motion.div
          initial={{ opacity: 0 }}
          animate={{ opacity: 1 }}
          transition={{ delay: 0.3 }}
          className="flex items-center gap-[1.2vw] mb-[2.5vh]"
        >
          <Step
            icon={BookOpen}
            label="Lees"
            sublabel="Registras páginas en < 10 seg"
            color="#E8637A"
            bg="#FFB3BA33"
            delay={0.35}
          />
          <motion.div
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            transition={{ delay: 0.55 }}
          >
            <ArrowRight className="w-[2.5vw] h-[2.5vw] text-das-text/25" />
          </motion.div>
          <Step
            icon={Coins}
            label="Ganas recursos"
            sublabel="Monedas, gemas, madera, metal"
            color="#CC7722"
            bg="#FFDFC433"
            delay={0.55}
          />
          <motion.div
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            transition={{ delay: 0.75 }}
          >
            <ArrowRight className="w-[2vw] h-[2vw] text-das-text/25" />
          </motion.div>
          <Step
            icon={Home}
            label="Construyes tu aldea"
            sublabel="41 especies - 8 edificios - 13 eventos"
            color="#7B79E8"
            bg="#B5B3FF33"
            delay={0.75}
          />
        </motion.div>

        <motion.div
          initial={{ y: 10, opacity: 0 }}
          animate={{ y: 0, opacity: 1 }}
          transition={{ delay: 0.9 }}
          className="flex flex-wrap gap-[0.6vw] justify-center"
        >
          {[
            "100% offline",
            "Sin cuenta",
            "Sin paywall en el progreso",
            "Registro < 10 seg",
          ].map((tag) => (
            <span
              key={tag}
              className="text-[1.1vw] font-bold bg-das-mint/40 text-das-text px-[0.9vw] py-[0.35vh] rounded-full border border-das-mint"
            >
              {tag}
            </span>
          ))}
        </motion.div>
      </div>

      <motion.div
        initial={{ x: 30, opacity: 0, scale: 0.95 }}
        animate={{ x: 0, opacity: 1, scale: 1 }}
        transition={{ delay: 0.15, duration: 0.6 }}
        className="shrink-0 pr-[1vw]"
      >
        <img
          src="/screenshot-village.webp"
          alt="My Reading Village gameplay"
          className="h-[80vh] w-auto rounded-3xl shadow-2xl border-4 border-das-light object-cover"
        />
      </motion.div>
    </div>
  </div>
);

export default SolutionSlide;
