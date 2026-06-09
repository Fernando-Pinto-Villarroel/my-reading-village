import { useCallback, useEffect, useRef, useState } from 'react'
import useEmblaCarousel from 'embla-carousel-react'
import { motion } from 'motion/react'
import { ChevronLeft, ChevronRight } from 'lucide-react'
import { villagers } from '../../data/villagers'
import RarityBadge from '../common/RarityBadge'

const AUTOPLAY_INTERVAL = 3200

export default function VillagerCarousel() {
  const [emblaRef, emblaApi] = useEmblaCarousel({
    loop: false,
    align: 'start',
    dragFree: true,
  })

  const [selectedIndex, setSelectedIndex]   = useState(0)
  const [scrollSnaps, setScrollSnaps]       = useState<number[]>([])
  const [isPaused, setIsPaused]             = useState(false)
  const intervalRef                         = useRef<ReturnType<typeof setInterval> | null>(null)

  const startAutoplay = useCallback(() => {
    if (intervalRef.current) clearInterval(intervalRef.current)
    intervalRef.current = setInterval(() => {
      if (!emblaApi) return
      if (emblaApi.canScrollNext()) {
        emblaApi.scrollNext()
      } else {
        emblaApi.scrollTo(0)
      }
    }, AUTOPLAY_INTERVAL)
  }, [emblaApi])

  const stopAutoplay = useCallback(() => {
    if (intervalRef.current) {
      clearInterval(intervalRef.current)
      intervalRef.current = null
    }
  }, [])

  useEffect(() => {
    if (!emblaApi) return
    setScrollSnaps(emblaApi.scrollSnapList())
    emblaApi.on('select', () => setSelectedIndex(emblaApi.selectedScrollSnap()))
    emblaApi.on('reInit', () => setScrollSnaps(emblaApi.scrollSnapList()))
  }, [emblaApi])

  useEffect(() => {
    if (!isPaused) {
      startAutoplay()
    } else {
      stopAutoplay()
    }
    return stopAutoplay
  }, [isPaused, startAutoplay, stopAutoplay])

  const scrollPrev = useCallback(() => { emblaApi?.scrollPrev() }, [emblaApi])
  const scrollNext = useCallback(() => { emblaApi?.scrollNext() }, [emblaApi])

  return (
    <section className="relative py-12 md:py-16 overflow-hidden" style={{ background: 'var(--color-soft-white)' }}>
      {/* Background blobs */}
      <div
        className="absolute top-0 left-0 w-full h-2 opacity-80"
        style={{ background: 'linear-gradient(to right, var(--color-pink), var(--color-lavender), var(--color-mint), var(--color-sky))' }}
      />

      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        {/* Header */}
        <motion.div
          className="text-center mb-10 md:mb-14"
          initial={{ opacity: 0, y: 22 }}
          whileInView={{ opacity: 1, y: 0 }}
          viewport={{ once: true, margin: '-80px' }}
          transition={{ duration: 0.55 }}
        >
          <span className="inline-block font-heading font-semibold text-sm tracking-widest uppercase mb-3"
            style={{ color: 'var(--color-dark-pink)' }}>
            Meet your neighbours
          </span>
          <h2 className="font-heading font-extrabold text-3xl md:text-4xl lg:text-5xl text-dark-text leading-tight">
            41 Adorable Villagers<br />
            <span className="text-gradient">Waiting to Move In</span>
          </h2>
          <p className="font-body text-base md:text-lg mt-4 max-w-xl mx-auto" style={{ color: 'var(--color-dark-text)', opacity: 0.7 }}>
            From common critters to legendary and godly rarities — every page you read brings you closer to welcoming a new friend home.
          </p>
        </motion.div>

        {/* Carousel */}
        <div
          className="relative"
          onMouseEnter={() => setIsPaused(true)}
          onMouseLeave={() => setIsPaused(false)}
          onFocus={() => setIsPaused(true)}
          onBlur={() => setIsPaused(false)}
        >
          <div className="overflow-hidden pt-4 -mt-4 pb-2 -mb-2" ref={emblaRef}>
            <div className="flex gap-3 md:gap-4">
              {villagers.map((villager) => (
                <motion.div
                  key={villager.id}
                  className="flex-none w-[46%] sm:w-[32%] md:w-[22%] lg:w-[17%] xl:w-[14%]"
                  whileHover={{ y: -8, scale: 1.03, zIndex: 10 }}
                  transition={{ type: 'spring', stiffness: 380, damping: 22 }}
                  style={{ position: 'relative' }}
                >
                  <div className="bg-cream rounded-2xl p-3 shadow-kawaii flex flex-col items-center gap-2.5 h-full">
                    <div
                      className="w-full aspect-square rounded-xl overflow-hidden flex items-center justify-center"
                      style={{ background: 'var(--color-soft-white)' }}
                    >
                      <img
                        src={villager.imagePath}
                        alt={villager.name}
                        className="w-full h-full object-contain p-2"
                        loading="lazy"
                      />
                    </div>
                    <p className="font-heading font-semibold text-xs text-center text-dark-text leading-tight">
                      {villager.name}
                    </p>
                    <RarityBadge rarity={villager.rarity} size="xs" />
                  </div>
                </motion.div>
              ))}

              {/* Closing card */}
              <motion.div
                className="flex-none w-[46%] sm:w-[32%] md:w-[22%] lg:w-[17%] xl:w-[14%]"
                whileHover={{ y: -8, scale: 1.03, zIndex: 10 }}
                transition={{ type: 'spring', stiffness: 380, damping: 22 }}
                style={{ position: 'relative' }}
              >
                <div className="bg-kawaii-gradient rounded-2xl p-3 shadow-kawaii flex flex-col items-center justify-center gap-2 h-full min-h-[140px]">
                  <span className="text-3xl">+</span>
                  <p className="font-heading font-bold text-xs text-center text-dark-text leading-tight">
                    Many more<br />to discover!
                  </p>
                </div>
              </motion.div>
            </div>
          </div>

          {/* Prev / Next buttons */}
          <button
            onClick={scrollPrev}
            aria-label="Previous villager"
            className="absolute left-0 top-1/2 -translate-y-1/2 -translate-x-3 md:-translate-x-5
                       w-10 h-10 rounded-full bg-soft-white shadow-kawaii
                       flex items-center justify-center text-dark-text hover:text-dark-pink
                       hover:bg-pink/20 transition-colors z-10 focus-visible:outline-none"
          >
            <ChevronLeft size={20} strokeWidth={2.5} />
          </button>
          <button
            onClick={scrollNext}
            aria-label="Next villager"
            className="absolute right-0 top-1/2 -translate-y-1/2 translate-x-3 md:translate-x-5
                       w-10 h-10 rounded-full bg-soft-white shadow-kawaii
                       flex items-center justify-center text-dark-text hover:text-dark-pink
                       hover:bg-pink/20 transition-colors z-10 focus-visible:outline-none"
          >
            <ChevronRight size={20} strokeWidth={2.5} />
          </button>
        </div>

        {/* Dot indicators */}
        <div className="flex justify-center gap-1.5 mt-6">
          {scrollSnaps.map((_, i) => (
            <button
              key={i}
              onClick={() => emblaApi?.scrollTo(i)}
              aria-label={`Go to slide ${i + 1}`}
              className="rounded-full transition-all duration-200 focus-visible:outline-none"
              style={{
                width: i === selectedIndex ? 20 : 7,
                height: 7,
                background: i === selectedIndex ? 'var(--color-dark-pink)' : 'var(--color-pink)',
              }}
            />
          ))}
        </div>
      </div>
    </section>
  )
}
