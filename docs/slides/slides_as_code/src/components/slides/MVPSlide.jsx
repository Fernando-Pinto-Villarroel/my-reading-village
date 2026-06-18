import { motion } from "framer-motion";
import {
  Smartphone,
  Star,
  CalendarDays,
  Gamepad2,
  Zap,
  Package,
} from "lucide-react";

const features = [
  {
    icon: Star,
    text: "41 especies de habitantes coleccionables",
    color: "#E8637A",
  },
  {
    icon: Package,
    text: "8 tipos de edificios × 3 niveles c/u",
    color: "#7B79E8",
  },
  {
    icon: CalendarDays,
    text: "13 eventos estacionales durante el año",
    color: "#2E9E6B",
  },
  {
    icon: Gamepad2,
    text: "4 minijuegos literarios integrados",
    color: "#CC7722",
  },
  { icon: Zap, text: "Registro de páginas en < 10 segundos", color: "#E8637A" },
  {
    icon: Smartphone,
    text: "Android - Flutter + Flame - SQLite local",
    color: "#7B79E8",
  },
];

const Badge = ({ label, color }) => (
  <span
    className="text-[0.95vw] font-bold px-[1.1vw] py-[0.5vh] rounded-full border"
    style={{ color, borderColor: `${color}55`, backgroundColor: `${color}18` }}
  >
    {label}
  </span>
);

const MVPSlide = () => (
  <div className="relative w-full h-full flex items-center justify-center px-[4vw] z-10">
    <div className="flex items-center gap-[3vw] w-full">
      <div className="flex-1">
        <motion.div
          initial={{ x: -20, opacity: 0 }}
          animate={{ x: 0, opacity: 1 }}
          className="mb-[2vh]"
        >
          <div className="flex items-center gap-[0.8vw] mb-[0.5vh]">
            <div className="bg-das-mint/40 border border-das-mint rounded-xl px-[1vw] py-[0.3vh]">
              <span className="text-[0.85vw] font-black text-green-700 uppercase tracking-wide">
                Ya está construido
              </span>
            </div>
            <div className="bg-das-gold/20 border border-das-gold/50 rounded-xl px-[1vw] py-[0.3vh]">
              <span className="text-[0.85vw] font-black text-yellow-700 uppercase tracking-wide">
                Pronto en Google Play
              </span>
            </div>
          </div>
          <h2 className="text-[2.7vw] font-black text-das-text">
            MVP: <span className="text-das-primary">App real, no mockup</span>
          </h2>
          <p className="text-[1.3vw] text-das-text/55 mt-[0.4vh]">
            No es un prototipo en Figma. Es una app funcional completa esperando
            aprobación de Google.
          </p>
        </motion.div>

        <div className="flex flex-col gap-[0.9vh] mb-[2vh]">
          {features.map((f, i) => (
            <motion.div
              key={f.text}
              initial={{ x: -15, opacity: 0 }}
              animate={{ x: 0, opacity: 1 }}
              transition={{ delay: 0.2 + i * 0.1 }}
              className="flex items-center gap-[0.7vw] bg-white/60 rounded-xl px-[1.2vw] py-[0.7vh] border border-das-light/60"
            >
              <f.icon
                className="w-[1.2vw] h-[1.2vw] shrink-0"
                style={{ color: f.color }}
              />
              <span className="text-[1.2vw] text-das-text font-semibold">
                {f.text}
              </span>
            </motion.div>
          ))}
        </div>

        <motion.div
          initial={{ opacity: 0 }}
          animate={{ opacity: 1 }}
          transition={{ delay: 0.85 }}
          className="flex flex-wrap gap-[0.5vw]"
        >
          <Badge label="Flutter + Flame" color="#7B79E8" />
          <Badge label="SQLite local" color="#2E9E6B" />
          <Badge label="Open Library API" color="#CC7722" />
          <Badge label="Google Play Billing" color="#E8637A" />
          <Badge label="Firebase Analytics" color="#E8637A" />
        </motion.div>
      </div>

      <motion.div
        initial={{ x: 30, opacity: 0, scale: 0.93 }}
        animate={{ x: 0, opacity: 1, scale: 1 }}
        transition={{ delay: 0.15, duration: 0.6 }}
        className="flex gap-[1.2vw] shrink-0"
      >
        <img
          src="/screenshot-build.webp"
          alt="Build modal"
          className="h-[68vh] w-auto rounded-3xl shadow-xl border-4 border-das-light object-cover"
        />
        <img
          src="/screenshot-village.webp"
          alt="Village view"
          className="h-[68vh] w-auto rounded-3xl shadow-xl border-4 border-das-light object-cover"
        />
      </motion.div>
    </div>
  </div>
);

export default MVPSlide;
