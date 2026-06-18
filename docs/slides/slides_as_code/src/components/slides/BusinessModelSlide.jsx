import { motion } from "framer-motion";
import { ShoppingBag, Tv, Server } from "lucide-react";

const RevenueCard = ({ icon: Icon, title, items, color, bg, delay }) => (
  <motion.div
    initial={{ y: 25, opacity: 0 }}
    animate={{ y: 0, opacity: 1 }}
    transition={{ delay, duration: 0.45 }}
    className="flex-1 rounded-3xl p-[2vw] border-2 shadow-md"
    style={{ backgroundColor: bg, borderColor: `${color}55` }}
  >
    <div className="flex items-center gap-[0.6vw] mb-[1.5vh]">
      <Icon className="w-[1.6vw] h-[1.6vw]" style={{ color }} />
      <h3 className="text-[1.35vw] font-black" style={{ color }}>
        {title}
      </h3>
    </div>
    <ul className="space-y-[0.7vh]">
      {items.map((item) => (
        <li key={item} className="flex items-start gap-[0.4vw]">
          <span
            className="text-[1.05vw] font-bold mt-[0.1vh]"
            style={{ color }}
          >
            -
          </span>
          <span className="text-[1.10vw] text-das-text/75">{item}</span>
        </li>
      ))}
    </ul>
  </motion.div>
);

const Metric = ({ label, value, sub, color, delay }) => (
  <motion.div
    initial={{ scale: 0.8, opacity: 0 }}
    animate={{ scale: 1, opacity: 1 }}
    transition={{ delay, type: "spring" }}
    className="text-center px-[1.5vw] py-[1.2vh] bg-white/60 rounded-2xl border border-das-light shadow-sm"
  >
    <p className="text-[1.7vw] font-black" style={{ color }}>
      {value}
    </p>
    <p className="text-[1.1vw] font-bold text-das-text/60">{label}</p>
    {sub && <p className="text-[1.1vw] text-das-text/60">{sub}</p>}
  </motion.div>
);

const BusinessModelSlide = () => (
  <div className="relative w-full h-full flex flex-col items-center justify-center px-[5vw] z-10">
    <motion.h2
      initial={{ y: -20, opacity: 0 }}
      animate={{ y: 0, opacity: 1 }}
      className="text-[2.9vw] font-black text-das-text mb-[0.5vh] text-center"
    >
      Modelo de negocio:{" "}
      <span className="text-das-primary">Freemium sin paywall</span>
    </motion.h2>
    <motion.p
      initial={{ opacity: 0 }}
      animate={{ opacity: 1 }}
      transition={{ delay: 0.15 }}
      className="text-[1.35vw] text-das-text/55 mb-[2.5vh] text-center"
    >
      100% del progreso del juego es gratis. Solo se paga lo opcional.
    </motion.p>

    <div className="flex gap-[2vw] w-full mb-[2.5vh]">
      <RevenueCard
        icon={ShoppingBag}
        title="In-App Purchases (IAP)"
        items={[
          "Especies raras coleccionables",
          "Paquetes de cosméticos y decoraciones",
          "Atajos opcionales (no ventaja competitiva)",
          "Conversión objetivo: 2–4% de usuarios activos",
          "Ticket promedio estimado: USD 3–5",
        ]}
        color="#E8637A"
        bg="#FFB3BA22"
        delay={0.25}
      />
      <RevenueCard
        icon={Tv}
        title="Rewarded Ads (opcionales)"
        items={[
          "Iniciados 100% por el usuario (no interrumpen)",
          "Recompensa opcional: recursos o gemas extra",
          "eCPM estimado: USD 8–12",
          "Sin anuncios invasivos ni banners",
          "Refuerza el modelo de respeto al usuario",
        ]}
        color="#7B79E8"
        bg="#B5B3FF22"
        delay={0.35}
      />
    </div>

    <div className="flex gap-[1.5vw] w-full">
      <Metric
        label="ARPU objetivo"
        value="USD 0.30/mes"
        color="#E8637A"
        delay={0.5}
      />
      <Metric
        label="Conversión IAP objetivo"
        value="2–4%"
        sub="usuarios activos"
        color="#7B79E8"
        delay={0.6}
      />
      <Metric
        label="Costo marginal / usuario"
        value="≈ USD 0"
        sub="sin servidor"
        color="#2E9E6B"
        delay={0.7}
      />
      <motion.div
        initial={{ scale: 0.8, opacity: 0 }}
        animate={{ scale: 1, opacity: 1 }}
        transition={{ delay: 0.8, type: "spring" }}
        className="flex-1 text-center px-[1.5vw] py-[1.2vh] bg-das-mint/30 rounded-2xl border border-das-mint shadow-sm flex flex-col justify-center"
      >
        <div className="flex items-center justify-center gap-[0.4vw] mb-[0.3vh]">
          <Server className="w-[1.2vw] h-[1.2vw] text-green-700" />
          <p className="text-[1.35vw] font-black text-green-700">
            Ventaja estructural
          </p>
        </div>
        <p className="text-[1.2vw] text-das-text/60">
          Sin servidor → margen casi total sobre cada USD ingresado
        </p>
      </motion.div>
    </div>
  </div>
);

export default BusinessModelSlide;
