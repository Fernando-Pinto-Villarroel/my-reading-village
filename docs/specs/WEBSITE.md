# Brief: Marketing Website for My Reading Village

> **For the Claude Code session picking this up**: run this in **Plan Mode** with the **Opus** model and **high** reasoning effort. Read this entire brief first, explore the asset paths it references, propose a concrete component/page architecture and animation plan, confirm it with the user, then build. This is a brand-new standalone project (not part of the Flutter app) — scaffold it in a new sibling directory, e.g. `my-reading-village-website/`.

---

## 1. What this is and why it exists

My Reading Village is a kawaii mobile game (Flutter/Android, soon on Google Play) that turns a reading habit into a cozy village-builder: every page the player logs earns resources that grow their own cute village and unlocks adorable collectible animal villagers. This website is its **public marketing face** — the place people land when they click a link from Reddit, Instagram, TikTok, YouTube or a Play Store search (see `MARKETING.md` and `PLAY_STORE.md` in the repo root for the full brand voice, taglines and existing copy this site should stay consistent with).

**Goal of the site**: convert a curious visitor into either (a) a Play Store install, or (b) a follower on one of the social channels — by making them feel, within seconds of landing, the same warm "I want to live in this cozy little world" feeling the app itself evokes.

**Pages required** (drives the footer/header navigation): **Home**, **News**, **Privacy Policy**, **Terms & Conditions**.

---

## 2. Tech stack — use these, they're the current standard for this kind of animated marketing site

- **Vite + React + TypeScript**
- **Tailwind CSS** (latest v4-style, CSS-first config)
- **Motion** (the modern successor/rebrand of Framer Motion — `motion/react`) for component animations, scroll reveals, hover/tap micro-interactions and page transitions
- **GSAP** (`gsap`, with `@gsap/react`'s `useGSAP` hook and the `ScrollTrigger` plugin — free to use, no Club GreenSock license needed for these) for the showcase-grade timeline animations Motion isn't built for: the hero's multi-step entrance sequence (logo + tagline + CTA choreographed in sequence), pinned/scrubbed scroll storytelling on the "How it works" strip, and any SVG path-drawing or text-splitting reveals. Use Motion for everyday component-level animation (cards, hovers, page transitions) and reach for GSAP specifically when a sequence needs precise timeline control or scroll-scrubbing — keep the split intentional so the two libraries don't fight over the same elements
- **Lenis** (`@studio-freight/lenis` or its current package name) for buttery smooth-scroll, paired with Motion's scroll-linked animations and GSAP's `ScrollTrigger` (sync Lenis's scroll events to `ScrollTrigger.update` so both stay in lockstep)
- **Embla Carousel** (`embla-carousel-react`) for the villager showcase carousel — lightweight, accessible, drag/swipe-native
- **React Router** for Home / News / Privacy / Terms navigation
- Plain SVG/PNG assets from the Flutter project (see Section 4) — no need for a CMS; News can start as a simple static array of post entries rendered into cards

Pick the latest stable versions of all of the above at build time — don't pin to versions you assume from training data, run `bun pm view <pkg> version` (or check the package's npm registry page) and check each library's current docs for breaking API changes (Motion in particular has had naming/import changes across major versions).

**Package manager: use [Bun](https://bun.sh) exclusively** — `bun install`, `bun add`, `bun run`, `bunx`. Do not use npm or yarn at any step.

---

## 3. Brand & visual identity — must match the app exactly

### Color palette (kawaii-pastel — reuse verbatim, make them Tailwind theme tokens / CSS variables so they're trivial to retune later)

Pulled directly from `AppTheme` (`lib/infrastructure/ui/config/app_theme.dart`) — the single source of truth for every color in the app — so the site matches it exactly, hex-for-hex. Don't invent your own shades for hover/contrast/text; every variant the site could need already exists below.

**Soft / base palette** — the dominant "kawaii-pastel" tones, used for backgrounds, cards and primary surfaces/buttons

```
--color-pink:      #FFB3BA   (soft pink — app bar / nav / FAB)
--color-lavender:  #B5B3FF   (lavender — primary buttons / CTAs)
--color-mint:      #B3FFD9   (mint green)
--color-cream:     #FFF8F0   (cream — base page background)
--color-peach:     #FFDFC4   (peach)
--color-sky:       #BAE1FF   (sky blue)
```

**Neutrals & text** — use these instead of pure black/white anywhere on the site

```
--color-soft-white: #FFFEFC  (card / surface background, sits "above" the cream base)
--color-dark-text:  #4A4A4A  (the app's body & heading text color)
```

**Dark/medium accent variants** — for hover states, emphasis, borders, link/button-active states: anything that needs more contrast than the soft palette gives on its own

```
--color-dark-pink:     #E8637A
--color-dark-lavender: #7B79E8
--color-dark-orange:   #CC7722
--color-medium-orange: #F6A249
--color-dark-mint:     #2E9E6B
--color-medium-mint:   #58CE99
--color-dark-sky:      #509BE1
```

**Resource highlight colors** — only if the site shows in-game iconography, screenshot callouts, or "earn rewards" style sections

```
--color-coin-gold:  #FFD700
--color-gem-purple: #BB86FC
```

These are the exact hex values used throughout `assets/prompts/*.md` for every piece of art in the game — the site must feel like it was painted by the same illustrator. No dark, neon, gritty or desaturated tones anywhere; even the "dark" accent variants above stay warm and soft — they exist purely for contrast, not to introduce a different mood.

### Typography

Pick warm, rounded, friendly Google Fonts that match a kawaii aesthetic — e.g. **Baloo 2** (or **Fredoka**) for headings/display text, and **Quicksand** (or **Nunito**) for body copy. Rounded letterforms reinforce the "chubby, soft, cozy" character design language used across every villager and building sprite. (Note: the app itself just uses Flutter's default Material typeface — there's no in-app font choice to mirror here, so this pick is a website-specific upgrade in service of the same kawaii character-design language, not a literal port from `AppTheme`.)

### Tone

Warm, playful, gentle, encouraging — never aggressive "BUY NOW" sales language. Mirror the voice of the in-app onboarding tour (`my_reading_village/assets/messages/en/en.json`, keys prefixed `tour_*`) — e.g. _"Welcome to your very own Reading Village! I'm so happy to show you around today! ✨"_. That same warmth should run through every heading, button label and microcopy string on this site.

---

## 4. Asset inventory — exact paths to copy into the new project

All paths below are relative to `my_reading_village/` in this repo. Copy (don't symlink) the files you need into the new site's `public/` or `src/assets/`.

- **Logo** (use everywhere — header, footer, favicon source): `assets/images/logos/my_reading_village_icon_cropped.png`
- **Hero / section backgrounds** (splash-screen illustrations — gorgeous, full-scene kawaii art, perfect for full-bleed hero sections or section dividers): `assets/images/backgrounds/splash_bg_1.png`, `splash_bg_2.png`, `splash_bg_3.png`
- **Horizontal marketing banner** (wide-format hero art generated from the prompt in `assets/prompts/backgrounds.md` → "Horizontal Marketing Banner Backgrounds" → `marketing_banner_horizontal.png`): **check whether this file has been generated yet** at `assets/images/backgrounds/marketing_banner_horizontal.png` (or ask the user where they saved it) — if it doesn't exist yet, fall back to the splash backgrounds above and flag it to the user as a follow-up asset to drop in later.
- **Villager carousel** — 42 species, each with a default "happy" sprite at `assets/images/villagers/<species>/<species>_villager.png`, e.g.:
  - `assets/images/villagers/cat/cat_villager.png`
  - `assets/images/villagers/red_panda/red_panda_villager.png`
  - `assets/images/villagers/lion/lion_villager.png`
  - … and 39 more (run `find my_reading_village/assets/images/villagers -maxdepth 1 -type d` to enumerate all species directories, then build the carousel data array from `<dir>/<dir>_villager.png`)
  - Each species also has `_sad.png` and `_sleeping.png` variants — **don't use those for the marketing carousel**, only the default happy pose.
- **Rarity tiers** (label the carousel cards with these — pulled from `assets/messages/en/en.json` keys `rarity_*`): Common, Rare, Extraordinary, Legendary, Godly — five tiers, each species belongs to exactly one (cross-reference `lib/domain/rules/species_rules.dart` if you want to tag each carousel card with its real rarity).
- **App icon variants** (for favicon/OG image generation): `assets/images/logos/my_reading_village_icon.png`, `my_reading_village_icon_rounded.png`

---

## 5. Site architecture

### Header (sticky, present on every page)

- Logo + "My Reading Village" wordmark (links to Home)
- Nav links: **Home · News · Privacy · Terms**
- Primary CTA button: **"Get it on Google Play"** — styled as a pill/rounded button in the brand palette, links to the Play Store listing (use a placeholder URL like `#` with a `data-todo` comment until the user supplies the real one — the listing isn't live yet per `PLAY_STORE.md`)
- Mobile: collapses into a friendly hamburger/drawer menu with the same items, animated open/close (Motion)

### Footer (every page)

- Logo (smaller)
- Nav links mirroring the header: **Home · News · Privacy · Terms**
- Social links row with icons: Reddit, Facebook, Instagram, TikTok, YouTube — placeholder `#` hrefs until the accounts in `MARKETING.md` exist; use real platform icons (e.g. `react-icons` or `lucide-react`, NOT emoji, to match the app's "use real icons, not emojis" aesthetic rule)
- Small copyright line: `© {currentYear} My Reading Village. All rights reserved.`

### Home (the landing page — this is where the animation budget goes)

1. **Hero section** — full-bleed splash background (`splash_bg_1.png` or the new horizontal banner once available), a choreographed GSAP entrance timeline (logo scales/fades in, then the tagline cascades into view, then the CTA settles into place — see Section 6 for the full sequencing spec), the core tagline (`Turn every page you read into a cozy village full of adorable animal friends.` — straight from `MARKETING.md` → Part 0 → "Core elevator pitch"), a primary CTA button, subtle parallax/scroll-linked drift on the background art
2. **"How it works" feature strip** — 3–4 cards (Read → Earn → Build → Collect), each scroll-reveals into place (staggered fade+slide via Motion's `whileInView`), each paired with a short line of copy adapted from the feature bullets already written in `PLAY_STORE.md` (📚 reading tracker, 🏘️ build & customize, 🐾 collect villagers, 🎮 minigames/events)
3. **Villager showcase carousel** — Embla-powered horizontal carousel of all 42 species, auto-playing, pausable on hover/focus, swipeable on touch, each card showing the sprite, species name, and a small rarity badge color-coded by tier; add a "+ many more to discover" closing card
4. **Screenshot/gameplay gallery** — a few in-game screenshots (placeholder image slots if none are supplied yet — flag to user) in a playful tilted/staggered grid that straightens on hover (Motion spring transitions)
5. **Closing CTA band** — restated tagline + the same "Get it on Google Play" button, on a warm gradient background built from the palette tokens

### News

A simple, clean list/grid of devlog-style post cards (title, date, short excerpt, "Read more" link). Ship it with **2–3 seed posts already written** introducing the project (e.g. "Welcome to the My Reading Village devlog", "Meet your first villagers", "Why we built a reading habit into a village game") — adapt tone/length from the devlog angle described in `MARKETING.md` Part 1, Step 1.6. Each post can be a static MDX/Markdown file or a typed array — keep it simple, no CMS needed for a v1.

### Privacy Policy

Render the **exact text below** as the page content (formatted with proper headings/spacing, not a wall of text). This is the same text that should be submitted as the Play Store privacy policy URL once this site is live — keep the two in sync.

```markdown
# Privacy Policy — My Reading Village

_Last updated: [INSERT PUBLISH DATE]_

My Reading Village ("the app", "we", "our") is developed by Fernando Pinto Villarroel ("the developer"). This Privacy Policy explains what information the app collects, how it is used, and your choices regarding it.

## 1. Information We Collect

**Information you provide directly**

- The username and village name you choose during setup — stored only on your device.
- Reading data you log: book titles, authors, page counts, reading sessions, dates, time spent, tags, and favorite quotes or authors — stored only on your device in a local database.
- Photos: if you choose to add a cover photo to a book using your camera or photo gallery, that photo is stored only on your device.

None of the above is transmitted to us or to any server of ours — My Reading Village stores all of your data locally on your device using a local SQLite database.

**Information collected automatically — only with your consent**
The first time you open the app, right after the welcome tour, you are shown a consent screen that explains, in plain language, what usage analytics are and asks you to accept or decline them — with a separate checkbox for this Privacy Policy and for the Terms & Conditions. **If you decline, or leave a box unchecked, no analytics library is ever started and no usage data is ever collected or sent anywhere; the app works exactly the same either way.**

If you do accept, the app uses **Google Analytics for Firebase** to send us anonymous, aggregate counters about how the game is used — for example, that a reading session was logged and how many pages it covered, that a building was placed or upgraded, that a villager of a certain rarity was unlocked, or that a minigame was played. These events never include your username, your village's name, book titles, authors, quotes, photos, or anything else that could identify you — only counts and categories that help us understand, in aggregate across all players, whether the app is helping people build a reading habit. Firebase Analytics may also collect basic technical information (such as an installation identifier, app version, and general device/locale info) needed to produce that aggregate reporting, governed by [Google's Privacy Policy](https://policies.google.com/privacy).

You can change your mind at any time from **Settings → Data Management → Analytics & Privacy** — turning analytics off there immediately stops all future collection, and turning it on starts it from that point forward.

## 2. Third-Party Services

**Book search.** When you search for a book by title, author or ISBN using the "Search Online" feature, your search query is sent to the [Open Library](https://openlibrary.org) API, a free service operated by the Internet Archive, in order to retrieve book details and cover images. Please refer to Open Library's own privacy policy for how they handle that request.

**Advertising.** The app displays optional rewarded video ads through Google AdMob (Google Mobile Ads). To serve and measure ads, Google AdMob may collect and process information such as advertising identifiers, IP address, and device information, in accordance with [Google's Privacy Policy](https://policies.google.com/privacy) and [ad technology policy](https://policies.google.com/technologies/ads). You can manage your ad personalization preferences in your device's settings.

**Analytics (only if you consent).** As described above, if — and only if — you accept analytics on the consent screen, the app uses Google Analytics for Firebase to collect anonymous, aggregate usage events. This library is never initialized, and no event is ever sent, unless you have actively opted in.

**Notifications.** The app schedules local reminder notifications (for example, daily reading reminders or "construction complete" alerts) directly on your device. These are generated locally and are never routed through an external push-notification server.

## 3. Data Storage & Backups

All of your game and reading data lives locally on your device. The app's "Export Backup" / "Import Backup" feature lets you save your data to a file that you control — for example, to move it to a new device. You create and manage these files yourself; My Reading Village never uploads them anywhere.

## 4. Data Sharing & Sale

We do not sell your personal information. The only data that ever leaves your device is: (a) book search queries sent to Open Library when you use that feature, (b) information collected by Google AdMob to serve ads, and (c) — only if you have explicitly consented — the anonymous, aggregate analytics events described in Section 1, sent via Google Analytics for Firebase.

## 5. Children's Privacy

My Reading Village is a general-audience app suitable for readers of all ages, including children. We do not knowingly collect personal information beyond what is described above. Analytics are strictly opt-in, off by default, configured for child-directed treatment (no ad-personalization signals from analytics data), and what is collected — only upon consent — is anonymous and aggregate, never tied to your identity. Where required, ads are served in accordance with Google's policies for child-directed treatment.

## 6. Your Choices

- Accept or decline analytics collection on first launch, and change that choice at any time from **Settings → Data Management → Analytics & Privacy**.
- Delete all of your data at any time from **Settings → Data Management → Reset All Data**.
- Export your data at any time using **Export Backup**.
- Manage ad personalization through your device's privacy settings.

## 7. Changes to This Policy

We may update this Privacy Policy from time to time. Any changes will be posted on this page with a new "Last updated" date.

## 8. Contact Us

Questions about this Privacy Policy can be sent to: **[INSERT CONTACT EMAIL]**
```

> **Two placeholders need the user's input before this goes live**: `[INSERT PUBLISH DATE]` and `[INSERT CONTACT EMAIL]`. Ask the user directly — for the email, suggest they consider using a dedicated address rather than a personal one, since this page will be public and submitted to Google Play.

### Terms & Conditions

Render the **exact text below** as the page content (same heading/spacing treatment as the Privacy Policy page). This is the same text that the in-app consent screen links to and asks the player to accept via checkbox before any analytics are enabled.

```markdown
# Terms & Conditions — My Reading Village

_Last updated: [INSERT PUBLISH DATE]_

Welcome to My Reading Village! These Terms & Conditions ("Terms") govern your use of the My Reading Village mobile app ("the app"), developed by Fernando Pinto Villarroel ("the developer", "we", "our"). By installing or using the app, you agree to these Terms. If you do not agree, please do not use the app.

## 1. The App

My Reading Village is a cozy, kawaii village-builder game that turns your real-world reading habit into in-game progress: logging the books and pages you read earns resources that grow your village and unlocks collectible animal villagers. It is provided free of charge, with optional rewarded video ads.

## 2. Your Account & Data

The app does not require you to create an account or sign in. Your village, reading log, and settings are stored locally on your device. You are responsible for keeping your device secure and for using the **Export Backup** feature if you want a copy of your data.

## 3. Acceptable Use

You agree to use the app only for its intended purpose — as a personal reading companion and cozy game — and not to attempt to reverse-engineer, exploit, disrupt, or interfere with the app, its assets, or the third-party services it relies on (Open Library, Google AdMob, Google Analytics for Firebase).

## 4. In-App Resources & Purchases

Coins, gems, wood, metal, villagers, buildings, and similar in-game items have no real-world monetary value, cannot be exchanged for cash, and exist solely for use within the app. Any optional purchases or rewarded-ad bonuses are described at the point of offer; please refer to the Google Play purchase terms for billing-related questions.

## 5. Third-Party Services

The app integrates with the third-party services described in our [Privacy Policy](/privacy) — Open Library (book search), Google AdMob (advertising), and, only with your consent, Google Analytics for Firebase (anonymous usage analytics). Your use of those services through the app is also subject to their own terms and policies.

## 6. Analytics Consent

As explained in our Privacy Policy, the app will only collect anonymous usage analytics if you actively opt in via the consent screen shown after the welcome tour. Accepting these Terms does not, by itself, enable analytics — that requires a separate, explicit choice, which you can revisit at any time from **Settings → Data Management → Analytics & Privacy**.

## 7. Intellectual Property

All artwork, characters, music, names, and other creative assets in My Reading Village are the property of the developer and are protected by applicable intellectual-property laws. You may not copy, redistribute, or use them outside the app without permission.

## 8. Disclaimer & Limitation of Liability

The app is provided "as is", without warranties of any kind. We do their best to keep it fun, cozy, and bug-free, but we cannot guarantee uninterrupted or error-free operation. To the fullest extent permitted by law, the developer is not liable for any indirect, incidental, or consequential damages arising from your use of the app.

## 9. Changes to These Terms

We may update these Terms from time to time, for example as new features are added. Any changes will be posted on this page with a new "Last updated" date, and significant changes may also be highlighted in the app.

## 10. Contact Us

Questions about these Terms can be sent to: **[INSERT CONTACT EMAIL]**
```

> Same two placeholders as the Privacy Policy — `[INSERT PUBLISH DATE]` and `[INSERT CONTACT EMAIL]` — should resolve to the same values so both pages stay consistent.

---

## 6. Animation & interaction spec

This is meant to be an "award-site" quality experience — that's the whole point of using Motion + GSAP + Lenis + Embla instead of a static template. Concretely:

- **Smooth scroll** site-wide via Lenis, integrated with Motion's `useScroll`/`useTransform` for scroll-linked effects (parallax backgrounds, fade/scale on scroll position) and with GSAP's `ScrollTrigger` for the heavier scroll-scrubbed sequences below — drive both off the same Lenis scroll source so nothing feels out of sync
- **Hero entrance choreography (GSAP)**: a single `gsap.timeline()` (wired up with `useGSAP`) that sequences the logo's gentle scale/fade-in, then the tagline's soft upward reveal (consider splitting it into words/lines for a staggered cascade), then the CTA button settling into place — this kind of precise, multi-step sequencing is exactly where GSAP shines over per-component libraries
- **"How it works" scroll storytelling (GSAP `ScrollTrigger`)**: pin the feature strip and scrub each Read → Earn → Build → Collect card into view as the user scrolls, for a cinematic, state-of-the-art feel — fall back to simple staggered reveals (see below) on narrow viewports where pinning gets cramped
- **Scroll-triggered reveals** (everywhere else): sections and cards animate in with staggered fade + slight upward slide as they enter the viewport — use Motion's `whileInView`/`viewport={{ once: true }}` for routine card/section reveals, reserving GSAP `ScrollTrigger` for the two showcase moments above so the two libraries don't compete for the same elements
- **Hover/tap micro-interactions**: buttons gently scale and shift hue on hover, cards lift with a soft shadow, villager carousel cards "bounce" slightly on focus — small, springy, playful (use Motion's `spring` transitions, not linear easing — linear reads as robotic, springs read as kawaii)
- **Page transitions**: a soft cross-fade or slide between Home/News/Privacy/Terms via `AnimatePresence`
- **Carousel**: auto-advances on a gentle interval, pauses on hover/focus/touch, supports drag/swipe, includes accessible prev/next controls and dot indicators
- **Reduced motion**: respect `prefers-reduced-motion` — fall back to simple opacity fades, no parallax/spring bounce/pinning/scrubbing, for users who've requested it (GSAP timelines and `ScrollTrigger` instances should check `window.matchMedia('(prefers-reduced-motion: reduce)')` and skip straight to the end state, or use `gsap.matchMedia()` to define a reduced-motion variant of each timeline)

---

## 7. Responsive requirements

Mobile-first. Verify the layout at minimum: **375px** (small phone), **768px** (tablet/portrait), **1024px** (tablet landscape / small laptop), **1440px+** (desktop). The header collapses to a drawer below ~768px; the villager carousel should show 1.2–2 cards on mobile (peek effect) and 4–6 on desktop; the feature strip stacks vertically on mobile and goes to a row/grid on desktop.

---

## 8. Content copy — reuse, don't reinvent

To keep the brand voice identical everywhere a visitor encounters it, seed all hero/feature/CTA copy from what's already written and approved in this repo:

- **Tagline & elevator pitch**: `MARKETING.md` → Part 0 → "Core elevator pitch"
- **Feature descriptions**: the `📚 / 🏘️ / 🐾 / 🎮 / 🎰 / 🎉 / 🎯` bullet sections of the English full description in `PLAY_STORE.md` → Step 3.2 → "English (en-US)"
- **Devlog seed posts for News**: adapt the angles described in `MARKETING.md` → Part 1 → Step 1.6, and the trailer storyboard beats in Part 5 → Step 5.4

Translate emoji section markers into real icon components (`lucide-react` or similar) where they appear as visual bullets in the app's own marketing copy — the game's CLAUDE.md brand rule is "use real icons, not emojis," and a polished website should hold to that even more strictly than social captions do.

---

## 9. Deployment & domain

- Recommended hosts: **Vercel** or **Netlify** — both auto-deploy from GitHub on push, handle SPA routing with zero config, and connect a custom domain for free.
- The user is considering buying a custom domain (~$11/yr). Once purchased, point its DNS at the chosen host (CNAME/A records per the host's docs) and configure it in the host's dashboard. The same domain should host this site, the Privacy Policy page (e.g. `https://<domain>/privacy`), and the Terms & Conditions page (e.g. `https://<domain>/terms`) — the privacy URL is what gets submitted to the Play Console "Privacy policy" field described in `PLAY_STORE.md`, and the in-app consent screen links to both.
- Set up a `robots.txt` and basic `sitemap.xml`, and Open Graph / Twitter Card meta tags using the logo and/or the new horizontal banner as the share-preview image — this directly improves how links look when shared on every platform listed in `MARKETING.md`.

---

## 10. Future refactor — migrate to Next.js Static Export (SSG)

### Why this wasn't done at initial build time

The site was built with Vite + React (CSR). The decision to stay on CSR was deliberate: the site has only 4 pages (Home, News, Privacy, Terms), all static, with no per-URL dynamic content. Googlebot renders JavaScript fine, and the Open Graph tags live in the root `index.html` so social previews work. The migration cost (see below) outweighed the marginal SEO gain for 4 pages at launch.

The immediate priority at the time was shipping the site fast so the Privacy Policy URL could be submitted to Google Play Console for app review.

### When to do this refactor

Migrate when **either** of these is true:

- The `/news` section has grown to 10+ individual post pages that each need their own URL, title, description, and OG image for indexing and social sharing — CSR serves the same `index.html` for every URL, so crawlers see identical meta for every post.
- Core Web Vitals audit shows LCP (Largest Contentful Paint) consistently above 2.5s on mobile — SSG ships pre-rendered HTML which eliminates the JS parse-then-render delay and directly improves LCP.

### What the migration involves

Replace Vite with **Next.js (App Router) in full static export mode** (`output: 'export'` in `next.config.ts`). This generates a fully pre-rendered `out/` folder of HTML/CSS/JS that deploys to Netlify identically to the current `dist/` — no Node.js server required.

**Key things to handle carefully:**

1. **All animation components need `'use client'`** — `HeroSection`, `HowItWorksSection`, `VillagerCarousel`, `ScreenshotGallery`, `ClosingCTABand`, `Header`, `Footer`. Every component that uses `useRef`, `useEffect`, `useGSAP`, `useEmblaCarousel`, or any Motion hook must be a Client Component. Layout-only wrappers (page shells, `Section`) can stay as Server Components.

2. **Lenis + GSAP ScrollTrigger must initialize client-side only** — move `useLenis` hook initialization inside a `useEffect` with an empty dep array, or wrap in `dynamic(() => import(...), { ssr: false })`. ScrollTrigger reads `window` and `document` and will throw during SSR if called at module level.

3. **React Router → Next.js App Router** — replace `<BrowserRouter>` + `<Routes>` + `<Route>` with the App Router file-system conventions: `app/page.tsx` (Home), `app/news/page.tsx`, `app/privacy/page.tsx`, `app/terms/page.tsx`. The `AnimatePresence` page-transition wrapper moves to `app/layout.tsx`.

4. **Per-page metadata** — replace the single `index.html` `<head>` block with Next.js `export const metadata: Metadata = { ... }` in each `page.tsx`. This is the main SEO payoff: each page gets its own `<title>`, `<meta name="description">`, and `og:*` tags baked into the HTML at build time.

5. **News posts as static params** — if news posts become individual pages, use `generateStaticParams()` in `app/news/[slug]/page.tsx` to pre-render each post at build time from the `src/data/news.ts` array (or a future Markdown/MDX source).

6. **`_redirects` → not needed** — Next.js static export generates real `index.html` files per route (e.g. `out/privacy/index.html`), so the Netlify SPA catch-all redirect is no longer required. Remove `public/_redirects` and the `[[redirects]]` block from `netlify.toml`; keep the security headers block.

7. **Package manager stays Bun** — Next.js works fine with Bun. `bun create next-app` or manual scaffold with `bun add next react react-dom`.

### Rough effort estimate

3–5 hours for an experienced developer familiar with the existing component structure. The animation-heavy sections (GSAP pin/scrub, Lenis) are the main risk area — test each on a local dev server before declaring done.

---

## 11. Suggested execution plan

1. Scaffold the Vite + React + TS + Tailwind project with `bun create vite` (choose React + TypeScript), then `bun add` all dependencies listed in Section 2; wire up the color tokens and fonts first so every component built afterward inherits the right look from day one.
2. Build the Header/Footer shell and routing (Home/News/Privacy/Terms) before any animation work — get the skeleton navigable first.
3. Build the Home page section by section, bottom-up on complexity: static layout → Tailwind styling → Motion reveal animations → Lenis smooth-scroll integration last (it affects the whole page, so wire it in once sections exist to scroll through).
4. Build the villager carousel as its own isolated component with mock data, then wire in the real 42-species asset list.
5. Write the News, Privacy, and Terms & Conditions pages (Privacy and Terms content are provided verbatim above — both just need the same two placeholders filled in by the user).
6. Pass for responsiveness at all four breakpoints, then accessibility (keyboard nav, `prefers-reduced-motion`, alt text on every villager/screenshot image), then performance (image optimization/lazy-loading — 42 villager sprites plus full-scene backgrounds is a lot of weight to ship naively).
7. Confirm with the user before connecting the real domain or pushing a public deploy.
