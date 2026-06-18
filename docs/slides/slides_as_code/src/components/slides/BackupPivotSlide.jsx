import { motion } from "framer-motion";
import {
  RefreshCw,
  Users,
  Lightbulb,
  DollarSign,
  AlertTriangle,
} from "lucide-react";

const pivots = [
  {
    icon: Users,
    type: "Pivote de Segmento",
    desc: "Mismo producto → escuelas y licencias B2B",
    detail:
      "Si el mercado consumer no escala, MRV como herramienta educativa para colegios tiene tracción inmediata y un modelo B2B más predecible.",
    color: "#E8637A",
    bg: "#FFB3BA22",
  },
  {
    icon: Lightbulb,
    type: "Pivote de Solución",
    desc: "Mismo mercado → mecánica de escritura/journaling",
    detail:
      "Si la lectura no engancha como mecánica, el mismo motor de aldea podría recompensar hábitos de escritura o reflexión diaria.",
    color: "#7B79E8",
    bg: "#B5B3FF22",
  },
  {
    icon: DollarSign,
    type: "Pivote de Modelo",
    desc: "Mismo producto → suscripción en vez de IAP",
    detail:
      "Si la conversión IAP queda por debajo del 1% sostenido, migrar a suscripción mensual baja (~USD 2/mes) podría mejorar el ARPU sin tocar el progreso.",
    color: "#2E9E6B",
    bg: "#B3FFD922",
  },
];

const BackupPivotSlide = () => (
  <div className="relative w-full h-full flex flex-col items-center justify-center px-[5vw] z-10">
    <motion.div
      initial={{ y: -10, opacity: 0 }}
      animate={{ y: 0, opacity: 1 }}
      className="bg-das-gold/20 border border-das-gold/50 rounded-xl px-[1.2vw] py-[0.4vh] mb-[1.5vh]"
    >
      <span className="text-[1.1vw] font-black text-yellow-700 uppercase tracking-widest">
        Backup - Estrategia de Pivote
      </span>
    </motion.div>

    <motion.h2
      initial={{ y: -15, opacity: 0 }}
      animate={{ y: 0, opacity: 1 }}
      transition={{ delay: 0.1 }}
      className="text-[2.6vw] font-black text-das-text mb-[0.5vh] text-center"
    >
      ¿Qué me haría pivotar?
    </motion.h2>

    <motion.div
      initial={{ opacity: 0 }}
      animate={{ opacity: 1 }}
      transition={{ delay: 0.2 }}
      className="flex items-center gap-[0.6vw] mb-[2.5vh] bg-das-primary/10 border border-das-primary/30 rounded-2xl px-[1.5vw] py-[0.8vh]"
    >
      <AlertTriangle className="w-[1.3vw] h-[1.3vw] text-das-primary shrink-0" />
      <p className="text-[1.15vw] font-semibold text-das-primary">
        Condición de pivote: Retención D30 &lt; 20% después de iterar el habit
        loop 2 veces.
      </p>
    </motion.div>

    <div className="flex gap-[1.8vw] w-full">
      {pivots.map((p, i) => (
        <motion.div
          key={p.type}
          initial={{ y: 20, opacity: 0 }}
          animate={{ y: 0, opacity: 1 }}
          transition={{ delay: 0.3 + i * 0.12 }}
          className="flex-1 rounded-3xl p-[2vw] border-2"
          style={{ backgroundColor: p.bg, borderColor: `${p.color}44` }}
        >
          <div className="flex items-center gap-[0.5vw] mb-[0.8vh]">
            <p.icon
              className="w-[1.4vw] h-[1.4vw]"
              style={{ color: p.color }}
            />
            <span
              className="text-[0.9vw] font-black uppercase tracking-wide"
              style={{ color: p.color }}
            >
              {p.type}
            </span>
          </div>
          <p className="text-[1.35vw] font-black text-das-text mb-[0.8vh] leading-snug">
            {p.desc}
          </p>
          <p className="text-[1.1vw] text-das-text/65 leading-snug">
            {p.detail}
          </p>
        </motion.div>
      ))}
    </div>

    <motion.div
      initial={{ opacity: 0 }}
      animate={{ opacity: 1 }}
      transition={{ delay: 0.7 }}
      className="mt-[2vh] flex items-center gap-[0.6vw] bg-white/60 rounded-2xl px-[2vw] py-[1vh] border border-das-light"
    >
      <RefreshCw className="w-[1.2vw] h-[1.2vw] text-das-text/40 shrink-0" />
      <p className="text-[1.2vw] text-das-text/55 font-semibold">
        El motor del juego (aldea isométrica + recursos) es reutilizable. El
        pivote no requiere reconstruir desde cero.
      </p>
    </motion.div>
  </div>
);

export default BackupPivotSlide;
