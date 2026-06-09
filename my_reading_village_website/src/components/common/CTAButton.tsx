import { motion } from 'motion/react'
import { ExternalLink } from 'lucide-react'

interface CTAButtonProps {
  href?: string
  onClick?: () => void
  size?: 'sm' | 'md' | 'lg'
  variant?: 'primary' | 'secondary'
  children: React.ReactNode
  className?: string
  showIcon?: boolean
}

export default function CTAButton({
  href = '#',
  onClick,
  size = 'md',
  variant = 'primary',
  children,
  className = '',
  showIcon = false,
}: CTAButtonProps) {
  const sizeClasses = {
    sm: 'px-5 py-2.5 text-sm gap-1.5',
    md: 'px-7 py-3.5 text-base gap-2',
    lg: 'px-9 py-4 text-lg gap-2.5',
  }

  const variantClasses = {
    primary: 'bg-dark-lavender text-soft-white hover:bg-[#6967D0] shadow-sm',
    secondary: 'bg-soft-white text-dark-lavender border-2 border-dark-lavender hover:bg-lavender',
  }

  const base =
    `inline-flex items-center justify-center font-heading font-semibold rounded-full
     transition-colors duration-200 focus-visible:outline-none
     ${sizeClasses[size]} ${variantClasses[variant]} ${className}`

  return (
    <motion.a
      href={href}
      onClick={onClick}
      className={base}
      whileHover={{ scale: 1.04, y: -2 }}
      whileTap={{ scale: 0.97 }}
      transition={{ type: 'spring', stiffness: 400, damping: 20 }}
      data-todo="replace href with real Play Store URL once listing is live"
    >
      {children}
      {showIcon && <ExternalLink size={size === 'lg' ? 20 : size === 'md' ? 17 : 15} strokeWidth={2.2} />}
    </motion.a>
  )
}
