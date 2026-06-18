import { useState, useEffect, lazy, Suspense, useRef } from "react";
import { motion, AnimatePresence } from "framer-motion";
import { ChevronLeft, ChevronRight } from "lucide-react";
import { useNavigate, useParams } from "react-router-dom";
import ImageSlide from "./shared/ImageSlide";
import VideoSlide from "./shared/VideoSlide";
import FloatingIconsBackground from "./shared/FloatingIconsBackground";
import { SlideLoader } from "./shared/SlideLoader";
import TitleSlide from "./slides/TitleSlide";
import QACoverSlide from "./slides/QACoverSlide";
import ThankYouSlide from "./slides/ThankYouSlide";

const LazyHookSlide = lazy(() => import("./slides/HookSlide"));
const LazyTargetUserSlide = lazy(() => import("./slides/TargetUserSlide"));
const LazyReadingBenefitsSlide = lazy(
  () => import("./slides/ReadingBenefitsSlide"),
);
const LazySolutionSlide = lazy(() => import("./slides/SolutionSlide"));
const LazyDifferentiationSlide = lazy(
  () => import("./slides/DifferentiationSlide"),
);
const LazyMVPSlide = lazy(() => import("./slides/MVPSlide"));
const LazyMarketSlide = lazy(() => import("./slides/MarketSlide"));
const LazyBusinessModelSlide = lazy(
  () => import("./slides/BusinessModelSlide"),
);
const LazyFinancialsSlide = lazy(() => import("./slides/FinancialsSlide"));

const LazyBackupAssumptionsSlide = lazy(
  () => import("./slides/BackupAssumptionsSlide"),
);
const LazyBackupCompetitorSlide = lazy(
  () => import("./slides/BackupCompetitorSlide"),
);
const LazyBackupPivotSlide = lazy(() => import("./slides/BackupPivotSlide"));
const LazyBackupFounderSlide = lazy(
  () => import("./slides/BackupFounderSlide"),
);
const LazyBackupRisksSlide = lazy(() => import("./slides/BackupRisksSlide"));
const LazyBackupPricingGemsSpeciesSlide = lazy(
  () => import("./slides/BackupPricingGemsSpeciesSlide"),
);
const LazyBackupPricingPacksAdsSlide = lazy(
  () => import("./slides/BackupPricingPacksAdsSlide"),
);

const SlidesPresentation = () => {
  const navigate = useNavigate();
  const { slideNumber } = useParams();
  const [showControls, setShowControls] = useState(false);
  const [hoveredDot, setHoveredDot] = useState(null);
  const [showOverlay, setShowOverlay] = useState(false);
  const hoverTimer = useRef(null);

  const slides = [
    {
      type: "jsx",
      component: <TitleSlide />,
      key: "title",
      path: "slide-1",
      label: "Título",
    },
    {
      type: "lazy",
      Component: LazyHookSlide,
      key: "hook",
      path: "slide-2",
      label: "Hook",
    },
    {
      type: "jsx",
      component: (
        <ImageSlide
          imageUrl="/charts.webp"
          caption="Lectura en declive: NEA/NAEP & PISA-OCDE"
        />
      ),
      key: "problem-data",
      path: "slide-3",
      label: "Datos del problema",
    },
    {
      type: "lazy",
      Component: LazyTargetUserSlide,
      key: "target-user",
      path: "slide-4",
      label: "Target User",
    },
    {
      type: "lazy",
      Component: LazyReadingBenefitsSlide,
      key: "benefits",
      path: "slide-5",
      label: "Beneficios de leer",
    },
    {
      type: "lazy",
      Component: LazySolutionSlide,
      key: "solution",
      path: "slide-6",
      label: "La Solución",
    },
    {
      type: "lazy",
      Component: LazyDifferentiationSlide,
      key: "diff",
      path: "slide-7",
      label: "Diferenciación",
    },
    {
      type: "lazy",
      Component: LazyMVPSlide,
      key: "mvp",
      path: "slide-8",
      label: "MVP",
    },
    {
      type: "jsx",
      component: (
        <VideoSlide
          videoSrc="/demo.webm"
          caption="Demo de la App: My Reading Village"
        />
      ),
      key: "demo",
      path: "slide-9",
      label: "Demo",
    },
    {
      type: "lazy",
      Component: LazyMarketSlide,
      key: "market",
      path: "slide-10",
      label: "Mercado",
    },
    {
      type: "lazy",
      Component: LazyBusinessModelSlide,
      key: "biz-model",
      path: "slide-11",
      label: "Modelo de Negocio",
    },
    {
      type: "lazy",
      Component: LazyFinancialsSlide,
      key: "financials",
      path: "slide-12",
      label: "Financials",
    },
    {
      type: "jsx",
      component: <ThankYouSlide />,
      key: "thank-you",
      path: "slide-13",
      label: "Gracias",
    },
    {
      type: "jsx",
      component: <QACoverSlide />,
      key: "qa",
      path: "slide-14",
      label: "Q & A",
    },
    {
      type: "jsx",
      component: (
        <ImageSlide
          imageUrl="/lean-startup.webp"
          caption="Lean Canvas: My Reading Village"
        />
      ),
      key: "backup-lean",
      path: "slide-15",
      label: "B: Lean Canvas",
    },
    {
      type: "jsx",
      component: (
        <ImageSlide imageUrl="/roadmap.webp" caption="Hoja de Ruta: 18 Meses" />
      ),
      key: "backup-roadmap",
      path: "slide-16",
      label: "B: Roadmap",
    },
    {
      type: "jsx",
      component: (
        <ImageSlide
          imageUrl="/cost_breakdown.webp"
          caption="Desglose de Costos: Año 1"
        />
      ),
      key: "backup-costs",
      path: "slide-17",
      label: "B: Costos",
    },
    {
      type: "lazy",
      Component: LazyBackupAssumptionsSlide,
      key: "backup-assumptions",
      path: "slide-18",
      label: "B: Supuesto Central",
    },
    {
      type: "lazy",
      Component: LazyBackupCompetitorSlide,
      key: "backup-competitor",
      path: "slide-19",
      label: "B: Competidores",
    },
    {
      type: "lazy",
      Component: LazyBackupPivotSlide,
      key: "backup-pivot",
      path: "slide-20",
      label: "B: Pivote",
    },
    {
      type: "lazy",
      Component: LazyBackupFounderSlide,
      key: "backup-founder",
      path: "slide-21",
      label: "B: Por qué yo",
    },
    {
      type: "lazy",
      Component: LazyBackupRisksSlide,
      key: "backup-risks",
      path: "slide-22",
      label: "B: Riesgos",
    },
    {
      type: "jsx",
      component: (
        <ImageSlide
          imageUrl="/roi.webp"
          caption="Proyección de ROI - 36 meses"
        />
      ),
      key: "backup-roi",
      path: "slide-23",
      label: "B: ROI",
    },
    {
      type: "lazy",
      Component: LazyBackupPricingGemsSpeciesSlide,
      key: "backup-pricing-gems",
      path: "slide-24",
      label: "B: Precios Gems & Species",
    },
    {
      type: "lazy",
      Component: LazyBackupPricingPacksAdsSlide,
      key: "backup-pricing-packs",
      path: "slide-25",
      label: "B: Precios Packs & Ads",
    },
  ];

  const parsedSlideNumber = slideNumber
    ? parseInt(slideNumber.split("-")[1])
    : 1;
  const currentSlide = parsedSlideNumber - 1;

  useEffect(() => {
    if (!slideNumber) {
      navigate("/slide-1", { replace: true });
      return;
    }
    if (
      isNaN(parsedSlideNumber) ||
      parsedSlideNumber < 1 ||
      parsedSlideNumber > slides.length
    ) {
      navigate("/slide-1", { replace: true });
    }
  }, [slideNumber, navigate, parsedSlideNumber, slides.length]);

  const nextSlide = () => {
    if (currentSlide < slides.length - 1) {
      navigate(`/${slides[currentSlide + 1].path}`);
    }
  };

  const prevSlide = () => {
    if (currentSlide > 0) {
      navigate(`/${slides[currentSlide - 1].path}`);
    }
  };

  const goToSlide = (index) => {
    navigate(`/${slides[index].path}`);
  };

  useEffect(() => {
    const handleKeyDown = (e) => {
      if (e.key === "ArrowRight") nextSlide();
      if (e.key === "ArrowLeft") prevSlide();
    };
    window.addEventListener("keydown", handleKeyDown);
    return () => window.removeEventListener("keydown", handleKeyDown);
  }, [currentSlide]);

  useEffect(() => {
    const handleMouseMove = (e) => {
      const windowHeight = window.innerHeight;
      const mouseY = e.clientY;
      const bottomZone = windowHeight * 0.8;
      setShowControls(mouseY > bottomZone);
    };
    window.addEventListener("mousemove", handleMouseMove);
    return () => window.removeEventListener("mousemove", handleMouseMove);
  }, []);

  if (currentSlide < 0 || currentSlide >= slides.length) {
    return null;
  }

  const isBackup = currentSlide >= 14;

  return (
    <div className="relative w-screen h-screen overflow-hidden bg-gradient-to-br from-das-bg via-das-body/40 to-das-lavender/20">
      <div className="pointer-events-none absolute inset-0">
        <div className="absolute top-0 -left-60 w-1/2 h-1/2 bg-das-primary/10 rounded-full blur-[180px]"></div>
        <div className="absolute -top-40 -right-60 w-1/2 h-1/2 bg-das-accent/8 rounded-full blur-[220px]"></div>
        <div className="absolute bottom-0 right-0 w-1/3 h-1/3 bg-das-mint/20 rounded-full blur-[120px]"></div>
      </div>
      <FloatingIconsBackground />

      {isBackup && (
        <div className="absolute top-4 left-4 z-50">
          <div className="bg-das-gold/30 border border-das-gold/60 backdrop-blur-sm rounded-xl px-3 py-1">
            <span className="text-[0.8vw] font-black text-yellow-700 uppercase tracking-widest">
              Backup Slide
            </span>
          </div>
        </div>
      )}

      <AnimatePresence mode="wait">
        <motion.div
          key={slides[currentSlide].path}
          initial={{ opacity: 0, scale: 0.97 }}
          animate={{ opacity: 1, scale: 1 }}
          exit={{ opacity: 0, scale: 1.03 }}
          transition={{ duration: 0.25 }}
          className="w-full h-full"
        >
          {slides[currentSlide].type === "lazy" ? (
            <Suspense fallback={<SlideLoader />}>
              {(() => {
                const Component = slides[currentSlide].Component;
                return <Component key={slides[currentSlide].key} />;
              })()}
            </Suspense>
          ) : (
            slides[currentSlide].component
          )}
        </motion.div>
      </AnimatePresence>


      <motion.div
        initial={{ opacity: 0, y: 50 }}
        animate={{ opacity: showControls ? 1 : 0, y: showControls ? 0 : 50 }}
        className="absolute bottom-[3vh] left-0 right-0 flex items-center justify-center gap-[1vw] z-50"
      >
        <button
          onClick={prevSlide}
          disabled={currentSlide === 0}
          className="bg-white/90 backdrop-blur-sm text-das-primary p-[0.75vw] rounded-full shadow-lg hover:bg-white hover:scale-110 transition-all disabled:opacity-30 disabled:cursor-not-allowed"
        >
          <ChevronLeft className="w-[1.5vw] h-[1.5vw]" />
        </button>
        <div className="flex items-center gap-[0.4vw] bg-white/30 backdrop-blur-md px-[1vw] py-[0.5vh] rounded-full">
          {slides.map((s, idx) => (
            <button
              key={idx}
              onClick={() => goToSlide(idx)}
              onMouseEnter={() => {
                if (hoverTimer.current) clearTimeout(hoverTimer.current);
                setHoveredDot(idx);
                hoverTimer.current = setTimeout(
                  () => setShowOverlay(true),
                  100,
                );
              }}
              onMouseLeave={() => {
                setHoveredDot(null);
                setShowOverlay(false);
                if (hoverTimer.current) {
                  clearTimeout(hoverTimer.current);
                  hoverTimer.current = null;
                }
              }}
              className={`relative rounded-full transition-all ${
                idx === currentSlide
                  ? "h-[0.75vh] w-[2vw] bg-das-primary hover:h-[1.5vh] hover:w-[4vw]"
                  : idx >= 14
                    ? "h-[0.75vh] w-[0.75vh] bg-das-gold/60 hover:bg-das-gold hover:h-[1.5vh] hover:w-[1.5vh]"
                    : "h-[0.75vh] w-[0.75vh] bg-das-accent/40 hover:bg-das-accent hover:h-[1.5vh] hover:w-[1.5vh]"
              }`}
            >
              {showOverlay && hoveredDot === idx && (
                <div className="absolute bottom-full left-1/2 transform -translate-x-1/2 mb-1 bg-das-text/80 text-white px-2 py-1 rounded text-xs whitespace-nowrap">
                  {s.label}
                </div>
              )}
            </button>
          ))}
        </div>
        <button
          onClick={nextSlide}
          disabled={currentSlide === slides.length - 1}
          className="bg-white/90 backdrop-blur-sm text-das-primary p-[0.75vw] rounded-full shadow-lg hover:bg-white hover:scale-110 transition-all disabled:opacity-30 disabled:cursor-not-allowed"
        >
          <ChevronRight className="w-[1.5vw] h-[1.5vw]" />
        </button>
      </motion.div>

      <motion.div
        initial={{ opacity: 0 }}
        animate={{ opacity: showControls ? 1 : 0 }}
        className="fixed top-4 right-4 bg-white/80 backdrop-blur-sm px-3 py-1 rounded-full text-sm font-bold text-das-text/70 z-[100] border border-das-light"
      >
        {currentSlide + 1} / {slides.length}
      </motion.div>
    </div>
  );
};

export default SlidesPresentation;
