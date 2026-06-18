import { motion } from "framer-motion";
import { Code2, BookOpen, GraduationCap, Hammer } from "lucide-react";

const points = [
  {
    icon: Hammer,
    title: "Construí la app completo: solo",
    detail:
      "Flutter + Flame Engine + SQLite + 41 especies animadas + sistema de misiones + tienda IAP + 4 minijuegos. Desde cero, en producción.",
    color: "#E8637A",
  },
  {
    icon: BookOpen,
    title: "Soy el usuario que resuelvo",
    detail:
      "Lector activo. Entiendo el problema desde adentro: la tensión de 'quiero leer más' pero el celular gana siempre. No estoy adivinando el pain point.",
    color: "#7B79E8",
  },
  {
    icon: GraduationCap,
    title: "Validación académica del enfoque",
    detail:
      "Curso CSRP-486 Software Projects & Startups: Jala University. Lean Canvas validado, plan de negocio construido, feedback de Davor Pavisic Ph.D.",
    color: "#2E9E6B",
  },
  {
    icon: Code2,
    title: "Ventaja técnica difícil de copiar rápido",
    detail:
      "Replicar 41 especies + misiones ramificadas + 13 eventos + motor de juego real atado a lectura obliga a reconstruir todo el sistema desde cero.",
    color: "#CC7722",
  },
];

const BackupFounderSlide = () => (
  <div className="relative w-full h-full flex flex-col items-center justify-center px-[5vw] z-10">
    <motion.div
      initial={{ y: -10, opacity: 0 }}
      animate={{ y: 0, opacity: 1 }}
      className="bg-das-gold/20 border border-das-gold/50 rounded-xl px-[1.2vw] py-[0.4vh] mb-[1.5vh]"
    >
      <span className="text-[1.1vw] font-black text-yellow-700 uppercase tracking-widest">
        Backup - Por qué yo
      </span>
    </motion.div>

    <motion.h2
      initial={{ y: -15, opacity: 0 }}
      animate={{ y: 0, opacity: 1 }}
      transition={{ delay: 0.1 }}
      className="text-[2.6vw] font-black text-das-text mb-[0.5vh] text-center"
    >
      ¿Por qué soy la persona correcta para construir esto?
    </motion.h2>
    <motion.p
      initial={{ opacity: 0 }}
      animate={{ opacity: 1 }}
      transition={{ delay: 0.2 }}
      className="text-[1.25vw] text-das-text/55 mb-[2.5vh] text-center"
    >
      Hay una persona que conoce este producto de arriba abajo. Soy yo.
    </motion.p>

    <div className="grid grid-cols-2 gap-[1.5vw] w-full">
      {points.map((p, i) => (
        <motion.div
          key={p.title}
          initial={{ scale: 0.9, opacity: 0 }}
          animate={{ scale: 1, opacity: 1 }}
          transition={{ delay: 0.25 + i * 0.1, type: "spring" }}
          className="bg-white/70 backdrop-blur-sm rounded-3xl p-[2vw] border border-das-light shadow-sm flex flex-col gap-[0.6vh]"
        >
          <div className="flex items-center gap-[0.6vw]">
            <div
              className="p-[0.4vw] rounded-xl"
              style={{ backgroundColor: `${p.color}22` }}
            >
              <p.icon
                className="w-[1.5vw] h-[1.5vw]"
                style={{ color: p.color }}
              />
            </div>
            <h3 className="text-[1.3vw] font-black text-das-text leading-tight">
              {p.title}
            </h3>
          </div>
          <p className="text-[1.2vw] text-das-text/65 leading-snug">
            {p.detail}
          </p>
        </motion.div>
      ))}
    </div>

    <motion.div
      initial={{ opacity: 0 }}
      animate={{ opacity: 1 }}
      transition={{ delay: 0.75 }}
      className="mt-[2vh] bg-das-primary/10 border border-das-primary/30 rounded-2xl px-[2.5vw] py-[1vh] text-center"
    >
      <p className="text-[1.1vw] font-bold text-das-primary">
        Fernando Pinto Villarroel - Jala University - myreadingvillage@gmail.com
      </p>
    </motion.div>
  </div>
);

export default BackupFounderSlide;
