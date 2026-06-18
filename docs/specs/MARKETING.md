# Social Media Launch Guide for My Reading Village

This guide walks you through registering My Reading Village's presence on Reddit, Facebook, Instagram, TikTok and YouTube, and publishing a first piece of content on each — with copy-paste-ready bios, captions, scripts and hashtags. Follow [PLAY_STORE.md](PLAY_STORE.md) for the Play Store side; this guide covers everything that drives people _toward_ that listing.

---

## PART 0 — Brand Assets & Voice (use these everywhere)

### Avatar / profile picture

Use `my_reading_village_icon_cropped.png` (`assets/images/logos/my_reading_village_icon_cropped.png`) as the profile picture on **every** platform. One consistent face builds recognition across feeds — never swap it per-platform.

### Cover / banner image

Generate a new landscape hero image from the **`marketing_banner_horizontal_1.png`** prompt that has been added to `assets/prompts/backgrounds.md` (under "Horizontal Marketing Banner Backgrounds"). It's composed at 2560×1440px with all the important content inside a centered 1546×423px safe area, so a single generated image can be cropped to fit:

- Facebook cover photo (≈ 820×312)
- X/Twitter header (1500×500)
- YouTube channel banner (2560×1440, safe area 1546×423)
- LinkedIn page banner (1128×191)
- The Play Store feature graphic (1024×500, see `PLAY_STORE.md` Step 3.2)

Generate it once, crop per platform, and you have a cohesive cross-platform look with a single piece of art.

### Handle / username

Use the same handle everywhere so people can find you by guessing:

- Primary: `@MyReadingVillage`
- Fallbacks if taken: `@MyReadingVillageGame`, `@PlayMyReadingVillage`

Check availability on each platform during sign-up (Step 1 of each section below) before committing — claim the same one across all five so cross-links always resolve.

### Brand voice

Match the warmth already present in the app's own onboarding (`tour_*` strings in `assets/messages/*/[locale].json`): soft, encouraging, a little playful, never aggressive "BUY NOW" sales language. Kawaii is the differentiator in a crowded mobile-game space — lean into gentle, inviting copy everywhere, including replies to comments.

### Core elevator pitch (reuse as the seed for every bio/caption)

> Turn every page you read into a cozy village full of adorable animal friends.

Notice the shape of that sentence: reading isn't listed as just one feature alongside "build a village" and "collect friends" — it's the engine that drives both of them. That's the whole point of the game and the business behind it: every other system (resources, buildings, villagers, events, missions) exists to give your reading habit somewhere to go. Keep that cause-and-effect framing ("every page you read becomes...") in any rewording, rather than a flat feature list — it's what makes the pitch land as "a reading habit that turns into a whole world" instead of "three separate things you can do."

This is the same promise that anchors the Play Store short descriptions in `PLAY_STORE.md` — repeating it verbatim across channels (in each platform's native language of communication) reinforces the same mental "hook" everywhere a potential player encounters the brand.

### Why this guide is written in English

Reddit, TikTok, YouTube and the broad indie-game/cozy-game discovery audiences on Facebook and Instagram primarily discover and discuss games in English, regardless of the poster's home market — that's where the organic reach is for a solo launch. Once the Play Console **Acquisition reports** (available after launch) show which language markets are actually converting, mirror the highest-performing posts in that language using the matching copy from `PLAY_STORE.md` as your translation seed (it already carries the right tone and keywords per language).

---

## PART 1 — Reddit

### Step 1.1 — Create the account

1. Go to https://www.reddit.com/register
2. Pick a username that signals the brand, e.g. `u/MyReadingVillageDev` (personal-feeling dev accounts perform far better on Reddit than faceless brand accounts — Reddit's culture rewards "a real person made this").
3. Verify your email (required to post in most communities).
4. Open **Settings > Profile**, set:
   - **Avatar**: `my_reading_village_icon_cropped.png`
   - **Banner**: `marketing_banner_horizontal_1.png` (cropped to Reddit's banner ratio)
   - **Display name**: My Reading Village

### Step 1.2 — Bio (≈180/200 chars)

```
Solo dev behind My Reading Village 🌸 — a cozy mobile game that turns your reading habit into a cute village full of adorable animal friends. Sharing devlogs, art and polls here!
```

### Step 1.3 — Build standing before you post

Reddit punishes cold self-promotion hard (instant bans, shadow-removed posts). Before posting anything promotional:

1. Spend 1–2 weeks genuinely commenting and upvoting in your target communities (below) — Reddit's culture rewards participants, not drive-by marketers.
2. Read each subreddit's rules/sidebar — most restrict self-promo to specific threads or days (e.g. "Self-Promo Saturday") or require a "Developer" flair.
3. Only then post — and lead with value/conversation, not a pitch.

### Step 1.4 — Target communities

- **r/CozyGamers** — exactly the audience that resonates with "cozy village builder," highest-affinity community
- **r/IndieGaming** — broad indie audience, screenshots/gifs welcome with genuine context
- **r/AndroidGaming** — indie showcases allowed, usually with a "Developer" flair and a video/gif
- **r/playmygame** — built specifically for indie devs to share work-in-progress or launched games for feedback
- **r/FlutterDev** — the technical/dev community; perfect for a _devlog_ angle ("I built a village-builder game in Flutter") rather than a player pitch

### Step 1.5 — First publication: a native poll (not a pitch)

Reddit rewards posts that start a conversation. Post this as a **native Reddit poll** in r/CozyGamers (or r/IndieGaming once you have standing there):

**Poll title**

```
Cozy gamers — what would actually get you to read more books?
```

**Poll options**

```
A pet/companion that grows happier the more I read 🐾
A village/town that visibly grows as I make progress 🏘️
Mini book-trivia games for bonus rewards 🎮
Daily streaks & surprise rewards 🎰
```

**Post body**

```
I've been building My Reading Village solo with Flutter — a game where every page you log grows a tiny cozy village and unlocks adorable animal villagers (cats, capybaras, red pandas... over 30 species so far). 🌸📚

Genuinely curious what would pull YOU into reading more — trying to make sure I'm building the right thing before launch. Screenshot in the comments if anyone's curious what it looks like!
```

### Step 1.6 — Follow-up devlog post (for r/FlutterDev)

```
Title: I turned "read more books" into a village-builder game with Flutter + SQLite — here's how the reading-to-resources loop works

Body: short technical walkthrough of the core loop (log a reading session → pages convert to coins/gems/wood/metal → spend them on buildings/villagers), one or two architecture notes, and the marketing_banner_horizontal_1 artwork as the header image. Close with the Play Store link once live.
```

---

## PART 2 — Facebook

### Step 2.1 — Create the Page

1. Go to https://www.facebook.com/pages/create
2. Choose **Page** (not a personal profile — Pages unlock analytics, ads and a public bio).
3. Page name: `My Reading Village`
4. Category: search for and select **Game** (or **App Page** / **Video Game** depending on what Meta surfaces).
5. Set:
   - **Profile picture**: `my_reading_village_icon_cropped.png` (square crop)
   - **Cover photo**: `marketing_banner_horizontal_1.png` (cropped to ≈ 820×312)
   - **Username/handle**: `@MyReadingVillage` (Page Settings > Username)
6. Fill in **Page bio** (short) and **About > Description** (long) — see below.
7. Add the Play Store link under **Contact and basic info** once the listing is live.

### Step 2.2 — Short bio (≈165 chars, shown under the Page name)

```
🌸 My Reading Village — the cozy mobile game where every page you read grows your own cute village and welcomes home a new animal villager. Free to play! 📚🏘️🐾
```

### Step 2.3 — Long "About > Description"

```
My Reading Village is a cozy mobile game that turns your reading habit into real progress: log every page, earn resources, build a charming little village, and collect dozens of adorable animal villagers — from common critters to legendary and godly rarities.

Perfect for book lovers, parents raising young readers, and anyone who wants a relaxing village-builder with a literary heart. Free to play, available in English, Spanish, Portuguese, French and Italian. 🌸📚🐾
```

### Step 2.4 — First publication: launch-teaser image post

Post the `marketing_banner_horizontal_1.png` artwork with this caption:

```
🌸 Hello, fellow readers! 🌸

We're building something we think you'll love: My Reading Village — a cozy mobile game where every page you read grows your own cute village and welcomes a brand-new adorable animal villager. 📚🏘️🐾

Log your books, build and upgrade your town, collect dozens of villager species, play literary mini-games, and spin the daily lucky wheel — all while growing a reading habit that actually sticks.

Follow this page for sneak peeks, devlogs and the launch announcement — we can't wait to show you around. 🐾📖

#CozyGames #IndieGameDev #MobileGames #VillageBuilder #BookLovers #KawaiiGame
```

### Step 2.5 — Engagement follow-up (emoji "poll" via comments)

Native polls require a Group, so on a Page the highest-engagement equivalent is a comment-vote post:

```
Which animal friend would you want to welcome to your village first? 🐱 = Cat · 🐶 = Dog · 🐰 = Rabbit — drop your pick in the comments below! 🌸
```

---

## PART 3 — Instagram

### Step 3.1 — Create the account

1. Sign up at https://www.instagram.com or in the app.
2. Open **Settings > Account type and tools > Switch to professional account**, choose **Creator** or **Business** (this unlocks Insights/analytics, vital for tracking what drives installs).
3. Username: `myreadingvillage` (fallbacks: `myreadingvillage.game`, `play.myreadingvillage`).
4. Set:
   - **Profile photo**: `my_reading_village_icon_cropped.png`
   - **Bio**: see below
   - **Link**: the Play Store listing once live (or a Linktree if you need more than one link later)
5. Pre-create empty **Story Highlight** categories for later: "Gameplay", "Villagers", "Devlog", "Events" — gives new visitors instant context.

### Step 3.2 — Bio (130/150 chars)

```
🌸 A cozy mobile game where every page you read grows your own cute village and welcomes home adorable animal villagers 🏘️🐾📚
```

### Step 3.3 — First publication: launch carousel

Post a 4-slide carousel: slide 1 = `marketing_banner_horizontal_1.png` (the hook), slides 2–4 = in-game screenshots (village view, species collection, a minigame).

```
🌸 Welcome to My Reading Village — where every page you read helps grow your own cozy town! 📚🏘️

Log your reading sessions, earn coins, gems, wood and metal, build and upgrade homes, parks, schools and more, and welcome dozens of adorable animal villagers — from common critters all the way to legendary and godly rarities. 🐾✨

Swipe through for a peek inside, and follow along as we get ready to launch on Google Play! 🌍📖
.
.
.
#cozygames #indiegame #mobilegame #villagebuilder #kawaii #bookstagram #booklovers #readingapp #cozygaming #indiegamedev #mobilegaming #flutterdev #petgame #collectiongame
```

_(the trailing dots are intentional — they push the hashtag block below the "...more" fold so the caption itself reads clean)_

### Step 3.4 — Reels concept (for reach beyond followers)

A 15–20s vertical screen-recording set to a trending cozy/lo-fi audio:

1. Tap to log a reading session
2. Coins/gems/wood/metal fly into the resource bar
3. Place or upgrade a building — village visibly grows
4. A brand-new animal villager reveal (pick a rare/legendary one for the biggest "wow")

Caption: `POV: reading finally feels like a game 🌸📚 #booktok #cozygames #mobilegaming`

---

## PART 4 — TikTok

### Step 4.1 — Create the account

1. Download the app or go to https://www.tiktok.com/signup
2. Open **Settings and privacy > Manage account > Switch to Business Account** — unlocks analytics and the bio link.
3. Username: `myreadingvillage`
4. Set:
   - **Profile photo**: `my_reading_village_icon_cropped.png`
   - **Bio**: see below
   - **Website link**: Play Store listing once live

### Step 4.2 — Bio (67/80 chars)

```
🌸 Turn your reading into a cozy village game 🐾📚 One page at a time.
```

### Step 4.3 — First publication: hook-first short video

TikTok rewards a hook in the first 1–2 seconds, screen-recorded gameplay, on-screen captions, and a trending sound. Suggested 20–25s storyboard:

| Time      | On screen                                                                                              |
| --------- | ------------------------------------------------------------------------------------------------------ |
| 0:00–0:02 | Bold caption overlay: **"I found an app that rewards every page you read... with a whole village 👀"** |
| 0:02–0:08 | Screen-recording: log a reading session → watch coins/gems/resources fly in                            |
| 0:08–0:15 | Screen-recording: place/upgrade a building, village visibly growing                                    |
| 0:15–0:22 | Screen-recording: a brand-new animal villager unlocks — the emotional payoff moment                    |
| 0:22–0:25 | End card: app icon + **"My Reading Village — coming to Google Play 🌸"**                               |

**Caption**

```
POV: you found an app that turns reading into the cutest village game 🌸📚🐾 #booktok #cozygames
```

**Audio**: pick a "cozy", "cute" or "lofi"-tagged track from TikTok's Commercial Music Library (Business accounts must use commercially-licensed sounds).

**Hashtags**

```
#booktok #cozygames #cozygaming #mobilegames #indiegame #villagebuilder #kawaii #bookrecommendations #readingmotivation #petgame
```

---

## PART 5 — YouTube

### Step 5.1 — Create the channel

1. Sign in at https://www.youtube.com with a Google account dedicated to the brand (recommended over your personal account, for clean ownership/analytics).
2. **Settings > Create a channel**, name it `My Reading Village`.
3. **Customization > Branding**:
   - **Picture**: `my_reading_village_icon_cropped.png`
   - **Banner**: `marketing_banner_horizontal_1.png` — its 2560×1440 canvas with a 1546×423 safe area was generated to match YouTube's exact banner spec, so it needs no extra cropping here.
   - **Handle**: `@MyReadingVillage`
4. **Customization > Basic info**: paste the description and keywords below, add links to the Play Store listing and other socials.
5. **Customization > Layout**: set a **Channel trailer** for people who haven't subscribed yet — this is the single highest-leverage piece of real estate on a new channel.

### Step 5.2 — Channel description

```
My Reading Village is a cozy mobile game that turns your reading habit into a charming village-builder adventure — log your books, grow your resources, build your town, and collect dozens of adorable animal villagers.

This channel follows the journey from indie project to Google Play launch: gameplay previews, devlogs, villager spotlights, and reading tips inspired by the game itself. New videos regularly — subscribe to follow along! 🌸📚🐾
```

### Step 5.3 — Channel keywords (paste comma-separated into Basic info > Keywords)

```
cozy games, village builder, reading app, book tracker, mobile game, indie game, kawaii game, animal collector game, casual game, flutter game, reading habit, devlog
```

### Step 5.4 — First publication: channel trailer (60–90s)

**Title**

```
My Reading Village — Official Trailer | Read. Build. Collect. 🌸
```

**Description**

```
Every page you read grows your own cozy village! 🌸📚

My Reading Village turns your reading habit into a relaxing village-builder game: log your reading sessions to earn resources, build and upgrade your town, collect dozens of adorable animal villagers across five rarity tiers, play literary mini-games, spin the daily lucky wheel, and join seasonal events all year round.

📲 Coming soon to Google Play
🌍 Available in English, Spanish, Portuguese, French and Italian

#CozyGames #VillageBuilder #MobileGame #IndieGame #BookTok
```

**Tags**

```
my reading village, cozy game, village builder game, reading app, book tracker app, mobile game trailer, indie game, kawaii game, animal collector
```

**Storyboard outline**
| Time | Beat |
|---|---|
| 0:00–0:05 | Logo reveal + tagline: "Every page grows your village" |
| 0:05–0:20 | Reading tracker → resources flying in → quick village-building montage |
| 0:20–0:40 | Villager collection showcase — a rarity-reveal moment from common up to godly |
| 0:40–0:55 | Fast montage: minigames, lucky wheel spin, seasonal event badge, mission confetti |
| 0:55–1:10 | Wide pastel village panorama — use `marketing_banner_horizontal_1.png` as the closing hero shot |
| 1:10–1:20 | End card: app icon, "Coming soon to Google Play", language flags |

---

## PART 6 — Cadence & Cross-Platform Growth Notes

- **Start at 2–3 posts per week per platform.** That's sustainable for a solo dev and is enough for platform algorithms to start learning your audience. Increase once a rhythm feels natural — consistency beats burst-and-disappear every time.
- **Reuse core assets, rewrite the wrapper.** The same banner, screenshots and trailer clips can be cross-posted everywhere — but the _caption tone_ should shift per platform: Reddit rewards transparent/conversational, Instagram and Facebook reward warm/visual storytelling, TikTok rewards punchy hook-first energy, YouTube rewards informative narrative.
- **Always lead with value, not the pitch.** The Reddit poll, the Instagram "peek inside," the TikTok "I found an app that..." — all of these let the audience discover the product through curiosity rather than being told to buy it. This matches the soft, kawaii brand voice and avoids the "spam" reflex that tanks reach on every one of these platforms.
- **Once the app is live, watch Play Console's Acquisition reports** (Grow > Acquisition) to see which referral source and which language market actually converts to installs — then double down on that platform/language combo, mirroring the matching localized copy from `PLAY_STORE.md`.
- **Engage before and after posting.** Replying warmly to every comment in the brand voice (and genuinely participating in target communities, not just posting) is what turns casual viewers into a community — and it's free.

---

## Quick Reference Checklist

- [x] Generate `marketing_banner_horizontal_1.png` from the new prompt in `assets/prompts/backgrounds.md`
- [ ] Reddit: create account, set avatar/banner/bio, build standing in target subs, post the launch poll
- [ ] Facebook: create Page, set assets/bios, publish the launch image post
- [ ] Instagram: switch to a Professional account, set assets/bio, publish the launch carousel
- [ ] TikTok: switch to a Business account, set assets/bio, publish the first hook video
- [ ] YouTube: create channel, set branding/description/keywords, publish the channel trailer
- [ ] Cross-link every profile to each other and to the Play Store listing once it's live
- [ ] Track Play Console Acquisition reports post-launch and double down on what converts
