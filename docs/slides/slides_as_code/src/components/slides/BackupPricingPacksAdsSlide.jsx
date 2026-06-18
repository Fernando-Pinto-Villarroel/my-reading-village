import { motion } from "framer-motion";
import { Package, Tv } from "lucide-react";

const PACKS = [
  {
    id: "Starter",
    price: "$1.99",
    savings: "20%",
    bg: "#FFB3BA",
    contents: "200 monedas · 100 madera · 60 metal · 2 sándwich",
  },
  {
    id: "Builder",
    price: "$3.49",
    savings: "20%",
    bg: "#FFD700",
    contents: "400 monedas · 200 madera · 120 metal · 3 martillos",
  },
  {
    id: "Reader",
    price: "$4.99",
    savings: "15%",
    bg: "#B5B3FF",
    contents:
      "200 monedas · 50 gemas · 3 libros · 3 gafas · Capybara (especie)",
  },
  {
    id: "Village",
    price: "$9.99",
    savings: "25%",
    bg: "#B3FFD9",
    contents:
      "500 monedas · 200 madera · 100 metal · 100 gemas · 5 sándwich · 5 martillos · Otter (especie)",
  },
  {
    id: "Mega",
    price: "$19.99",
    savings: "25%",
    bg: "#FFCDD2",
    contents:
      "1 000 monedas · 500 madera · 200 metal · 200 gemas · 10× todos los power-ups · Kangaroo (especie)",
  },
];

const BackupPricingPacksAdsSlide = () => (
  <div className="relative w-full h-full flex flex-col items-center justify-center px-[4vw] z-10 gap-[2.5vh]">
    <motion.div
      initial={{ y: -20, opacity: 0 }}
      animate={{ y: 0, opacity: 1 }}
      className="w-full max-w-[88vw]"
    >
      <div className="flex items-center gap-[0.6vw] mb-[1.2vh]">
        <Package className="w-[1.4vw] h-[1.4vw] text-das-primary" />
        <h2 className="text-[1.5vw] font-black text-das-text uppercase tracking-wide">
          Packs IAP - consumibles
        </h2>
      </div>
      <div className="bg-white/70 backdrop-blur-sm rounded-2xl overflow-hidden border border-das-light shadow-md">
        <div className="grid grid-cols-[9vw_1fr_6.5vw_5.5vw] bg-das-primary px-[1.2vw] py-[0.7vh] text-[0.85vw] font-black uppercase tracking-wide text-white">
          <span>Pack</span>
          <span>Contenido</span>
          <span className="text-center">Precio</span>
          <span className="text-center">Ahorro</span>
        </div>
        {PACKS.map(({ id, price, savings, bg, contents }, i) => (
          <div
            key={id}
            className={`grid grid-cols-[9vw_1fr_6.5vw_5.5vw] items-center px-[1.2vw] py-[0.85vh] text-[0.88vw] ${
              i % 2 === 0 ? "bg-das-light/20" : "bg-white/60"
            }`}
          >
            <span
              className="font-black px-[0.6vw] py-[0.3vh] rounded-lg text-[0.88vw] text-center text-das-text"
              style={{ background: bg }}
            >
              {id}
            </span>
            <span className="text-das-text/70 px-[0.8vw] leading-tight">
              {contents}
            </span>
            <span className="text-das-primary font-bold text-center">
              {price}
            </span>
            <span className="text-green-600 font-bold text-center">
              -{savings}
            </span>
          </div>
        ))}
      </div>
    </motion.div>

    <motion.div
      initial={{ y: 20, opacity: 0 }}
      animate={{ y: 0, opacity: 1 }}
      transition={{ delay: 0.3 }}
      className="w-full max-w-[88vw] bg-white/70 backdrop-blur-sm border-2 border-das-accent/30 rounded-2xl px-[2vw] py-[1.5vh] flex items-center gap-[2vw] shadow-md"
    >
      <div className="bg-das-accent/10 p-[0.8vw] rounded-xl shrink-0">
        <Tv className="w-[2vw] h-[2vw] text-das-accent" />
      </div>
      <div className="flex-1">
        <p className="text-[1.05vw] font-black text-das-text uppercase tracking-wide mb-[0.4vh]">
          Publicidad - Unity Ads (Rewarded Video)
        </p>
        <p className="text-[0.9vw] text-das-text/60 leading-snug">
          El jugador elige ver un video a cambio de recursos bonus.
          Completamente opcional · sin banners ni intersticiales · Unity Ads SDK
          · Game ID:{" "}
          <span className="font-mono text-das-primary">800005941</span> ·
          Placement:{" "}
          <span className="font-mono text-das-primary">Rewarded_Android</span>
        </p>
      </div>
      <div className="shrink-0 text-right space-y-[0.3vh]">
        <p className="text-[0.82vw] bg-green-100 text-green-700 font-bold px-[0.6vw] py-[0.2vh] rounded-full">
          100% opt-in
        </p>
        <p className="text-[0.82vw] bg-das-light/60 text-das-text/50 px-[0.6vw] py-[0.2vh] rounded-full">
          Sin banners
        </p>
      </div>
    </motion.div>
  </div>
);

export default BackupPricingPacksAdsSlide;
