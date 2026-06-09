import { useEffect } from 'react'
import { BrowserRouter, Routes, Route, useLocation } from 'react-router-dom'
import { AnimatePresence, motion } from 'motion/react'
import Header from './components/layout/Header'
import Footer from './components/layout/Footer'
import Home    from './pages/Home'
import News    from './pages/News'
import Privacy from './pages/Privacy'
import Terms   from './pages/Terms'
import { useLenis } from './hooks/useLenis'

const pageVariants = {
  initial: { opacity: 0, y: 10 },
  enter:   { opacity: 1, y: 0, transition: { duration: 0.35, ease: [0.25, 0.46, 0.45, 0.94] as [number,number,number,number] } },
  exit:    { opacity: 0,       transition: { duration: 0 } },
}

function ScrollToTop() {
  const { pathname } = useLocation()
  useEffect(() => { window.scrollTo(0, 0) }, [pathname])
  return null
}

function AnimatedRoutes() {
  const location = useLocation()

  return (
    <AnimatePresence mode="wait">
      <motion.div
        key={location.pathname}
        variants={pageVariants}
        initial="initial"
        animate="enter"
        exit="exit"
      >
        <Routes location={location}>
          <Route path="/"        element={<Home />}    />
          <Route path="/news"    element={<News />}    />
          <Route path="/privacy" element={<Privacy />} />
          <Route path="/terms"   element={<Terms />}   />
          <Route path="*"        element={<Home />}    />
        </Routes>
      </motion.div>
    </AnimatePresence>
  )
}

function AppInner() {
  useLenis()

  return (
    <div className="flex flex-col min-h-screen">
      <ScrollToTop />
      <Header />
      <AnimatedRoutes />
      <Footer />
    </div>
  )
}

export default function App() {
  return (
    <BrowserRouter>
      <AppInner />
    </BrowserRouter>
  )
}
