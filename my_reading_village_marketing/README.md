# My Reading Village — Marketing

Scripts for generating social media content (Instagram/Facebook/TikTok stories and reels) using game assets, backgrounds, villagers, and audio from the main app.

---

## Structure

```
my_reading_village_marketing/
├── palette.py              # AppTheme colors as Python constants
├── assets.py               # Resolved paths to game assets
├── utils.py                # Shared PIL helpers (drawing, easing, species data)
├── requirements.txt
│
├── templates/
│   ├── image/
│   │   ├── villager_spotlight.py     # Villager on background + name + rarity
│   │   ├── feature_highlight.py      # "Did you know?" card with fact stat (--fact 0-3)
│   │   ├── reading_tip.py            # Quote from game's reading_tips JSON
│   │   ├── excuses_not_to_read.py    # Relatable excuse list + solution pivot
│   │   ├── who_should_read.py        # "Who should read more?" benefit list
│   │   └── what_if_reading.py        # "What if reading was a game?" questions
│   └── video/
│       ├── reading_benefits_story.py  # Benefits of Reading (all 5 languages)
│       ├── villager_reveal_reel.py    # Intro + dramatic reveal + CTA, ~12 s
│       ├── gameplay_showcase.py       # Buildings + villager parade, ~15 s
│       └── countdown_story.py         # Mystery silhouette teaser, ~10 s
│
├── scripts/
│   ├── generate.py              # CLI dispatcher
│   └── generate_calendar.sh     # Generates all Jun–Jul 2026 calendar content
│
└── output/                 # ignored by git
```

---

## Setup

```bash
cd my_reading_village_marketing

python3 -m venv .venv
.venv/bin/pip install --upgrade pip setuptools
.venv/bin/pip install -r requirements.txt
```

> Requires **FFmpeg** installed on the system (used by MoviePy for video encoding).
> On Ubuntu/Debian: `sudo apt install ffmpeg`

---

## Running templates

```bash
# Videos (9:16 vertical)
.venv/bin/python3 scripts/generate.py --template reading_benefits_story --lang en
.venv/bin/python3 scripts/generate.py --template reading_benefits_story --lang es
.venv/bin/python3 scripts/generate.py --template villager_reveal_reel --villager cat --lang en
.venv/bin/python3 scripts/generate.py --template gameplay_showcase --lang en
.venv/bin/python3 scripts/generate.py --template countdown_story --villager fox --lang en

# Images (1080×1920 PNG)
.venv/bin/python3 scripts/generate.py --template villager_spotlight --villager cat --lang en
.venv/bin/python3 scripts/generate.py --template feature_highlight --lang en --fact 0
.venv/bin/python3 scripts/generate.py --template reading_tip --lang en
.venv/bin/python3 scripts/generate.py --template excuses_not_to_read --lang en
.venv/bin/python3 scripts/generate.py --template who_should_read --lang en
.venv/bin/python3 scripts/generate.py --template what_if_reading --lang en
```

### `--fact N` (feature_highlight only)

Selects which reading fact to display (0-indexed). Available facts:

| N | Stat | Topic |
|---|------|-------|
| 0 | 1.8M | Words per year |
| 1 | 5 | Rarity tiers |
| 2 | 🌙 | Better sleep |
| 3 | 1 book | Per month |

### Generate all calendar content at once

```bash
bash scripts/generate_calendar.sh
```

Renders all 14 pieces for the Jun–Jul 2026 content calendar and places each file under `output/<date>/` (e.g. `output/jun_21/villager_reveal_reel_cat_en.mp4`). Jun 20 and Jun 27 (horizontal banners) are manual uploads — not included in the script.

**Available languages:** `en` · `es` · `pt` · `fr` · `it`

### `--background N` (1–6)

All templates accept `--background N` to select the splash background (6 total: `splash_bg_1.png` … `splash_bg_6.png`).

- **Image templates** use background N directly.
- **Video templates** (multi-scene) start at N and cycle forward — scenes use N → N+1 → N+2 wrapping at 6.

Each template defaults to its original background (feature\_highlight=1, villager\_spotlight=2, reading\_tip=3, videos=1), so omitting the flag preserves original behavior.

```bash
# Examples with --background
.venv/bin/python3 scripts/generate.py --template feature_highlight --lang en --background 4
.venv/bin/python3 scripts/generate.py --template villager_spotlight --villager rabbit --lang en --background 5
.venv/bin/python3 scripts/generate.py --template reading_tip --lang en --background 6
.venv/bin/python3 scripts/generate.py --template reading_benefits_story --lang en --background 4  # scenes use 4,5,6
.venv/bin/python3 scripts/generate.py --template gameplay_showcase --lang en --background 5       # scenes use 5,6,1
.venv/bin/python3 scripts/generate.py --template countdown_story --villager fox --lang en --background 4  # scenes use 4,5
.venv/bin/python3 scripts/generate.py --template villager_reveal_reel --villager cat --lang en --background 3  # scenes use 3,4
```

---

## Platform Quick Reference

| Platform | Format | Char limit | Hashtags | Notes |
|----------|--------|-----------|----------|-------|
| **Instagram Reel** | 9:16 video | 2,200 | 5–10 at end, all lowercase | First ~125 chars show without tapping "more" |
| **Instagram Story** | 9:16 video/image | 2,200 | 3–5, all lowercase | Ephemeral 24h — short text, CTA sticker |
| **Instagram Post** | 9:16 image | 2,200 | 5–10 at end, all lowercase | Same hook rule as Reel |
| **TikTok** | 9:16 video | 2,200 | 3–5, all lowercase | Hook MUST be in first line; conversational tone |
| **Facebook Reel** | 9:16 video | keep ≤500 | 1–2, all lowercase | No external links in caption; warm tone |
| **Facebook Post** | 9:16 image | keep ≤300 | 1–2, all lowercase | Under 80 chars = highest organic reach |
| **Facebook Story** | 9:16 video/image | overlay only | none | Text minimal; use stickers |
| **YouTube Shorts** | 9:16 video | Title 100 · Desc 5,000 | in description, lowercase | Title = keyword phrase; first 2 desc lines shown |

---

## Content Calendar — June–July 2026

### Overview

| Date | Day | Content | Format | Template | Status |
|------|-----|---------|--------|----------|--------|
| Jun 10 | Wed | Reading Benefits | 📹 Video 9:16 | `reading_benefits_story --lang en` | ✅ Done |
| Jun 13 | Sat | Feature Highlight — 1.8M Words | 🖼️ Image 9:16 | `feature_highlight --lang en --fact 0` | ✅ Done |
| Jun 20 | Sat | Marketing Banner 3 | 🖼️ Banner horizontal | `assets/images/backgrounds/marketing_banner_horizontal_3.png` | |
| Jun 21 | Sun | Villager Reveal — Cat | 📹 Video 9:16 | `villager_reveal_reel --villager cat --lang en` | |
| Jun 22 | Mon | Reading Tip — Phone Face-Down | 🖼️ Image 9:16 | `reading_tip --lang en --tip 14 --villager dog` | |
| Jun 23 | Tue | Gameplay Showcase | 📹 Video 9:16 | `gameplay_showcase --lang en` | |
| Jun 24 | Wed | Countdown Teaser — Dog | 📹 Video 9:16 | `countdown_story --villager dog --lang en` | |
| Jun 25 | Thu | Villager Reveal — Dog | 📹 Video 9:16 | `villager_reveal_reel --villager dog --lang en` | |
| Jun 26 | Fri | Excuses Not to Read | 🖼️ Image 9:16 | `excuses_not_to_read --lang en --background 5` | |
| Jun 27 | Sat | Marketing Banner 2 | 🖼️ Banner horizontal | `assets/images/backgrounds/marketing_banner_horizontal_2.png` | |
| Jun 28 | Sun | Feature Highlight — 5 Rarity Tiers | 🖼️ Image 9:16 | `feature_highlight --lang en --fact 1 --villager lion` | |
| Jun 29 | Mon | Who Should Read More? | 🖼️ Image 9:16 | manual upload | |
| Jun 30 | Tue | Villager Spotlight — Rabbit | 🖼️ Image 9:16 | `villager_spotlight --villager rabbit --lang en` | |
| Jul 1 | Wed | Reading Challenge | 📹 Video 9:16 | `reading_challenge_story --lang en` | |
| Jul 2 | Thu | Countdown Teaser — Rabbit | 📹 Video 9:16 | `countdown_story --villager rabbit --lang en` | |
| Jul 3 | Fri | Villager Reveal — Rabbit | 📹 Video 9:16 | `villager_reveal_reel --villager rabbit --lang en` | |
| Jul 4 | Sat | Feature Highlight — Habit | 🖼️ Image 9:16 | `feature_highlight --lang en --fact 3` | |
| Jul 5 | Sun | What if Reading Was a Game? | 🖼️ Image 9:16 | `what_if_reading --lang en` | |
| Jul 6 | Mon | Excuses Not to Read | 🖼️ Image 9:16 | `excuses_not_to_read --lang en` | |
| Jul 7 | Tue | Who Should Read More? | 🖼️ Image 9:16 | `who_should_read --lang en` | |

---

---

### Jun 10 · Wednesday — Reading Benefits 📹 Video

**Template:** `reading_benefits_story --lang en` · **Best time:** 19:00–21:00

---

#### 📱 Instagram Reel

**Advice:** First ~125 chars are the hook (shown without tapping "more"). 5–10 hashtags at the very end. Emojis throughout.

**Caption:**

📚 Did you know **6 minutes of reading** can cut your stress by 68%? Not hours. Not a whole book. Six. Minutes. 🌸

Meet **My Reading Village** — the game where your reading habit builds a cozy little world. Read books, unlock adorable villagers, construct buildings, and grow your village one page at a time. 🏡✨

Your wellbeing starts at chapter one. Coming soon FREE to Play Store 👇

#myreadingvillage #readingbenefits #booklovers #readinghabit #wellness #mindfulreading #comingsoon #mobilegame #readmore #kawaigame

---

#### 📱 Instagram Story

**Advice:** 1–2 lines max. Add a "Follow" or link sticker as CTA. Keep it punchy — people tap fast.

**Caption:**

📚 6 minutes of reading = 68% less stress. Science says so. 🌸
👉 Follow us — app coming soon!

---

#### 🎵 TikTok

**Advice:** First line IS the hook — it shows before "more". 3–5 hashtags. Lowercase tone, feels native to the platform.

**Caption:**

POV: you just found out reading for 6 minutes is literally better for your stress than most wellness apps 📚✨

And someone built a GAME around that fact 🏡🌸

My Reading Village: read books → unlock villagers → build your cozy little world. Free. Coming soon.

Which villager would you want first? 👇

#myreadingvillage #readingtok #cozygame

---

#### 👥 Facebook Reel

**Advice:** Under 500 chars. 1–2 hashtags. No external links in the caption (algorithm penalizes it). Warm, conversational tone — FB audience skews older.

**Caption:**

Reading just 6 minutes a day can reduce your stress by 68% — that's University of Sussex research from 2009. 🌸

We built **My Reading Village** around that idea: a free mobile game where your daily reading habit builds a cozy little village. Read a book, earn a villager. Simple as that. 🏡📚

Coming soon to Play Store — follow to be first to know!

#myreadingvillage #readinghabit

---

#### 📺 YouTube Shorts

**Advice:** Title must be keyword-first and under 100 chars. First 2 lines of description show without expanding — put the hook there.

**Title:** `Reading 6 minutes a day reduces stress by 68% — My Reading Village 🌸📚`

**Description:**

Did you know reading for just 6 minutes can cut stress by 68%? (University of Sussex, 2009)

My Reading Village is a free mobile game where your reading habit builds a cozy kawaii village — read books, unlock villagers, construct buildings, and grow your world one page at a time. 🏡✨

Coming soon FREE to the Play Store! Subscribe so you don't miss the launch.

#myreadingvillage #readingbenefits #cozygame #mobilegame #readinghabit

---

---

### Jun 13 · Saturday — Feature Highlight: 1.8M Words 🖼️ Image

**Template:** `feature_highlight --lang en --fact 0` · **Best time:** 12:00–14:00

---

#### 📱 Instagram Post

**Advice:** Lead with the number — "1.8M" stops the scroll better than any sentence. The scale of the stat is the hook. Keep copy tight; the image card carries the message.

**Caption:**

📚 **1.8 million words.**

That's what you'd read in a year if you spent just 20 minutes a day with a book.

Not a reading marathon. Not a new year's resolution. Just 20 quiet minutes — and the compound effect is extraordinary.

My Reading Village makes those 20 minutes feel like a reward every single day. 🏡🌸 Coming soon FREE!

#readingbenefits #didyouknow #readinghabit #myreadingvillage #wordsperyear #readmore #booklovers #20minutehabit

---

#### 📱 Instagram Story

**Advice:** One punchy line + CTA. Add a "Save this 💾" sticker or a poll: "20 min/day — could you do it? ✅ / Hard 😅".

**Caption:**

📚 20 min/day = 1.8 million words/year. The math is wild. 🌸
My Reading Village — coming soon!

---

#### 🎵 TikTok

**Advice:** Lead with the surprising stat, then deliver the payoff. Short lines work well as voiceover over the image slide.

**Caption:**

reading 20 minutes a day gives you 1.8 million words a year 📚🤯

that's like reading 18 full novels

all from 20 quiet minutes

My Reading Village rewards every single page with gems, villagers, and a growing cozy world 🏡✨

what 20-minute habit would change your year? 👇

#readingbenefits #didyouknow #readinghabit #myreadingvillage

---

#### 👥 Facebook Post

**Advice:** FB audience likes the "worth thinking about" framing — keeps it shareable without feeling pushy. End with an open question.

**Caption:**

Here's a number worth sitting with: reading for just 20 minutes a day exposes you to around 1.8 million words over the course of a year.

That's not just vocabulary — it's 1.8 million chances to encounter new ideas, perspectives, and stories that quietly shape who you are.

My Reading Village is built around making those 20 minutes irresistible. 🏡📚 Coming soon, completely free.

What would you read if you had 20 minutes right now?

#readingbenefits #myreadingvillage

---

---

### Jun 20 · Saturday — Marketing Banner 3 🖼️ Horizontal Banner

**Asset:** `my_reading_village/assets/images/backgrounds/marketing_banner_horizontal_3.png` · **Best time:** 12:00–14:00

*Post the banner image as-is — no generated template needed. Pair with the captions below.*

---

#### 📱 Instagram Post

**Advice:** Landscape image — post as a regular feed image. Short hook in the first line, app name visible.

**Caption:**

A village built one page at a time. 🏡📚

My Reading Village is coming soon: read books, unlock 41 adorable villagers, and grow your cozy little world. Free on Play Store.

Are you ready to start your village? 👇

#myreadingvillage #comingsoon #kawaii #cozygame #readmore

---

#### 👥 Facebook Post

**Advice:** Simple image + short copy. FB audiences engage with an open question at the end.

**Caption:**

Every great village starts with a single page. 📖🌸

My Reading Village turns your daily reading habit into a beautiful, growing world — completely free. 41 villagers to collect. Buildings to unlock. A cozy little town that grows as you read.

Coming soon to Play Store. Excited? Drop a ❤️

#myreadingvillage #readinghabit

---

---

### Jun 21 · Sunday — Villager Reveal: Cat 📹 Video

**Template:** `villager_reveal_reel --villager cat --lang en` · **Best time:** 19:00–21:00

---

#### 📱 Instagram Reel

**Advice:** Character intro posts get high saves. "Who will you unlock next?" drives comments. Hook = the number (41 villagers).

**Caption:**

🐱✨ Everyone starts here. Meet **Cat** — the first villager to join your reading village!

Common rarity, iconic status. In My Reading Village, every book you finish brings a new neighbor to your world. 📚🏡

41 villagers total. Cat is just the beginning. Who will you unlock next? 👀

Coming soon FREE to Play Store — follow so you don't miss a single reveal! 🌸

#villagerreveal #catvillager #myreadingvillage #readinggame #kawaii #comingsoon #mobilegame

---

#### 📱 Instagram Story

**Advice:** Tease energy. Add a countdown sticker to build anticipation for the next reveal.

**Caption:**

🐱 Meet Cat — your first villager! 📚
Follow us for a new reveal every week 👀

---

#### 🎵 TikTok

**Advice:** Reveal format with a satisfying loop. Great for trending "meet the character" sounds. Invite comments with a direct question.

**Caption:**

introducing the first resident of My Reading Village 🐱✨

Cat. Common rarity. Absolutely iconic.

read a book → Cat moves in 📚🏡
read more books → 40 more neighbors arrive 👀

free mobile game. coming soon. which animal do you want in your village? 👇

#myreadingvillage #villagerreveal #cozygame

---

#### 👥 Facebook Reel

**Advice:** Storytelling tone. "Follow us for weekly reveals" is the CTA — drives follows more than likes.

**Caption:**

Say hello to **Cat** 🐱 — the very first villager you'll meet in My Reading Village!

Every book you read earns you a new neighbor for your cozy little world. There are 41 villagers to collect, from common cuties like Cat all the way to Godly rarities. 📚🏡✨

Coming soon, completely free. Follow us for a new villager reveal every week!

#myreadingvillage #villagerreveal

---

#### 📺 YouTube Shorts

**Advice:** Include "rarity" in title — it's searchable. First description line = elevator pitch.

**Title:** `Meet Cat — First Villager in My Reading Village 🐱📚 (Common Rarity Reveal)`

**Description:**

Say hello to Cat — the first villager you unlock in My Reading Village! 🐱✨

My Reading Village is a free kawaii mobile game where reading books earns you villagers, gems, and buildings for your cozy little town. 41 collectible villagers across 5 rarity tiers: Common, Rare, Extraordinary, Legendary, and Godly.

Read → Unlock → Build → Grow 🏡📚

Subscribe for weekly villager reveals! Coming soon FREE on Play Store.

#myreadingvillage #villagerreveal #mobilegame #kawaigame

---

---

### Jun 22 · Monday — Reading Tip: Phone Face-Down 🖼️ Image

**Template:** `reading_tip --lang en --tip 14 --villager dog` · **Best time:** 11:00–13:00

---

#### 📱 Instagram Post

**Advice:** Bedtime routine angle — high relatability. "Phone face-down" is a vivid, actionable image.

**Caption:**

💡 **Reading tip of the week:**

*"Put your phone face-down, open a book, and give yourself one chapter. You'll read three."* 📖✨

The scroll never satisfies. A good chapter always does.

Replace the last 10 minutes of late-night scrolling with reading — your sleep quality will thank you. 🌙🌸

My Reading Village turns that bedtime habit into something you actually look forward to. 🏡🐶 Coming soon, free!

#readingtip #nightroutine #sleephygiene #bookhabit #myreadingvillage #readmore #justonechapter #booklovers

---

#### 📱 Instagram Story

**Advice:** Add a "Try this tonight 🌙" sticker or question box: "What are you reading right now?"

**Caption:**

💡 "Give yourself one chapter. You'll read three." 📖🌙
Replace the scroll. Rest better. 🌸

---

#### 🎵 TikTok

**Advice:** Short lines, direct ask. Feels like a voiceover-friendly habit tip.

**Caption:**

the reading hack that replaced my late night scrolling 📖✨

phone face down. one chapter. just one.

you will not stop at one.

My Reading Village rewards every page — and makes the habit genuinely addictive 🏡🐶 coming soon free

#readingtip #readingtok #justonechapter #myreadingvillage

---

#### 👥 Facebook Post

**Advice:** Sleep + reading resonates with parents. Cite the sleep science briefly.

**Caption:**

A tip worth trying tonight: put your phone face-down and read one chapter before bed.

Sleep researchers confirm what book lovers always knew — reading before sleep reduces stress, slows your heart rate, and improves sleep quality. 🌙📖

And "just one chapter" almost never stays at one. 😄

My Reading Village makes that bedtime ritual even more rewarding. Coming soon, free!

#readingtip #myreadingvillage

---

---

### Jun 23 · Tuesday — Gameplay Showcase 📹 Video

**Template:** `gameplay_showcase --lang en` · **Best time:** 12:00–14:00

---

#### 📱 Instagram Reel

**Advice:** Product showcase — lead with the "wow" of the game loop. 41 villagers is the hook. "Free" is the close.

**Caption:**

🏡 Libraries. Parks. Schools. And 41 of the cutest characters you've ever seen. 🌸

**My Reading Village** is what happens when a reading habit meets a village-builder game. Every book you read = new villager, new gem, new building. The more you read, the more your world grows. 📚✨

Free to play. All 41 villagers collectible. Coming soon to Play Store!

Follow 👇 — new villager reveals every week.

#myreadingvillage #gameplay #villagebuilder #mobilegame #readinggame #kawaii #indiegame #comingsoon #bookapp #cozygame

---

#### 📱 Instagram Story

**Advice:** Fast cut energy. 2 lines, strong CTA.

**Caption:**

🏡 Build libraries. Collect villagers. Just by reading. 📚
Coming soon FREE — follow us! 🌸

---

#### 🎵 TikTok

**Advice:** The game loop written as a satisfying list. Very TikTok-native — reads well as voiceover over gameplay footage.

**Caption:**

the reading game nobody knew they needed 🏡📚

step 1: read a book 📖
step 2: earn gems + unlock a villager 🐱
step 3: build your village 🏛️
step 4: repeat forever because it's adorable ✨

41 villagers. 5 rarity tiers. free.

My Reading Village — coming soon 🌸

#myreadingvillage #cozygame #readingtok

---

#### 👥 Facebook Reel

**Advice:** Emphasize "free" + habit angle. FB parent/adult demographic appreciates the "reward for something useful" pitch.

**Caption:**

Ever wished there was a reward for finishing that book? 📚

My Reading Village gives you exactly that. Read books, earn villagers, construct buildings, and watch your cozy little town grow — all for free.

It's a mobile game designed to make the reading habit stick. 41 adorable collectible villagers await! 🏡🌸

Coming soon to Play Store. Follow us so you don't miss the launch!

#myreadingvillage #readinghabit

---

#### 📺 YouTube Shorts

**Advice:** "Build a Village by Reading Books" is a strong keyword phrase — searchable and specific.

**Title:** `Build a Village by Reading Books — My Reading Village Gameplay 🏡📚`

**Description:**

My Reading Village is a free kawaii mobile game where your reading habit literally builds a world.

Collect 41 villagers across 5 rarity tiers. Construct libraries, parks, schools, and more. Every book you read earns gems and unlocks new characters. 🏡✨

Read → Earn → Build → Grow

Coming soon FREE to the Play Store! Subscribe for weekly reveals.

#myreadingvillage #mobilegame #cozygame #villagebuilder #readinggame

---

---

### Jun 24 · Wednesday — Countdown Teaser: Dog 📹 Video

**Template:** `countdown_story --villager dog --lang en` · **Best time:** 18:00–20:00

---

#### 📱 Instagram Story

**Advice:** Add a poll sticker with a wrong guess and Dog as one option (or keep all wrong to tease). Story → drives people to check the Reel reveal tomorrow.

**Caption:**

👀 Something's coming to My Reading Village...
A new villager is hiding in the shadows 🌑🐾
Guess who? Follow us — reveal drops tomorrow! 🌸

---

#### 📱 Instagram Reel

**Advice:** Short tease. Loyalty angle hints at Dog without naming them. Drive follows with "reveal tomorrow".

**Caption:**

🌑 Something's coming to My Reading Village...

A new villager is hiding in the shadows. 👀✨
Always there. Always loyal. Common rarity, rare heart.

Can you guess who? 🐾 Follow us — the reveal drops tomorrow. 🌸

#myreadingvillage #comingsoon #villagerreveal

---

#### 🎵 TikTok

**Advice:** Mystery + loyalty hints drive guesses. "Best reading companion" is a playful tease for Dog.

**Caption:**

wait for the reveal... 🌑👀

your most loyal reading companion is coming to My Reading Village ✨

guess the villager in the comments 👇

#myreadingvillage #villagerreveal #comingsoon

---

#### 👥 Facebook Story

**Advice:** Minimal text. Short teaser.

**Caption:**

👀 A new villager is coming tomorrow...
Guess who! 🌑🐾 #myreadingvillage

---

---

### Jun 25 · Thursday — Villager Reveal: Dog 📹 Video

**Template:** `villager_reveal_reel --villager dog --lang en` · **Best time:** 19:00–21:00

---

#### 📱 Instagram Reel

**Advice:** Payoff post after yesterday's tease. Dog = loyalty angle. "Reading companion" framing is warm and shareable.

**Caption:**

🐕✨ THE REVEAL IS HERE.

Meet **Dog** — a **Common rarity** villager joining My Reading Village! 🌿🏡

Your most loyal reading companion. Dog shows up every single day — just like the best readers do. 📚❤️

41 villagers total. Who's your reading companion? Drop it below 👇

Coming soon FREE to Play Store — follow for weekly reveals! 🌸

#dogvillager #villagerreveal #myreadingvillage #readinggame #kawaii #comingsoon

---

#### 📱 Instagram Story

**Advice:** Warm announcement energy. "Best friend" framing resonates universally.

**Caption:**

🐕🌿 Dog has arrived! Common rarity.
Your most loyal reading companion. 📚❤️

---

#### 🎵 TikTok

**Advice:** Relatable loyalty angle — "shows up every day" mirrors the reader's own commitment.

**Caption:**

meet dog 🐕 the most loyal reader in My Reading Village ✨

shows up every day. never skips a chapter. common rarity, uncommon dedication 📚

that's the kind of reader we built this game for 🏡🌸

are you a daily reader? 👀

#myreadingvillage #villagerreveal #readingtok

---

#### 👥 Facebook Reel

**Advice:** Warm community tone. "Reading companion" angle for adults who grew up with dogs.

**Caption:**

Meet **Dog** 🐕 — a Common rarity villager joining My Reading Village! 🌿✨

Every great reading habit needs a companion. Dog is yours — always there, always loyal, always ready for the next chapter. 📚🏡

41 collectible villagers await. Coming soon FREE — follow us!

#myreadingvillage #villagerreveal

---

#### 📺 YouTube Shorts

**Advice:** "Dog Villager Reveal" — friendly, high-click-through keyword for a casual gaming audience.

**Title:** `Dog — Common Rarity Villager Reveal 🐕✨ My Reading Village`

**Description:**

Meet Dog — a Common rarity villager in My Reading Village! 🐕✨

My Reading Village has 41 collectible villagers across 5 rarity tiers: Common, Rare, Extraordinary, Legendary, and Godly. Dog is Common rarity — loyal, friendly, and always ready to read.

Read books → Earn gems → Unlock villagers → Build your village 🏡📚

Subscribe for weekly reveals. Coming soon FREE on Play Store!

#myreadingvillage #villagerreveal #mobilegame

---

---

### Jun 26 · Friday — Excuses Not to Read 🖼️ Image

**Template:** `excuses_not_to_read --lang en --background 5` · **Best time:** 11:00–13:00

---

#### 📱 Instagram Post

**Advice:** Relatable humor → solution pivot. High save + share potential. "Tag someone" drives comments.

**Caption:**

Let's be real for a second. 😅

❌ "I don't have time."
❌ "I can't focus."
❌ "Books are boring."
❌ "I'll start tomorrow."

We've all said every single one of these. And honestly? They're not really about time or focus.

We just... don't feel like it. And that's completely normal. 📖

The secret isn't willpower — it's removing the friction. Make it easy. Make it fun. Make it feel like a reward.

That's exactly what **My Reading Village** does. 🏡🌸 Coming soon FREE.

Tag someone who needs this push 👇

#readingexcuses #readmore #bookmotivation #habitbuilding #myreadingvillage #booklovers #readinglife #startreading

---

#### 📱 Instagram Story

**Advice:** Use a poll sticker: "Which excuse is yours?" with 2 options (e.g., "No time 😅" vs "Not in the mood 😴").

**Caption:**

Which excuse is your go-to? 😅
❌ No time / ❌ Can't focus / ❌ Not in the mood
(We built a game to fix that 🌸)

---

#### 👥 Facebook Post

**Advice:** Warm, non-judgmental tone. End with an open question to drive comments.

**Caption:**

Raise your hand if you've said "I'll start reading again soon" more than once this year 🙋

No judgment — we all have our reasons. But most reading blocks aren't about intelligence or time. They're about friction and motivation.

My Reading Village is a free mobile game designed to remove both. Read a little, earn a reward, watch something adorable grow. 🏡📚

Coming soon! What's holding you back from reading more?

#readmore #myreadingvillage

---

---

### Jun 27 · Saturday — Marketing Banner 2 🖼️ Horizontal Banner

**Asset:** `my_reading_village/assets/images/backgrounds/marketing_banner_horizontal_2.png` · **Best time:** 19:00–21:00

*Post the banner image as-is — no generated template needed. Pair with the captions below.*

---

#### 📱 Instagram Post

**Advice:** Mid-week visual anchor — landmark post between villager reveals. Let the art speak; keep copy minimal and warm.

**Caption:**

This is your village. 🏡🌿

Built book by book. Page by page. Chapter by chapter.

My Reading Village — coming soon, completely free. 📚✨ Follow us for weekly villager reveals!

#myreadingvillage #kawaii #comingsoon #cozygame

---

#### 👥 Facebook Post

**Caption:**

We built My Reading Village because we believe reading deserves a reward. 📚🏡

Every book you finish unlocks a new neighbor. Every page moves you closer to a world that's entirely yours.

41 villagers. 5 rarity tiers. Free to play. Coming soon to Play Store — follow us to be first!

#myreadingvillage #readmore

---

---

### Jun 28 · Sunday — Feature Highlight: 5 Rarity Tiers 🖼️ Image

**Template:** `feature_highlight --lang en --fact 1 --villager lion` · **Best time:** 19:00–21:00

---

#### 📱 Instagram Post

**Advice:** The "5 tiers" hook taps into collector psychology. Lead with the range — Common to Godly — and let the rarity chase do the work.

**Caption:**

✨ **5 rarity tiers. 41 villagers. One village.**

From **Common** to **Legendary** to **Godly** — the rarest species in My Reading Village take serious reading commitment to unlock. 📚🏡

The more you read, the higher you level — and the closer you get to your dream villager.

Which tier are you chasing first? Drop it below 👇

Coming soon FREE to Play Store — follow so you don't miss a single reveal! 🌸

#myreadingvillage #raritytiers #collectibles #mobilegame #readinggame #kawaii #comingsoon #villagerreveal

---

#### 📱 Instagram Story

**Advice:** Rarity teaser — add a poll: "Which tier are you aiming for? Common 🐱 / Godly 🦁"

**Caption:**

✨ 5 rarity tiers in My Reading Village!
Common → Rare → Extraordinary → Legendary → Godly 🦁
Which one is your goal? 📚🏡

---

#### 🎵 TikTok

**Advice:** Collector energy. Short escalating list reads well as voiceover. Lion = aspirational top-tier.

**Caption:**

5 rarity tiers in My Reading Village 📚✨

common 🐱 — start here
rare 🦊 — level up
extraordinary 🐼 — now we're talking
legendary 🐯 — serious readers only
godly 🦁 — the endgame

which one is your must-have? 👇

free mobile game coming soon 🏡🌸

#myreadingvillage #raritytiers #cozygame #readingtok

---

#### 👥 Facebook Post

**Advice:** Collector + completionist framing resonates on Facebook. Ask about favorite animals to drive comments.

**Caption:**

Did you know My Reading Village has **5 rarity tiers** — from Common all the way to Godly? 🌸

Common, Rare, Extraordinary, Legendary, and Godly. The rarer the villager, the more reading milestones it takes to unlock. That's the whole design: your real-world reading habit determines which species join your world. 📚🏡

41 collectible villagers total. Some are easy to find. Some take dedication.

Which animal would YOU want as your Godly rarity? 👇

Coming soon FREE to Play Store!

#myreadingvillage #collectibles #readinghabit

---

---

### Jun 29 · Monday — Who Should Read More? 🖼️ Image *(original content)*

**Template:** manual/canva · **Best time:** 19:00–21:00

---

#### 📱 Instagram Post

**Advice:** "Tag someone from this list" is one of the highest comment-driving CTAs on Instagram. Each bullet is a tagging opportunity.

**Caption:**

📚 Based on everything science tells us about reading, here's who should be reading more right now:

🧠 **You** — 68% less stress, sharper memory, better focus
❤️ **Your kids** — stronger empathy, richer vocabulary, lifelong habit
📝 **Your students** — critical thinking, concentration, academic results
😴 **Your partner who scrolls till 2am** — better sleep, calmer mornings
☕ **Your friend who "used to love reading"** — they just need a nudge

Tag someone from this list. They need this. 👇

My Reading Village turns reading into a habit everyone can build — free, fun, and genuinely rewarding. 🏡🌸 Coming soon!

#tagafriend #readmore #readingbenefits #familyreading #myreadingvillage #booklovers #sharethis

---

#### 📱 Instagram Story

**Advice:** Use the mention sticker. Ask: "Tag the person who needs to read more 👇"

**Caption:**

Tag someone who needs to read more 📚
(We won't tell them why 😄)

---

#### 👥 Facebook Post

**Advice:** Shareable content — parents and teachers share lists like this. End with a personal question.

**Caption:**

Here's a question worth sitting with: who in your life would benefit most from reading more?

The benefits of a regular reading habit — reduced stress, better memory, stronger empathy, improved sleep — apply at every age. Kids, students, adults, seniors. Everyone.

If you know someone who wants to read more but struggles to make it stick, **My Reading Village** is being built exactly for that. A free mobile game that turns daily reading into a rewarding habit. 🏡📚

Coming soon! Who would you gift this to first?

#readmore #myreadingvillage

---

---

### Jun 30 · Tuesday — Villager Spotlight: Rabbit 🖼️ Image

**Template:** `villager_spotlight --villager rabbit --lang en` · **Best time:** 12:00–14:00

---

#### 📱 Instagram Post

**Advice:** Character card format — high save potential. Give Rabbit a personality, not just stats. End with "which one is your must-have?" for comments.

**Caption:**

🐰💜 **Villager Spotlight: Rabbit**
Rarity: Common · Your loyal first reader neighbor

Rabbit is always ready for the next chapter. Soft ears, warm heart, and a personal library that puts yours to shame. 📚🌸

In My Reading Village, Rabbit is one of the first friends to join your world — and one of the most beloved. Every book you finish brings you one step closer to unlocking your next neighbor. 🏡

41 villagers total. Which one is your must-have? 👇

#villager spotlight #rabbitvillager #myreadingvillage #kawaii #readinggame #comingsoon

---

#### 📱 Instagram Story

**Advice:** Simple character card. Add a question sticker: "Rabbit or Fox? 🐰🦊"

**Caption:**

🐰 Villager Spotlight: Rabbit
Common rarity · Coming to My Reading Village 📚🏡

---

#### 👥 Facebook Post

**Advice:** Warm character intro. "Which animal would YOU want?" drives friendly engagement.

**Caption:**

Meet **Rabbit** 🐰 — one of the first villagers to join your world in My Reading Village!

Every book you read earns you a new neighbor for your cozy little village. Rabbit is Common rarity, always welcoming, and a true bookworm at heart. 📚🏡🌸

Coming soon FREE to Play Store. Which animal would YOU want as your first villager?

#myreadingvillage #villager spotlight

---

---

### Jul 1 · Wednesday — Reading Challenge 📹 Video

**Template:** `reading_challenge_story --lang en` · **Best time:** 12:00–14:00

---

#### 📱 Instagram Reel

**Advice:** Challenge format drives comments — people love sharing their goal. Ask a direct question in the first line. The "drop below" CTA turns it into a thread.

**Caption:**

📚 This week's reading challenge: can you read 20 pages every day?

Sounds small. Adds up to 1.8 million words a year. 🤯

Drop your daily page goal in the comments below 👇 and let's build a reading streak together.

My Reading Village turns your reading habit into something you can actually see grow. 🏡🌸 Coming soon FREE!

#readingchallenge #readmore #pagegoal #readinghabit #myreadingvillage #booktok #readingtok #comingsoon

---

#### 📱 Instagram Story

**Advice:** Question sticker: "How many pages can you read today?" drives direct engagement.

**Caption:**

📚 Can you read 20 pages every day this week?
Drop your goal — let's streak together 👇🌸

---

#### 🎵 TikTok

**Advice:** Challenge format is native TikTok. Short lines, direct ask. "I'll go first" builds trust.

**Caption:**

reading challenge 📚✨

can you read 20 pages a day this week?

I'll go first: 20 pages. every. day.

that's 140 pages this week → 1.8 million words a year

drop your goal below 👇 let's keep each other accountable

My Reading Village rewards every single page 🏡🌸 coming soon free

#readingchallenge #readingtok #pagegoal #myreadingvillage

---

#### 👥 Facebook Post

**Advice:** Community challenge angle. "Tag someone" drives shares. Open question for comments.

**Caption:**

Here's your reading challenge for this week: 20 pages every day. 📚

That's about 15–20 minutes of reading daily — and over the course of a year, it adds up to roughly 1.8 million words. It's one of the highest-leverage habits you can build.

Drop your daily page goal in the comments 👇 and tag someone who should join you.

My Reading Village is being built to make that habit stick — with rewards, villagers, and a little world that grows every time you read. 🏡 Coming soon, completely free.

#readingchallenge #readmore #myreadingvillage

---

---

### Jul 2 · Thursday — Countdown Teaser: Rabbit 📹 Video

**Template:** `countdown_story --villager rabbit --lang en` · **Best time:** 18:00–20:00

---

#### 📱 Instagram Story

**Advice:** Poll sticker with a wrong guess and Rabbit as one option (or keep all wrong to tease harder). Story → drives people to check the Reel reveal tomorrow.

**Caption:**

🌑 Something cozy is coming to My Reading Village...
A new villager is stepping into the light 🐾✨
Guess who? Follow us — reveal drops tomorrow! 🌸

---

#### 📱 Instagram Reel

**Advice:** Cozy + bookish personality angle for Rabbit — "always with a book in paw."

**Caption:**

🌑 *Something cozy is coming to My Reading Village...*

A Common rarity villager is stepping out of the shadows. 🐾✨

Soft. Bookish. Always with a chapter in paw.

Guess who? Drop your best guess below 👀
Reveal drops tomorrow — follow so you don't miss it! 🌸

#myreadingvillage #comingsoon #villagerreveal

---

#### 🎵 TikTok

**Advice:** Cozy clues drive guesses. Invite comments with "obviously" hints that are still fun.

**Caption:**

soft. loves books. hops with excitement every time a chapter ends. 🌑📚

guess the villager coming to My Reading Village tomorrow 👀

#myreadingvillage #villagerreveal

---

#### 👥 Facebook Story

**Caption:**

👀 A cozy villager is coming tomorrow...
Can you guess? 🐾 #myreadingvillage

---

---

### Jul 3 · Friday — Villager Reveal: Rabbit 📹 Video

**Template:** `villager_reveal_reel --villager rabbit --lang en` · **Best time:** 19:00–21:00

---

#### 📱 Instagram Reel

**Advice:** Payoff after yesterday's tease. Rabbit = cozy, bookish, the ultimate reader persona. Soft warm energy.

**Caption:**

🐰💜 THE COZY REVEAL IS HERE.

Meet **Rabbit** — a **Common rarity** villager joining My Reading Village! 🌸✨

Soft ears. Warm heart. A personal library that puts yours to shame. 📚🏡

Every page you finish gets you one step closer to this adorable reader. 41 villagers total — which rarity tier are you chasing?

Coming soon FREE to Play Store — follow for more reveals! 👇

#rabbitvillager #villagerreveal #myreadingvillage #kawaii #readinggame #comingsoon

---

#### 📱 Instagram Story

**Caption:**

🐰🌸 Rabbit revealed! Common rarity.
The coziest reader in My Reading Village 📚🏡

---

#### 🎵 TikTok

**Advice:** Cozy reader personality — relatable, warm. Invite "your pick?" responses.

**Caption:**

the cozy reveal you've been waiting for 🐰✨

meet rabbit — common rarity but maximum comfort vibes 📚🌸

in My Reading Village every book you finish brings a new neighbor home

who's your reading spirit animal? 👇

#myreadingvillage #villagerreveal #readingtok

---

#### 👥 Facebook Reel

**Caption:**

And the mystery villager is... 🐰 **Rabbit**! Common rarity, and the coziest reader in the village.

In My Reading Village, Rabbit is one of the first friends to join your world — soft-hearted, book-obsessed, and always ready for the next chapter. 📚🏡

41 collectible villagers await. Coming soon FREE! Which animal is your must-have?

#myreadingvillage #villagerreveal

---

#### 📺 YouTube Shorts

**Title:** `Rabbit — Common Rarity Villager Reveal 🐰💜 My Reading Village`

**Description:**

Rabbit joins My Reading Village as a Common rarity villager! 🐰✨

Collect all 41 villagers across 5 rarity tiers by building your daily reading habit. Every book earns you rewards to grow your cozy little village. 📚🏡

Subscribe for weekly villager reveals. Coming soon FREE on Play Store!

#myreadingvillage #villagerreveal #cozygame

---

---

### Jul 4 · Saturday — Feature Highlight: Habit 🖼️ Image

**Template:** `feature_highlight --lang en --fact 3` · **Best time:** 19:00–21:00

---

#### 📱 Instagram Post

**Advice:** "1 book a month" is highly approachable — removes the intimidation factor. Pair with the app's goal-setting angle.

**Caption:**

📚 The secret to a reading habit? Start embarrassingly small.

One book. Per month. That's it. 🌸

Readers who set a concrete goal — even just 1 book a month — are dramatically more likely to stick with it than those who try to "read more" with no target.

My Reading Village helps you build that goal, track your progress, and rewards you every step of the way. 🏡✨ Coming soon FREE!

#readinghabit #readmore #1bookamonth #habitbuilding #myreadingvillage #booklovers #readinggoal #comingsoon

---

#### 📱 Instagram Story

**Advice:** Relatable "start small" message. Poll sticker: "Your reading goal this month? 📚"

**Caption:**

📚 1 book a month = a reading habit that actually sticks.
My Reading Village makes it even easier. 🏡🌸

---

#### 👥 Facebook Post

**Advice:** FB audience loves practical advice they can act on today. Keep it warm and non-judgmental.

**Caption:**

The #1 mistake readers make? Trying to do too much too fast.

Setting a goal of just 1 book a month — and actually tracking it — is one of the most effective ways to build a lasting reading habit. 📚

Small goals stick. Big goals don't.

My Reading Village is built around exactly that: giving you a goal, tracking your reading, and rewarding every page you turn. 🏡🌸 Coming soon, completely free.

What's your reading goal for this month?

#readinghabit #readmore #myreadingvillage

---

---

### Jul 5 · Sunday — What if Reading Was a Game? 🖼️ Image *(original content)*

**Template:** manual/canva · **Best time:** 12:00–14:00

---

#### 📱 Instagram Post

**Advice:** "What if" aspirational format — high engagement. Each question should escalate. End with the product as the answer.

**Caption:**

🎮📚 What if finishing a book meant unlocking a new villager in your cozy little village?

What if reading 10 pages gave you gems to build a library?

What if your reading streak literally constructed a world?

What if the habit you've always wanted to build... finally felt like a reward? 🌸

**That's My Reading Village.**

A free mobile game that turns the reading habit into the most satisfying loop you've ever played. 🏡✨

Coming soon to Play Store — follow us and be first to play! 👇

#readinggame #gamification #bookapp #myreadingvillage #indiegame #kawaii #cozygame #mobilegame #habitbuilding #readmore

---

#### 📱 Instagram Story

**Advice:** Use the "What if?" as a story question sticker. Invite responses.

**Caption:**

📖 What if reading built a village? 🏡
My Reading Village does exactly that. Coming soon free. 🌸

---

#### 👥 Facebook Post

**Advice:** Conversational. Tell the origin story of the idea — FB audiences engage with "why we built this".

**Caption:**

What if the reading habit felt like a game you actually wanted to play?

That's the question we started with when building My Reading Village. 📚

The idea is simple: every book you read earns rewards inside a cozy village-builder. Finish a chapter, unlock a villager. Build a streak, construct a library. The more you read, the more your world grows. 🏡✨

No willpower required. Just the natural pull of a satisfying game loop — built around something that genuinely improves your life.

Free. Coming soon to Play Store. Interested? Follow us!

#myreadingvillage #readinggame

---

---

### Jul 6 · Monday — Excuses Not to Read 🖼️ Image

**Template:** `excuses_not_to_read --lang en` · **Best time:** 11:00–13:00

---

#### 📱 Instagram Post

**Advice:** Relatable humor → solution pivot. High save + share potential. "Tag someone" drives comments.

**Caption:**

Let's be real for a second. 😅

❌ "I don't have time."
❌ "I can't focus."
❌ "Books are boring."
❌ "I'll start tomorrow."

We've all said every single one of these. And honestly? They're not really about time or focus.

We just... don't feel like it. And that's completely normal. 📖

The secret isn't willpower — it's removing the friction. Make it easy. Make it fun. Make it feel like a reward.

That's exactly what **My Reading Village** does. 🏡🌸 Coming soon FREE.

Tag someone who needs this push 👇

#readingexcuses #readmore #bookmotivation #habitbuilding #myreadingvillage #booklovers #readinglife #startreading

---

#### 📱 Instagram Story

**Advice:** Use a poll sticker: "Which excuse is yours?" with 2 options (e.g., "No time 😅" vs "Not in the mood 😴").

**Caption:**

Which excuse is your go-to? 😅
❌ No time / ❌ Can't focus / ❌ Not in the mood
(We built a game to fix that 🌸)

---

#### 👥 Facebook Post

**Advice:** Warm, non-judgmental tone. End with an open question to drive comments.

**Caption:**

Raise your hand if you've said "I'll start reading again soon" more than once this year 🙋

No judgment — we all have our reasons. But most reading blocks aren't about intelligence or time. They're about friction and motivation.

My Reading Village is a free mobile game designed to remove both. Read a little, earn a reward, watch something adorable grow. 🏡📚

Coming soon! What's holding you back from reading more?

#readmore #myreadingvillage

---

---

### Jul 7 · Tuesday — Who Should Read More? 🖼️ Image

**Template:** `who_should_read --lang en` · **Best time:** 19:00–21:00

---

#### 📱 Instagram Post

**Advice:** "Tag someone from this list" is one of the highest comment-driving CTAs on Instagram. Each bullet is a tagging opportunity.

**Caption:**

📚 Based on everything science tells us about reading, here's who should be reading more right now:

🧠 **You** — less stress, sharper memory, better focus
❤️ **Your kids** — stronger empathy, richer vocabulary, lifelong habit
📝 **Your students** — critical thinking, concentration, academic results
😴 **Your partner who scrolls till 2am** — better sleep, calmer mornings
☕ **Your friend who "used to love reading"** — they just need a nudge

Tag someone from this list. They need this. 👇

My Reading Village turns reading into a habit everyone can build — free, fun, and genuinely rewarding. 🏡🌸 Coming soon!

#tagafriend #readmore #readingbenefits #familyreading #myreadingvillage #booklovers #sharethis

---

#### 📱 Instagram Story

**Advice:** Use the mention sticker. Ask: "Tag the person who needs to read more 👇"

**Caption:**

Tag someone who needs to read more 📚
(We won't tell them why 😄)

---

#### 👥 Facebook Post

**Advice:** Shareable content — parents and teachers share lists like this. End with a personal question.

**Caption:**

Here's a question worth sitting with: who in your life would benefit most from reading more?

The benefits of a regular reading habit — reduced stress, better memory, stronger empathy, improved sleep — apply at every age. Kids, students, adults, seniors. Everyone.

If you know someone who wants to read more but struggles to make it stick, **My Reading Village** is being built exactly for that. A free mobile game that turns daily reading into a rewarding habit. 🏡📚

Coming soon! Who would you gift this to first?

#readmore #myreadingvillage

---

---

## Hashtag Bank

```
core brand       #myreadingvillage #readinggame #bookapp #comingsoon #playstore
game content     #villagerreveal #kawaigame #cozygame #villagebuilder #indiegame #mobilegame
reading habit    #readmore #readinghabit #dailyreading #booklovers #booktok #readingtok
benefits         #readingbenefits #brainhealth #stressrelief #mentalhealth #mindfuliving
rarity tiers     #commonrarity #rarevillager #legendaryvillager #godlyrarity
community        #tagafriend #shareandcare #readinglife
kawaii/aesthetic #kawaii #cozyvibes #pastelaesthetic #cutegame
```
