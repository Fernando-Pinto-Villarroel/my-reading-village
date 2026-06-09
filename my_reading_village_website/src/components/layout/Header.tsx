import { useState, useEffect } from 'react'
import { NavLink, Link } from 'react-router-dom'
import { motion, AnimatePresence } from 'motion/react'
import { Menu, X } from 'lucide-react'
import CTAButton from '../common/CTAButton'

const navLinks = [
  { to: '/',        label: 'Home' },
  { to: '/news',    label: 'News' },
  { to: '/privacy', label: 'Privacy' },
  { to: '/terms',   label: 'Terms' },
]

export default function Header() {
  const [open, setOpen]         = useState(false)
  const [scrolled, setScrolled] = useState(false)

  useEffect(() => {
    const onScroll = () => setScrolled(window.scrollY > 20)
    window.addEventListener('scroll', onScroll, { passive: true })
    return () => window.removeEventListener('scroll', onScroll)
  }, [])

  useEffect(() => {
    document.body.style.overflow = open ? 'hidden' : ''
    return () => { document.body.style.overflow = '' }
  }, [open])

  const navLinkClass = ({ isActive }: { isActive: boolean }) =>
    `font-heading font-semibold text-sm transition-colors duration-150 px-1 py-0.5 rounded
     ${isActive
       ? 'text-dark-lavender border-b-2 border-dark-lavender'
       : 'text-dark-text hover:text-dark-pink'}`

  return (
    <>
      <header
        className={`fixed top-0 left-0 right-0 z-40
          backdrop-blur-[12px] [-webkit-backdrop-filter:blur(12px)]
          border-b transition-[background-color,border-color,box-shadow] duration-300
          ${scrolled
            ? 'bg-soft-white/75 border-pink/25 shadow-kawaii'
            : 'bg-transparent border-transparent shadow-none'}`}
      >
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex items-center justify-between h-16 md:h-20">

            {/* Logo */}
            <Link to="/" className="flex items-center gap-2.5 group" onClick={() => setOpen(false)}>
              <motion.img
                src="/assets/images/logos/my_reading_village_icon_cropped.webp"
                alt="My Reading Village"
                className="w-9 h-9 md:w-11 md:h-11 rounded-xl object-contain"
                whileHover={{ rotate: [0, -8, 8, 0], scale: 1.08 }}
                transition={{ duration: 0.45, ease: 'easeInOut' }}
              />
              <span className="font-heading font-bold text-sm md:text-base text-dark-text leading-tight hidden sm:block whitespace-nowrap">
                My Reading Village
              </span>
            </Link>

            {/* Desktop nav */}
            <nav className="hidden md:flex items-center gap-6">
              {navLinks.map(({ to, label }) => (
                <NavLink key={to} to={to} end={to === '/'} className={navLinkClass}>
                  {label}
                </NavLink>
              ))}
            </nav>

            {/* Desktop CTA */}
            <div className="hidden md:block">
              <CTAButton href="#" size="sm" showIcon>
                Get it on Google Play
              </CTAButton>
            </div>

            {/* Mobile hamburger */}
            <motion.button
              className="md:hidden p-2 rounded-xl text-dark-text hover:bg-pink/30 transition-colors"
              onClick={() => setOpen(!open)}
              whileTap={{ scale: 0.92 }}
              aria-label={open ? 'Close menu' : 'Open menu'}
              aria-expanded={open}
            >
              {open ? <X size={22} /> : <Menu size={22} />}
            </motion.button>
          </div>
        </div>
      </header>

      {/* Mobile drawer — sibling of header, outside its stacking context */}
      <AnimatePresence>
        {open && (
          <>
            <motion.div
              className="fixed inset-0 bg-dark-text/20 z-40 md:hidden"
              initial={{ opacity: 0 }}
              animate={{ opacity: 1 }}
              exit={{ opacity: 0 }}
              onClick={() => setOpen(false)}
            />
            <motion.div
              className="fixed top-0 right-0 h-full w-72 z-50 md:hidden flex flex-col"
              style={{ background: 'var(--color-soft-white)' }}
              initial={{ x: '100%' }}
              animate={{ x: 0 }}
              exit={{ x: '100%' }}
              transition={{ type: 'spring', stiffness: 320, damping: 32 }}
            >
              <div className="flex items-center justify-between p-5 border-b border-pink/30">
                <Link to="/" className="flex items-center gap-2" onClick={() => setOpen(false)}>
                  <img
                    src="/assets/images/logos/my_reading_village_icon_cropped.webp"
                    alt="My Reading Village"
                    className="w-8 h-8 rounded-lg object-contain"
                  />
                  <span className="font-heading font-bold text-sm text-dark-text">My Reading Village</span>
                </Link>
                <button
                  onClick={() => setOpen(false)}
                  className="p-1.5 rounded-lg hover:bg-pink/20"
                  aria-label="Close menu"
                >
                  <X size={20} />
                </button>
              </div>

              <nav className="flex flex-col gap-1 p-5 flex-1">
                {navLinks.map(({ to, label }, i) => (
                  <motion.div
                    key={to}
                    initial={{ opacity: 0, x: 24 }}
                    animate={{ opacity: 1, x: 0 }}
                    transition={{ delay: i * 0.06 + 0.05 }}
                  >
                    <NavLink
                      to={to}
                      end={to === '/'}
                      className={({ isActive }) =>
                        `block px-4 py-3 rounded-xl font-heading font-semibold transition-colors
                         ${isActive ? 'bg-lavender text-dark-lavender' : 'text-dark-text hover:bg-pink/20'}`
                      }
                      onClick={() => setOpen(false)}
                    >
                      {label}
                    </NavLink>
                  </motion.div>
                ))}
              </nav>

              <div className="p-5 border-t border-pink/30">
                <CTAButton href="#" size="sm" className="w-full justify-center" showIcon>
                  Get it on Google Play
                </CTAButton>
              </div>
            </motion.div>
          </>
        )}
      </AnimatePresence>
    </>
  )
}
