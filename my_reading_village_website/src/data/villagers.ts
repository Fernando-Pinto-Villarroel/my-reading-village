export type Rarity = 'common' | 'rare' | 'extraordinary' | 'legendary' | 'godly'

export interface Villager {
  id: string
  name: string
  rarity: Rarity
  imagePath: string
}

function img(id: string) {
  return `/assets/images/villagers/${id}/${id}_villager.webp`
}

function name(id: string) {
  return id.split('_').map(w => w.charAt(0).toUpperCase() + w.slice(1)).join(' ')
}

export const villagers: Villager[] = [
  { id: 'cat',         name: name('cat'),         rarity: 'common',        imagePath: img('cat') },
  { id: 'dog',         name: name('dog'),         rarity: 'common',        imagePath: img('dog') },
  { id: 'rabbit',      name: name('rabbit'),      rarity: 'common',        imagePath: img('rabbit') },
  { id: 'koala',       name: name('koala'),       rarity: 'common',        imagePath: img('koala') },
  { id: 'hamster',     name: name('hamster'),     rarity: 'common',        imagePath: img('hamster') },
  { id: 'elephant',    name: name('elephant'),    rarity: 'common',        imagePath: img('elephant') },
  { id: 'duck',        name: name('duck'),        rarity: 'common',        imagePath: img('duck') },
  { id: 'pig',         name: name('pig'),         rarity: 'common',        imagePath: img('pig') },
  { id: 'raccoon',     name: name('raccoon'),     rarity: 'common',        imagePath: img('raccoon') },
  { id: 'platypus',    name: name('platypus'),    rarity: 'common',        imagePath: img('platypus') },
  { id: 'grizzly_bear',name: 'Grizzly Bear',      rarity: 'rare',          imagePath: img('grizzly_bear') },
  { id: 'polar_bear',  name: 'Polar Bear',        rarity: 'rare',          imagePath: img('polar_bear') },
  { id: 'panda_bear',  name: 'Panda Bear',        rarity: 'rare',          imagePath: img('panda_bear') },
  { id: 'red_panda',   name: 'Red Panda',         rarity: 'rare',          imagePath: img('red_panda') },
  { id: 'sloth',       name: name('sloth'),       rarity: 'rare',          imagePath: img('sloth') },
  { id: 'hedgehog',    name: name('hedgehog'),    rarity: 'rare',          imagePath: img('hedgehog') },
  { id: 'capybara',    name: name('capybara'),    rarity: 'rare',          imagePath: img('capybara') },
  { id: 'cow',         name: name('cow'),         rarity: 'rare',          imagePath: img('cow') },
  { id: 'sheep',       name: name('sheep'),       rarity: 'rare',          imagePath: img('sheep') },
  { id: 'bull',        name: name('bull'),        rarity: 'extraordinary', imagePath: img('bull') },
  { id: 'otter',       name: name('otter'),       rarity: 'extraordinary', imagePath: img('otter') },
  { id: 'kangaroo',    name: name('kangaroo'),    rarity: 'extraordinary', imagePath: img('kangaroo') },
  { id: 'reindeer',    name: name('reindeer'),    rarity: 'extraordinary', imagePath: img('reindeer') },
  { id: 'ferret',      name: name('ferret'),      rarity: 'extraordinary', imagePath: img('ferret') },
  { id: 'mole',        name: name('mole'),        rarity: 'extraordinary', imagePath: img('mole') },
  { id: 'bat',         name: name('bat'),         rarity: 'extraordinary', imagePath: img('bat') },
  { id: 'donkey',      name: name('donkey'),      rarity: 'extraordinary', imagePath: img('donkey') },
  { id: 'turkey',      name: name('turkey'),      rarity: 'extraordinary', imagePath: img('turkey') },
  { id: 'monkey',      name: name('monkey'),      rarity: 'legendary',     imagePath: img('monkey') },
  { id: 'gorilla',     name: name('gorilla'),     rarity: 'legendary',     imagePath: img('gorilla') },
  { id: 'zebra',       name: name('zebra'),       rarity: 'legendary',     imagePath: img('zebra') },
  { id: 'horse',       name: name('horse'),       rarity: 'legendary',     imagePath: img('horse') },
  { id: 'skunk',       name: name('skunk'),       rarity: 'legendary',     imagePath: img('skunk') },
  { id: 'hyena',       name: name('hyena'),       rarity: 'legendary',     imagePath: img('hyena') },
  { id: 'mouse',       name: name('mouse'),       rarity: 'legendary',     imagePath: img('mouse') },
  { id: 'lion',        name: name('lion'),        rarity: 'godly',         imagePath: img('lion') },
  { id: 'armadillo',   name: name('armadillo'),   rarity: 'godly',         imagePath: img('armadillo') },
  { id: 'beaver',      name: name('beaver'),      rarity: 'godly',         imagePath: img('beaver') },
  { id: 'fox',         name: name('fox'),         rarity: 'godly',         imagePath: img('fox') },
  { id: 'tiger',       name: name('tiger'),       rarity: 'godly',         imagePath: img('tiger') },
  { id: 'leopard',     name: name('leopard'),     rarity: 'godly',         imagePath: img('leopard') },
]

export const rarityColors: Record<Rarity, { bg: string; text: string; border: string }> = {
  common:        { bg: '#B3FFD9', text: '#2E9E6B', border: '#58CE99' },
  rare:          { bg: '#BAE1FF', text: '#509BE1', border: '#509BE1' },
  extraordinary: { bg: '#B5B3FF', text: '#7B79E8', border: '#7B79E8' },
  legendary:     { bg: '#FFDFC4', text: '#CC7722', border: '#F6A249' },
  godly:         { bg: '#FFD700', text: '#CC7722', border: '#CC7722' },
}

export const rarityLabels: Record<Rarity, string> = {
  common:        'Common',
  rare:          'Rare',
  extraordinary: 'Extraordinary',
  legendary:     'Legendary',
  godly:         'Godly',
}
