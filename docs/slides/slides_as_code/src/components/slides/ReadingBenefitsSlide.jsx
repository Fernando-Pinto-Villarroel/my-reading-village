import { motion } from "framer-motion";
import {
  BookOpen,
  Brain,
  Shield,
  Lightbulb,
  Heart,
  PenLine,
} from "lucide-react";

const benefits = [
  {
    icon: BookOpen,
    title: "+Vocabulario",
    desc: "Expone al cerebro a más palabras y estructuras lingüísticas de forma natural.",
    color: "#E8637A",
    bg: "#FFB3BA33",
  },
  {
    icon: Brain,
    title: "Mejor retención de memoria",
    desc: "La lectura activa fortalece conexiones neuronales asociadas a la memoria episódica.",
    color: "#7B79E8",
    bg: "#B5B3FF33",
  },
  {
    icon: Shield,
    title: "Previene Alzheimer",
    desc: "Estudios muestran que la lectura habitual reduce el riesgo de deterioro cognitivo.",
    color: "#2E9E6B",
    bg: "#B3FFD933",
  },
  {
    icon: Lightbulb,
    title: "+Conocimiento",
    desc: "Acceso acumulativo a ideas, contextos históricos y perspectivas globales.",
    color: "#CC7722",
    bg: "#FFDFC433",
  },
  {
    icon: Heart,
    title: "+Empatía",
    desc: "Leer ficción entrena la capacidad de comprender perspectivas ajenas.",
    color: "#E8637A",
    bg: "#FFB3BA33",
  },
  {
    icon: PenLine,
    title: "Mejor escritura",
    desc: "Los lectores habituales desarrollan naturalmente mejor sintaxis y expresión escrita.",
    color: "#7B79E8",
    bg: "#B5B3FF33",
  },
];

const BenefitCard = ({ icon: Icon, title, desc, color, bg, delay }) => (
  <motion.div
    initial={{ y: 20, opacity: 0 }}
    animate={{ y: 0, opacity: 1 }}
    transition={{ delay, duration: 0.4 }}
    className="rounded-2xl px-[1.3vw] py-[1.3vh] border shadow-sm flex flex-col gap-[0.5vh]"
    style={{ backgroundColor: bg, borderColor: `${color}44` }}
  >
    <div className="flex items-center gap-[0.5vw] pb-2">
      <Icon className="w-[1.4vw] h-[1.4vw] shrink-0" style={{ color }} />
      <span className="text-[1.4vw] font-black text-das-text">{title}</span>
    </div>
    <p className="text-[1.3vw] text-das-text/65 leading-snug">{desc}</p>
  </motion.div>
);

const ReadingBenefitsSlide = () => (
  <div className="relative w-full h-full flex flex-col items-center justify-center px-[5vw] z-10">
    <motion.h2
      initial={{ y: -20, opacity: 0 }}
      animate={{ y: 0, opacity: 1 }}
      className="text-[3.1vw] font-black text-das-text mb-[0.5vh] text-center"
    >
      Pero leer importa. <span className="text-das-primary">Mucho.</span>
    </motion.h2>
    <motion.p
      initial={{ opacity: 0 }}
      animate={{ opacity: 1 }}
      transition={{ delay: 0.2 }}
      className="text-[1.25vw] text-das-text/55 mb-[2.5vh] text-center"
    >
      Lo que Ricardo está perdiendo cada noche que elige YouTube en lugar de un
      libro:
    </motion.p>

    <div className="grid grid-cols-3 gap-[1.5vw] w-full">
      {benefits.map((b, i) => (
        <BenefitCard key={b.title} {...b} delay={0.25 + i * 0.1} />
      ))}
    </div>

    <motion.div
      initial={{ y: 10, opacity: 0 }}
      animate={{ y: 0, opacity: 1 }}
      transition={{ delay: 0.9 }}
      className="mt-[2.5vh] bg-das-primary/10 border border-das-primary/30 rounded-2xl px-[2.5vw] py-[1.2vh] text-center"
    >
      <p className="text-[1.3vw] font-bold text-das-primary">
        Ricardo lo sabe. Pero el cerebro elige la dopamina rápida: a menos que
        leer la provea.
      </p>
    </motion.div>
  </div>
);

export default ReadingBenefitsSlide;
