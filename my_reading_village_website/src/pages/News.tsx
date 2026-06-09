import { useState } from 'react'
import { motion, AnimatePresence } from 'motion/react'
import { ChevronDown, ChevronUp, Calendar } from 'lucide-react'
import { posts } from '../data/news'

function formatDate(dateStr: string) {
  return new Date(dateStr).toLocaleDateString('en-US', {
    year: 'numeric', month: 'long', day: 'numeric',
  })
}

function PostCard({ post, index }: { post: (typeof posts)[0]; index: number }) {
  const [expanded, setExpanded] = useState(false)

  return (
    <motion.article
      className="bg-soft-white rounded-3xl shadow-kawaii overflow-hidden"
      initial={{ opacity: 0, y: 28 }}
      whileInView={{ opacity: 1, y: 0 }}
      viewport={{ once: true, margin: '-60px' }}
      transition={{ delay: index * 0.1, duration: 0.5, ease: 'easeOut' }}
    >
      {/* Top accent bar */}
      <div
        className="h-1.5 w-full"
        style={{
          background: [
            'linear-gradient(to right, var(--color-pink), var(--color-lavender))',
            'linear-gradient(to right, var(--color-mint), var(--color-sky))',
            'linear-gradient(to right, var(--color-peach), var(--color-pink))',
          ][index % 3],
        }}
      />

      <div className="p-6 md:p-8">
        {/* Date */}
        <div className="flex items-center gap-1.5 mb-3">
          <Calendar size={13} className="opacity-50" />
          <time
            dateTime={post.date}
            className="font-body text-xs text-dark-text/50"
          >
            {formatDate(post.date)}
          </time>
        </div>

        {/* Title */}
        <h2 className="font-heading font-extrabold text-xl md:text-2xl text-dark-text mb-3 leading-tight">
          {post.title}
        </h2>

        {/* Excerpt */}
        <p className="font-body text-sm md:text-base text-dark-text/70 leading-relaxed mb-5">
          {post.excerpt}
        </p>

        {/* Read more toggle */}
        <button
          onClick={() => setExpanded(!expanded)}
          className="inline-flex items-center gap-1.5 font-heading font-semibold text-sm
                     transition-colors duration-150 focus-visible:outline-none"
          style={{ color: expanded ? 'var(--color-dark-pink)' : 'var(--color-dark-lavender)' }}
          aria-expanded={expanded}
        >
          {expanded ? 'Show less' : 'Read more'}
          <motion.span animate={{ rotate: expanded ? 0 : 180 }} transition={{ duration: 0.2 }}>
            {expanded ? <ChevronUp size={15} /> : <ChevronDown size={15} />}
          </motion.span>
        </button>

        {/* Full content */}
        <AnimatePresence>
          {expanded && (
            <motion.div
              initial={{ height: 0, opacity: 0 }}
              animate={{ height: 'auto', opacity: 1 }}
              exit={{ height: 0, opacity: 0 }}
              transition={{ duration: 0.35, ease: 'easeInOut' }}
              className="overflow-hidden"
            >
              <div className="pt-5 border-t border-pink/20 mt-5">
                {post.content.split('\n\n').map((para, i) => {
                  if (para.startsWith('**') && para.endsWith('**')) {
                    return (
                      <h3 key={i} className="font-heading font-bold text-base text-dark-text mb-2 mt-4 first:mt-0">
                        {para.replace(/\*\*/g, '')}
                      </h3>
                    )
                  }
                  const formatted = para.replace(/\*\*(.*?)\*\*/g, '<strong>$1</strong>')
                  return (
                    <p
                      key={i}
                      className="font-body text-sm text-dark-text/75 leading-relaxed mb-3 last:mb-0"
                      dangerouslySetInnerHTML={{ __html: formatted }}
                    />
                  )
                })}
              </div>
            </motion.div>
          )}
        </AnimatePresence>
      </div>
    </motion.article>
  )
}

export default function News() {
  return (
    <main className="min-h-screen pt-24 pb-20 px-4 sm:px-6 lg:px-8" style={{ background: 'var(--color-cream)' }}>
      {/* Background blob */}
      <div
        className="fixed top-0 right-0 w-96 h-96 rounded-full opacity-15 blur-3xl pointer-events-none -z-10"
        style={{ background: 'var(--color-lavender)' }}
      />

      <div className="max-w-3xl mx-auto">
        {/* Header */}
        <motion.div
          className="text-center mb-12"
          initial={{ opacity: 0, y: 22 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.5 }}
        >
          <span className="inline-block font-heading font-semibold text-sm tracking-widest uppercase mb-3"
            style={{ color: 'var(--color-dark-lavender)' }}>
            Devlog
          </span>
          <h1 className="font-heading font-extrabold text-4xl md:text-5xl text-dark-text mb-4">News</h1>
          <p className="font-body text-base md:text-lg text-dark-text/60 max-w-md mx-auto">
            Behind-the-scenes updates, devlogs, and announcements from the team building your cozy village.
          </p>
        </motion.div>

        {/* Posts */}
        <div className="flex flex-col gap-6">
          {posts.map((post, i) => (
            <PostCard key={post.slug} post={post} index={i} />
          ))}
        </div>
      </div>
    </main>
  )
}
