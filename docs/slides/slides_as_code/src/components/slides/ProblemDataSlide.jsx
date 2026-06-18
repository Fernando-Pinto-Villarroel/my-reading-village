import { motion } from "framer-motion";
import { TrendingDown } from "lucide-react";

const leftBars = [
  { year: "1982", pct: 60, label: "60%" },
  { year: "1992", pct: 53, label: "53%" },
  { year: "2002", pct: 43, label: "43%" },
  { year: "2007", pct: 37, label: "37%" },
];

const rightBars = [
  { year: "2000", pct: 72, label: "72" },
  { year: "2005", pct: 68, label: "68" },
  { year: "2010", pct: 64, label: "64" },
  { year: "2015", pct: 59, label: "59" },
];

const Bar = ({ year, pct, label, color, delay }) => (
  <div className="flex flex-col items-center gap-[0.5vh]">
    <span className="text-[0.85vw] font-bold" style={{ color }}>
      {label}
    </span>
    <motion.div
      initial={{ height: 0 }}
      animate={{ height: `${pct * 0.55}vh` }}
      transition={{ delay, duration: 0.7, ease: "easeOut" }}
      className="w-[2.5vw] rounded-t-xl"
      style={{ backgroundColor: color, opacity: 0.85 }}
    />
    <span className="text-[0.8vw] text-das-text/60 font-medium">{year}</span>
  </div>
);

const ChartPanel = ({ title, subtitle, bars, color, source, delay }) => (
  <div className="flex-1 bg-white/70 backdrop-blur-sm rounded-3xl p-[2.5vw] border border-das-light shadow-md flex flex-col">
    <div className="flex items-center gap-[0.6vw] mb-[0.5vh]">
      <TrendingDown className="w-[1.3vw] h-[1.3vw]" style={{ color }} />
      <h3 className="text-[1.2vw] font-black text-das-text">{title}</h3>
    </div>
    <p className="text-[0.8vw] text-das-text/55 mb-[2vh]">{subtitle}</p>
    <div className="flex items-end justify-around flex-1 pb-[0.5vh]">
      {bars.map((b, i) => (
        <Bar key={b.year} {...b} color={color} delay={delay + i * 0.12} />
      ))}
    </div>
    <p className="text-[0.65vw] text-das-text/55 mt-[1.5vh]">{source}</p>
  </div>
);

const ProblemDataSlide = () => (
  <div className="relative w-full h-full flex flex-col items-center justify-center px-[4vw] z-10">
    <motion.h2
      initial={{ y: -20, opacity: 0 }}
      animate={{ y: 0, opacity: 1 }}
      className="text-[2.2vw] font-black text-das-text mb-[3vh] text-center"
    >
      Los datos confirman:{" "}
      <span className="text-das-primary">el hábito lector colapsa</span>
    </motion.h2>

    <div className="flex gap-[2.5vw] w-full">
      <motion.div
        initial={{ x: -30, opacity: 0 }}
        animate={{ x: 0, opacity: 1 }}
        transition={{ delay: 0.2 }}
        className="flex-1"
      >
        <ChartPanel
          title="Lectura por placer en declive"
          subtitle="% de jóvenes (18–24) que leen literatura por placer"
          bars={leftBars}
          color="#E8637A"
          source="Fuente: NEA - To Read or Not to Read (2007)"
          delay={0.3}
        />
      </motion.div>

      <motion.div
        initial={{ x: 30, opacity: 0 }}
        animate={{ x: 0, opacity: 1 }}
        transition={{ delay: 0.35 }}
        className="flex-1"
      >
        <ChartPanel
          title="Comprensión lectora en caída"
          subtitle="Puntaje promedio NAEP - lectores de 12.° grado (EE. UU.)"
          bars={rightBars}
          color="#7B79E8"
          source="Fuente: National Assessment of Educational Progress (NAEP)"
          delay={0.45}
        />
      </motion.div>
    </div>

    <motion.p
      initial={{ opacity: 0 }}
      animate={{ opacity: 1 }}
      transition={{ delay: 1.2 }}
      className="text-[1vw] text-das-text/55 mt-[2.5vh] font-semibold text-center"
    >
      Leen menos. Y los que leen, comprenden menos. El problema es sistémico.
    </motion.p>
  </div>
);

export default ProblemDataSlide;
