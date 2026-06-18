import { motion } from "framer-motion";
import { TrendingUp, Smartphone, Target } from "lucide-react";

const MarketSlide = () => (
  <div className="relative w-full h-full flex flex-col items-center justify-center px-[5vw] z-10">
    <motion.h2
      initial={{ y: -20, opacity: 0 }}
      animate={{ y: 0, opacity: 1 }}
      className="text-[2.8vw] font-black text-das-text mb-[0.5vh] text-center"
    >
      El mercado es grande.{" "}
      <span className="text-das-primary">Y va hacia arriba.</span>
    </motion.h2>
    <motion.p
      initial={{ opacity: 0 }}
      animate={{ opacity: 1 }}
      transition={{ delay: 0.15 }}
      className="text-[1.15vw] text-das-text/55 mb-[2.5vh] text-center"
    >
      MRV vive en la intersección de dos mercados en crecimiento sostenido.
    </motion.p>

    <div className="flex gap-[2vw] w-full mb-[2.5vh]">
      <motion.div
        initial={{ y: 20, opacity: 0 }}
        animate={{ y: 0, opacity: 1 }}
        transition={{ delay: 0.2 }}
        className="flex-1 flex flex-col justify-center bg-white/70 backdrop-blur-sm rounded-3xl p-[2vw] border border-das-light shadow-md"
      >
        <div className="flex items-center gap-[0.6vw] mb-[1.2vh]">
          <TrendingUp className="w-[1.5vw] h-[1.5vw] text-das-primary" />
          <span className="text-[1.3vw] font-black text-das-text/60 uppercase tracking-wide">
            TAM
          </span>
        </div>
        <div className="mb-[1.5vh]">
          <p className="text-[0.95vw] font-bold text-das-text/50 uppercase mb-[0.3vh]">
            Book Reading Apps
          </p>
          <p className="text-[1.7vw] font-black text-das-primary">
            USD 1.2B → 2.56B
          </p>
          <p className="text-[0.95vw] text-das-text/65">
            2024 → 2032 - CAGR 8.1% - Verified Market Research
          </p>
        </div>
        <div>
          <p className="text-[0.95vw] font-bold text-das-text/50 uppercase mb-[0.3vh]">
            Gamification (global)
          </p>
          <p className="text-[1.7vw] font-black text-das-accent">
            USD 26.9B → 92.4B
          </p>
          <p className="text-[0.95vw] text-das-text/65">
            2025 → 2030 - CAGR ~28% - The Business Research Co.
          </p>
        </div>
      </motion.div>

      <motion.div
        initial={{ y: 20, opacity: 0 }}
        animate={{ y: 0, opacity: 1 }}
        transition={{ delay: 0.3 }}
        className="flex-1 flex flex-col justify-center bg-white/70 backdrop-blur-sm rounded-3xl p-[2vw] border border-das-light shadow-md"
      >
        <div className="flex items-center gap-[0.6vw] mb-[1.2vh]">
          <Target className="w-[1.5vw] h-[1.5vw] text-das-accent" />
          <span className="text-[1.3vw] font-black text-das-text/60 uppercase tracking-wide">
            SAM
          </span>
        </div>
        <p className="text-[1.25vw] font-semibold text-das-text mb-[0.8vh] leading-snug">
          Lectores jóvenes Android con hábito de gaming casual y modelo freemium
        </p>
        <p className="text-[1.2vw] text-das-text/55 leading-snug">
          El subconjunto del TAM que ya entiende el lenguaje de Duolingo,
          Habitica y Clash of Clans: y que siente la tensión de "debería leer
          más".
        </p>
      </motion.div>

      <motion.div
        initial={{ y: 20, opacity: 0 }}
        animate={{ y: 0, opacity: 1 }}
        transition={{ delay: 0.4 }}
        className="flex-1 flex flex-col justify-center bg-das-primary/8 rounded-3xl p-[2vw] border-2 border-das-primary/30 shadow-md"
      >
        <div className="flex items-center gap-[0.6vw] mb-[1.2vh]">
          <Smartphone className="w-[1.5vw] h-[1.5vw] text-das-primary" />
          <span className="text-[1.3vw] font-black text-das-primary uppercase tracking-wide">
            SOM: Objetivo
          </span>
        </div>
        <div className="space-y-[0.8vh]">
          <div>
            <p className="text-[0.95vw] text-das-text/50 font-semibold uppercase">
              Año 1
            </p>
            <p className="text-[1.9vw] font-black text-das-primary">
              1.000 MAU
            </p>
          </div>
          <div>
            <p className="text-[0.95vw] text-das-text/50 font-semibold uppercase">
              Año 3
            </p>
            <p className="text-[1.6vw] font-black text-das-text">22.000 MAU</p>
          </div>
        </div>
      </motion.div>
    </div>

    <motion.div
      initial={{ y: 10, opacity: 0 }}
      animate={{ y: 0, opacity: 1 }}
      transition={{ delay: 0.65 }}
      className="flex items-center gap-[0.7vw] bg-white/60 rounded-2xl px-[2vw] py-[1vh] border border-das-light mb-[1.5vh]"
    >
      <Smartphone className="w-[1.2vw] h-[1.2vw] text-das-text/50 shrink-0" />
      <p className="text-[1.2vw] text-das-text/65 font-semibold">
        Android representa más del 70% de los smartphones en circulación: MRV es
        Android-first.
      </p>
      <span className="text-[0.95vw] text-das-text/75 ml-auto shrink-0">
        Fuente: CommandLinux / StatCounter (2026)
      </span>
    </motion.div>

    <motion.div
      initial={{ y: 10, opacity: 0 }}
      animate={{ y: 0, opacity: 1 }}
      transition={{ delay: 0.8 }}
      className="flex items-center justify-center gap-[1.5vw]"
    >
      {[
        {
          href: "https://www.instagram.com/myreadingvillage/",
          label: "@myreadingvillage",
          color: "#E1306C",
          icon: (
            <svg
              viewBox="0 0 24 24"
              fill="currentColor"
              className="w-[1.3vw] h-[1.3vw]"
            >
              <path d="M12 2.163c3.204 0 3.584.012 4.85.07 3.252.148 4.771 1.691 4.919 4.919.058 1.265.069 1.645.069 4.849 0 3.205-.012 3.584-.069 4.849-.149 3.225-1.664 4.771-4.919 4.919-1.266.058-1.644.07-4.85.07-3.204 0-3.584-.012-4.849-.07-3.26-.149-4.771-1.699-4.919-4.92-.058-1.265-.07-1.644-.07-4.849 0-3.204.013-3.583.07-4.849.149-3.227 1.664-4.771 4.919-4.919 1.266-.057 1.645-.069 4.849-.069zm0-2.163c-3.259 0-3.667.014-4.947.072-4.358.2-6.78 2.618-6.98 6.98-.059 1.281-.073 1.689-.073 4.948 0 3.259.014 3.668.072 4.948.2 4.358 2.618 6.78 6.98 6.98 1.281.058 1.689.072 4.948.072 3.259 0 3.668-.014 4.948-.072 4.354-.2 6.782-2.618 6.979-6.98.059-1.28.073-1.689.073-4.948 0-3.259-.014-3.667-.072-4.947-.196-4.354-2.617-6.78-6.979-6.98-1.281-.059-1.69-.073-4.949-.073zm0 5.838c-3.403 0-6.162 2.759-6.162 6.162s2.759 6.163 6.162 6.163 6.162-2.759 6.162-6.163c0-3.403-2.759-6.162-6.162-6.162zm0 10.162c-2.209 0-4-1.79-4-4 0-2.209 1.791-4 4-4s4 1.791 4 4c0 2.21-1.791 4-4 4zm6.406-11.845c-.796 0-1.441.645-1.441 1.44s.645 1.44 1.441 1.44c.795 0 1.439-.645 1.439-1.44s-.644-1.44-1.439-1.44z" />
            </svg>
          ),
        },
        {
          href: "https://www.tiktok.com/@myreadingvillage",
          label: "@myreadingvillage",
          color: "#010101",
          icon: (
            <svg
              viewBox="0 0 24 24"
              fill="currentColor"
              className="w-[1.3vw] h-[1.3vw]"
            >
              <path d="M19.59 6.69a4.83 4.83 0 01-3.77-4.25V2h-3.45v13.67a2.89 2.89 0 01-2.88 2.5 2.89 2.89 0 01-2.89-2.89 2.89 2.89 0 012.89-2.89c.28 0 .54.04.79.1V9.01a6.33 6.33 0 00-.79-.05 6.34 6.34 0 00-6.34 6.34 6.34 6.34 0 006.34 6.34 6.34 6.34 0 006.33-6.34V8.69a8.18 8.18 0 004.78 1.52V6.77a4.85 4.85 0 01-1.01-.08z" />
            </svg>
          ),
        },
        {
          href: "https://www.facebook.com/myreadingvillage/",
          label: "myreadingvillage",
          color: "#1877F2",
          icon: (
            <svg
              viewBox="0 0 24 24"
              fill="currentColor"
              className="w-[1.3vw] h-[1.3vw]"
            >
              <path d="M24 12.073c0-6.627-5.373-12-12-12s-12 5.373-12 12c0 5.99 4.388 10.954 10.125 11.854v-8.385H7.078v-3.47h3.047V9.43c0-3.007 1.792-4.669 4.533-4.669 1.312 0 2.686.235 2.686.235v2.953H15.83c-1.491 0-1.956.925-1.956 1.874v2.25h3.328l-.532 3.47h-2.796v8.385C19.612 23.027 24 18.062 24 12.073z" />
            </svg>
          ),
        },
        {
          href: "https://www.youtube.com/@myreadingvillage",
          label: "@myreadingvillage",
          color: "#FF0000",
          icon: (
            <svg
              viewBox="0 0 24 24"
              fill="currentColor"
              className="w-[1.3vw] h-[1.3vw]"
            >
              <path d="M23.498 6.186a3.016 3.016 0 0 0-2.122-2.136C19.505 3.545 12 3.545 12 3.545s-7.505 0-9.377.505A3.017 3.017 0 0 0 .502 6.186C0 8.07 0 12 0 12s0 3.93.502 5.814a3.016 3.016 0 0 0 2.122 2.136c1.871.505 9.376.505 9.376.505s7.505 0 9.377-.505a3.015 3.015 0 0 0 2.122-2.136C24 15.93 24 12 24 12s0-3.93-.502-5.814zM9.545 15.568V8.432L15.818 12l-6.273 3.568z" />
            </svg>
          ),
        },
        {
          href: "https://www.reddit.com/user/myreadingvillage/",
          label: "u/myreadingvillage",
          color: "#FF4500",
          icon: (
            <svg
              viewBox="0 0 24 24"
              fill="currentColor"
              className="w-[1.3vw] h-[1.3vw]"
            >
              <path d="M12 0A12 12 0 0 0 0 12a12 12 0 0 0 12 12 12 12 0 0 0 12-12A12 12 0 0 0 12 0zm5.01 4.744c.688 0 1.25.561 1.25 1.249a1.25 1.25 0 0 1-2.498.056l-2.597-.547-.8 3.747c1.824.07 3.48.632 4.674 1.488.308-.309.73-.491 1.207-.491.968 0 1.754.786 1.754 1.754 0 .716-.435 1.333-1.01 1.614a3.111 3.111 0 0 1 .042.52c0 2.694-3.13 4.87-7.004 4.87-3.874 0-7.004-2.176-7.004-4.87 0-.183.015-.366.043-.534A1.748 1.748 0 0 1 4.028 12c0-.968.786-1.754 1.754-1.754.463 0 .898.196 1.207.49 1.207-.883 2.878-1.43 4.744-1.487l.885-4.182a.342.342 0 0 1 .14-.197.35.35 0 0 1 .238-.042l2.906.617a1.214 1.214 0 0 1 1.108-.701zM9.25 12C8.561 12 8 12.562 8 13.25c0 .687.561 1.248 1.25 1.248.687 0 1.248-.561 1.248-1.249 0-.688-.561-1.249-1.249-1.249zm5.5 0c-.687 0-1.248.561-1.248 1.25 0 .687.561 1.248 1.249 1.248.688 0 1.249-.561 1.249-1.249 0-.687-.562-1.249-1.25-1.249zm-5.466 3.99a.327.327 0 0 0-.231.094.33.33 0 0 0 0 .463c.842.842 2.484.913 2.961.913.477 0 2.105-.056 2.961-.913a.361.361 0 0 0 .029-.463.33.33 0 0 0-.464 0c-.547.533-1.684.73-2.512.73-.828 0-1.979-.196-2.512-.73a.326.326 0 0 0-.232-.095z" />
            </svg>
          ),
        },
      ].map((s) => (
        <a
          key={s.href}
          href={s.href}
          target="_blank"
          rel="noreferrer"
          className="flex items-center gap-[0.4vw] bg-white/60 backdrop-blur-sm rounded-xl px-[1vw] py-[0.5vh] border border-das-light hover:bg-white/90 transition-all"
          style={{ color: s.color }}
        >
          {s.icon}
          <span className="text-[0.8vw] font-bold text-das-text/70">
            {s.label}
          </span>
        </a>
      ))}
    </motion.div>
  </div>
);

export default MarketSlide;
