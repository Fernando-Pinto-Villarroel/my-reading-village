import { motion } from "framer-motion";
import { ShieldAlert } from "lucide-react";

const risks = [
  {
    risk: "Bug crítico post-lanzamiento",
    type: "Técnico",
    priority: "Alta",
    mitigation:
      "Staged rollout en Play Console - canal de reporte visible en la app - rollback disponible",
    priorityColor: "#E8637A",
  },
  {
    risk: "Habit loop no retiene en D7",
    type: "Mercado",
    priority: "Alta",
    mitigation:
      "Iteración rápida del flujo de recompensas - A/B test del loop - encuestas a primeros 50 usuarios activos",
    priorityColor: "#E8637A",
  },
  {
    risk: "BookTok no genera tracción",
    type: "Mercado",
    priority: "Media",
    mitigation:
      "Redirigir budget a Reddit / Discord - medir CPI por canal antes de escalar cualquiera",
    priorityColor: "#CC7722",
  },
  {
    risk: "Conversión IAP < 2%",
    type: "Negocio",
    priority: "Media",
    mitigation:
      "Umbral definido antes de escalar - iterar tienda y cosméticos antes de tocar el progreso gratis",
    priorityColor: "#CC7722",
  },
  {
    risk: "Burnout del desarrollador (equipo de 1)",
    type: "Negocio",
    priority: "Media",
    mitigation:
      "Ritmo sostenible sin fechas públicas que presionen - buscar colaborador en la Fase 2",
    priorityColor: "#CC7722",
  },
];

const priorityBg = { Alta: "#FFB3BA33", Media: "#FFDFC433" };

const BackupRisksSlide = () => (
  <div className="relative w-full h-full flex flex-col items-center justify-center px-[5vw] z-10">
    <motion.div
      initial={{ y: -10, opacity: 0 }}
      animate={{ y: 0, opacity: 1 }}
      className="bg-das-gold/20 border border-das-gold/50 rounded-xl px-[1.2vw] py-[0.4vh] mb-[1.5vh]"
    >
      <span className="text-[1.1vw] font-black text-yellow-700 uppercase tracking-widest">
        Backup - Riesgos y Mitigación
      </span>
    </motion.div>

    <motion.h2
      initial={{ y: -15, opacity: 0 }}
      animate={{ y: 0, opacity: 1 }}
      transition={{ delay: 0.1 }}
      className="text-[2.8vw] font-black text-das-text mb-[0.5vh] text-center"
    >
      Riesgos identificados y{" "}
      <span className="text-das-primary">cómo los mitigo</span>
    </motion.h2>
    <motion.p
      initial={{ opacity: 0 }}
      animate={{ opacity: 1 }}
      transition={{ delay: 0.2 }}
      className="text-[1.25vw] text-das-text/50 mb-[2.5vh] text-center"
    >
      Prever el caos antes de que suceda permite pivotar hacia la dirección
      correcta con mayor fluidez.
    </motion.p>

    <motion.div
      initial={{ y: 15, opacity: 0 }}
      animate={{ y: 0, opacity: 1 }}
      transition={{ delay: 0.25 }}
      className="w-full bg-white/70 backdrop-blur-sm rounded-3xl overflow-hidden border border-das-light shadow-md"
    >
      <table className="w-full">
        <thead>
          <tr className="border-b border-das-light bg-das-light/30">
            <th className="text-left px-[1.5vw] py-[1.1vh] text-[1.1vw] text-das-text/50 font-semibold w-[28%]">
              Riesgo
            </th>
            <th className="text-center px-[0.8vw] py-[1.1vh] text-[1.1vw] text-das-text/50 font-semibold w-[10%]">
              Tipo
            </th>
            <th className="text-center px-[0.8vw] py-[1.1vh] text-[1.1vw] text-das-text/50 font-semibold w-[10%]">
              Prioridad
            </th>
            <th className="text-left px-[1.5vw] py-[1.1vh] text-[1.1vw] text-das-text/50 font-semibold">
              Mitigación
            </th>
          </tr>
        </thead>
        <tbody>
          {risks.map((r, i) => (
            <motion.tr
              key={r.risk}
              initial={{ x: -10, opacity: 0 }}
              animate={{ x: 0, opacity: 1 }}
              transition={{ delay: 0.35 + i * 0.09 }}
              className="border-b border-das-light/50 last:border-0"
            >
              <td className="px-[1.5vw] py-[1vh] text-[1.15vw] font-bold text-das-text">
                {r.risk}
              </td>
              <td className="px-[0.8vw] py-[1vh] text-center">
                <span className="text-[0.98vw] font-semibold text-das-text/60">
                  {r.type}
                </span>
              </td>
              <td className="px-[0.8vw] py-[1vh] text-center">
                <span
                  className="text-[0.98vw] font-black px-[0.5vw] py-[0.2vh] rounded-full"
                  style={{
                    color: r.priorityColor,
                    backgroundColor: priorityBg[r.priority],
                  }}
                >
                  {r.priority}
                </span>
              </td>
              <td className="px-[1.5vw] py-[1vh] text-[1.1vw] text-das-text/65">
                {r.mitigation}
              </td>
            </motion.tr>
          ))}
        </tbody>
      </table>
    </motion.div>
  </div>
);

export default BackupRisksSlide;
