# Unity Ads — Complete Integration Guide for My Reading Village

This guide documents the Unity Ads setup for My Reading Village. The account and app registration are already complete — follow the steps below only when you are ready to enable real ads.

---

## Current Status

| Item | Status |
|---|---|
| Unity Ads account | Created at unity.com |
| App registered in Unity Dashboard | Done — "My Reading Village" (Android) |
| Game ID | `800005941` |
| Placement ID (Rewarded) | `Rewarded_Android` |
| SDK integrated in Flutter | Done — `unity_ads_plugin: ^0.3.30` |
| W-8BEN tax form | Signed |
| `unityAds` flag | `false` (simulation mode) |
| Play Store URL in Unity Dashboard | Pending — add once app is published |

---

## PART 1 — Enable Real Ads

When you are ready to go to production:

### Step 1.1 — Update app_constants.dart

Open `my_reading_village/lib/app_constants.dart` and change:

```dart
static const bool unityAds = false;
static const bool playStore = false;
```

to:

```dart
static const bool unityAds = true;
static const bool playStore = true;
```

When `unityAds = true`:
- The Unity Ads SDK initializes on app start.
- Real rewarded video ads are loaded and shown.
- Users earn in-game rewards only after watching a full ad.
- The stored GDPR consent (from the in-app consent banner) is automatically passed to Unity Ads on startup.

When `unityAds = false` (default / simulation mode):
- No real ads are loaded.
- Tapping any "Watch Ad" button shows a test-mode dialog.
- The user can press "Simulate Watched" to receive the reward instantly.
- No Unity Ads account or internet connection needed for testing.

### Step 1.2 — Add Play Store URL to Unity Dashboard

Once the app is published on Google Play:

1. Go to unity.com → Dashboard → My Reading Village project.
2. Edit the app entry and paste in the Play Store URL.
3. This is required for Unity Ads to fully verify the app for production ad serving.

---

## PART 2 — Where Ads Are Used in the App

The app uses a single Rewarded placement (`Rewarded_Android`) in three places:

### 2.1 — In-Progress Construction Modal (Skip Time)

- **Trigger**: User taps "Watch Ad (−10 min)" while a building is under construction.
- **Reward**: 10 minutes are subtracted from the remaining construction time for that building.
- **Cooldown**: 30 seconds between ads per building (enforced by `AppConstants.adSkipCooldownMs`).

### 2.2 — Lucky Wheel / Roulette (Free Spin)

- **Trigger**: User taps "Watch Ad" in the "Free Spin via Ads" section inside the Lucky Wheel dialog.
- **Progress**: Watching 3 ads (not necessarily consecutive) earns 1 free spin.
- **Limits per day**: Maximum 3 ad-earned free spins per day (9 ads total). Only 1 pending spin at a time.
- **Resets**: All counters reset at midnight daily.

### 2.3 — Store → Gems Tab (Free Gems)

- **Trigger**: User taps "Watch Ad" in the "5 Free Gems via Ads" container at the top of the Gems tab.
- **Progress**: Watching 3 ads earns 5 gems automatically upon completing the 3rd ad.
- **Daily limit**: Once per day. Resets at midnight daily.

---

## PART 3 — Testing Before Going Live

### Step 3.1 — Simulation Mode (No Unity Account Required)

While `unityAds = false`, all "Watch Ad" buttons show the test dialog — no real Unity Ads account or internet needed.

### Step 3.2 — Test Mode with Real SDK (unityAds = true, playStore = false)

When `unityAds = true` and `playStore = false`, the SDK runs with `testMode: true`, which means Unity Ads returns test ads (no real impressions, no revenue, no policy risk). Use this to verify the full ad flow on a real device before going to production.

### Step 3.3 — Production (unityAds = true, playStore = true)

Both flags `true` = real ads, real revenue, GDPR consent applied. Only use this in production builds uploaded to Play Console.

---

## PART 4 — Payments

Unity Ads pays via wire transfer (bank transfer) directly to your bank account. There is no minimum payout threshold comparable to AdMob's $100 — payments are processed monthly.

**Recommended**: use **Wise** (wise.com) as your receiving bank account. Wise provides a real bank account with SWIFT/BIC that accepts international wire transfers, has low fees, and works from Bolivia. This is the most widely used solution by indie developers in Latin America receiving payments from Unity, Google, Apple, and similar platforms.

Tax form W-8BEN has already been signed (2026-06-14). No U.S. tax withholding applies since services are performed outside the United States and Bolivia has no tax treaty with the U.S.

---

## PART 5 — Unity Ads Dashboard Monitoring

Once ads are live, monitor performance at unity.com → Dashboard → My Reading Village:

- **Monetization overview**: impressions, fill rate, eCPM, estimated revenue.
- **Placement stats**: break down by placement ID (`Rewarded_Android`), country, date range.
- **Mediation** (optional future step): Unity LevelPlay (formerly IronSource) can mediate across multiple ad networks (AppLovin MAX, Meta Audience Network, etc.) to maximize fill rate and revenue.

---

## PART 6 — Privacy and Consent

Unity Ads GDPR consent is automatically handled by the app:

- On startup, `AdService` reads the stored consent from the database and passes it to Unity Ads via `UnityAds.setPrivacyConsent(PrivacyConsentType.gdpr, ...)`.
- When the user changes their consent in the in-app consent dialog, `AdService.setConsent()` is called alongside `AnalyticsService.setConsent()`.
- If the user has not consented, Unity Ads shows non-personalized ads (lower CPM but still functional).

No additional consent handling is required.

---

## Quick Reference Checklist

- [x] Create Unity Ads account at unity.com
- [x] Register app "My Reading Village" (Android) — Game ID `800005941`
- [x] Create Rewarded placement — Placement ID `Rewarded_Android`
- [x] Integrate `unity_ads_plugin: ^0.3.30` in Flutter
- [x] Add `com.google.android.gms.permission.AD_ID` to AndroidManifest.xml
- [x] Sign W-8BEN tax form
- [ ] Set up payment method (Wise recommended)
- [ ] Set `unityAds = true` and `playStore = true` in `app_constants.dart`
- [ ] Build release AAB and upload to Play Console Internal Testing
- [ ] Test ads on a real device with `testMode: true` first
- [ ] Add Play Store URL to Unity Dashboard once app is published
- [ ] Roll out to production
