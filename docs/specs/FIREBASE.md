# Firebase Analytics Setup — My Reading Village

Firebase Analytics is **100% free** on the Spark plan. This document covers the one-time setup you must complete before building the app for Android. iOS is not in scope.

---

## What's already done in the code

- `firebase_core` and `firebase_analytics` packages added to `pubspec.yaml`
- `google-services` Gradle plugin declared in `android/settings.gradle.kts`
- Plugin applied in `android/app/build.gradle.kts`
- Placeholder `android/app/google-services.json` created (package name: `com.ferchostudiodev.my_reading_village`)
- Firebase initialized in `main.dart` (wrapped in try/catch — app works fine if not yet configured)
- `AnalyticsService` manages all events and consent
- Consent modal shown after onboarding completes
- Analytics toggle in Settings → Data tab

**The only thing you need to do is replace the placeholder `google-services.json` with the real one from your Firebase project.**

---

## Step-by-step: Create your Firebase project

### 1. Create a Firebase account / project

1. Go to [https://console.firebase.google.com](https://console.firebase.google.com)
2. Sign in with a Google account (ideally the same one used for Google Play Console)
3. Click **"Add project"**
4. Name it: `My Reading Village`
5. **Disable Google Analytics** — we use Firebase Analytics independently, no need for a linked GA4 property for basic usage (you can enable it later if you want BigQuery export)
6. Click **Create project**

---

### 2. Add your Android app to the project

1. In the Firebase Console, click the **Android icon** (Add app)
2. Fill in:
   - **Android package name**: `com.ferchostudiodev.my_reading_village`  
     *(must match exactly — this is your `applicationId` in `android/app/build.gradle.kts`)*
   - **App nickname**: `My Reading Village Android`
   - **Debug signing certificate SHA-1**: optional for analytics, skip for now
3. Click **Register app**

---

### 3. Download `google-services.json`

1. Firebase will prompt you to download `google-services.json`
2. Click **Download google-services.json**
3. Place it at: `android/app/google-services.json`  
   *(replace the placeholder file already there)*
4. Click **Next** on Firebase Console until you reach "You're all set"

---

### 4. Build and verify

Run the app on a device or emulator:

```bash
flutter run
```

The app should launch normally. Firebase initialization runs silently — if it fails (wrong JSON, no internet), the app still works because it's wrapped in a try/catch.

---

### 5. Verify events in Firebase Console

1. Go to Firebase Console → **Analytics → DebugView**
2. On your device/emulator, run:
   ```bash
   adb shell setprop debug.firebase.analytics.app com.ferchostudiodev.my_reading_village
   ```
3. Interact with the app (go through onboarding, accept analytics, log some pages)
4. Events should appear in DebugView within a few seconds

To disable DebugView mode:
```bash
adb shell setprop debug.firebase.analytics.app .none.
```

---

## Events tracked by the app

| Event | When fired |
|---|---|
| `pages_logged` | User logs reading pages |
| `book_completed` | Book reaches 100% pages read |
| `book_rated` | User rates a book after completing it |
| `book_note_saved` | User saves a note on a book |
| `building_placed` | Building placed on the map |
| `chunk_unlocked` | Map expansion purchased |
| `level_up` | Player reaches a new level |
| `mission_claimed` | Mission reward collected |
| `villager_choice_made` | User picks a villager species |
| `species_unlocked` | New species unlocked (level-up reward) |
| `roulette_spun` | Roulette wheel spin (free / ad / paid) |
| `ad_watched` | Rewarded ad watched (roulette or gems) |
| `iap_purchase` | In-app purchase completed |
| `reading_modal_opened` | Reading tracker opened |
| `stats_dialog_opened` | Statistics dialog opened |
| `backpack_opened` | Backpack opened |
| `species_gallery_opened` | Species gallery opened |
| `store_opened` | Store opened |
| `settings_opened` | Settings opened |
| `photo_taken` | Village screenshot taken |
| `data_exported` | Backup exported |
| `data_imported` | Backup imported |
| `language_changed` | Language changed in settings |
| `tutorial_completed` | Onboarding tour finished |
| `analytics_consent_given` | User enabled analytics |
| `analytics_consent_revoked` | User disabled analytics |

## User properties set automatically

| Property | Updated when |
|---|---|
| `player_level` | Level up |
| `building_count` | Building placed |
| `villager_count` | Villager confirmed |
| `expansion_count` | Chunk unlocked |
| `total_books_completed` | Book completed |
| `total_pages_read` | Pages logged |
| `has_made_iap` | IAP purchase completed |
| `language` | Language changed |

---

## Firebase plan / pricing

- **Spark plan = $0/month**, no credit card required
- Firebase Analytics has no event limit, no data retention cost
- The Spark plan only limits other services (Firestore, Functions, Storage) — none of which this app uses
- If you later want SQL queries over raw event data, you can upgrade to **Blaze** (pay-as-you-go) and enable **BigQuery export** — but the analytics dashboard itself stays free forever

---

## Anonymous user ID

The app generates a random `analytics_id` stored in SQLite on first launch. This ID:
- Is set as Firebase's custom user ID via `setUserId()`
- Travels with the user's backup — if they uninstall, reinstall, and import their backup, the same ID is restored
- Has no connection to any personal data, name, email, or account
- Satisfies GDPR/CCPA anonymous data requirements

Firebase also generates its own `app_instance_id` per install (unrelated to ours) — this one resets on reinstall but is only used for Firebase's internal retention metrics.

---

## Troubleshooting

**"No matching client found for package name"**  
→ The `package_name` in `google-services.json` doesn't match your `applicationId`. Double-check both.

**Events not showing in DebugView**  
→ Make sure you ran the `adb setprop` command above. Events only appear in DebugView when debug mode is active.

**Build fails with "google-services.json not found"**  
→ Make sure the file is in `android/app/`, not `android/`.

**"Firebase: No Firebase App '[DEFAULT]' has been created"**  
→ `Firebase.initializeApp()` in `main.dart` runs before any Firebase usage. If you see this, check that the `google-services.json` is valid and matches your package name.
