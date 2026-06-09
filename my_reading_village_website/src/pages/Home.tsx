import HeroSection from '../components/home/HeroSection'
import HowItWorksSection from '../components/home/HowItWorksSection'
import VillagerCarousel from '../components/home/VillagerCarousel'
import ScreenshotGallery from '../components/home/ScreenshotGallery'
import ClosingCTABand from '../components/home/ClosingCTABand'

export default function Home() {
  return (
    <main>
      <HeroSection />
      <HowItWorksSection />
      <VillagerCarousel />
      <ScreenshotGallery />
      <ClosingCTABand />
    </main>
  )
}
