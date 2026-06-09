import { motion } from 'motion/react'
import { ImageOff } from 'lucide-react'

const placeholders = [
  { label: 'Village Overview',        tilt: '-3deg',  delay: 0 },
  { label: 'Villager Collection',     tilt:  '2deg',  delay: 0.1 },
  { label: 'Reading Session Tracker', tilt: '-1.5deg',delay: 0.2 },
]

function PlaceholderCard({ label, tilt, delay }: { label: string; tilt: string; delay: number }) {
  return (
    <motion.div
      className="relative"
      style={{ rotate: tilt }}
      initial={{ opacity: 0, y: 32, rotate: tilt }}
      whileInView={{ opacity: 1, y: 0, rotate: tilt }}
      whileHover={{ rotate: '0deg', scale: 1.04, zIndex: 10 }}
      viewport={{ once: true, margin: '-60px' }}
      transition={{
        default:  { delay, duration: 0.55, ease: 'easeOut' },
        rotate:   { type: 'spring', stiffness: 260, damping: 20 },
        scale:    { type: 'spring', stiffness: 300, damping: 22 },
      }}
    >
      <div
        className="bg-soft-white rounded-3xl shadow-kawaii-lg overflow-hidden border-2 border-pink/20"
        style={{ aspectRatio: '9 / 16', width: '100%', maxWidth: 220 }}
      >
        {/* Phone chrome top bar */}
        <div className="flex items-center justify-center h-7 bg-pink/20 gap-1.5">
          <div className="w-16 h-1.5 rounded-full bg-dark-text/20" />
        </div>

        {/* Content area */}
        <div className="flex flex-col items-center justify-center h-[calc(100%-28px)] gap-3 p-4">
          <div className="w-14 h-14 rounded-2xl bg-lavender/30 flex items-center justify-center">
            <ImageOff size={22} className="text-dark-lavender/50" strokeWidth={1.5} />
          </div>
          <p className="font-heading font-semibold text-sm text-dark-text/50 text-center leading-tight">
            {label}
          </p>
          <p className="font-body text-[10px] text-dark-text/35 text-center">
            Screenshot coming soon
          </p>
        </div>
      </div>
    </motion.div>
  )
}

export default function ScreenshotGallery() {
  return (
    <section className="relative py-12 md:py-16 overflow-hidden" style={{ background: 'var(--color-cream)' }}>
      <div
        className="absolute top-0 right-0 w-80 h-80 rounded-full opacity-20 blur-3xl pointer-events-none"
        style={{ background: 'var(--color-sky)' }}
      />
      <div
        className="absolute bottom-0 left-0 w-64 h-64 rounded-full opacity-20 blur-3xl pointer-events-none"
        style={{ background: 'var(--color-peach)' }}
      />

      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        {/* Header */}
        <motion.div
          className="text-center mb-12 md:mb-16"
          initial={{ opacity: 0, y: 22 }}
          whileInView={{ opacity: 1, y: 0 }}
          viewport={{ once: true, margin: '-80px' }}
          transition={{ duration: 0.55 }}
        >
          <span className="inline-block font-heading font-semibold text-sm tracking-widest uppercase mb-3"
            style={{ color: 'var(--color-dark-sky)' }}>
            See it in action
          </span>
          <h2 className="font-heading font-extrabold text-3xl md:text-4xl lg:text-5xl text-dark-text leading-tight">
            Your cozy little world,<br />
            <span className="text-gradient">one page at a time</span>
          </h2>
        </motion.div>

        {/* Gallery — tilted grid */}
        <div className="flex flex-wrap justify-center items-center gap-6 md:gap-10 lg:gap-14">
          {placeholders.map(({ label, tilt, delay }) => (
            <PlaceholderCard key={label} label={label} tilt={tilt} delay={delay} />
          ))}
        </div>

        {/* Availability note */}
        <motion.p
          className="text-center font-body text-sm mt-10 opacity-50"
          initial={{ opacity: 0 }}
          whileInView={{ opacity: 0.5 }}
          viewport={{ once: true }}
          transition={{ delay: 0.4, duration: 0.5 }}
        >
          Screenshots will be added once the app launches on Google Play
        </motion.p>
      </div>
    </section>
  )
}
