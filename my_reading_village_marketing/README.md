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
│   │   ├── feature_highlight.py      # "Did you know?" card with fact stat
│   │   └── reading_tip.py            # Quote from game's reading_tips JSON
│   └── video/
│       ├── reading_benefits_story.py  # Benefits of Reading (all 5 languages)
│       ├── villager_reveal_reel.py    # Intro + dramatic reveal + CTA, ~12 s
│       ├── gameplay_showcase.py       # Buildings + villager parade, ~15 s
│       └── countdown_story.py         # Mystery silhouette teaser, ~10 s
│
├── scripts/
│   └── generate.py         # CLI dispatcher
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
.venv/bin/python3 scripts/generate.py --template feature_highlight --lang en
.venv/bin/python3 scripts/generate.py --template reading_tip --lang en
```

**Available languages:** `en` · `es` · `pt` · `fr` · `it`

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

## Content Calendar — June 2026

### Overview

| Date | Day | Content | Format | Template |
|------|-----|---------|--------|----------|
| Jun 10 | Tue | Reading Benefits | 📹 Video 9:16 | `reading_benefits_story --lang en` |
| Jun 11 | Wed | Reading Tip | 🖼️ Image 9:16 | `reading_tip --lang en` |
| Jun 12 | Thu | Villager Reveal — Cat | 📹 Video 9:16 | `villager_reveal_reel --villager cat --lang en` |
| Jun 13 | Fri | Feature Highlight — Stress | 🖼️ Image 9:16 | `feature_highlight --lang en` |
| Jun 14 | Sat | Gameplay Showcase | 📹 Video 9:16 | `gameplay_showcase --lang en` |
| Jun 15 | Sun | Countdown Teaser — Fox | 📹 Video 9:16 | `countdown_story --villager fox --lang en` |
| Jun 16 | Mon | Villager Reveal — Fox | 📹 Video 9:16 | `villager_reveal_reel --villager fox --lang en` |
| Jun 17 | Tue | Excuses Not to Read | 🖼️ Image 9:16 | manual/canva |
| Jun 18 | Wed | Reading Tip | 🖼️ Image 9:16 | `reading_tip --lang en` |
| Jun 19 | Thu | Who Should Read More? | 🖼️ Image 9:16 | manual/canva |
| Jun 20 | Fri | Villager Spotlight — Rabbit | 🖼️ Image 9:16 | `villager_spotlight --villager rabbit --lang en` |
| Jun 21 | Sat | Reading Benefits (ES) | 📹 Video 9:16 | `reading_benefits_story --lang es` |
| Jun 22 | Sun | Countdown Teaser — Panda | 📹 Video 9:16 | `countdown_story --villager panda_bear --lang en` |
| Jun 23 | Mon | Villager Reveal — Panda Bear | 📹 Video 9:16 | `villager_reveal_reel --villager panda_bear --lang en` |
| Jun 24 | Tue | Feature Highlight — Memory | 🖼️ Image 9:16 | `feature_highlight --lang en` |
| Jun 25 | Wed | Reading Tip | 🖼️ Image 9:16 | `reading_tip --lang en` |
| Jun 26 | Thu | What if Reading Was a Game? | 🖼️ Image 9:16 | manual/canva |
| Jun 27 | Fri | Villager Spotlight — Koala | 🖼️ Image 9:16 | `villager_spotlight --villager koala --lang en` |
| Jun 28 | Sat | Gameplay Showcase (ES) | 📹 Video 9:16 | `gameplay_showcase --lang es` |
| Jun 29 | Sun | Countdown Teaser — Lion | 📹 Video 9:16 | `countdown_story --villager lion --lang en` |
| Jun 30 | Mon | Villager Reveal — Lion | 📹 Video 9:16 | `villager_reveal_reel --villager lion --lang en` |

---

---

### Jun 10 · Tuesday — Reading Benefits 📹 Video

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

### Jun 11 · Wednesday — Reading Tip 🖼️ Image

**Template:** `reading_tip --lang en` · **Best time:** 11:00–13:00

---

#### 📱 Instagram Post

**Advice:** Quote-format captions get high saves. First line = the quote or stat. Hashtags at the very end.

**Caption:**

💡 **Reading tip of the week:**

*"Read at the same time every day and your brain will start craving it like coffee."* ☕📖

Consistency beats intensity — even 10 minutes counts. Attach it to something you already do: morning coffee, lunch break, bedtime. Stack the habit. 🌸

My Reading Village turns that daily ritual into something you actually look forward to. 🏡🐱 Coming soon, free!

#readingtip #bookhabit #dailyreading #myreadingvillage #readmore #habitbuilding #booklovers

---

#### 📱 Instagram Story

**Advice:** Show the quote visually on the image. Add a poll sticker like "You do this already? ✅ / Not yet 😅".

**Caption:**

💡 "Read at the same time every day — your brain will crave it like coffee." ☕📖
Follow for more tips! 🌸

---

#### 🎵 TikTok

**Advice:** Use a soft hook, then deliver the tip as a short rhythm. Feels like a voiceover-friendly script.

**Caption:**

the reading habit hack nobody talks about 📖✨

same time. every day. your brain starts expecting it like your morning coffee ☕

you don't even need to want to read. you just need to start at the same time.

My Reading Village makes the habit stick — and rewards you with the cutest little village 🏡🌸 coming soon free!

#readinghabit #booktok #myreadingvillage

---

#### 👥 Facebook Post

**Advice:** Under 300 chars for best organic reach on image posts. Simple, no link.

**Caption:**

💡 Reading tip: pick the same time every day — even 10 minutes — and your brain will start craving it. Consistency beats intensity every time. 📖🌸

My Reading Village makes that habit feel like a reward. Coming soon, free!

#readingtip #myreadingvillage

---

---

### Jun 12 · Thursday — Villager Reveal: Cat 📹 Video

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

### Jun 13 · Friday — Feature Highlight: Stress 🖼️ Image

**Template:** `feature_highlight --lang en` · **Best time:** 12:00–14:00

---

#### 📱 Instagram Post

**Advice:** Lead with the stat — numbers stop the scroll. The "68%" belongs in the first word.

**Caption:**

🧠 **68%.**

That's how much your stress drops after just 6 minutes of reading. No subscription. No meditation cushion. Just a book.

Reading rewires your nervous system — slowing heart rate, releasing muscle tension, quieting the mental noise. It's the oldest wellness hack in the world. 📖🌿

My Reading Village turns that ancient habit into a game that rewards you every single day. 🏡🌸 Coming soon FREE!

#readingbenefits #stressrelief #mentalhealth #mindfuliving #myreadingvillage #booklovers #wellness #sciencesays

---

#### 📱 Instagram Story

**Advice:** The stat card image does the heavy lifting. Text overlay = minimal. Add a "Save this 💾" sticker or quiz sticker.

**Caption:**

🧠 68% less stress. From reading. 6 minutes. Free.
My Reading Village — coming soon 🌸

---

#### 🎵 TikTok

**Advice:** "Tell me you didn't know this" hook is very native to TikTok. Short, punchy, disbelief format.

**Caption:**

tell me you didn't know this 🧠📚

6 minutes of reading = 68% stress reduction

that's not a wellness influencer stat. that's University of Sussex, 2009.

and we built a whole game around making that habit stick 🏡🌸 My Reading Village. coming soon, free.

#stressrelief #readingfacts #myreadingvillage

---

#### 👥 Facebook Post

**Advice:** FB audience appreciates context and source citations. Slightly longer is fine here. Share-friendly = "worth sharing with someone you care about" framing.

**Caption:**

Here's a fact worth sharing: reading for just 6 minutes a day can reduce stress by 68%. That's from a University of Sussex study — and it outperformed music, walking, and even video games for stress relief.

My Reading Village is built around this idea: make the reading habit irresistible by turning it into an adorable village-building game. 🏡📚 Free. Coming soon.

#readingbenefits #myreadingvillage

---

---

### Jun 14 · Saturday — Gameplay Showcase 📹 Video

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

### Jun 15 · Sunday — Countdown Teaser: Fox 📹 Video

**Template:** `countdown_story --villager fox --lang en` · **Best time:** 18:00–20:00

---

#### 📱 Instagram Story

**Advice:** Add a poll sticker with two wrong guesses + Fox as one option (or keep all wrong to tease harder). Story → drives people to check the Reel reveal tomorrow.

**Caption:**

👀 Something's coming to My Reading Village...
A new villager is hiding in the shadows 🌑🐾
Guess who? Follow us — reveal drops tomorrow! 🌸

---

#### 📱 Instagram Reel

**Advice:** Short tease. The mystery sells itself. Drive follows with "reveal tomorrow".

**Caption:**

🌑 Something's coming to My Reading Village...

A new villager is hiding in the shadows. 👀✨
Godly rarity. Rare find. Legendary reader required.

Can you guess who? 🐾 Follow us — the reveal drops tomorrow. 🌸

#myreadingvillage #comingsoon #villagerreveal

---

#### 🎵 TikTok

**Advice:** Mystery + curiosity gap drives comments. Ask directly: "Guess in the comments."

**Caption:**

wait for the reveal... 🌑👀

something godly is coming to My Reading Village ✨

guess the villager in the comments 👇 winner gets bragging rights when the app drops 🐾

#myreadingvillage #villagerreveal #comingsoon

---

#### 👥 Facebook Story

**Advice:** Minimal text. Short. Works as a teaser to tomorrow's Reel.

**Caption:**

👀 A new villager is coming tomorrow...
Guess who! 🌑🐾 #myreadingvillage

---

---

### Jun 16 · Monday — Villager Reveal: Fox 📹 Video

**Template:** `villager_reveal_reel --villager fox --lang en` · **Best time:** 19:00–21:00

---

#### 📱 Instagram Reel

**Advice:** Payoff post after yesterday's tease — reference it. "THE WAIT IS OVER" energy. Godly rarity = exclusivity flex.

**Caption:**

🦊👑 THE WAIT IS OVER.

Meet **Fox** — a **Godly rarity** villager joining My Reading Village! 💜✨

Only the most dedicated readers will unlock this one. Fox doesn't just move into any village — Fox chooses the committed. 📚🔥

41 villagers total. 5 rarity tiers. Which rarity are you going for? Drop it below 👇

Coming soon FREE to Play Store — follow for weekly reveals! 🌸

#foxvillager #godlyrarity #villagerreveal #myreadingvillage #readinggame #kawaii #comingsoon

---

#### 📱 Instagram Story

**Advice:** Announcement energy. Use the "New" sticker.

**Caption:**

🦊💜 Fox has arrived! Godly rarity.
Only dedicated readers unlock this. 📚🔥

---

#### 🎵 TikTok

**Advice:** Lean into the rarity flex — "worth every page" is relatable and satisfying.

**Caption:**

godly rarity unlocked 👑🦊

fox just joined My Reading Village and honestly? worth every page 📚✨

godly = the hardest tier to reach. for the readers who actually show up every day.

are you a godly reader? 👀

#myreadingvillage #villagerreveal #readingtok

---

#### 👥 Facebook Reel

**Advice:** Reward the followers who saw the tease yesterday. Reference it lightly.

**Caption:**

You guessed it — or maybe you didn't 😄 Meet **Fox**, a Godly rarity villager coming to My Reading Village! 🦊💜

Fox is one of the rarest collectibles in the game, reserved for players who build a consistent reading habit over time. The more you read, the rarer the rewards. 📚🏡

Coming soon FREE — follow us!

#myreadingvillage #villagerreveal

---

#### 📺 YouTube Shorts

**Advice:** "Godly Rarity" is a strong keyword — collectors and completionists search for this.

**Title:** `Fox — Godly Rarity Villager Reveal 🦊👑 My Reading Village`

**Description:**

Meet Fox — a Godly rarity villager in My Reading Village! 🦊✨

My Reading Village has 41 collectible villagers across 5 rarity tiers: Common, Rare, Extraordinary, Legendary, and Godly. Fox sits at the very top — only the most dedicated readers unlock this one.

Read books → Earn gems → Unlock villagers → Build your village 🏡📚

Subscribe for weekly reveals. Coming soon FREE on Play Store!

#myreadingvillage #villagerreveal #godlyrarity #mobilegame

---

---

### Jun 17 · Tuesday — Excuses Not to Read 🖼️ Image *(original content)*

**Template:** manual/canva · **Best time:** 11:00–13:00

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

#### 🎵 TikTok

**Advice:** Self-aware confessional tone — very TikTok-native. Short lines. Invite the audience to comment their own excuse.

**Caption:**

real talk about reading excuses 📚😭

"no time" → you have 6 minutes
"can't focus" → start with 2 pages
"books are boring" → you haven't found your genre yet
"i'll start tomorrow" → ...we know how that goes

the real reason? we just don't feel like it

that's why My Reading Village turns reading into a game with actual rewards 🏡🌸 coming soon free

what's YOUR excuse? 👇

#readingtok #booktok #readmore #myreadingvillage

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

### Jun 18 · Wednesday — Reading Tip 🖼️ Image

**Template:** `reading_tip --lang en` · **Best time:** 11:00–13:00

---

#### 📱 Instagram Post

**Advice:** Bedtime routine angle — high relatability. "Phone face-down" is a vivid, actionable image.

**Caption:**

💡 **Reading tip of the week:**

*"Put your phone face-down, open a book, and give yourself one chapter. You'll read three."* 📖✨

The scroll never satisfies. A good chapter always does.

Replace the last 10 minutes of late-night scrolling with reading — your sleep quality will thank you. 🌙🌸

My Reading Village turns that bedtime habit into something you actually look forward to. 🏡🐱 Coming soon, free!

#readingtip #nightroutine #sleephygiene #bookhabit #myreadingvillage #readmore #justonechapter #booklovers

---

#### 📱 Instagram Story

**Advice:** Add a "Try this tonight 🌙" sticker or question box: "What are you reading right now?"

**Caption:**

💡 "Give yourself one chapter. You'll read three." 📖🌙
Replace the scroll. Rest better. 🌸

---

#### 🎵 TikTok

**Advice:** Actionable micro-tip format. Short, rhythmic lines — reads well as text-overlay video.

**Caption:**

reading tip that actually works 📖✨

phone face-down.
book open.
one chapter.

that's it. you'll read three 🌙

the scroll never satisfies. a good chapter always does.

My Reading Village makes the habit even sweeter 🏡🌸 coming soon free

#booktok #readingtok #readingtip #myreadingvillage

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

### Jun 19 · Thursday — Who Should Read More? 🖼️ Image *(original content)*

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

#### 🎵 TikTok

**Advice:** List format with rhythm — works great as text-overlay or voiceover. Invite tags in comments.

**Caption:**

who needs to read more? let me count 📚👇

you → stress relief, memory, focus ✅
your kids → empathy + vocabulary ✅
your students → critical thinking ✅
your partner who scrolls till 2am → sleep quality ✅
your "i used to love reading" friend → just needs a push ✅

tag them in the comments 👇

My Reading Village makes the habit stick for all of them 🏡🌸 free, coming soon

#readmore #readingbenefits #tagafriend #myreadingvillage

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

### Jun 20 · Friday — Villager Spotlight: Rabbit 🖼️ Image

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

#### 🎵 TikTok

**Advice:** Give the character a personality — playful, human. Invite "your pick?" responses.

**Caption:**

meet rabbit 🐰 the reader's reader 📚✨

common rarity but makes up for it in pure cozy energy 🌸

in My Reading Village every book you finish brings a new neighbor home

41 villagers. 5 rarity tiers. rabbit is just the start.

who's your pick? 👇

#myreadingvillage #villager spotlight #cozygame

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

### Jun 21 · Saturday — Reading Benefits (ES) 📹 Video

**Template:** `reading_benefits_story --lang es` · **Best time:** 12:00–14:00

---

#### 📱 Instagram Reel

**Advice:** Spanish caption for LatAm + Spain audience. Same hook rule — first ~125 chars count.

**Caption:**

📚 ¿Sabías que **leer solo 6 minutos** puede reducir tu estrés un 68%? No horas. No capítulos enteros. Seis minutos. 🌸

**My Reading Village** es el juego donde tu hábito lector construye un pueblo adorable. Lee libros, desbloquea aldeanos, construye edificios. 🏡✨

Tu bienestar empieza en la primera página. ¡Próximamente GRATIS en Play Store! Síguenos 👇

#myreadingvillage #hábitodelectura #leer #beneficiosdelalectura #juegomóvil #kawaii #próximamentedisponible #libros

---

#### 📱 Instagram Story

**Advice:** Quick stat. Spanish. CTA sticker.

**Caption:**

📚 6 minutos de lectura = 68% menos estrés.
My Reading Village — próximamente gratis 🌸

---

#### 🎵 TikTok

**Advice:** Short, punchy. Hook = the stat. Native TikTok Spanish tone.

**Caption:**

¿sabías que leer 6 minutos al día reduce el estrés 68%? 📚✨

ni meditación ni apps de respiración

solo un libro y un ratito

My Reading Village convierte ese hábito en un juego adorable 🏡🌸 gratis, próximamente

¿ya sigues la cuenta? 👇

#myreadingvillage #leer #hábitodelectura

---

#### 👥 Facebook Reel

**Advice:** Spanish FB — slightly longer OK. Include the source to build credibility.

**Caption:**

Leer solo 6 minutos al día puede reducir el estrés un 68%. Lo demostró la Universidad de Sussex en 2009 — y supera en efectividad a la música, los videojuegos y hasta salir a caminar. 🌸

Construimos **My Reading Village** alrededor de esa idea: un juego móvil gratuito donde tu hábito lector construye un pueblo kawaii. Lee libros, gana aldeanos, construye tu mundo. 🏡📚

¡Próximamente en Play Store, completamente gratis! Síguenos para ser el primero en jugar.

#myreadingvillage #hábitodelectura

---

---

### Jun 22 · Sunday — Countdown Teaser: Panda Bear 📹 Video

**Template:** `countdown_story --villager panda_bear --lang en` · **Best time:** 18:00–20:00

---

#### 📱 Instagram Story

**Advice:** Poll sticker: "It's a Panda 🐼" vs "No way... 👀" (keep one wrong to tease).

**Caption:**

🌑 Something rare is hiding in the shadows...
A new villager is coming to My Reading Village tomorrow 🐾✨
Guess who? 👀

---

#### 📱 Instagram Reel

**Advice:** Short. Mystery sells itself. Drive follows.

**Caption:**

🌑 *Something rare is coming to My Reading Village...*

A Rare rarity villager is hiding in the shadows. 🐾✨

Guess who? Drop your best guess below 👀
Reveal drops tomorrow — follow so you don't miss it! 🌸

#myreadingvillage #comingsoon #villagerreveal

---

#### 🎵 TikTok

**Advice:** Clues game — "rare, black and white" is obvious but fun. Drives comments.

**Caption:**

rare rarity. black and white. loves bamboo AND books. 🌑📚

guess the villager coming to My Reading Village tomorrow 👀

#myreadingvillage #villagerreveal

---

#### 👥 Facebook Story

**Caption:**

👀 A rare villager is coming tomorrow...
Can you guess? 🐾 #myreadingvillage

---

---

### Jun 23 · Monday — Villager Reveal: Panda Bear 📹 Video

**Template:** `villager_reveal_reel --villager panda_bear --lang en` · **Best time:** 19:00–21:00

---

#### 📱 Instagram Reel

**Advice:** Payoff after Sunday tease. "Rare enough to feel special" communicates the tier value well.

**Caption:**

🐼💜 **RARE RARITY REVEALED.**

Meet **Panda Bear** — joining My Reading Village! 🌸✨

Rare enough to feel special. Adorable enough to be your wallpaper. 📱🎀

Every page you read gets you closer to this one. Build the reading habit. Earn the village. Collect them all. 📚🏡

Coming soon FREE to Play Store — follow for weekly reveals! 👇

#pandabear #rarevillager #villagerreveal #myreadingvillage #kawaii #readinggame

---

#### 📱 Instagram Story

**Caption:**

🐼 Panda Bear revealed! Rare rarity 💜
Coming to My Reading Village 📚🏡

---

#### 🎵 TikTok

**Advice:** "Plot twist" hook works even when the answer was obvious — it's playful.

**Caption:**

plot twist: the rare villager was panda bear all along 🐼💜

rare tier in My Reading Village = for readers who actually show up consistently

are you a rare reader or still working up to it? 📚✨

#myreadingvillage #villagerreveal #pandabear

---

#### 👥 Facebook Reel

**Caption:**

And the mystery villager is... 🐼 **Panda Bear**! Rare rarity, and absolutely worth every page.

In My Reading Village, rarer villagers unlock as your reading habit grows stronger. Panda Bear is Rare tier — for readers who show up consistently. 📚🏡

41 collectible villagers await. Coming soon FREE! Which rarity tier are you aiming for?

#myreadingvillage #villagerreveal

---

#### 📺 YouTube Shorts

**Title:** `Panda Bear — Rare Rarity Villager Reveal 🐼💜 My Reading Village`

**Description:**

Panda Bear joins My Reading Village as a Rare rarity villager! 🐼✨

Collect all 41 villagers across 5 rarity tiers by building your daily reading habit. The more consistent your reading, the rarer your rewards. 📚🏡

Subscribe for weekly villager reveals. Coming soon FREE on Play Store!

#myreadingvillage #villagerreveal #rarevillager

---

---

### Jun 24 · Tuesday — Feature Highlight: Memory 🖼️ Image

**Template:** `feature_highlight --lang en` · **Best time:** 19:00–21:00

---

#### 📱 Instagram Post

**Advice:** "Highest-return investment" framing is strong for an adult audience. End with a concrete product bridge.

**Caption:**

🧠 Every page you read builds **new neural connections.**

Reading doesn't just entertain — it physically rewires your brain. Each session strengthens memory pathways, sharpens focus, and deepens empathy through perspective-taking. 📖✨

The science is clear: a consistent reading habit is one of the highest-return investments you can make in your own mind.

My Reading Village rewards that investment every single day. 🏡🌸 Coming soon FREE!

#brainhealth #readingscience #neuralpathways #memory #readmore #mindfuliving #myreadingvillage #booklovers #memoryboost

---

#### 📱 Instagram Story

**Advice:** Bold stat overlay on the image. Question sticker: "Did you know this? 🧠"

**Caption:**

🧠 Reading builds new neural connections with every page. 📖
Your brain rewards you for it. We do too. 🌸

---

#### 🎵 TikTok

**Advice:** List of brain benefits with a short product bridge at the end.

**Caption:**

your brain literally changes when you read 🧠📚

new neural connections ✅
stronger memory ✅
deeper empathy ✅
sharper focus ✅

every. single. session.

My Reading Village rewards your brain AND gives you cute villagers 🏡🌸 coming soon free

#brainhealth #readingtok #myreadingvillage

---

#### 👥 Facebook Post

**Advice:** FB audience appreciates the full science breakdown. End with an open question.

**Caption:**

Here's what happens to your brain when you read consistently:

📖 New neural pathways form with each session
🧠 Memory encoding improves — you retain more
❤️ Empathy deepens through perspective-taking
🎯 Focus and attention span strengthen over time

Reading is arguably the highest-return habit you can build. My Reading Village is designed to make that habit effortless and genuinely rewarding. 🏡✨

Coming soon, free. What's one book that changed your thinking?

#brainhealth #readingbenefits #myreadingvillage

---

---

### Jun 25 · Wednesday — Reading Tip 🖼️ Image

**Template:** `reading_tip --lang en` · **Best time:** 11:00–13:00

---

#### 📱 Instagram Post

**Advice:** Sleep science angle — "brain processes what you read while you sleep" is a surprising and highly shareable fact.

**Caption:**

💡 **Reading tip of the week:**

*"Keep a book on your nightstand. The last 10 minutes before sleep belong to it — not your phone."* 🌙📖

Your brain processes what you read while you sleep. Wake up having absorbed it. That's not a metaphor — it's memory consolidation.

Replace the scroll. Read instead. Rest deeper. 🌸

My Reading Village turns that nightly ritual into something you'll actually look forward to. 🏡🐱 Coming soon, free!

#readingtip #nightroutine #sleepbetter #bookhabit #myreadingvillage #bedtimereading #mindfulness #nomorescrolling

---

#### 📱 Instagram Story

**Advice:** Add a poll: "Tonight: 📖 book vs 📱 scroll?"

**Caption:**

💡 Nightstand book > phone before sleep. 🌙📖
Your brain will process it while you dream. 🌸

---

#### 🎵 TikTok

**Caption:**

reading tip nobody sticks to but everyone should 🌙📖

keep a book on your nightstand

those last 10 minutes before sleep? they belong to the book, not the scroll

your brain processes it while you dream. you wake up having actually absorbed it

My Reading Village makes that ritual a reward 🏡🌸 coming soon free

#readingtok #nightroutine #booktok #myreadingvillage

---

#### 👥 Facebook Post

**Caption:**

A simple swap with a big payoff: replace your phone with a book in the last 10 minutes before sleep.

Your brain consolidates memories during sleep — meaning what you read right before bed gets processed and retained better than almost any other time of day. 🌙📖

My Reading Village turns that bedtime ritual into something genuinely rewarding. Coming soon, free!

#readingtip #sleepbetter #myreadingvillage

---

---

### Jun 26 · Thursday — What if Reading Was a Game? 🖼️ Image *(original content)*

**Template:** manual/canva · **Best time:** 19:00–21:00

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

#### 🎵 TikTok

**Advice:** "What if" with rhythm — reads well as voiceover. Short, punchy lines. Reveal = the app name.

**Caption:**

what if reading had actual rewards? 📚✨

finish a book → new villager moves in 🐱
read 10 pages → earn gems 💎
maintain your streak → unlock buildings 🏛️
read consistently → godly rarity characters 👑

this is My Reading Village

free mobile game. coming soon. no willpower required. just books 🏡🌸

#myreadingvillage #readinggame #gamification #cozygame

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

### Jun 27 · Friday — Villager Spotlight: Koala 🖼️ Image

**Template:** `villager_spotlight --villager koala --lang en` · **Best time:** 12:00–14:00

---

#### 📱 Instagram Post

**Advice:** Give Koala a fun, relatable personality angle: "nap + read = perfect day". "Team Koala?" drives lighthearted engagement.

**Caption:**

🐨💚 **Villager Spotlight: Koala**
Rarity: Common · The nap-and-read champion

Koala believes every great reading session deserves a great nap afterward. Science agrees. 😴📚🌿

Bring Koala home to your village in My Reading Village — just open a book and start reading. 🏡🌸 41 collectible villagers, free to play. Coming soon!

Which villager is your spirit animal? 👇

#villager spotlight #koalavillager #myreadingvillage #kawaii #readinggame #comingsoon

---

#### 📱 Instagram Story

**Advice:** Fun character energy. Poll: "Koala or Rabbit? 🐨🐰"

**Caption:**

🐨 Villager Spotlight: Koala
Nap champion. Bookworm. Yours to unlock. 📚🌿

---

#### 🎵 TikTok

**Caption:**

meet koala 🐨 the most relatable villager in My Reading Village 📚😴

read a book. take a nap. read another book. nap again.

koala gets it. koala lives it.

common rarity but elite energy 🌿🌸

coming soon free — who's getting koala first? 👇

#myreadingvillage #koalavillager #cozygame

---

#### 👥 Facebook Post

**Caption:**

Meet **Koala** 🐨 — proof that reading and napping are a perfect pair. Common rarity, maximum cozy energy. 📚🌿🌸

In My Reading Village, every book you read brings a new neighbor to your village. Koala is waiting patiently — probably mid-nap.

Coming soon FREE to Play Store. Are you Team Koala?

#myreadingvillage #villager spotlight

---

---

### Jun 28 · Saturday — Gameplay Showcase (ES) 📹 Video

**Template:** `gameplay_showcase --lang es` · **Best time:** 12:00–14:00

---

#### 📱 Instagram Reel

**Caption:**

🏡🌸 ¡Construye tu **Pueblo Lector**!

Bibliotecas, parques, escuelas y **41 aldeanos adorables** te esperan en My Reading Village. Lee libros → gana gemas → construye tu mundo. 📚✨

Entre más lees, más crece tu pueblo. ¡Próximamente GRATIS en Play Store!

#myreadingvillage #pueblolector #aldeanosadorables #juegomóvil #kawaii #hábitodelectura #próximamentedisponible

---

#### 📱 Instagram Story

**Caption:**

🏡 Lee libros. Construye un pueblo. Colecciona aldeanos. 📚
¡Próximamente GRATIS! 🌸

---

#### 🎵 TikTok

**Caption:**

¿qué tal si leer construyera literalmente un mundo? 🏡📚✨

eso es My Reading Village

lees → desbloqueas aldeanos → construyes edificios → tu pueblo crece

41 aldeanos. 5 rarezas. gratis.

¿cuántos libros leerías para desbloquearlos todos? 👇

#myreadingvillage #juegomóvil #leer

---

#### 👥 Facebook Reel

**Caption:**

¿Alguna vez quisiste que terminar un libro tuviera una recompensa real? 📚🌸

**My Reading Village** te la da: cada libro que lees desbloquea un nuevo aldeano y te da recursos para construir tu pueblo. Gratis, adorable y diseñado para que el hábito lector se quede contigo. 🏡✨

¡Próximamente en Play Store, completamente gratis! Síguenos para ser el primero en jugar.

#myreadingvillage #hábitodelectura

---

---

### Jun 29 · Sunday — Countdown Teaser: Lion 📹 Video

**Template:** `countdown_story --villager lion --lang en` · **Best time:** 18:00–20:00

---

#### 📱 Instagram Story

**Advice:** Use a slider sticker "How hyped are you for tomorrow's reveal? 🦁" to drive engagement.

**Caption:**

👑 Something legendary is coming to My Reading Village...
The king arrives tomorrow. 🌑🔥
Follow so you don't miss it! 🌸

---

#### 📱 Instagram Reel

**Caption:**

👑🌑 Only the bravest readers unlock this one.

A **Godly** rarity villager is coming to My Reading Village tomorrow. 🔥✨

The rarest of the rare. The crown of the collection.

Guess who reigns supreme? 👀 Follow — reveal drops Monday. 🌸

#myreadingvillage #comingsoon #godlyrarity

---

#### 🎵 TikTok

**Caption:**

the most powerful villager in My Reading Village arrives tomorrow 👑🌑

godly rarity.
only for the most dedicated readers.
you already know who this is. 🔥

guess in the comments → reveal tomorrow

#myreadingvillage #villagerreveal #godlyrarity

---

#### 👥 Facebook Story

**Caption:**

👑 Something legendary is coming to My Reading Village...
Reveal tomorrow. Who do you think it is? 🌑🔥 #myreadingvillage

---

---

### Jun 30 · Monday — Villager Reveal: Lion 📹 Video

**Template:** `villager_reveal_reel --villager lion --lang en` · **Best time:** 19:00–21:00

---

#### 📱 Instagram Reel

**Advice:** Month-end climax — make it feel like an event. "This is just the beginning" seeds curiosity for July content.

**Caption:**

👑🔥 **GODLY RARITY UNLOCKED.**

Meet **Lion** — the crown jewel of My Reading Village. 💜✨

This is not for casual readers. Lion belongs to the builders. The ones who show up every single day. The ones who finish what they start. 📚🏆

41 villagers. 5 rarity tiers. One legendary ending to the month.

My Reading Village launches soon — **completely FREE** on Play Store. This is just the beginning. Follow us and be first to play. 🌸👇

#lionvillager #godlyrarity #villagerreveal #myreadingvillage #readinggame #kawaii #comingsoon #mobilegame #launchingsoon

---

#### 📱 Instagram Story

**Caption:**

👑 Lion has arrived. Godly rarity. 💜
My Reading Village — coming soon FREE 🌸
Are you ready? 📚🔥

---

#### 🎵 TikTok

**Advice:** Grand finale energy. "This whole month was just the preview" closes the arc perfectly.

**Caption:**

the king has arrived 👑🦁

Lion — Godly rarity — the hardest villager to unlock in My Reading Village

only for readers who never miss a day 📚🔥

41 villagers. 5 rarity tiers. free to play.

this whole month was just the preview 🌸 the real thing comes soon

follow. subscribe. don't miss the launch.

#myreadingvillage #lionvillager #godlyrarity #readingtok

---

#### 👥 Facebook Reel

**Advice:** Recap the whole month journey — works as a closing statement for new followers who just discovered the page.

**Caption:**

All month, we've been introducing you to the residents of My Reading Village. And today, on the last day of June, we saved the best for last. 👑

Meet **Lion** — Godly rarity, the most powerful villager in the game. Reserved for players who build a true, consistent reading habit. 💜🦁📚

My Reading Village launches soon — completely free on Play Store. After everything you've seen this month, are you ready to build your village? 🏡🌸

Follow us — the launch is getting close!

#myreadingvillage #lionvillager #comingsoon

---

#### 📺 YouTube Shorts

**Advice:** "GODLY" in caps in the title drives clicks. "Coming Soon FREE" is the value proposition — include it.

**Title:** `Lion — GODLY Rarity Villain Reveal 👑 My Reading Village | Coming Soon FREE`

**Description:**

The king arrives. Meet Lion — a Godly rarity villager in My Reading Village! 👑✨

Lion is the hardest villager to unlock, reserved for the most dedicated readers. My Reading Village rewards every page you read with villagers, gems, and buildings for your cozy kawaii town.

41 collectible villagers · 5 rarity tiers · Free to play

Subscribe now — we're launching soon on Play Store. Don't miss it!

#myreadingvillage #lionvillager #godlyrarity #mobilegame #comingsoon

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
