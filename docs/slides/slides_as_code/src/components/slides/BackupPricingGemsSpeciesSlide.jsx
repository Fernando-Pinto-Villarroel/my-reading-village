import { motion } from "framer-motion";
import { Gem, Users } from "lucide-react";

const GEMS = [
  { gems: 50, price: "$0.99" },
  { gems: 100, price: "$1.79" },
  { gems: 200, price: "$3.29" },
  { gems: 500, price: "$7.99" },
  { gems: 1000, price: "$14.99" },
  { gems: 2000, price: "$29.99" },
];

const SPECIES_TIERS = [
  {
    tier: "Free",
    price: "$0",
    count: 10,
    bg: "#B3FFD9",
    fg: "#2E9E6B",
    examples: "Cat, Dog, Rabbit, Koala, Hamster…",
    note: "Se desbloquean por nivel",
  },
  {
    tier: "Tier 1",
    price: "$1.99",
    count: 9,
    bg: "#FFB3BA",
    fg: "#E8637A",
    examples: "Grizzly, Polar Bear, Panda, Red Panda, Sloth, Hedgehog…",
    note: "IAP no-consumible",
  },
  {
    tier: "Tier 2",
    price: "$4.99",
    count: 9,
    bg: "#B5B3FF",
    fg: "#7B79E8",
    examples: "Bull, Otter, Kangaroo, Reindeer, Ferret, Mole, Bat…",
    note: "IAP no-consumible",
  },
  {
    tier: "Tier 3",
    price: "$7.99",
    count: 7,
    bg: "#FFDFC4",
    fg: "#C4714A",
    examples: "Monkey, Gorilla, Zebra, Horse, Skunk, Hyena, Mouse",
    note: "IAP no-consumible",
  },
  {
    tier: "Tier 4",
    price: "$13.99",
    count: 6,
    bg: "#FFD700",
    fg: "#8A6C00",
    examples: "Lion, Armadillo, Beaver, Fox, Tiger, Leopard",
    note: "IAP no-consumible",
  },
];

const BackupPricingGemsSpeciesSlide = () => (
  <div className="relative w-full h-full flex items-center justify-center px-[4vw] z-10">
    <div className="w-full max-w-[90vw] flex gap-[3vw]">
      <motion.div
        initial={{ x: -30, opacity: 0 }}
        animate={{ x: 0, opacity: 1 }}
        transition={{ duration: 0.5 }}
        className="flex-1"
      >
        <div className="flex items-center gap-[0.6vw] mb-[1.5vh]">
          <Gem className="w-[1.4vw] h-[1.4vw] text-das-accent" />
          <h2 className="text-[1.5vw] font-black text-das-text uppercase tracking-wide">
            Gems - IAP consumibles
          </h2>
        </div>
        <div className="bg-white/70 backdrop-blur-sm rounded-2xl overflow-hidden border border-das-light shadow-md">
          <div className="grid grid-cols-2 bg-das-primary px-[1.2vw] py-[0.7vh] text-[0.95vw] font-black uppercase tracking-wide text-white">
            <span>Gemas</span>
            <span className="text-right">Precio USD</span>
          </div>
          {GEMS.map(({ gems, price }, i) => (
            <div
              key={gems}
              className={`grid grid-cols-2 px-[1.2vw] py-[0.85vh] text-[1.1vw] font-semibold ${
                i % 2 === 0 ? "bg-das-light/20" : "bg-white/60"
              }`}
            >
              <span className="text-das-text">💎 {gems.toLocaleString()}</span>
              <span className="text-right text-das-primary font-bold">
                {price}
              </span>
            </div>
          ))}
        </div>
        <p className="text-[0.9vw] text-das-text/60 mt-[0.8vh] italic">
          Consumibles - Google Play Billing
        </p>
      </motion.div>

      <motion.div
        initial={{ x: 30, opacity: 0 }}
        animate={{ x: 0, opacity: 1 }}
        transition={{ duration: 0.5, delay: 0.1 }}
        className="flex-1"
      >
        <div className="flex items-center gap-[0.6vw] mb-[1.5vh]">
          <Users className="w-[1.4vw] h-[1.4vw] text-das-primary" />
          <h2 className="text-[1.5vw] font-black text-das-text uppercase tracking-wide">
            Species Tiers - no-consumibles
          </h2>
        </div>
        <div className="flex flex-col gap-[0.8vh]">
          {SPECIES_TIERS.map(
            ({ tier, price, count, bg, fg, examples, note }, i) => (
              <motion.div
                key={tier}
                initial={{ x: 20, opacity: 0 }}
                animate={{ x: 0, opacity: 1 }}
                transition={{ delay: 0.15 + i * 0.07 }}
                className="flex items-center gap-[1vw] bg-white/70 rounded-xl px-[1.2vw] py-[0.75vh] border shadow-sm"
                style={{ borderColor: `${bg}99` }}
              >
                <span
                  className="text-[1.1vw] font-black px-[0.7vw] py-[0.3vh] rounded-lg shrink-0 min-w-[4.5vw] text-center"
                  style={{ background: bg, color: fg }}
                >
                  {tier}
                </span>
                <div className="flex-1 min-w-0">
                  <p className="text-[0.95vw] text-das-text/80 leading-tight truncate">
                    {examples}
                  </p>
                </div>
                <div className="text-right shrink-0">
                  <p className="text-[1.25vw] font-black" style={{ color: fg }}>
                    {price}
                  </p>
                  <p className="text-[0.95vw] text-das-text/60">
                    {count} especies
                  </p>
                </div>
              </motion.div>
            ),
          )}
        </div>
        <p className="text-[0.9vw] text-das-text/60 mt-[0.8vh] italic">
          41 especies en total - permanentes una vez compradas
        </p>
      </motion.div>
    </div>
  </div>
);

export default BackupPricingGemsSpeciesSlide;
