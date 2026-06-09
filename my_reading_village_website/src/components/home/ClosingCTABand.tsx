import { motion } from "motion/react";
import CTAButton from "../common/CTAButton";

export default function ClosingCTABand() {
  return (
    <section className="relative py-14 md:py-20 overflow-hidden">
      {/* Gradient background */}
      <div className="absolute inset-0 bg-cta-gradient opacity-90" />

      {/* Decorative blobs */}
      <div
        className="absolute -top-20 -right-20 w-64 h-64 rounded-full opacity-30 blur-3xl pointer-events-none"
        style={{ background: "var(--color-lavender)" }}
      />
      <div
        className="absolute -bottom-20 -left-20 w-64 h-64 rounded-full opacity-30 blur-3xl pointer-events-none"
        style={{ background: "var(--color-sky)" }}
      />

      {/* Villager row — decorative */}
      <div className="absolute bottom-0 left-0 right-0 h-20 flex items-end justify-center gap-2 overflow-hidden opacity-20 pointer-events-none select-none">
        {[
          "cat",
          "rabbit",
          "koala",
          "red_panda",
          "fox",
          "lion",
          "hamster",
          "duck",
        ].map((id, i) => (
          <img
            key={id}
            src={`/assets/images/villagers/${id}/${id}_villager.webp`}
            alt=""
            aria-hidden="true"
            className="h-14 w-auto object-contain"
            style={{ transform: `translateY(${i % 2 === 0 ? "4px" : "-4px"})` }}
          />
        ))}
      </div>

      <div className="relative z-10 max-w-3xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
        <motion.div
          initial={{ opacity: 0, y: 28 }}
          whileInView={{ opacity: 1, y: 0 }}
          viewport={{ once: true, margin: "-80px" }}
          transition={{ duration: 0.6, ease: "easeOut" }}
          className="flex flex-col items-center gap-7"
        >
          {/* Logo */}
          <img
            src="/assets/images/logos/my_reading_village_icon_rounded.webp"
            alt="My Reading Village"
            className="w-20 h-20 md:w-24 md:h-24 rounded-2xl shadow-kawaii-lg object-contain"
          />

          <div>
            <h2 className="font-heading font-extrabold text-3xl md:text-4xl lg:text-5xl text-dark-text leading-tight mb-4">
              Your village is waiting.
              <br />
              One page at a time.
            </h2>
            <p className="font-body text-base md:text-lg text-dark-text/75 max-w-xl mx-auto">
              Turn every page you read into a cozy village full of adorable
              animal friends. Free to play. Available in 5 languages.
            </p>
          </div>

          <CTAButton href="#" size="lg" showIcon>
            Get it on Google Play — Free
          </CTAButton>

          <p className="font-body text-xs text-dark-text/75 mt-2">
            Available in English, Spanish, Portuguese, French and Italian
          </p>
        </motion.div>
      </div>
    </section>
  );
}
