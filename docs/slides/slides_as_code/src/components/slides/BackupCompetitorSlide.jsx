import { motion } from "framer-motion";
import { Check, X, Minus } from "lucide-react";

const competitors = [
  {
    name: "My Reading Village",
    reading: true,
    deepGame: true,
    offline: true,
    noPaywall: true,
    community: false,
    multiPlatform: false,
    highlight: true,
  },
  {
    name: "Goodreads",
    reading: true,
    deepGame: false,
    offline: false,
    noPaywall: true,
    community: true,
    multiPlatform: true,
  },
  {
    name: "Habitica",
    reading: false,
    deepGame: true,
    offline: false,
    noPaywall: false,
    community: true,
    multiPlatform: true,
  },
  {
    name: "Duolingo",
    reading: false,
    deepGame: true,
    offline: false,
    noPaywall: false,
    community: true,
    multiPlatform: true,
  },
  {
    name: "Bookly",
    reading: true,
    deepGame: false,
    offline: false,
    noPaywall: false,
    community: false,
    multiPlatform: false,
  },
  {
    name: "Nook / Libby",
    reading: null,
    deepGame: false,
    offline: false,
    noPaywall: true,
    community: false,
    multiPlatform: true,
  },
];

const cols = [
  { key: "reading", label: "Lectura como mecánica" },
  { key: "deepGame", label: "Juego con profundidad" },
  { key: "offline", label: "100% offline" },
  { key: "noPaywall", label: "Sin paywall en progreso" },
  { key: "community", label: "Comunidad lectora" },
  { key: "multiPlatform", label: "Multi-plataforma" },
];

const Cell = ({ value, highlight }) => {
  if (value === null)
    return (
      <div className="flex justify-center">
        <div className="w-[1.8vw] h-[1.8vw] rounded-full bg-gray-100 flex items-center justify-center">
          <Minus className="w-[1vw] h-[1vw] text-gray-300" strokeWidth={3} />
        </div>
      </div>
    );
  return (
    <div className="flex justify-center">
      {value ? (
        <div
          className={`w-[1.8vw] h-[1.8vw] rounded-full flex items-center justify-center ${highlight ? "bg-das-primary" : "bg-das-mint/60"}`}
        >
          <Check
            className={`w-[1vw] h-[1vw] ${highlight ? "text-white" : "text-green-700"}`}
            strokeWidth={3}
          />
        </div>
      ) : (
        <div className="w-[1.8vw] h-[1.8vw] rounded-full bg-gray-100 flex items-center justify-center">
          <X className="w-[1vw] h-[1vw] text-gray-300" strokeWidth={3} />
        </div>
      )}
    </div>
  );
};

const BackupCompetitorSlide = () => (
  <div className="relative w-full h-full flex flex-col items-center justify-center px-[4vw] z-10">
    <motion.div
      initial={{ y: -10, opacity: 0 }}
      animate={{ y: 0, opacity: 1 }}
      className="bg-das-gold/20 border border-das-gold/50 rounded-xl px-[1.2vw] py-[0.4vh] mb-[1.5vh]"
    >
      <span className="text-[1.1vw] font-black text-yellow-700 uppercase tracking-widest">
        Backup - Análisis Competitivo Expandido
      </span>
    </motion.div>

    <motion.h2
      initial={{ y: -15, opacity: 0 }}
      animate={{ y: 0, opacity: 1 }}
      transition={{ delay: 0.1 }}
      className="text-[2.4vw] font-black text-das-text mb-[2.5vh] text-center"
    >
      Panorama competitivo completo
    </motion.h2>

    <motion.div
      initial={{ y: 15, opacity: 0 }}
      animate={{ y: 0, opacity: 1 }}
      transition={{ delay: 0.2 }}
      className="w-full bg-white/70 backdrop-blur-sm rounded-3xl overflow-hidden border border-das-light shadow-md"
    >
      <table className="w-full">
        <thead>
          <tr className="border-b border-das-light bg-das-light/30">
            <th className="text-left px-[1.5vw] py-[1.1vh] text-[0.9vw] text-das-text/50 font-semibold w-[22%]">
              App
            </th>
            {cols.map((c) => (
              <th
                key={c.key}
                className="text-center px-[0.5vw] py-[1.1vh] text-[0.85vw] text-das-text/65 font-bold"
              >
                {c.label}
              </th>
            ))}
          </tr>
        </thead>
        <tbody>
          {competitors.map((comp, i) => (
            <motion.tr
              key={comp.name}
              initial={{ x: -15, opacity: 0 }}
              animate={{ x: 0, opacity: 1 }}
              transition={{ delay: 0.3 + i * 0.08 }}
              className={`border-b border-das-light/50 last:border-0 ${comp.highlight ? "bg-das-primary/8" : ""}`}
            >
              <td
                className={`px-[1.5vw] py-[1.1vh] text-[1vw] font-black ${comp.highlight ? "text-das-primary" : "text-das-text/70"}`}
              >
                {comp.highlight && <span className="mr-[0.3vw]">★</span>}
                {comp.name}
              </td>
              {cols.map((c) => (
                <td key={c.key} className="px-[0.5vw] py-[1.1vh]">
                  <Cell value={comp[c.key]} highlight={comp.highlight} />
                </td>
              ))}
            </motion.tr>
          ))}
        </tbody>
      </table>
    </motion.div>

    <motion.p
      initial={{ opacity: 0 }}
      animate={{ opacity: 1 }}
      transition={{ delay: 0.85 }}
      className="text-[0.82vw] text-das-text/55 mt-[1.5vh] text-center"
    >
      Fuentes: Google Play - Pratt IXD (2024) - Verified Market Research (2026)
      - AppBrain (2026)
    </motion.p>
  </div>
);

export default BackupCompetitorSlide;
