<div align="center">

  <img src="my_reading_town/assets/images/logos/my_reading_town_icon_rounded.png" alt="My Reading Town" width="220" />

  <br>

# My Reading Town

**A mobile village-building game that turns real-world reading into dopamine-driven gameplay — built with Flutter and Flame Engine.**

  <br>

![Flutter](https://img.shields.io/badge/Flutter-3.5-02569B?style=flat-square&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-3.5-0175C2?style=flat-square&logo=dart&logoColor=white)
![Flame](https://img.shields.io/badge/Flame-1.21-FF6D00?style=flat-square&logo=firebase&logoColor=white)
![SQLite](https://img.shields.io/badge/SQLite-Local_DB-003B57?style=flat-square&logo=sqlite&logoColor=white)
![Provider](https://img.shields.io/badge/Provider-6.1-6C63FF?style=flat-square)
![AdMob](https://img.shields.io/badge/AdMob-Rewarded_Ads-EA4335?style=flat-square&logo=googleads&logoColor=white)
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
- [Project Structure](#project-structure)
- [Database Schema](#database-schema)
- [Asset Pipeline](#asset-pipeline)
- [Getting Started](#getting-started)
- [Building for Android](#building-for-android)
- [License](#license)

---

## Overview

**My Reading Town** is a privacy-first mobile game that rewards real-world reading with in-game village-building progression. Log the pages you read, earn coins, gems, wood, and metal, then use those resources to construct and upgrade buildings in a charming 2D isometric village populated by 43 unique kawaii animal villagers.

The game replicates the dopamine reward loops found in addictive mobile games — but redirects them toward building a healthy reading habit. All gameplay data stays exclusively on your device: no accounts, no cloud sync, no tracking.

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
      <td><strong>43 villager species</strong></td>
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
      <td>Export and import the full game state as a file — full local backup without cloud dependency</td>
    </tr>
    <tr>
      <td><strong>Stats dashboard</strong></td>
      <td>Track village level, XP, total pages, books completed, building counts, happiness scores, and resource history</td>
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
      <td>Core gameplay requires no internet — all progress lives on-device in a local SQLite database. Network is used only for optional book search (Open Library API), in-app purchases, and rewarded ads; books can always be added manually without a connection</td>
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

My Reading Town is free-to-play with optional in-app purchases. No paywalls block core gameplay — all progression is achievable without spending.

### Revenue Streams

**1. In-App Purchases (Google Play Billing)**

| Category                         | Products                 | Price Range  |
| -------------------------------- | ------------------------ | ------------ |
| Gem Packs (consumable)           | 6 tiers (50–2000 gems)   | $0.99–$29.99 |
| Item Packs (consumable)          | 5 bundles (Starter–Mega) | $1.49–$19.99 |
| Species Unlocks (non-consumable) | 30 paid species          | $0.99–$19.99 |

**2. AdMob Rewarded Ads (3 placements)**

| Placement         | Mechanic                                                |
| ----------------- | ------------------------------------------------------- |
| Construction skip | Watch ad → reduce build time by 10 minutes (unlimited)  |
| Lucky wheel       | Watch 3 ads → earn 1 free spin (max 3 ad-spins per day) |
| Free gems         | Watch 3 ads → receive 5 gems (once per day)             |

Ads are always optional and user-initiated — no interruptions to gameplay.

### Retention Mechanics

- 13 seasonal events throughout the year drive re-engagement spikes
- Multi-branch mission chains provide always-available progression goals
- 43 collectible species create long-term collection motivation
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
| Monetization         | in_app_purchase + google_mobile_ads                 | ^3.2.0 / ^5.1.0   |
| Book Search          | http                                                | ^1.2.2            |
| Image Picker         | image_picker                                        | ^1.1.2            |
| File I/O (backup)    | file_picker + path_provider                         | ^10.3.10 / ^2.1.5 |
| Gallery Save         | gal                                                 | ^2.3.0            |
| Sharing              | share_plus                                          | ^12.0.1           |
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

## Project Structure

```
my-reading-town/
├── my_reading_town/              # Flutter application root
│   ├── android/                  # Android platform files + build config
│   ├── assets/
│   │   ├── audios/               # Background music and sound effect files
│   │   ├── images/               # Sprites: buildings (3 levels), decorations,
│   │   │                         #   villagers (43 species), items, resources, logos
│   │   ├── messages/             # i18n JSON files (en, es, pt, fr, it)
│   │   └── prompts/
│   │       └── decorations.md    # AI prompt specifications for all decoration assets
│   ├── lib/                      # All Dart source code (see Architecture above)
│   └── pubspec.yaml
├── tools/                        # Asset pipeline utilities (Python)
│   ├── autocrop.py               # Batch remove transparent/empty borders
│   ├── mirror.py                 # Batch flip images horizontally or vertically
│   ├── remove_background.py      # Batch background removal via flood-fill
│   ├── original-images/          # Source images before processing
│   └── README.md                 # Full usage guide for all tools
├── LICENSE.md                    # My Reading Town Community License v1.0
└── README.md                     # This file
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
| `game_state`               | Singleton player profile — XP, level, username, town name, language, settings, ad counters, volume |
| `inventory_items`          | Consumable item quantities — book, sandwich, glasses, hammer                                       |
| `minigame_cooldowns`       | Per-minigame cooldown end timestamps                                                               |
| `active_powerups`          | Time-limited active buffs — type, target villager, activation time, duration                       |
| `mission_progress`         | Mission completion and claim state — plus baseline counters for event delta tracking               |
| `species_unlocks`          | Roster of unlocked villager species with unlock timestamps                                         |
| `pending_villager_choices` | Queued house-population dialogs (species/name options per house)                                   |
| `used_secret_codes`        | Redeemed promotional codes — one-time use per device                                               |

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

AI generation prompts for all game assets (villagers, buildings, decorations, items, and more), including dimensions, style, and palette guidance, are in [`my_reading_town/assets/prompts/`](my_reading_town/assets/prompts/).

---

## Getting Started

### Prerequisites

- **[Flutter SDK](https://docs.flutter.dev/get-started/install)** >= 3.5
- **Android Studio** or **VS Code** with the Flutter extension
- An Android device or emulator (API 21+)

### Installation

```bash
# Clone the repository
git clone https://github.com/FernandoPV02/my-reading-town.git
cd my-reading-town/my_reading_town

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
cd my_reading_town

# Debug APK
flutter build apk --debug

# Release APK
flutter build apk --release
# Output: build/app/outputs/flutter-apk/app-release.apk

# Release App Bundle (required for Google Play)
flutter build appbundle --release
# Output: build/app/outputs/bundle/release/app-release.aab
```

For the full Google Play publishing workflow (signing, store listing, in-app products, staged rollout) see [`PLAY_STORE.md`](PLAY_STORE.md).

For AdMob account setup, ad unit IDs, and enabling live ads see [`GOOGLE_ADS.md`](GOOGLE_ADS.md).

---

## License

This project is licensed under the **My Reading Town Community License v1.0** — see [LICENSE.md](LICENSE.md) for full terms.

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
