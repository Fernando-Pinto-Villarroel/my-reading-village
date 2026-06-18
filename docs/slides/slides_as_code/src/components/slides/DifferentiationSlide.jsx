import { motion } from "framer-motion";
import { Check, X } from "lucide-react";

const competitors = [
  {
    name: "My Reading Village",
    readingMoney: true,
    deepGame: true,
    offline: true,
    noPaywall: true,
    highlight: true,
  },
  {
    name: "Goodreads",
    readingMoney: false,
    deepGame: false,
    offline: false,
    noPaywall: true,
  },
  {
    name: "Habitica",
    readingMoney: false,
    deepGame: true,
    offline: false,
    noPaywall: false,
  },
  {
    name: "Duolingo",
    readingMoney: false,
    deepGame: true,
    offline: false,
    noPaywall: false,
  },
  {
    name: "Bookly",
    readingMoney: true,
    deepGame: false,
    offline: false,
    noPaywall: false,
  },
];

const cols = [
  { key: "readingMoney", label: "Lectura = moneda del juego" },
  { key: "deepGame", label: "Juego con profundidad real" },
  { key: "offline", label: "100% offline" },
  { key: "noPaywall", label: "Sin paywall en progreso" },
];

const Cell = ({ value, highlight }) => (
  <div className="flex justify-center">
    {value ? (
      <div
        className={`w-[2vw] h-[2vw] rounded-full flex items-center justify-center ${highlight ? "bg-das-primary shadow-md" : "bg-das-mint/60"}`}
      >
        <Check
          className={`w-[1.2vw] h-[1.2vw] ${highlight ? "text-white" : "text-green-700"}`}
          strokeWidth={3}
        />
      </div>
    ) : (
      <div className="w-[2vw] h-[2vw] rounded-full bg-gray-100 flex items-center justify-center">
        <X className="w-[1.2vw] h-[1.2vw] text-gray-300" strokeWidth={3} />
      </div>
    )}
  </div>
);

const DifferentiationSlide = () => (
  <div className="relative w-full h-full flex flex-col items-center justify-center px-[5vw] z-10">
    <motion.h2
      initial={{ y: -20, opacity: 0 }}
      animate={{ y: 0, opacity: 1 }}
      className="text-[2.8vw] font-black text-das-text mb-[0.5vh] text-center"
    >
      ¿Por qué <span className="text-das-primary">nosotros</span>?
    </motion.h2>
    <motion.p
      initial={{ opacity: 0 }}
      animate={{ opacity: 1 }}
      transition={{ delay: 0.15 }}
      className="text-[1.15vw] text-das-text/55 mb-[3vh] text-center"
    >
      Ningún competidor combina estas cuatro apuestas a la vez.
    </motion.p>

    <motion.div
      initial={{ y: 20, opacity: 0 }}
      animate={{ y: 0, opacity: 1 }}
      transition={{ delay: 0.25 }}
      className="w-full bg-white/70 backdrop-blur-sm rounded-3xl overflow-hidden border border-das-light shadow-md"
    >
      <table className="w-full">
        <thead>
          <tr className="border-b border-das-light">
            <th className="text-left px-[1.8vw] py-[1.4vh] text-[1vw] text-das-text/50 font-semibold w-[22%]">
              App
            </th>
            {cols.map((c) => (
              <th
                key={c.key}
                className="text-center px-[1vw] py-[1.4vh] text-[1.1vw] text-das-text/70 font-bold"
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
              initial={{ x: -20, opacity: 0 }}
              animate={{ x: 0, opacity: 1 }}
              transition={{ delay: 0.35 + i * 0.1 }}
              className={`border-b border-das-light/50 last:border-0 ${comp.highlight ? "bg-das-primary/8" : ""}`}
            >
              <td
                className={`px-[1.8vw] py-[1.6vh] text-[1.1vw] font-black ${comp.highlight ? "text-das-primary" : "text-das-text/70"}`}
              >
                {comp.highlight && <span className="mr-[0.3vw]">★</span>}
                {comp.name}
              </td>
              {cols.map((c) => (
                <td key={c.key} className="px-[1vw] py-[1.6vh]">
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
      transition={{ delay: 0.9 }}
      className="text-[0.9vw] text-das-text/65 mt-[2vh] text-center"
    >
      Fuentes: Google Play reviews - Pratt IXD (2024) - Verified Market Research
      (2026)
    </motion.p>
  </div>
);

export default DifferentiationSlide;
