# Google AdMob — Complete Integration Guide for My Reading Village

This guide explains how to go from zero to real ads running inside the app. Follow every step in order before setting `googleAds = true` in `lib/app_constants.dart`.

---

## PART 1 — Create a Google AdMob Account

### Step 1.1 — Sign in to AdMob

1. Open https://admob.google.com
2. Sign in with the same Google account you use for the Play Console (recommended, but not required).
3. If this is your first time, accept the AdMob Terms of Service.

### Step 1.2 — Set Up Payments

1. In the left menu go to **Payments > Payments info**.
2. Enter your payment details (bank account or transfer). AdMob pays you when your balance reaches the payment threshold (usually $100 USD).
3. Provide your tax information if prompted (required for payout).

### Step 1.3 — Verify Your Identity

Google may ask you to verify your identity before your account is fully active. Follow any verification prompts in the AdMob dashboard.

---

## PART 2 — Create Your App in AdMob

### Step 2.1 — Add the App

1. In AdMob, click **Apps** in the left menu.
2. Click **Add app**.
3. Choose **Android** as the platform.
4. If your app is not yet published on the Play Store, select **"No, my app isn't listed in a supported app store"**.
5. Enter the app name: **My Reading Village**.
6. Click **Add**.

### Step 2.2 — Copy Your AdMob App ID

After adding the app, AdMob shows you an **App ID** in the format:

```
ca-app-pub-XXXXXXXXXXXXXXXX~XXXXXXXXXX
```

You will need this. Keep this page open.

---

## PART 3 — Configure the App with Your AdMob App ID

### Step 3.1 — Update AndroidManifest.xml

Open `my_reading_village/android/app/src/main/AndroidManifest.xml` and replace the test App ID with your real one:

```xml
<meta-data
    android:name="com.google.android.gms.ads.APPLICATION_ID"
    android:value="ca-app-pub-XXXXXXXXXXXXXXXX~XXXXXXXXXX"/>
```

Replace `ca-app-pub-XXXXXXXXXXXXXXXX~XXXXXXXXXX` with your actual AdMob App ID from Step 2.2.

---

## PART 4 — Create a Rewarded Ad Unit

All three ad placements in the app use **Rewarded ads** (the user watches a video and earns a reward).

### Step 4.1 — Create the Ad Unit

1. In AdMob, go to **Apps > My Reading Village > Ad units**.
2. Click **Add ad unit**.
3. Select **Rewarded**.
4. Give it a name: e.g., `my_reading_village_rewarded`.
5. Leave all other settings at their defaults.
6. Click **Create ad unit**.

### Step 4.2 — Copy the Ad Unit ID

After creation, AdMob shows you the **Ad Unit ID** in the format:

```
ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX
```

### Step 4.3 — Update app_constants.dart

Open `my_reading_village/lib/app_constants.dart` and replace the placeholder with your real ad unit ID:

```dart
static const String _adUnitIdReal = 'ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX';
```

Replace the value with the actual Ad Unit ID from Step 4.2.

---

## PART 5 — Enable Real Ads

### Step 5.1 — Turn on googleAds

In `my_reading_village/lib/app_constants.dart`, change:

```dart
static const bool googleAds = false;
```

to:

```dart
static const bool googleAds = true;
```

When `googleAds = true`:

- The AdMob SDK initializes on app start.
- Real rewarded video ads are loaded and shown.
- Users earn in-game rewards only after watching a full ad.

When `googleAds = false` (default / test mode):

- No real ads are loaded.
- Tapping any "Watch Ad" button shows a test-mode dialog.
- The user can press "Simulate Watched" to receive the reward instantly.
- No AdMob account or internet connection needed for testing.

---

## PART 6 — Where Ads Are Used in the App

The app uses a single Rewarded ad unit in three different places:

### 6.1 — In-Progress Construction Modal (Skip Time)

- **Trigger**: User taps "Watch Ad (−10 min)" while a building is under construction.
- **Reward**: 10 minutes are subtracted from the remaining construction time for that specific building.
- **Daily limit**: None. The user can watch as many ads as needed to complete construction.
- **Example**: A Water Tower (Level 1, 40 min) requires 4 ads to skip the entire wait.

### 6.2 — Lucky Wheel / Roulette (Free Spin)

- **Trigger**: User taps "Watch Ad" in the "Free Spin via Ads" section inside the Lucky Wheel dialog.
- **Progress**: Watching 3 ads (not necessarily consecutive) earns 1 free spin. A counter (0/3, 1/3, 2/3, 3/3) shows progress.
- **Reward**: A pending free spin is granted. The user spins by pressing the regular Spin button.
- **Limits per day**:
  - Maximum 3 ad-earned free spins per day (9 ads total).
  - Only 1 ad-earned spin can be pending at a time. The user must use the spin before earning another.
  - The ad-earned spin and the daily free spin can coexist (user can spin twice).
- **Resets**: All counters reset at midnight daily.

### 6.3 — Store → Gems Tab (Free Gems)

- **Trigger**: User taps "Watch Ad" in the "5 Free Gems via Ads" container at the top of the Gems tab.
- **Progress**: Watching 3 ads earns 5 gems automatically upon completing the 3rd ad.
- **Daily limit**: Once per day. After claiming, the section shows "Claimed today! Come back tomorrow."
- **Resets**: Resets at midnight daily.

---

## PART 7 — Testing Before Going Live

### Step 7.1 — Use Test Ad Unit IDs (Already Configured)

While `googleAds = false`, the app uses Google's official test Ad Unit ID:

- **Rewarded**: `ca-app-pub-3940256099942544/5224354917`

And the test App ID in the manifest:

- `ca-app-pub-3940256099942544~3347511713`

These IDs are safe to use during development — they always return test ads and never generate real revenue or policy violations.

### Step 7.2 — Add Your Device as a Test Device (When googleAds = true)

When testing with real ad unit IDs on a real device:

1. Run the app and watch the logcat output for a line like:
   ```
   Use RequestConfiguration.Builder().setTestDeviceIds(Arrays.asList("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"))
   ```
2. Copy that hash string.
3. In AdMob → **Settings > Test devices**, add your device hash.

This ensures test devices see test ads (not charged impressions) even with real ad unit IDs.

### Step 7.3 — Simulation Mode Dialog

When `googleAds = false`, tapping any "Watch Ad" button shows:

> **Ad Test Mode**
> This is a simulated ad. In production with Google Ads enabled, a real rewarded video ad would play here.

Press **"Simulate Watched"** to receive the reward. Press **Cancel** to dismiss without reward.

---

## PART 8 — AdMob Policies

Before going live, your app must comply with AdMob policies:

1. **Privacy Policy**: You must have a Privacy Policy that discloses ad data collection. Add the URL to your Play Console store listing and inside the app settings.
2. **Content Policy**: Ads must not appear in inappropriate content. The app's content rating must be accurate.
3. **Ad Placement**: Do not place ads that users are likely to click accidentally. The current placement (full-screen rewarded ads triggered by explicit user tap) is compliant.
4. **COPPA**: If your app targets children under 13, you must configure child-directed treatment. See: https://support.google.com/admob/answer/9857753

---

## PART 9 — AdMob Dashboard Monitoring

Once ads are live, monitor performance at https://admob.google.com:

- **Home dashboard**: Daily impressions, clicks, eCPM, and estimated revenue.
- **Reports**: Break down by ad unit, country, date range.
- **Mediation** (optional): Add other ad networks (Meta, AppLovin, etc.) to increase fill rate and revenue.

---

## Quick Reference Checklist

- [ ] Create AdMob account at https://admob.google.com
- [ ] Set up payment profile
- [ ] Add app "My Reading Village" (Android) in AdMob
- [ ] Copy **AdMob App ID** → update `AndroidManifest.xml`
- [ ] Create one **Rewarded** ad unit named `my_reading_village_rewarded`
- [ ] Copy **Ad Unit ID** → update `_adUnitIdReal` in `app_constants.dart`
- [ ] Set `googleAds = true` in `app_constants.dart`
- [ ] Build release AAB and upload to Play Console Internal Testing
- [ ] Test ads on a real device (add device as test device in AdMob)
- [ ] Verify policy compliance (Privacy Policy, content rating, COPPA if needed)
- [ ] Set `playStore = true` in `app_constants.dart` when publishing
- [ ] Roll out to production
