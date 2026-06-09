export interface NewsPost {
  slug: string
  title: string
  date: string
  excerpt: string
  content: string
}

export const posts: NewsPost[] = [
  {
    slug: 'welcome-to-my-reading-village',
    title: 'Welcome to My Reading Village',
    date: '2026-05-15',
    excerpt:
      'Hello, dear reader! I am so excited to finally share My Reading Village with the world — a cozy mobile game that turns your reading habit into a charming little village full of adorable animal friends.',
    content: `Hello, dear reader! I am so excited to finally introduce My Reading Village — a cozy mobile game built solo with Flutter that transforms every page you read into real in-game progress.

The idea started simple: I wanted a reading tracker that felt like a reward, not a chore. What if every book you finished, every reading session you logged, actually built something? A home for a little cat. A park where a capybara could nap. A library where your koala could curl up with a good book.

That is exactly what My Reading Village does. Log your books and reading sessions, earn coins, gems, wood and metal, and spend them to grow a charming kawaii village with dozens of adorable animal villagers — from common critters all the way to legendary and godly rarities.

I am building this in public, sharing devlogs, behind-the-scenes art process posts, and gameplay previews right here as we approach the Google Play launch. Follow along — I cannot wait to show you what is coming next!`,
  },
  {
    slug: 'meet-your-villagers',
    title: 'Meet Your Villagers: Five Rarity Tiers Await',
    date: '2026-05-29',
    excerpt:
      'One of the most delightful parts of My Reading Village is collecting your animal neighbours. With 41 adorable species across five rarity tiers, there is always someone new to welcome home.',
    content: `One of the most delightful parts of My Reading Village is collecting your animal neighbours. With 41 adorable species across five rarity tiers, there is always someone new to welcome home.

**Common** — your starter companions: the cheerful cat, the loyal dog, the bouncy rabbit, and seven more familiar faces waiting to move into your village from the very start. Friendly, easy to meet, and full of personality.

**Rare** — a little harder to find, but worth every page: the grizzly bear, the fluffy polar bear, a chubby panda, the adorable red panda, and five more special friends. Each costs a little more reading effort (or a small real-world purchase) to unlock.

**Extraordinary** — creatures with serious character: a laid-back otter, a kangaroo with a joey peeking out, a tiny mole in a reading hat, and six more. These visitors make your village feel truly alive.

**Legendary** — rare and magnificent: the zebra, the horse, the gorilla, the sneaky skunk, and three more. When a legendary moves in, your whole village celebrates!

**Godly** — the rarest of all: the majestic lion, the armoured armadillo, the cunning fox, the striped tiger, the spotted leopard, and the industrious beaver. These six are the crown jewels of any collection.

Every species has a unique happy pose that you will see in your village, plus sleeping and sad variants that appear depending on how much attention they are getting. Keep reading — your villagers are counting on you!`,
  },
  {
    slug: 'why-reading-habit-in-a-village-game',
    title: 'Why We Built a Reading Habit Into a Village Game',
    date: '2026-06-05',
    excerpt:
      'The cozy game genre is full of village builders, farm sims and life games. So why add a reading habit loop? Because reading is one of the few habits that is universally good for you — and yet most of us struggle to stick with it.',
    content: `The cozy game genre is full of village builders, farm sims and life games. So why layer a reading habit loop on top?

Because reading is one of the few habits that is almost universally good for you — it reduces stress, builds empathy, expands vocabulary, improves focus — and yet most of us struggle to make it stick. We start strong in January, drift in February, and by March the bookmark is still on page 47.

The problem is not willpower. It is feedback. Real books give you a great story, but the reward is deferred — you feel it after finishing the book, not after each session. Village builders, on the other hand, give you instant visible progress: you placed a building, you watched a character move in, your town grew before your eyes.

My Reading Village fuses both loops. Log a reading session — even ten pages counts — and immediately watch coins and gems and wood fly into your resource bar. Then spend them on buildings, upgrades, and new animal villagers. The reading habit becomes the engine that drives the game, and the game makes every session feel like it mattered.

This is not gamification for its own sake. It is an attempt to give your reading habit somewhere to go — to make the abstract ("I am becoming a better reader") tangible ("my koala just got a bigger house"). I genuinely believe that if a cozy game can make someone read one more page a day, that is a meaningful thing worth building.

I hope you feel that too when you play. See you in the village!`,
  },
]
