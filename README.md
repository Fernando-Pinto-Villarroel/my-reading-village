<div align="center">

  <img src="my_reading_village/assets/images/logos/my_reading_village_icon_rounded.png" alt="My Reading Village" width="220" />

  <br>

# My Reading Village

**A mobile village-building game that turns real-world reading into dopamine-driven gameplay — built with Flutter and Flame Engine.**

  <br>

![Flutter](https://img.shields.io/badge/Flutter-3.5-02569B?style=flat-square&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-3.5-0175C2?style=flat-square&logo=dart&logoColor=white)
![Flame](https://img.shields.io/badge/Flame-1.21-FF6D00?style=flat-square&logo=firebase&logoColor=white)
![SQLite](https://img.shields.io/badge/SQLite-Local_DB-003B57?style=flat-square&logo=sqlite&logoColor=white)
![Firebase](https://img.shields.io/badge/Firebase-Analytics-FFCA28?style=flat-square&logo=firebase&logoColor=black)
![Provider](https://img.shields.io/badge/Provider-6.1-6C63FF?style=flat-square)
![Unity Ads](https://img.shields.io/badge/Unity_Ads-Rewarded_Ads-000000?style=flat-square&logo=unity&logoColor=white)
![IAP](https://img.shields.io/badge/IAP-Google_Play-34A853?style=flat-square&logo=googleplay&logoColor=white)
![Privacy](https://img.shields.io/badge/Data-Device--Only-64748B?style=flat-square&logo=lock&logoColor=white)
![Platform](https://img.shields.io/badge/Platform-Android-3DDC84?style=flat-square&logo=android&logoColor=white)
![License](https://img.shields.io/badge/License-Community_v1.0-blue?style=flat-square)

</div>

---

## Table of Contents

- [Overview](#overview)
- [Why I Built This](#why-i-built-this)
- [Features](#features)
- [Core Gameplay Loop](#core-gameplay-loop)
- [Seasonal Events](#seasonal-events)
- [Business Model & ROI](#business-model--roi)
- [Tech Stack](#tech-stack)
- [Architecture](#architecture)
- [Subprojects](#subprojects)
- [Project Structure](#project-structure)
- [Database Schema](#database-schema)
- [Firebase Analytics](#firebase-analytics)
- [Security Features](#security-features)
- [Asset Pipeline](#asset-pipeline)
- [Getting Started](#getting-started)
- [Building for Android](#building-for-android)
- [Troubleshooting](#troubleshooting)
- [License](#license)

---

## Overview

**My Reading Village** is a privacy-first mobile game that rewards real-world reading with in-game village-building progression. Log the pages you read, earn coins, gems, wood, and metal, then use those resources to construct and upgrade buildings in a charming 2D isometric village populated by 41 unique kawaii animal villagers.

The game replicates the dopamine reward loops found in addictive mobile games — but redirects them toward building a healthy reading habit. All gameplay data stays exclusively on your device: no accounts, no cloud sync, no tracking. Analytics are opt-in and anonymous.

---

## Why I Built This

Most people struggle to replace addictive digital habits (social media scrolling, mobile games) with positive ones like reading. The reason is simple: those apps are carefully engineered to exploit dopamine feedback loops, and a book can't compete on that front alone.

This app bridges that gap:

- _Log pages you've read and instantly receive satisfying rewards._
- _Build a village that grows with every reading session._
- _Watch cute animal villagers move in, express happiness, and thrive._
- _Seasonal events and mission chains keep engagement fresh year-round._
- _Keep everything offline — no sign-ups, no subscriptions, no data leaving your phone._

The goal is to make reading **feel as rewarding as playing a mobile game**, creating a positive habit loop that gradually replaces screen-time addictions.

---

## Features

<table>
  <thead>
    <tr>
      <th>Feature</th>
      <th>Description</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><strong>Reading tracker</strong></td>
      <td>Add books with title, author, and total pages — log reading sessions with optional time tracking and progress toward completion</td>
    </tr>
    <tr>
      <td><strong>Book search</strong></td>
      <td>Search for books via external API with auto-fill for title, author, cover image, and page count</td>
    </tr>
    <tr>
      <td><strong>Resource rewards</strong></td>
      <td>Earn coins, gems, wood, and metal per page read — bonus rewards for completing books, with per-book reward caps</td>
    </tr>
    <tr>
      <td><strong>Tags system</strong></td>
      <td>Organize books with custom color-coded tags for filtering and personal organization</td>
    </tr>
    <tr>
      <td><strong>Reading calendar</strong></td>
      <td>Visual monthly calendar showing reading history, session details, and a dedicated current-event month tab</td>
    </tr>
    <tr>
      <td><strong>Isometric village builder</strong></td>
      <td>Place and upgrade buildings on a 2D isometric tile grid rendered in real-time by the Flame Engine</td>
    </tr>
    <tr>
      <td><strong>8 building types</strong></td>
      <td>Houses, Water Plants, Power Stations, Schools, Restaurants, Parks, Libraries, and Hospitals — each with 3 upgrade levels</td>
    </tr>
    <tr>
      <td><strong>13 decorations</strong></td>
      <td>Purchasable cosmetic decorations (fountains, arches, monuments, benches, trees, etc.) placed freely on the map</td>
    </tr>
    <tr>
      <td><strong>Construction system</strong></td>
      <td>Buildings require real time to construct and upgrade — spend gems to speed up or watch a rewarded ad to skip 10 minutes</td>
    </tr>
    <tr>
      <td><strong>41 villager species</strong></td>
      <td>Common, Rare, Extraordinary, Legendary, and Godly species — unlock through leveling, IAP, lucky wheel, species bonus, or secret codes</td>
    </tr>
    <tr>
      <td><strong>Villager happiness mechanics</strong></td>
      <td>Villagers need water, power, schooling, dining, healthcare, and park access — gaps in coverage reduce happiness</td>
    </tr>
    <tr>
      <td><strong>Player leveling</strong></td>
      <td>Earn XP from reading, building, upgrading, and missions — higher levels unlock more buildings, species, and village slots</td>
    </tr>
    <tr>
      <td><strong>Mission system</strong></td>
      <td>Multi-branch sequential quest chains — reading missions, building missions, villager missions, and seasonal event branches</td>
    </tr>
    <tr>
      <td><strong>13 seasonal events</strong></td>
      <td>Calendar-driven holiday branches active throughout the year, each with unique missions, decoration rewards, and villager chain unlocks</td>
    </tr>
    <tr>
      <td><strong>Map expansion</strong></td>
      <td>Expand village territory chunk by chunk, with costs scaling progressively as the settlement grows</td>
    </tr>
    <tr>
      <td><strong>Lucky wheel (roulette)</strong></td>
      <td>Spend coins or earn free spins via rewarded ads — win gems, resources, XP, or rare species unlocks</td>
    </tr>
    <tr>
      <td><strong>Minigames</strong></td>
      <td>Book-or-Not, First-or-Last-Line, Guess-the-Author, and Match-Character-Role — trivia games with cooldowns and rewards</td>
    </tr>
    <tr>
      <td><strong>Consumable items</strong></td>
      <td>Backpack with four item types: Book (double XP), Sandwich (villager happiness +50), Glasses (double pages reward), Hammer (speed up construction)</td>
    </tr>
    <tr>
      <td><strong>Active power-ups</strong></td>
      <td>Time-limited buffs applied to villagers or the global session, tracked in the database</td>
    </tr>
    <tr>
      <td><strong>Secret codes</strong></td>
      <td>Redeemable promotional codes that grant gems, items, or species — each code one-time use per device</td>
    </tr>
    <tr>
      <td><strong>In-app store</strong></td>
      <td>4-tab store (Gems, Items, Species, Packs) — IAP via Google Play Billing, with daily ad-based free gem earning</td>
    </tr>
    <tr>
      <td><strong>Audio system</strong></td>
      <td>Background music and sound effects with independent volume sliders — persisted per device</td>
    </tr>
    <tr>
      <td><strong>Notifications</strong></td>
      <td>Local push notifications for construction completion, event start/end, and reading reminders</td>
    </tr>
    <tr>
      <td><strong>Village photo</strong></td>
      <td>Capture and share a screenshot of your village, saved directly to the device gallery</td>
    </tr>
    <tr>
      <td><strong>Backup & restore</strong></td>
      <td>Export and import the full game state as a file — full local backup without cloud dependency, protected against malicious imports</td>
    </tr>
    <tr>
      <td><strong>Stats dashboard</strong></td>
      <td>Track village level, XP, total pages, books completed, building counts, happiness scores, and resource history — with fl_chart visualizations</td>
    </tr>
    <tr>
      <td><strong>Firebase Analytics</strong></td>
      <td>Opt-in anonymous analytics with consent modal after onboarding — toggle in Settings → Data; 27+ custom events and 8 user properties tracked</td>
    </tr>
    <tr>
      <td><strong>Security protections</strong></td>
      <td>Backup import sanitization strips paid species to prevent IAP bypassing; device clock-tamper detection warns when the system date appears manipulated</td>
    </tr>
    <tr>
      <td><strong>5 languages</strong></td>
      <td>Fully localized in English, Spanish, Portuguese, French, and Italian — runtime language switching</td>
    </tr>
    <tr>
      <td><strong>Kawaii art style</strong></td>
      <td>Pastel palette with hand-finished animal sprites and building artwork — AI-assisted asset pipeline with custom Python tools</td>
    </tr>
    <tr>
      <td><strong>Privacy by design</strong></td>
      <td>Core gameplay requires no internet — all progress lives on-device in a local SQLite database. Network is used only for optional book search (Open Library API), in-app purchases, rewarded ads, and opt-in analytics; books can always be added manually without a connection</td>
    </tr>
  </tbody>
</table>

---

## Core Gameplay Loop

```
Read real pages
      ↓
Log pages in app → earn coins, gems, wood, metal
      ↓
Build & upgrade village buildings
      ↓
Villagers move in, happiness grows
      ↓
Complete mission chains → earn XP and rewards
      ↓
Level up → unlock new building types and species slots
      ↓
Seasonal events activate → limited-time missions and decorations
      ↓
Read more
```

This loop mirrors the dopamine patterns of top-grossing mobile games — triggered by real-world reading instead of in-game grind.

---

## Seasonal Events

13 time-gated holiday branches activate automatically based on the system date. Each event unlocks a 3-mission branch:

- **M1** — Enter the app during the event window
- **M2** — Read a target number of pages (event-specific)
- **M3** — Place a specific decoration to complete the branch

Completing M3 grants bonus XP and unlocks a guaranteed villager species chain unique to that event.

| Event           | Window        | Pages (M2) | M2 Reward      | M3 Decoration            | M3 XP | Villager Chain                 |
| --------------- | ------------- | ---------- | -------------- | ------------------------ | ----- | ------------------------------ |
| New Year        | Jan 1–15      | 300        | 40 XP + 3 gems | Celebration Arch         | 70 XP | Lion → Tiger → random          |
| Valentine's Day | Feb 1–14      | 200        | 40 XP + 3 gems | Reading Bench            | 60 XP | Otter → random                 |
| Carnival        | Feb 15–Mar 15 | 500        | 40 XP + 5 gems | Water Fountain           | 80 XP | Zebra → random                 |
| Easter          | Apr 1–30      | 400        | 40 XP + 5 gems | 5 happy rabbit villagers | 70 XP | Monkey → random                |
| Workers' Day    | May 1–15      | 250        | 40 XP + 3 gems | Gear Monument            | 70 XP | Bull → random                  |
| Environment Day | Jun 1–15      | 250        | 40 XP + 3 gems | Flower Garden            | 75 XP | Red Panda → random             |
| Chocolate Day   | Jul 1–10      | 150        | 30 XP + 2 gems | Chocolate Fountain       | 60 XP | Capybara → random              |
| Friendship Day  | Jul 20–31     | 200        | 40 XP + 3 gems | Friendship Arch          | 70 XP | Horse → random                 |
| Youth Day       | Aug 1–15      | 250        | 40 XP + 3 gems | Wishing Well             | 70 XP | Kangaroo → random              |
| Literacy Day    | Sep 1–30      | 500        | 50 XP + 5 gems | Book Stack Monument      | 90 XP | Fox → random                   |
| Halloween       | Oct 1–31      | 500        | 40 XP + 5 gems | Lamp Post                | 60 XP | Bat → random                   |
| Thanksgiving    | Nov 1–30      | 500        | 40 XP + 5 gems | Cat Statue               | 70 XP | Turkey → Cow → random          |
| Christmas       | Dec 1–31      | 500        | 50 XP + 5 gems | Christmas Tree           | 80 XP | Polar Bear → Reindeer → random |

Event mission progress counters are baseline-snapshotted at activation, so only pages read _during_ the event count toward M2.

---

## Business Model & ROI

My Reading Village is free-to-play with optional in-app purchases. No paywalls block core gameplay — all progression is achievable without spending.

### Revenue Streams

**1. In-App Purchases (Google Play Billing)**

| Category                         | Products                 | Price Range  |
| -------------------------------- | ------------------------ | ------------ |
| Gem Packs (consumable)           | 6 tiers (50–2000 gems)   | $0.99–$29.99 |
| Item Packs (consumable)          | 5 bundles (Starter–Mega) | $1.99–$19.99 |
| Species Unlocks (non-consumable) | 31 paid species          | $1.99–$13.99 |

**2. Unity Ads Rewarded Ads (3 placements)**

| Placement         | Mechanic                                                |
| ----------------- | ------------------------------------------------------- |
| Construction skip | Watch ad → reduce build time by 10 minutes (unlimited)  |
| Lucky wheel       | Watch 3 ads → earn 1 free spin (max 3 ad-spins per day) |
| Free gems         | Watch 3 ads → receive 5 gems (once per day)             |

Ads are always optional and user-initiated — no interruptions to gameplay.

### Retention Mechanics

- 13 seasonal events throughout the year drive re-engagement spikes
- Multi-branch mission chains provide always-available progression goals
- 41 collectible species create long-term collection motivation
- Habit loop tied to real reading creates daily active use patterns

### Revenue Projections (Lean Estimate)

| Stage               | MAU  | Monthly IAP | Monthly Ads | Total Est.     |
| ------------------- | ---- | ----------- | ----------- | -------------- |
| Early (soft launch) | 1K   | $60–$120    | $60–$90     | ~$150–$210     |
| Growth              | 10K  | $800–$1,500 | $400–$800   | ~$1,200–$2,300 |
| Scale               | 100K | $10K–$20K   | $5K–$12K    | ~$15K–$32K     |

_Assumptions: 2–4% monthly IAP conversion, $3–$5 avg purchase, rewarded ad eCPM $8–$12. Projections are illustrative, not guaranteed._

### Unit Economics

- Development cost: personal project (zero external team cost)
- Distribution fee: $25 Google Play one-time registration
- Platform cut: 15% on first $1M revenue (Google Play reduced fee), 30% above
- No server infrastructure cost (all data is local)
- Marginal cost per additional user: effectively $0

---

## Tech Stack

| Category             | Technology                                          | Version           |
| -------------------- | --------------------------------------------------- | ----------------- |
| Framework            | Flutter                                             | ^3.5              |
| Language             | Dart                                                | ^3.5              |
| Game Engine          | Flame                                               | ^1.21.0           |
| State Management     | Provider                                            | ^6.1.2            |
| Dependency Injection | get_it                                              | ^9.2.1            |
| Database             | sqflite (SQLite)                                    | ^2.3.3+2          |
| Localization         | flutter_localizations + intl                        | ^0.20.2           |
| Animations           | confetti                                            | ^0.8.0            |
| Audio                | audioplayers                                        | ^6.1.0            |
| Notifications        | flutter_local_notifications                         | ^21.0.0           |
| Monetization         | in_app_purchase + unity_ads_plugin                  | ^3.2.0 / ^0.3.30  |
| Analytics            | firebase_core + firebase_analytics                  | ^3.6.0 / ^11.3.3  |
| Encryption           | encrypt                                             | ^5.0.3            |
| Charts               | fl_chart                                            | ^0.69.0           |
| Book Search          | http                                                | ^1.2.2            |
| Image Picker         | image_picker                                        | ^1.1.2            |
| File I/O (backup)    | file_picker + path_provider                         | ^10.3.10 / ^2.1.5 |
| Gallery Save         | gal                                                 | ^2.3.0            |
| Sharing              | share_plus                                          | ^12.0.1           |
| URL Launching        | url_launcher                                        | ^6.3.0            |
| Icons                | font_awesome_flutter                                | ^10.7.0           |
| Art Pipeline         | AI-generated sprites (Gemini + custom Python tools) | —                 |

---

## Architecture

The project follows **Hexagonal (Ports & Adapters) + Clean Architecture**. The dependency rule flows strictly inward: Infrastructure → Adapters → Application → Domain.

```
lib/
  main.dart                              # Composition root (DI + app entry)

  domain/                                # Pure Dart — no Flutter imports
    entities/       (11 files)           # Book, Tag, Villager, PlacedBuilding, Mission, etc.
    ports/          (5 files)            # Abstract interfaces (repositories, search, image)
    rules/          (8 files)            # VillageRules, SpeciesRules, HolidayRules, ReadingRules,
                                         #   StoreRules, RouletteRules, MinigameRules, SecretCodesRules

  application/                           # Use case services — pure Dart, no Flutter
    services/       (12 files)           # Building, Villager, Reading, Inventory, Mission,
                                         #   Player, Tag, Store, Ad, Audio, Backup, Notification

  adapters/                              # Implements domain ports — bridges app ↔ infrastructure
    providers/      (3 files)            # VillageProvider, BookProvider, TagProvider (ChangeNotifiers)
    repositories/   (4 files)            # SqliteBookRepo, SqliteVillageRepo, SqliteInventoryRepo,
                                         #   VillagerFavorites
    services/       (2 files)            # BookSearchAdapter, ImageServiceAdapter

  infrastructure/                        # Flutter UI, SQLite schema, platform integrations
    di/
      service_locator.dart               # get_it wiring
    persistence/    (6 files)            # DatabaseHelper + 5 partitioned operation files
                                         #   (books, buildings, game_state, inventory, backup)
    ui/
      config/       (2 files)            # AppTheme (colors), UiConstants (layout values)
      localization/ (2 files)            # LanguageProvider, context extension
      game/         (5 files)            # Flame VillageGame + BuildingComponent, VillagerComponent,
                                         #   GridComponent, ExpansionSignComponent
      screens/      (7 files)            # GameScreen, SplashScreen, minigame screens
      widgets/
        common/     (16 files)           # Reusable widgets (cards, filters, selectors, HUD utils)
        dialogs/    (21 files)           # All modal/dialog widgets (store, missions, roulette, etc.)
        sheets/     (3 files)            # Bottom sheet widgets
        popups/     (3 files)            # Overlay popups (level-up, reward, minigame win)
        hud/        (4 files)            # In-game HUD (resources, constructor counter, side menu)
        tour/       (1 file)             # Onboarding tour overlay
```

**Dependency rule summary:**

- `domain/` → nothing (pure Dart, zero external dependencies)
- `application/` → `domain/` only
- `adapters/` → `domain/` + `application/`
- `infrastructure/` → all layers (UI consumes providers, persistence implements repositories)

---

## Subprojects

This monorepo contains three standalone subprojects alongside the Flutter app.

### `my_reading_village_marketing/` — Social Media Content Generator

A Python toolkit that generates ready-to-post social media content (Instagram/Facebook/TikTok stories and reels) using the game's own assets, brand palette, and villager data.

```bash
cd my_reading_village_marketing
python3 -m venv .venv && .venv/bin/pip install -r requirements.txt

# Generate a vertical video story (9:16)
.venv/bin/python3 scripts/generate.py --template reading_benefits_story --lang en
.venv/bin/python3 scripts/generate.py --template villager_reveal_reel --villager cat --lang en
.venv/bin/python3 scripts/generate.py --template gameplay_showcase --lang en

# Generate a static image post (1080×1920 PNG)
.venv/bin/python3 scripts/generate.py --template villager_spotlight --villager fox --lang en
.venv/bin/python3 scripts/generate.py --template feature_highlight --lang es
```

> Requires **FFmpeg** on the system path for video encoding: `sudo apt install ffmpeg`

Templates live in `templates/image/` and `templates/video/`. Generated output goes to `output/` (git-ignored). See [`my_reading_village_marketing/README.md`](my_reading_village_marketing/README.md) for the full template catalog and options.

### `my_reading_village_website/` — Marketing Website

A standalone marketing website deployed on **Netlify**. Built with Vite + React + TypeScript, Tailwind CSS v4, Motion (Framer Motion successor), GSAP + ScrollTrigger, Lenis smooth scroll, and Embla Carousel — all using the exact same kawaii-pastel palette as the app.

Pages: **Home**, **News**, **Privacy Policy**, **Terms & Conditions**.

```bash
cd my_reading_village_website
bun install
bun run dev        # local dev server
bun run build      # production build → dist/
```

Deployment is automated via [`netlify.toml`](my_reading_village_website/netlify.toml): every push to `main` triggers `bun run build` and publishes `dist/`. See [`docs/specs/WEBSITE.md`](docs/specs/WEBSITE.md) for the original design brief and brand guidelines.

---

## Project Structure

```
my-reading-village/
├── my_reading_village/              # Flutter application root
│   ├── android/                     # Android platform files + build config
│   ├── assets/
│   │   ├── audios/                  # Background music and sound effect files
│   │   ├── images/                  # Sprites: buildings (3 levels), decorations,
│   │   │                            #   villagers (41 species), items, resources, logos
│   │   └── messages/                # i18n JSON files (en, es, pt, fr, it)
│   ├── lib/                         # All Dart source code (see Architecture above)
│   └── pubspec.yaml
│
├── my_reading_village_marketing/    # Social media content generator (Python)
│   ├── palette.py                   # AppTheme colors as Python constants
│   ├── assets.py                    # Resolved paths to game assets
│   ├── utils.py                     # Shared PIL helpers (drawing, easing, species data)
│   ├── templates/
│   │   ├── image/                   # Static image templates (villager_spotlight, feature_highlight, reading_tip)
│   │   └── video/                   # Animated video templates (reading_benefits_story, villager_reveal_reel,
│   │                                #   gameplay_showcase, countdown_story)
│   ├── scripts/generate.py          # CLI dispatcher
│   ├── output/                      # Generated content — git-ignored
│   ├── requirements.txt
│   └── README.md
│
├── my_reading_village_website/      # Marketing website (Vite + React + TS)
│   ├── src/
│   │   ├── pages/                   # Home, News, Privacy, Terms
│   │   ├── components/              # Layout, common, and home-specific components
│   │   ├── hooks/                   # Custom React hooks
│   │   ├── data/                    # Static content (news entries, etc.)
│   │   └── styles/                  # Global CSS and Tailwind tokens
│   ├── public/                      # Static assets (icons, sitemap, robots.txt)
│   ├── netlify.toml                  # Netlify build + headers config
│   ├── package.json                  # Bun-managed dependencies
│   └── README.md
│
├── docs/
│   ├── specs/
│   │   ├── FIREBASE.md              # Firebase Analytics one-time setup guide
│   │   ├── UNITY_ADS.md             # Unity Ads account setup and placement IDs
│   │   ├── MARKETING.md             # Social media launch guide (Reddit, Instagram, TikTok, YouTube)
│   │   ├── PLAY_STORE.md            # Google Play publishing workflow
│   │   ├── VULNERABILITIES.md       # Security feature implementation spec
│   │   └── WEBSITE.md               # Marketing website design brief
│   ├── bug_reports/                  # Dated bug reports
│   └── slides/                       # Presentation decks
│
├── tools/                           # Asset pipeline utilities (Python)
│   ├── autocrop.py                  # Batch remove transparent/empty borders
│   ├── mirror.py                    # Batch flip images horizontally or vertically
│   ├── remove_background.py         # Batch background removal via flood-fill
│   ├── original-images/             # Source images before processing
│   └── README.md                    # Full usage guide for all tools
│
├── LICENSE.md                       # My Reading Village Community License v1.0
└── README.md                        # This file
```

---

## Database Schema

All data is stored in a local SQLite database on-device. No data is ever transmitted externally.

| Table                      | Purpose                                                                                            |
| -------------------------- | -------------------------------------------------------------------------------------------------- |
| `books`                    | User book library — title, author, total/read pages, completion, cover, rating                     |
| `tags`                     | User-created color-coded book categories                                                           |
| `book_tags`                | Many-to-many join between books and tags                                                           |
| `reading_sessions`         | Individual reading logs — pages, resources earned, date, time taken                                |
| `resources`                | Singleton row — current coins, gems, wood, metal                                                   |
| `villagers`                | Spawned villager instances — species, name, happiness, assigned house                              |
| `placed_buildings`         | Building instances — type, tile position, level, construction state, costs                         |
| `road_tiles`               | Player-placed road terrain tiles                                                                   |
| `special_tiles`            | Water, sand, and rock terrain markers                                                              |
| `unlocked_chunks`          | Map expansion tracking — which 5×5 tile chunks are unlocked                                        |
| `game_state`               | Singleton player profile — XP, level, username, village name, language, settings, ad counters, volume, analytics_id |
| `inventory_items`          | Consumable item quantities — book, sandwich, glasses, hammer                                       |
| `minigame_cooldowns`       | Per-minigame cooldown end timestamps                                                               |
| `active_powerups`          | Time-limited active buffs — type, target villager, activation time, duration                       |
| `mission_progress`         | Mission completion and claim state — plus baseline counters for event delta tracking               |
| `species_unlocks`          | Roster of unlocked villager species with unlock timestamps and purchase origin flag                |
| `pending_villager_choices` | Queued house-population dialogs (species/name options per house)                                   |
| `used_secret_codes`        | Redeemed promotional codes — one-time use per device                                               |

---

## Firebase Analytics

Analytics are **100% opt-in** and **anonymous**. A consent modal is shown after the onboarding tour completes. The user can toggle analytics at any time in **Settings → Data**. The app works identically with analytics on or off.

An anonymous `analytics_id` is generated on first launch and stored in SQLite. It travels with the player's backup file — restoring a backup on a new device preserves the same ID. It has no connection to any personal identifier.

Analytics use the **Firebase Spark plan** (free, no credit card, no event-count limit).

**Events tracked (27+):**

| Category       | Events                                                                                          |
| -------------- | ----------------------------------------------------------------------------------------------- |
| Reading        | `pages_logged`, `book_completed`, `book_rated`, `book_note_saved`                              |
| Village        | `building_placed`, `chunk_unlocked`, `level_up`, `species_unlocked`, `villager_choice_made`    |
| Engagement     | `mission_claimed`, `roulette_spun`, `reading_modal_opened`, `stats_dialog_opened`, `backpack_opened`, `species_gallery_opened`, `store_opened`, `settings_opened` |
| Monetization   | `ad_watched`, `iap_purchase`                                                                    |
| Lifecycle      | `photo_taken`, `data_exported`, `data_imported`, `language_changed`, `tutorial_completed`      |
| Consent        | `analytics_consent_given`, `analytics_consent_revoked`                                         |

**User properties set automatically:** `player_level`, `building_count`, `villager_count`, `expansion_count`, `total_books_completed`, `total_pages_read`, `has_made_iap`, `language`.

For the one-time Firebase project setup (download `google-services.json`, enable DebugView, etc.) see [`docs/specs/FIREBASE.md`](docs/specs/FIREBASE.md).

---

## Security Features

### Species Purchase Protection

A user could export their backup JSON, share it with a friend, and the friend imports it — gaining all paid species ($1.99–$13.99 each) for free. The import pipeline prevents this:

1. `species_unlocks` rows flagged as IAP-purchased (`is_purchased = 1`) are stripped from the imported file.
2. Any villager whose species was stripped has their species replaced with a random starter species (cat, dog, or rabbit) — the villager itself (name, happiness, house assignment) is preserved.
3. Any pending villager choice that included a stripped species is removed entirely — the player receives a new choice naturally through gameplay.

A warning dialog is shown when stripping occurs, with a **Restore Purchases** button that lets legitimate users (e.g. reinstalling on a new device) recover paid species via Google Play.

### Date Tampering Detection

Seasonal events are date-gated. A player could set their device clock forward to access out-of-date events or backward to exploit time-based cooldowns. The app detects suspicious clock changes:

- On each app foreground, the app compares the device clock against a trusted internet time source (when online) and against the last recorded timestamp (when offline).
- A sudden forward jump or backward shift beyond a configurable threshold triggers a **fraud warning popup** — the player is informed that the date appears manipulated and that event progress may be affected.
- The warning is purely informational (no data is deleted); it serves as a deterrent and preserves trust in the seasonal event system.

For the full implementation spec see [`docs/specs/VULNERABILITIES.md`](docs/specs/VULNERABILITIES.md).

---

## Asset Pipeline

The `tools/` directory contains three Python utilities for processing sprite assets. All tools operate on a local `.venv` and output PNG with transparency preserved.

```bash
cd tools
python3 -m venv .venv && source .venv/bin/activate
pip install -r requirements.txt
```

| Tool                   | Purpose                                                | Example                                                |
| ---------------------- | ------------------------------------------------------ | ------------------------------------------------------ |
| `remove_background.py` | Flood-fill background removal by color or hex          | `.venv/bin/python3 remove_background.py --color white` |
| `mirror.py`            | Batch horizontal or vertical flip                      | `.venv/bin/python3 mirror.py --horizontal`             |
| `autocrop.py`          | Remove empty/transparent borders with optional padding | `.venv/bin/python3 autocrop.py --padding 5`            |

For full usage details, flags, and examples see [`tools/README.md`](tools/README.md).

---

## Getting Started

### Prerequisites

- **[Flutter SDK](https://docs.flutter.dev/get-started/install)** >= 3.5
- **Android Studio** or **VS Code** with the Flutter extension
- An Android device or emulator (API 21+)

### Installation

```bash
# Clone the repository
git clone https://github.com/FernandoPV02/my-reading-village.git
cd my-reading-village/my_reading_village

# Install dependencies
flutter pub get

# List available devices
flutter devices

# Run on a connected device or emulator
flutter run

# Run on a specific device
flutter run -d <device_id>
```

### Useful Development Commands

```bash
# Static analysis / lint check
flutter analyze

# Run tests
flutter test

# Check Flutter environment
flutter doctor

# Clean build artifacts
flutter clean
```

---

## Building for Android

```bash
cd my_reading_village

# Debug APK
flutter build apk --debug

# Release APK
flutter build apk --release
# Output: build/app/outputs/flutter-apk/app-release.apk

# Release App Bundle (required for Google Play)
flutter build appbundle --release
# Output: build/app/outputs/bundle/release/app-release.aab
```

For the full Google Play publishing workflow (signing, store listing, in-app products, staged rollout) see [`docs/specs/PLAY_STORE.md`](docs/specs/PLAY_STORE.md).

For Unity Ads account setup, placement IDs, and enabling live ads see [`docs/specs/UNITY_ADS.md`](docs/specs/UNITY_ADS.md).

For Firebase Analytics setup (replacing the placeholder `google-services.json`) see [`docs/specs/FIREBASE.md`](docs/specs/FIREBASE.md).

---

## Troubleshooting

### `flutter run` hangs at "Waiting for VM Service port to be available..."

**Affected devices:** Honor, Huawei, Nubia, RedMagic, and other Chinese OEM phones running Android 14 or 15 (MagicOS 8, HarmonyOS 4+, RedMagicOS, etc.).

**Root cause:** These devices suppress logcat output for third-party apps by default. Flutter's tool discovers the Dart VM debug port by scanning logcat for the "VM Service listening on..." message — if logcat is silenced, the tool never finds the port and hangs indefinitely. The app itself installs and runs fine; only the debug connection is broken.

**Fix (one-time, survives reboots):**

```bash
adb shell setprop persist.log.tag I
```

Then run `flutter run` normally. The `persist.` prefix makes the change permanent across reboots. Without it (`log.tag` without `persist.`) the fix is lost on the next device restart.

**To verify it worked:**

```bash
adb shell getprop persist.log.tag
# Should print: I
```

**To confirm Firebase Analytics is receiving events** (optional, while debugging):

```bash
# Enable DebugView mode on the device
adb shell setprop debug.firebase.analytics.app com.ferchostudiodev.my_reading_village

# Then open Firebase Console → Analytics → DebugView
# Events will appear in real time

# Disable when done
adb shell setprop debug.firebase.analytics.app .none.
```

**If `setprop persist.log.tag I` is not enough** (some Honor GT / Magic Pro models), try enabling logging through the device's engineering menu:

1. Open the Phone dialer and dial `*#*#2846579#*#*`
2. Navigate to **Background Settings**
3. Enable **Log output** or **Logging always on**

> This issue is tracked upstream in the Flutter repository. The `persist.log.tag I` workaround was confirmed working on Honor Magic 6 Lite, Honor GT Pro, Nubia, and RedMagic devices.

---

## License

This project is licensed under the **My Reading Village Community License v1.0** — see [LICENSE.md](LICENSE.md) for full terms.

- Personal and non-commercial use is permitted.
- Commercial use requires prior written authorization from the author.
- Forks must remain public and carry this same license.
- Attribution to the original author is mandatory in all derivative works.

---

<div align="center">
  <br>
  <sub>
    Developed by <a href="https://www.linkedin.com/in/fernando-pinto-villarroel/">Fernando Pinto Villarroel</a>
    <br>
    A personal project — not affiliated with any organization.
  </sub>
  <br><br>
</div>
