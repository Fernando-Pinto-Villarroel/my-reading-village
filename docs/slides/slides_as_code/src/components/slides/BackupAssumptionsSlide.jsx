import { motion } from "framer-motion";
import { FlaskConical, Target, BarChart2 } from "lucide-react";

const BackupAssumptionsSlide = () => (
  <div className="relative w-full h-full flex flex-col items-center justify-center px-[5vw] z-10">
    <motion.div
      initial={{ y: -10, opacity: 0 }}
      animate={{ y: 0, opacity: 1 }}
      className="bg-das-gold/20 border border-das-gold/50 rounded-xl px-[1.2vw] py-[0.4vh] mb-[1.5vh]"
    >
      <span className="text-[1.1vw] font-black text-yellow-700 uppercase tracking-widest">
        Backup - Supuesto Central
      </span>
    </motion.div>

    <motion.h2
      initial={{ y: -15, opacity: 0 }}
      animate={{ y: 0, opacity: 1 }}
      transition={{ delay: 0.1 }}
      className="text-[2.8vw] font-black text-das-text mb-[3vh] text-center"
    >
      La apuesta central del producto
    </motion.h2>

    <div className="flex gap-[2vw] w-full">
      <motion.div
        initial={{ x: -20, opacity: 0 }}
        animate={{ x: 0, opacity: 1 }}
        transition={{ delay: 0.2 }}
        className="flex-1 bg-das-primary/10 border-2 border-das-primary/40 rounded-3xl p-[2vw]"
      >
        <div className="flex items-center gap-[0.6vw] mb-[1.2vh]">
          <Target className="w-[1.5vw] h-[1.5vw] text-das-primary" />
          <h3 className="text-[1.25vw] font-black text-das-primary">
            Supuesto de valor
          </h3>
        </div>
        <p className="text-[1.4vw] font-black text-das-text mb-[1vh] leading-snug">
          "La recompensa inmediata de ver crecer la aldea motiva lectura real y
          sostenida."
        </p>
        <p className="text-[1.3vw] text-das-text/65 leading-snug">
          Si la gente no lee más por tener una aldea que crece, el producto
          entero pierde sentido. Es el supuesto más crítico de todos.
        </p>
        <p className="text-[1.1vw] text-das-text/65 mt-[1vh]">
          Base teórica: Nir Eyal: Hooked (2014) - Duhigg: The Power of Habit
          (2012)
        </p>
      </motion.div>

      <motion.div
        initial={{ x: 20, opacity: 0 }}
        animate={{ x: 0, opacity: 1 }}
        transition={{ delay: 0.35 }}
        className="flex-1 bg-white/70 backdrop-blur-sm border border-das-light rounded-3xl p-[2vw]"
      >
        <div className="flex items-center gap-[0.6vw] mb-[1.2vh]">
          <FlaskConical className="w-[1.5vw] h-[1.5vw] text-das-accent" />
          <h3 className="text-[1.35vw] font-black text-das-accent">
            Experimento de validación
          </h3>
        </div>
        <ul className="space-y-[0.9vh]">
          {[
            "Grupo beta cerrado (Reddit + Discord)",
            "Grupo A: app completa con aldea y recompensas",
            "Grupo B: solo registro de páginas sin recompensa",
            "Duración: 3–4 semanas",
            "Métrica: páginas leídas / usuario / semana",
          ].map((item, i) => (
            <li key={i} className="flex items-start gap-[0.4vw]">
              <span className="text-das-accent font-black text-[1.1vw] mt-[0.1vh]">
                -
              </span>
              <span className="text-[1.10vw] text-das-text/75">{item}</span>
            </li>
          ))}
        </ul>

        <div className="mt-[1.5vh] pt-[1.2vh] border-t border-das-light">
          <div className="flex items-center gap-[0.5vw]">
            <BarChart2 className="w-[1.4vw] h-[1.4vw] text-green-700" />
            <span className="text-[1.2vw] font-black text-green-700">
              Criterio de éxito:
            </span>
          </div>
          <p className="text-[1.10vw] text-das-text/70 mt-[0.3vh]">
            ≥ 80 páginas / usuario activo / semana (North Star Metric)
          </p>
        </div>
      </motion.div>
    </div>
  </div>
);

export default BackupAssumptionsSlide;
