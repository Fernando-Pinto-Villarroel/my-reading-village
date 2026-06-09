import { type Rarity, rarityColors, rarityLabels } from '../../data/villagers'
import { Sparkles } from 'lucide-react'

interface RarityBadgeProps {
  rarity: Rarity
  size?: 'xs' | 'sm' | 'md'
}

export default function RarityBadge({ rarity, size = 'sm' }: RarityBadgeProps) {
  const colors = rarityColors[rarity]
  const label  = rarityLabels[rarity]

  const sizeClasses = {
    xs: 'text-[10px] px-1.5 py-0.5 gap-0.5',
    sm: 'text-xs px-2 py-1 gap-1',
    md: 'text-sm px-3 py-1.5 gap-1',
  }

  const iconSize = size === 'xs' ? 9 : size === 'sm' ? 11 : 13

  return (
    <span
      className={`inline-flex items-center rounded-full font-heading font-semibold ${sizeClasses[size]}`}
      style={{
        backgroundColor: colors.bg,
        color: colors.text,
        border: `1.5px solid ${colors.border}`,
      }}
    >
      {(rarity === 'legendary' || rarity === 'godly') && (
        <Sparkles size={iconSize} strokeWidth={2.5} />
      )}
      {label}
    </span>
  )
}
