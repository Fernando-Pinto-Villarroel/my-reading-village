import { useRef } from "react";
import { useGSAP } from "@gsap/react";
import gsap from "gsap";
import { ScrollTrigger } from "gsap/ScrollTrigger";
import { motion } from "motion/react";
import {
  BookOpen,
  BookMarked,
  Building2,
  PawPrint,
  Gamepad2,
  Dices,
  CalendarDays,
  Coins,
  Home,
  Star,
} from "lucide-react";

gsap.registerPlugin(ScrollTrigger, useGSAP);

const steps = [
  {
    icon: BookOpen,
    color: "var(--color-lavender)",
    darkColor: "var(--color-dark-lavender)",
    step: "01",
    title: "Read",
    description:
      "Log every book and reading session — even ten pages counts. Track titles, authors, page counts, quotes, and time spent.",
  },
  {
    icon: Coins,
    color: "var(--color-mint)",
    darkColor: "var(--color-dark-mint)",
    step: "02",
    title: "Earn",
    description:
      "Every page you log earns coins, gems, wood and metal. The more you read, the faster your resources grow.",
  },
  {
    icon: Home,
    color: "var(--color-peach)",
    darkColor: "var(--color-medium-orange)",
    step: "03",
    title: "Build",
    description:
      "Spend your resources to build homes, parks, schools, libraries and more. Upgrade buildings and unlock new land as your village expands.",
  },
  {
    icon: Star,
    color: "var(--color-pink)",
    darkColor: "var(--color-dark-pink)",
    step: "04",
    title: "Collect",
    description:
      "Welcome adorable animal villagers — from common critters to legendary and godly rarities. Keep them happy and grow your collection one page at a time.",
  },
];

const features = [
  {
    Icon: BookMarked,
    iconColor: "var(--color-dark-lavender)",
    iconBg: "var(--color-lavender)",
    label: "Full reading tracker",
    desc: "Books, sessions, quotes, authors, time spent",
  },
  {
    Icon: Building2,
    iconColor: "var(--color-medium-orange)",
    iconBg: "var(--color-peach)",
    label: "Village builder",
    desc: "Homes, parks, schools, libraries and more",
  },
  {
    Icon: PawPrint,
    iconColor: "var(--color-dark-pink)",
    iconBg: "var(--color-pink)",
    label: "41 collectible villagers",
    desc: "Five rarity tiers — common to godly",
  },
  {
    Icon: Gamepad2,
    iconColor: "var(--color-dark-mint)",
    iconBg: "var(--color-mint)",
    label: "Literary minigames",
    desc: "Guess the author, match characters, real or fake titles",
  },
  {
    Icon: Dices,
    iconColor: "var(--color-dark-sky)",
    iconBg: "var(--color-sky)",
    label: "Daily lucky wheel",
    desc: "Free spin every day with surprise prizes",
  },
  {
    Icon: CalendarDays,
    iconColor: "var(--color-medium-orange)",
    iconBg: "var(--color-peach)",
    label: "Seasonal events",
    desc: "Halloween, Christmas, Easter and more",
  },
];

export default function HowItWorksSection() {
  const sectionRef = useRef<HTMLElement>(null);
  const stripRef = useRef<HTMLDivElement>(null);

  useGSAP(
    () => {
      const mm = gsap.matchMedia();

      mm.add(
        "(min-width: 768px) and (prefers-reduced-motion: no-preference)",
        () => {
          const cards = gsap.utils.toArray<HTMLElement>(".how-card");

          gsap.set(cards, { x: 70, opacity: 0, scale: 0.92 });

          const tl = gsap.timeline({
            scrollTrigger: {
              trigger: sectionRef.current,
              start: "top top",
              end: `+=${cards.length * 340}`,
              pin: true,
              pinSpacing: true,
              scrub: 1,
            },
          });

          cards.forEach((card, i) => {
            tl.to(
              card,
              { x: 0, opacity: 1, scale: 1, duration: 1, ease: "power2.out" },
              i * 0.9,
            );
          });
        },
      );

      mm.add("(max-width: 767px), (prefers-reduced-motion: reduce)", () => {
        gsap.set(".how-card", { opacity: 1, x: 0, scale: 1 });
      });
    },
    { scope: sectionRef },
  );

  return (
    <section
      ref={sectionRef}
      className="relative bg-cream py-14 md:py-20 overflow-hidden"
    >
      {/* Background decoration */}
      <div
        className="absolute -top-32 -right-32 w-96 h-96 rounded-full opacity-30 blur-3xl pointer-events-none"
        style={{ background: "var(--color-lavender)" }}
      />
      <div
        className="absolute -bottom-32 -left-32 w-96 h-96 rounded-full opacity-20 blur-3xl pointer-events-none"
        style={{ background: "var(--color-mint)" }}
      />

      <div ref={stripRef} className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        {/* Header */}
        <motion.div
          className="text-center mb-14 md:mb-20"
          initial={{ opacity: 0, y: 24 }}
          whileInView={{ opacity: 1, y: 0 }}
          viewport={{ once: true, margin: "-80px" }}
          transition={{ duration: 0.55, ease: "easeOut" }}
        >
          <span
            className="inline-block font-heading font-semibold text-sm tracking-widest uppercase mb-3"
            style={{ color: "var(--color-dark-lavender)" }}
          >
            How it works
          </span>
          <h2 className="font-heading font-extrabold text-3xl md:text-4xl lg:text-5xl text-dark-text leading-tight">
            Reading is the engine.
            <br />
            <span className="text-gradient">Your village is the reward.</span>
          </h2>
        </motion.div>

        {/* Cards grid */}
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-5 md:gap-6">
          {steps.map(({ icon: Icon, color, darkColor, step, title, description }) => (
            <motion.div
              key={step}
              className="how-card relative bg-soft-white rounded-3xl p-6 shadow-kawaii flex flex-col gap-4"
              whileHover={{ y: -6, boxShadow: "0 12px 40px 0 rgba(181,179,255,0.25)" }}
              transition={{ type: "spring", stiffness: 340, damping: 22 }}
            >
              {/* Step number */}
              <span
                className="absolute top-5 right-5 font-heading font-extrabold text-4xl leading-none select-none"
                style={{ color: darkColor, opacity: 0.45 }}
              >
                {step}
              </span>

              {/* Icon */}
              <div
                className="w-12 h-12 rounded-2xl flex items-center justify-center"
                style={{ background: color }}
              >
                <Icon size={22} style={{ color: darkColor }} strokeWidth={2.2} />
              </div>

              <div>
                <h3 className="font-heading font-bold text-2xl text-dark-text mb-1.5">
                  {title}
                </h3>
                <p
                  className="font-body text-base leading-relaxed"
                  style={{ color: "var(--color-dark-text)", opacity: 0.72 }}
                >
                  {description}
                </p>
              </div>
            </motion.div>
          ))}
        </div>

        {/* Feature list */}
        <motion.div
          className="relative z-10 mt-14 md:mt-20 grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4"
          initial={{ opacity: 0 }}
          whileInView={{ opacity: 1 }}
          viewport={{ once: true, margin: "-60px" }}
          transition={{ duration: 0.5, delay: 0.2 }}
        >
          {features.map(({ Icon, iconColor, iconBg, label, desc }) => (
            <motion.div
              key={label}
              className="flex items-center gap-4 bg-soft-white rounded-2xl p-4 shadow-kawaii"
              whileInView={{ opacity: 1, y: 0 }}
              initial={{ opacity: 0, y: 16 }}
              viewport={{ once: true }}
              transition={{ duration: 0.4 }}
            >
              <div
                className="w-10 h-10 rounded-xl flex items-center justify-center shrink-0"
                style={{ background: iconBg }}
              >
                <Icon size={18} style={{ color: iconColor }} strokeWidth={2} />
              </div>
              <div>
                <p className="font-heading font-semibold text-base text-dark-text">
                  {label}
                </p>
                <p
                  className="font-body text-sm mt-0.5"
                  style={{ color: "var(--color-dark-text)", opacity: 0.6 }}
                >
                  {desc}
                </p>
              </div>
            </motion.div>
          ))}
        </motion.div>
      </div>
    </section>
  );
}
