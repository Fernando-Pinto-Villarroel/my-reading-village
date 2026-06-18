# Bug Report — Second Round Verification — June 12, 2026

Scope: verification pass over the fixes applied (by Opus/Sonnet) for every finding in `BUGS_REPORT_JUNE_12_2026_1.md`, plus a fresh senior-engineer review of the changed code. `flutter analyze` is clean after this pass.

All paths relative to `my_reading_village/`.

---

## 1. Verification of round-1 findings

### CRITICAL — all 4 fixed

| ID                                            | Status    | Evidence                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
| --------------------------------------------- | --------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| C1 (IAP never granted)                        | **FIXED** | `StoreService` is a `get_it` singleton (`service_locator.dart:60`), initialized at app start (`main.dart`). `_grantAndAcknowledge` (`store_service.dart:99-114`) grants the entitlement to the repo **before** calling `completePurchase`; granted product IDs are queued (`_grantedProductIds`) and the store dialog listens (`store_dialog.dart:_onPurchaseStateChanged`) to refresh resources and show popups. If a grant throws, the purchase is NOT acknowledged, so Google redelivers — no money lost. Residual risk: see **N2** below. |
| C2 (gems via buyNonConsumable)                | **FIXED** | `_launchPurchase` (`store_service.dart:198-204`) routes species → `buyNonConsumable`, everything else → `buyConsumable`. `docs/specs/PLAY_STORE.md` Steps 4.2-4.4 correctly document Consumable vs Non-consumable types.                                                                                                                                                                                                                                                                                                                      |
| C3 (speed-up rollback destroys paid progress) | **FIXED** | `BuildingService.speedUpConstruction` (`building_service.dart:462-472`) now persists `construction_start = now − duration` before `markBuildingConstructed`; the dead in-memory assignment in the provider was removed. `rollbackFraudulentConstructions` (`database_helper_building_operations.dart:103-125`) only resets rows whose `construction_start` is **in the future** — impossible without clock tampering, so zero false positives. Residual gap: see **N1**.                                                                      |
| C4 (stopwatch deep-sleep false positives)     | **FIXED** | `onResume` re-baselines on forward drift and only flags backward drift; network sync runs **before** any rollback (initialize ordering corrected in this session — see §2); `onPause` persists `last_seen_at` (wired in this session); `last_seen_at`/`last_trusted_at` columns added; a dismissible kawaii warning banner shows when suspicious (`game_screen.dart:_ClockWarningBanner`).                                                                                                                                                    |

### HIGH — all 5 fixed

| ID                                      | Status    | Evidence                                                                                                                                                                                                                                                                                                                                                                           |
| --------------------------------------- | --------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| H1 (roulette races)                     | **FIXED** | Reentrancy guard at top of `_spin()` + `_isSpinning` set before the charge; reward is **persisted before the 4s animation** so a mid-animation kill no longer eats the spin (`roulette_dialog.dart:294-360`). Analytics call moved after the successful charge (this session).                                                                                                     |
| H2 (reading rewards dropped on unmount) | **FIXED** | `addResources`/`checkMissions` now run unconditionally after `logPages`; only the popup/sound stays behind `context.mounted` (`log_pages_dialog.dart:284-296`).                                                                                                                                                                                                                    |
| H3 (negative balances)                  | **FIXED** | `subtractResources` is conditional (`WHERE … AND coins >= ? AND gems >= ? …`) and returns `bool` (`database_helper_game_state_operations.dart:19-26`). All 7 call sites check the result and abort (BuildingService ×5, spinRoulette, refreshSpeciesForGems — the latter also gained the missing balance pre-check).                                                               |
| H4 (splash swallows init errors)        | **FIXED** | Per-step try/catch; village/book load failures show a retry dialog instead of navigating; favorites/tips failures degrade gracefully (`splash_screen.dart:178-300`).                                                                                                                                                                                                               |
| H5 (silent import + blind inserts)      | **FIXED** | `importAllTables` filters row keys against `PRAGMA table_info` per table; `_validateBackup` rejects `version > 3`; the trailing `catch (_) {}` in `_handleImport` now shows an error toast. Backups are additionally AES-GCM encrypted `.mrvb` files (`lib/infrastructure/security/backup_cipher.dart`) with a `tampered_backup` error path — part of the VULNERABILITIES.md work. |

### MEDIUM — all 7 fixed (one partial)

| ID                                 | Status           | Evidence                                                                                                                                                                                                                                              |
| ---------------------------------- | ---------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| M1 (cover filename collisions)     | **FIXED**        | `cover_${importTs}_$i$ext` (`database_helper_backup_operations.dart:138`).                                                                                                                                                                            |
| M2 (restore-purchases sync)        | **MOSTLY FIXED** | Queue-based `consumeGrantedProductIds()`, listener-driven completion with 5s idle timer + 30s cap, singleton service no longer disposed (`settings_dialog.dart:_handleRestorePurchases`). Remaining: still the only restore entry point — see **N4**. |
| M3 (fire-and-forget happiness)     | **FIXED**        | `updateVillagerHappiness` is `Future<void>`, awaits writes; all call sites await it.                                                                                                                                                                  |
| M4 (CME / un-awaited loadData)     | **FIXED**        | `for (final b in List.of(_placedBuildings))` in `_crystallizeExpiredSpeedups`; minigames `onReturn` awaits `loadData()` before `_syncGameState()`.                                                                                                    |
| M5 (device-date daily resets)      | **FIXED**        | `_todayStr`, `canSpinDailyFree`, `_currentIsoWeek`, event resolution, store discounts and species rotation all route through `trustedNow()`. Three leftovers closed in this session (§2).                                                             |
| M6 (mission species lost on crash) | **FIXED**        | `claimMissionReward` persists `unlockSpecies(resolvedSpeciesId)` before returning (`village_provider.dart:1181`); the UI `applySpeciesBonus` is now idempotent presentation (`ConflictAlgorithm.ignore`).                                             |
| M7 (stale completed_at)            | **FIXED**        | New `completed_at` column; set on completion in `logPages`, set/cleared on transitions in `editSession`/`deleteSession` (`reading_service.dart:183-185, 263-267, 283-285`).                                                                           |

### LOW — all 10 fixed

L1 `PRAGMA foreign_keys = ON` via `onConfigure` ✓ · L2 `cleanupExpiredPowerups` deleted ✓ · L3 hardcoded `displayName`/`description` removed ✓ · L4 dead `'exp': 0` reward removed ✓ · L5 `tz.setLocalLocation` no-op removed ✓ · L6 strip logic uses `SpeciesRules.starterSpecies` ✓ · L7 export errors toast ✓ · L8 single `SpeciesRules.isoWeek` shared ✓ · L9 stream `onError` sets error state ✓ · L10 `LanguageProvider.load` after import ✓ (analytics consent re-read added this session).

---

## 2. Small remnant fixes applied in THIS session

All verified with `flutter analyze` (clean):

1. **Daily free spin re-grant via clock change** — `spinRoulette` stored the free-spin timestamp with `DateTime.now()` while `canSpinDailyFree` compares against `trustedNow()`; setting the device clock a day ahead made the stored date ≠ trusted date, re-granting the free spin instantly. Now stores `trustedNow()` (`village_provider.dart:485`). Also moved `logRouletteSpin` after the successful charge so failed spins are not logged.
2. **Holiday mission tree gated by device date** — `missions_tree_tab.dart:27` used `DateTime.now()` to decide event branch visibility (the exact out-of-date-event abuse CLAUDE.md targets); now `trustedNow()`.
3. **Species refresh countdown** — `store_dialog.dart:_nextRefreshText` counted to device-midnight while the rotation itself uses trusted date; now counts to trusted midnight.
4. **Building placement double-tap** — `_placeBuilding` had no reentrancy guard; a fast double-tap could insert two stacked buildings on the same tile (balances were already safe via H3). Added `_isPlacingBuilding` guard with try/finally, and the handler now checks `placeBuilding`'s null result: failed placements show the not-enough-resources toast instead of playing the construction sound (`game_screen_tap_handlers.dart`).
5. **Rollback before network correction** — `TimeVerificationService.initialize` rolled back constructions _before_ `_syncWithNetwork()` (i.e., with a possibly-wrong device clock) and then again after. Now: sync first, single rollback with the corrected clock.
6. **Stale in-memory state after resume rollback** — `onResume` now returns the rolled-back count; `game_screen.didChangeAppLifecycleState` reloads `VillageProvider` and re-syncs the game when count > 0, so the map no longer shows buildings the DB just un-constructed.
7. **`onPause` was never called** — `last_seen_at` only persisted at launch/resume, weakening cross-session backward-clock detection. Wired `sl<TimeVerificationService>().onPause()` into the existing lifecycle observer in `main.dart`.
8. **Analytics consent stale after import** — import replaces `game_state` (including `analytics_consent`/`analytics_id`) but `AnalyticsService` kept its cached values. Added `await sl<AnalyticsService>().initialize()` to `_handleImport` (the method is safely re-runnable).

---

## 3. NEW findings — larger fixes for a follow-up session

### N1. HIGH (business critical gap): forward-clock construction exploit is NOT detected

**Files:** `lib/infrastructure/persistence/database_helper_building_operations.dart:103-125` (`rollbackFraudulentConstructions`), `lib/application/services/building_service.dart:374-388` (`checkAndCompleteConstructions`, uses device-clock `effectiveRemainingTime`).

**Gap:** The rollback only flags `construction_start > trustedNow`, which catches _backward_ tampering signatures. The primary abuse is _forward_: place a building → set the device date +10 days → the 1-second timer (driven by `DateTime.now()`) sees zero remaining and completes it → restore the date. The resulting row has `construction_start` in the past and `is_constructed = 1` — indistinguishable from a legit row under the current check. The naive `start + duration > now` check can't be reinstated because sandwich-boosted completions legitimately finish ahead of schedule and the powerup rows are deleted after expiry (no way to reconstruct at the DB level).

**Why it can't be a small fix:** completion needs to be driven by trusted time, and the "ahead of schedule" credit must be persisted at completion, not recomputed. Suggested design (consistent with `docs/specs/VULNERABILITIES.md` task 2 — CLAUDE.md requires presenting a proposal to the owner before implementing):

1. Persist a `completes_at` (ISO string) on `placed_buildings`, computed with `trustedNow()` at placement/upgrade.
2. When a sandwich boost is crystallized or a gem speed-up applied, update `completes_at` accordingly (this replaces the start-rewriting trick from C3 with an explicit field).
3. `effectiveRemainingTime` / `checkAndCompleteConstructions` compare `completes_at` against `trustedNow()` instead of `DateTime.now()`.
4. `rollbackFraudulentConstructions` resets `is_constructed = 1` rows where `completes_at > trustedNow + 2min` — a clean fraud signature with no false positives, covering both directions of tampering.
5. Schema change is fine per project rules (version stays 1, DB can be reset; remember to keep `importAllTables`'s column filtering happy — it already tolerates new columns).

Known residual limit (document, don't fight it): a fully **offline** mid-session forward jump is indistinguishable from deep sleep; only the network sync or intentional manual device date/hour modification can catch it. That matches the spec's "internet + best-effort offline" requirement.

### N2. MEDIUM: consumable double-grant window in IAP delivery

**File:** `lib/application/services/store_service.dart:99-114`.

**Bug:** `_grantAndAcknowledge` grants, then acknowledges. If the app is killed between the two, Google redelivers the purchase on next launch and the gems/pack resources are granted **again** (species are idempotent; only consumables double). This is the inverse — user-favorable — failure mode of the original C1, so it's bounded and far less severe, but it is free currency.

**Fix:** persist processed purchase identifiers (e.g., a tiny `processed_purchases(purchase_id TEXT PRIMARY KEY)` table keyed on `purchase.purchaseID ?? productID+transactionDate`); insert inside the same flow as the grant, skip granting when already present, and still call `completePurchase` for replays.

### N3. LOW/MEDIUM: cold start blocks on a network HEAD request

**File:** `lib/main.dart` (`await sl<TimeVerificationService>().initialize();` before `runApp`), `time_verification_service.dart:_syncWithNetwork` (5s timeout).

**Issue:** On slow/captive-portal networks the app shows the native splash for up to ~5 extra seconds before the Flutter splash even appears. Offline devices fail fast, so most users never notice, but it's on the critical path.

**Fix:** start `initialize()` before `runApp` _without_ awaiting it, store the `Future`, and have `SplashScreen` await it just before `villageProvider.loadData()` (the rollback must land before village data loads). Alternatively lower the HEAD timeout to ~3s. Pure refactor, no behavior change otherwise.

### N4. LOW: "Restore purchases" still has a single entry point

**File:** `lib/infrastructure/ui/widgets/dialogs/settings_dialog.dart` (`_PurchasedSpeciesStrippedDialog`).

**Issue:** Restore is only offered after importing a backup that had purchased species stripped. A user who reinstalls _without_ a backup has no way to recover purchased species (Google would restore non-consumables, but nothing in the UI triggers it).

**Fix:** add a "Restore purchases" row to the settings Data/Info section (visible when `AppConstants.playStore`), reusing the exact listener/idle-timer logic from `_PurchasedSpeciesStrippedDialog._handleRestorePurchases` (extract it into a shared helper or into `StoreService`). New strings must go into all 5 locale files.

### N5. LOW (note only): short-lived cooldowns still on device clock

`village_provider.dart:1251-1282` — ad cooldown and construction-skip cooldowns use `DateTime.now()` deltas. In-memory only (reset on app restart anyway), minutes-scale, and clock jumps now trip the suspicion banner; not worth churn unless abuse is observed. Same applies to `mission_service.dart:113` (`activatedAt`), which is intentionally consistent with session timestamps, and `village_rules.dart:76` (cosmetic daily rotation of villager needs).

---

## 4. Verification notes

- `flutter analyze`: **No issues found** after all changes in §2.
- There is still **no test suite** (`test/` does not exist). The highest-value additions remain: `TimeVerificationService` with an injectable clock, conditional `subtractResources`, and `BackupCipher` round-trip/tamper tests. N1 should not be implemented without them.
- Project rules honored: DB stays version 1 (new columns are fine — DB resets freely), no code comments, all new UI strings exist in all 5 locales (verified `en/es/fr/it/pt` for every key referenced by the new dialogs/banner), kawaii palette via `AppTheme` variables.
- `PLAY_STORE.md` already matches the consumable/non-consumable split; no GOOGLE_ADS.md changes were needed (no ads logic changed).

---

## 5. ADDENDUM — N1-N4 implemented (same day, later session)

All four findings from §3 were implemented after owner approval of the N1 design (including the fraud-decision popup). `flutter analyze` clean.

### N1 — forward-clock exploit detection + fraud decision popup

- New `completes_at TEXT` column on `placed_buildings`. Written with `trustedNow()` whenever a building is marked constructed (`markBuildingConstructed(id, completedAt)` — timer completion and gem speed-up). Cleared on upgrade start, upgrade revert, and rollback.
- All construction timing in `BuildingService` (placement start, upgrade start, `effectiveRemainingTime`, speed-up) now uses `trustedNow()` instead of `DateTime.now()`, so a network-synced session cannot complete constructions early at all.
- `rollbackFraudulentConstructions` now flags `is_constructed = 1` rows where `construction_start` OR `completes_at` is in the future of `trustedNow` (+2 min slack) — catches both backward and forward tampering signatures. Future `construction_start` values are clamped to `trustedNow` on rollback so the re-wait never exceeds the normal duration.
- New `getFraudulentConstructionsInfo(trustedNow)` (count + latest fraudulent timestamp) powers the decision flow in `TimeVerificationService._evaluateFraud`:
  - **Online (network sync succeeded):** automatic rollback, warning banner — restoring a fake date cannot beat server truth, so no choice is offered.
  - **Offline:** no automatic rollback; `hasPendingFraudDecision` is exposed and the new `clock_fraud_dialog.dart` asks the user: *accept* (rollback → buildings return to in-progress and finish naturally in real time) or *go back to my previous date* (`SystemNavigator.pop()` closes the app). The dialog shows the restore target (`max(previous last_seen_at, latest fraudulent timestamp)`, formatted) so the user knows what date to set ("{date} or later"). `PopScope(canPop: false)` — no way to skip the choice.
  - The pending state needs no persistence: the fraudulent rows themselves are the evidence, so the popup naturally reappears at every launch at real time until resolved, and naturally disappears if the user returns to the fake timeline (accepted offline gap, per spec).
- Wired in `splash_screen.dart` (after language load, reload village on accept) and `game_screen.didChangeAppLifecycleState` (on resume, guarded against double dialogs, reloads + re-syncs on accept/auto-rollback).
- 5 new locale keys (`clock_fraud_title/_body/_restore_hint/_accept/_restore`) added to all 5 languages.
- Known accepted behaviors: a building whose `completes_at` already passed in real time is not reverted (no retained advantage); EXP from a rolled-back-then-recompleted building is granted twice (EXP is not premium currency; not worth the complexity).

### N2 — consumable double-grant dedup

New `processed_purchases(purchase_key PRIMARY KEY, processed_at)` table (excluded from backups by design — `_validateBackup` already rejects unknown tables). `_grantAndAcknowledge` now: skip grant if a non-species purchase key (`purchaseID` or `productID_transactionDate` fallback) was already processed → still acknowledges; otherwise grant → mark processed → acknowledge. Species stay un-deduped on purpose (unlock is idempotent and the import-strip → restore flow must re-grant them).

### N3 — non-blocking cold start

`TimeVerificationService.initialize()` became memoized `ensureInitialized()`; `main.dart` fires it `unawaited` before `runApp`, and `splash_screen.dart` awaits it just before `villageProvider.loadData()` (rollback/fraud evaluation still lands before village data loads). The up-to-5s network HEAD is now off the first-frame critical path.

### N4 — general "Restore purchases" entry point

The completer/idle-timer restore logic was extracted from the post-import dialog into `StoreService.restoreAndCollectResults()` (single implementation, returns `anyRestored`). The post-import `_PurchasedSpeciesStrippedDialog` now calls it, and a new "Restore purchases" button (gated by `AppConstants.playStore`) was added to the settings Data section with success/nothing/error toasts — reuses the existing `restore_purchases*` locale keys, no new strings needed.
