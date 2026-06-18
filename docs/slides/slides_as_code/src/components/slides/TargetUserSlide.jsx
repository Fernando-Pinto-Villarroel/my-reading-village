import { motion } from "framer-motion";
import {
  BookOpen,
  Smartphone,
  Clock,
  Zap,
  Users,
  Gamepad2,
  Wallet,
} from "lucide-react";

const Tag = ({ icon: Icon, text, color, delay }) => (
  <motion.div
    initial={{ scale: 0, opacity: 0 }}
    animate={{ scale: 1, opacity: 1 }}
    transition={{ delay, type: "spring", stiffness: 200 }}
    className="flex items-center gap-[0.5vw] bg-white/80 backdrop-blur-sm rounded-full px-[1.2vw] py-[0.6vh] border shadow-sm"
    style={{ borderColor: `${color}55` }}
  >
    <Icon className="w-[1.1vw] h-[1.1vw]" style={{ color }} />
    <span className="text-[1.1vw] font-semibold text-das-text">{text}</span>
  </motion.div>
);

const PROFILE = [
  { icon: Users, text: "12–35 años", color: "#E8637A" },
  { icon: Smartphone, text: "Android primero", color: "#7B79E8" },
  { icon: BookOpen, text: "Hábitos / crecimiento", color: "#2E9E6B" },
  {
    icon: Gamepad2,
    text: "Duolingo - Habitica - Clash of Clans",
    color: "#F4A261",
  },
  { icon: Clock, text: "Tiempo / distracción", color: "#B5B3FF" },
  { icon: Wallet, text: "Freemium", color: "#E8637A" },
];

const TargetUserSlide = () => (
  <div className="relative w-full h-full flex flex-col items-center justify-center px-[5vw] z-10 gap-[2vh]">
    <div className="flex items-center gap-[4vw] w-full max-w-[90vw]">
      <motion.div
        initial={{ x: -40, opacity: 0 }}
        animate={{ x: 0, opacity: 1 }}
        transition={{ duration: 0.6 }}
        className="flex flex-col items-center shrink-0"
      >
        <div
          className="w-[14vw] h-[14vw] rounded-full flex items-center justify-center shadow-xl border-4 border-das-light mb-[2vh]"
          style={{
            background: "linear-gradient(135deg, #FFB3BA 0%, #B5B3FF 100%)",
          }}
        >
          <span className="text-[6vw]">📚</span>
        </div>
        <motion.div
          initial={{ y: 10, opacity: 0 }}
          animate={{ y: 0, opacity: 1 }}
          transition={{ delay: 0.5 }}
          className="text-center"
        >
          <h2 className="text-[3vw] font-black text-das-primary">
            Ricardo Pinto
          </h2>
          <p className="text-[1.2vw] text-das-text/60 font-semibold">
            13 años - Pre-adolescente
          </p>
        </motion.div>
      </motion.div>

      <div className="flex-1">
        <motion.div
          initial={{ y: -15, opacity: 0 }}
          animate={{ y: 0, opacity: 1 }}
          transition={{ delay: 0.2 }}
          className="bg-das-mint/30 border border-das-mint rounded-2xl px-[1.8vw] py-[1.5vh] mb-[1.8vh]"
        >
          <div className="flex items-center gap-[0.6vw] mb-[0.6vh]">
            <BookOpen className="w-[1.3vw] h-[1.3vw] text-green-600" />
            <span className="text-[1.1vw] font-black text-green-700 uppercase tracking-wide">
              Le gusta leer
            </span>
          </div>
          <p className="text-[1.1vw] text-das-text/70">
            De hecho, tiene libros pendientes. Sabe que leer le hace bien.
          </p>
        </motion.div>

        <motion.div
          initial={{ y: -15, opacity: 0 }}
          animate={{ y: 0, opacity: 1 }}
          transition={{ delay: 0.35 }}
          className="bg-das-light/40 border border-das-primary/30 rounded-2xl px-[1.8vw] py-[1.5vh] mb-[1.8vh]"
        >
          <div className="flex items-center gap-[0.6vw] mb-[0.6vh]">
            <Smartphone className="w-[1.3vw] h-[1.3vw] text-das-primary" />
            <span className="text-[1.1vw] font-black text-das-primary uppercase tracking-wide">
              Pero la dopamina rápida gana siempre
            </span>
          </div>
          <p className="text-[1.1vw] text-das-text/70">
            TikTok, YouTube, Clash of Clans. Entre clases y actividades, el
            celular llena cada hueco.
          </p>
        </motion.div>

        <motion.div
          initial={{ y: -15, opacity: 0 }}
          animate={{ y: 0, opacity: 1 }}
          transition={{ delay: 0.5 }}
          className="bg-das-lavender/30 border border-das-accent/30 rounded-2xl px-[1.8vw] py-[1.5vh] mb-[2vh]"
        >
          <div className="flex items-center gap-[0.6vw] mb-[0.6vh]">
            <Clock className="w-[1.3vw] h-[1.3vw] text-das-accent" />
            <span className="text-[1.1vw] font-black text-das-accent uppercase tracking-wide">
              Tiene 20–30 min antes de dormir
            </span>
          </div>
          <p className="text-[1.1vw] text-das-text/70">
            Los usa en YouTube o jugando algo. El libro está en el cajón.
          </p>
        </motion.div>

        <motion.div
          initial={{ y: 10, opacity: 0 }}
          animate={{ y: 0, opacity: 1 }}
          transition={{ delay: 0.65 }}
          className="flex items-start gap-[0.8vw] bg-white/60 rounded-2xl px-[1.8vw] py-[1.2vh] border border-das-gold/40 shadow-sm"
        >
          <Zap className="w-[1.3vw] h-[1.3vw] text-das-gold mt-[0.2vh] shrink-0" />
          <p className="text-[1.1vw] text-das-text/80 font-semibold italic leading-snug">
            "No tengo tiempo para leer" es la excusa. La realidad: la lectura no
            puede competir contra plataformas diseñadas para enganchar. Este
            problema no es solo de Ricardo: es de cualquiera que busca
            justificar su falta de deseo por leer frente a alternativas que
            generan más placer a corto plazo.
          </p>
        </motion.div>
      </div>
    </div>

    <motion.div
      initial={{ y: 16, opacity: 0 }}
      animate={{ y: 0, opacity: 1 }}
      transition={{ duration: 0.45 }}
      className="w-full max-w-[90vw] bg-white/75 backdrop-blur-sm border-2 border-das-primary/20 rounded-2xl px-[2vw] py-[1.1vh] flex flex-col items-center gap-[1vh] shadow-sm"
    >
      <span className="text-[1.1vw] font-black text-das-primary uppercase tracking-widest">
        Target general
      </span>
      <div className="w-full h-px bg-das-primary/20" />
      <div className="flex items-center justify-center gap-[1.2vw] flex-wrap">
        {PROFILE.map(({ icon, text, color }, i) => (
          <Tag
            key={text}
            icon={icon}
            text={text}
            color={color}
            delay={0.05 * (i + 1)}
          />
        ))}
      </div>
    </motion.div>
  </div>
);

export default TargetUserSlide;
