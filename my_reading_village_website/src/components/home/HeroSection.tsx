import { useRef } from "react";
import { useGSAP } from "@gsap/react";
import gsap from "gsap";
import { ScrollTrigger } from "gsap/ScrollTrigger";
import { motion, useScroll, useTransform } from "motion/react";
import CTAButton from "../common/CTAButton";

gsap.registerPlugin(ScrollTrigger, useGSAP);

const taglineWords =
  "Turn every page you read into a cozy village full of adorable animal friends.".split(
    " ",
  );

export default function HeroSection() {
  const containerRef = useRef<HTMLDivElement>(null);
  const bgRef = useRef<HTMLDivElement>(null);

  const { scrollYProgress } = useScroll({
    target: containerRef,
    offset: ["start start", "end start"],
  });
  const bgY = useTransform(scrollYProgress, [0, 1], ["0%", "25%"]);
  const contentY = useTransform(scrollYProgress, [0, 1], ["0%", "12%"]);
  const contentOpacity = useTransform(scrollYProgress, [0, 0.6], [1, 0]);

  useGSAP(
    () => {
      const mm = gsap.matchMedia();

      mm.add("(prefers-reduced-motion: no-preference)", () => {
        const tl = gsap.timeline({
          delay: 0.15,
          defaults: { ease: "power3.out" },
        });

        tl.fromTo(
          ".hero-logo",
          { scale: 0.55, opacity: 0, y: 18 },
          { scale: 1, opacity: 1, y: 0, duration: 0.85 },
        )
          .fromTo(
            ".hero-title",
            { opacity: 0, y: 14 },
            { opacity: 1, y: 0, duration: 0.55 },
            "-=0.4",
          )
          .fromTo(
            ".hero-word",
            { opacity: 0, y: 22, filter: "blur(4px)" },
            {
              opacity: 1,
              y: 0,
              filter: "blur(0px)",
              stagger: 0.055,
              duration: 0.55,
            },
            "-=0.25",
          )
          .fromTo(
            ".hero-cta",
            { opacity: 0, y: 18, scale: 0.94 },
            { opacity: 1, y: 0, scale: 1, duration: 0.5 },
            "-=0.15",
          )
          .fromTo(
            ".hero-badge",
            { opacity: 0, scale: 0.8 },
            { opacity: 1, scale: 1, stagger: 0.08, duration: 0.4 },
            "-=0.2",
          );
      });

      mm.add("(prefers-reduced-motion: reduce)", () => {
        gsap.set(
          [
            ".hero-logo",
            ".hero-title",
            ".hero-word",
            ".hero-cta",
            ".hero-badge",
          ],
          {
            opacity: 1,
            y: 0,
            scale: 1,
            filter: "none",
          },
        );
      });
    },
    { scope: containerRef },
  );

  return (
    <section
      ref={containerRef}
      className="relative min-h-screen flex items-center justify-center overflow-hidden"
    >
      {/* Parallax background */}
      <motion.div
        ref={bgRef}
        className="absolute inset-0 z-0"
        style={{ y: bgY }}
      >
        <img
          src="/assets/images/backgrounds/marketing_banner_horizontal.webp"
          alt=""
          className="w-full h-full object-cover object-center"
          loading="eager"
        />
      </motion.div>

      {/* Gradient overlay — single, reduced to let the artwork breathe */}
      <div
        className="absolute inset-0 z-10"
        style={{
          background:
            "linear-gradient(to bottom, rgba(254,240,244,0.08) 0%, rgba(254,240,244,0.42) 55%, var(--color-cream) 100%)",
        }}
      />

      {/* Content */}
      <motion.div
        className="relative z-20 flex flex-col items-center text-center px-5 max-w-4xl mx-auto pt-24 pb-32"
        style={{ y: contentY, opacity: contentOpacity }}
      >
        {/* Logo */}
        <div className="hero-logo mb-6">
          <img
            src="/assets/images/logos/my_reading_village_icon_rounded.webp"
            alt="My Reading Village"
            className="w-24 h-24 md:w-32 md:h-32 rounded-3xl shadow-kawaii-lg object-contain mx-auto"
          />
        </div>

        {/* App name */}
        <h1 className="hero-title font-heading font-extrabold text-4xl md:text-5xl lg:text-6xl text-dark-text mb-5 leading-tight">
          My Reading Village
        </h1>

        {/* Tagline — word-by-word reveal */}
        <p className="font-body font-medium text-lg md:text-xl lg:text-2xl text-dark-text/80 mb-8 max-w-2xl leading-relaxed">
          {taglineWords.map((word, i) => (
            <span key={i} className="hero-word inline-block mr-[0.28em]">
              {word}
            </span>
          ))}
        </p>

        {/* CTA */}
        <div className="hero-cta mb-10">
          <CTAButton href="#" size="lg" showIcon>
            Get it on Google Play
          </CTAButton>
        </div>

        {/* Resource badges */}
        <div className="grid grid-cols-2 sm:flex sm:flex-wrap sm:justify-center gap-3">
          {[
            { src: "/assets/images/resources/coin.webp", label: "Coins" },
            { src: "/assets/images/resources/gem.webp", label: "Gems" },
            { src: "/assets/images/resources/wood.webp", label: "Wood" },
            { src: "/assets/images/resources/metal.webp", label: "Metal" },
          ].map(({ src, label }) => (
            <div
              key={label}
              className="hero-badge glass flex items-center gap-1.5 px-3 py-1.5 rounded-full shadow-kawaii"
            >
              <img src={src} alt={label} className="w-5 h-5 object-contain" />
              <span className="font-heading font-semibold text-xs text-dark-text">
                {label}
              </span>
            </div>
          ))}
        </div>
      </motion.div>

      {/* Scroll hint */}
      <motion.div
        className="absolute bottom-8 left-1/2 -translate-x-1/2 z-20 flex flex-col items-center gap-1.5"
        initial={{ opacity: 0 }}
        animate={{ opacity: 1 }}
        transition={{ delay: 2.2, duration: 0.6 }}
        style={{ opacity: useTransform(scrollYProgress, [0, 0.15], [1, 0]) }}
      >
        <span className="font-body text-xs text-dark-text/40 tracking-widest uppercase">
          Scroll
        </span>
        <motion.div
          className="w-0.5 h-8 bg-dark-text/20 rounded-full origin-top"
          animate={{ scaleY: [0.3, 1, 0.3] }}
          transition={{ repeat: Infinity, duration: 1.6, ease: "easeInOut" }}
        />
      </motion.div>
    </section>
  );
}
