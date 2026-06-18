# Bug Report & Fix Plan — June 12, 2026

Scope: `my_reading_village/` Flutter app only (senior-engineer first-pass review).
Purpose: actionable fix plan for a follow-up Claude Code session (Sonnet/Opus). **Do not refactor for taste — fix exactly what is listed.**

All paths are relative to `my_reading_village/`. Line numbers are valid as of commit `e109694`.

Context that matters for several findings:
- `AppConstants.playStore == false` and `AppConstants.googleAds == false` (lib/app_constants.dart:4-5), so the IAP/ads bugs below are **dormant in dev builds but live the moment those flags are flipped for release**.
- Project rules (CLAUDE.md): SQLite stays at version 1, no migrations needed; DB may be reset; all 5 locales must keep working; no code comments; colors via variables.

---

## CRITICAL

### C1. Real (Play Store) purchases are never granted in-game, but ARE acknowledged to Google

**Files:**
- `lib/application/services/store_service.dart:118-152` (`_launchPurchase`), `:83-92` (`_completePurchase`)
- `lib/infrastructure/ui/widgets/dialogs/store_dialog.dart:808-833` (gems), `:1029-1065` (packs), `:1801-1847` (species)

**Bug:** `_launchPurchase` calls `buyNonConsumable` and returns `StorePurchaseResult(state: pending)`. The actual success arrives asynchronously on `purchaseStream` → `_completePurchase`, which only sets a private `_pendingProductId` and immediately calls `_iap.completePurchase(purchase)` (acknowledges/consumes at Google). **Nothing ever consumes `_pendingProductId` in the purchase flow** — `consumePendingProductId()` is called only from the restore dialog in `settings_dialog.dart:1418`. All three `_purchase` methods in `store_dialog.dart` only grant when `result.state == StorePurchaseState.success`, which `_launchPurchase` can never return on a real build (only the `!playStore` simulation path returns success).

**Why it's a bug:** User pays real money → gems/pack/species never granted → purchase already acknowledged so Google will not auto-refund and `restorePurchases` won't redeliver consumables.

**Blast radius:** Every real IAP after release. Revenue + trust killer; guaranteed refund requests/reviews.

**Safe fix:**
1. Register `StoreService` as a singleton in `service_locator.dart` (today `store_dialog.dart:43` creates a throwaway instance per dialog — purchases completing after the dialog closes are lost entirely because `dispose()` cancels the stream subscription).
2. In `_onPurchaseUpdated`, on `purchased`/`restored`: **grant the entitlement first** (route product ID → gems amount / pack contents / species unlock via VillageProvider, persisting to DB), **then** call `completePurchase`. Keep a persisted queue (e.g., a small `pending_purchases` table or game_state column) so a kill between grant and ack cannot lose a purchase.
3. The dialog UI should listen to the service (it is already a `ChangeNotifier` — nobody listens today) to show success/error states instead of relying on `_launchPurchase`'s return value.

### C2. Consumable gem packs sold with `buyNonConsumable`

**File:** `lib/application/services/store_service.dart:142`; product list in `lib/domain/rules/store_rules.dart` (`gemsItems`, `packs`).

**Bug:** Gems (`gems_50` … `gems_2000`) and resource packs are consumables, but all purchases go through `buyNonConsumable`. On Android the second purchase of the same product fails with "item already owned" because it is never consumed.

**Blast radius:** Each gem pack and pack purchasable exactly once per Google account, forever.

**Safe fix:** Use `buyConsumable` for gems and packs; keep `buyNonConsumable` for `species_*`. Update `PLAY_STORE.md` so the console product types match (consumable vs non-consumable) — CLAUDE.md rule 6 requires this doc to stay in sync.

### C3. Gem speed-up never persists a completed `construction_start` → anti-fraud rollback destroys paid progress

**Files:**
- `lib/application/services/building_service.dart:445-464` (`speedUpConstruction` — persists only `is_constructed = 1`)
- `lib/adapters/providers/village_provider.dart:738-776` (sets `building.constructionStart = now-24h` **in memory only**, then reloads from DB at line 752, discarding it)
- `lib/infrastructure/persistence/database_helper_building_operations.dart:103-127` (`rollbackFraudulentConstructions`)

**Bug:** After a gem speed-up the DB row is `is_constructed = 1` with the **original** `construction_start` and full duration, so its naive completion time (`start + duration`) lies in the future. `rollbackFraudulentConstructions` flags exactly that condition (`completesAt.isAfter(trustedNow)`) as fraud and resets `is_constructed = 0`. The same false flag hits constructions completed early by sandwich 2x boosts, because the rollback query ignores power-ups entirely while `BuildingService.effectiveRemainingTime` accounts for them.

**Blast radius:** Any user who paid gems to finish a building and then trips the suspicion path (see C4 — that path has false positives) loses the building's completed state; gems are not refunded. Honest paying users are punished by the anti-cheat.

**Safe fix:**
1. In `BuildingService.speedUpConstruction`, also persist `construction_start = now - constructionDurationMinutes` (one `updateConstructionStart` call) so the row is self-consistent. Remove the dead in-memory assignment in the provider.
2. Make `rollbackFraudulentConstructions` compute remaining time the same way the game does (including sandwich boosts), or simpler: only roll back buildings whose `construction_start` itself is in the future relative to `trustedNow` (impossible without clock tampering), which has no false positives.

### C4. Time verification false-positives: monotonic stopwatch stops during device sleep → honest users flagged + rolled back + double EXP

**File:** `lib/application/services/time_verification_service.dart:18-21, 47-57`

**Bug:** `trustedNow()` = `_sessionStart + Stopwatch.elapsed`. Dart's `Stopwatch` uses the OS monotonic clock, which **does not advance while the device is in deep sleep**. If the app process survives a night in the background, `trustedNow()` lags hours behind. `onResume` then computes `drift = deviceNow - trustedNow > 2min` → sets `_isSuspicious = true` and **immediately** runs `rollbackFraudulentConstructions(trustedNow())` *before* `_syncWithNetwork()` gets a chance to correct the baseline.

**Consequences for an honest user:**
- Constructions that legitimately finished overnight have `completesAt > trustedNow` (because trustedNow is stale) → rolled back to `is_constructed = 0`. One second later the game-screen timer (`game_screen.dart:206-209` → `checkAndCompleteConstructions`) sees zero remaining time (it uses real `DateTime.now()`) and re-completes them — **granting construction EXP a second time** (`village_provider.dart:655-677`).
- Gem-sped-up buildings stay broken permanently (see C3).
- The "your date looks wrong" warning fires for users who did nothing.

**Blast radius:** Every user whose phone sleeps with the app backgrounded — i.e., everyone. Breaks trust in the warning, corrupts EXP, destroys paid progress.

**Safe fix:**
1. In `onResume`, treat **forward** drift (deviceNow ahead of trustedNow) as "process was suspended": re-baseline (`_sessionStart = deviceNow - elapsed` equivalent, or simply `_sessionStart = deviceNow; _stopwatch.reset()`), and only treat **backward** device time (deviceNow < last persisted `last_seen_at`) as suspicious, mirroring the `initialize()` logic.
2. Never roll back before attempting `_syncWithNetwork()`; only roll back when suspicion is confirmed (network says so, or deviceNow < lastSeenAt − 5min).
3. Persist `last_seen_at` periodically (e.g., on pause), not only at launch, so backward jumps are actually catchable.

---

## HIGH

### H1. Roulette spin: cost consumed before reward exists; no reentrancy guard

**File:** `lib/infrastructure/ui/widgets/dialogs/roulette_dialog.dart:294-409`; `lib/adapters/providers/village_provider.dart:474-502`

**Bugs (three in one flow):**
1. `_spin()` has no guard at the top. The button's `onPressed` is decided at build time, so a fast double-tap runs `_spin()` twice; the second invocation passes `village.spinRoulette()` again — the first consumed the free spin, so the second silently **charges 25 gems** (or double-charges gems).
2. `spinRoulette()` deducts gems / consumes the free spin, then the reward is applied only **after** the 4-second wheel animation (`await _controller.forward()`), and every step after it bails on `if (!mounted) return;` (lines 365, 375, 394). If the widget is disposed mid-animation (app backgrounded + killed, phone call, etc.) the spin is paid for and the reward is never granted.
3. Analytics `logRouletteSpin` fires before validation (`village_provider.dart:480`) even when the spin is then rejected for insufficient gems — wrong data.

**Safe fix:** Add `if (_isSpinning || _showingReward) return;` plus set `_isSpinning = true` synchronously at the top of `_spin()` (before any `await`). Pick `targetIndex` and **persist the pending reward together with the spin charge** (e.g., apply the reward right after `spinRoulette()` succeeds, before the animation; the popup afterwards is just presentation). Move the analytics call after the success checks.

### H2. Reading rewards silently dropped when context unmounts

**File:** `lib/infrastructure/ui/widgets/dialogs/log_pages_dialog.dart:275-301`

**Bug:** `bookProvider.logPages(...)` persists the session and **bumps `max_rewarded_pages`** (so the pages can never earn rewards again), but the actual `villageProvider.addResources(...)` is wrapped in `if (context.mounted)`. If the parent context is gone after the dialog pops (screen disposed during the awaits), coins/wood/metal/gems for those pages are permanently lost with no error.

**Blast radius:** Core game loop reward integrity; intermittent, unreproducible "I didn't get my coins" reports.

**Safe fix:** Grant the resources unconditionally (ideally move the grant into `ReadingService.logPages` / a single service call so session + rewards persist together). Keep only the popup/sound behind `context.mounted`. Same pattern check: `mission claim → species` (M5).

### H3. Check-then-act resource races; `subtractResources` can drive balances negative

**Files:**
- `lib/infrastructure/persistence/database_helper_game_state_operations.dart:19-25` (`subtractResources` — unconditional `coins = coins - ?`)
- `lib/adapters/providers/village_provider.dart:600-653` (`placeBuilding`: checks stale in-memory `_coins`, then service subtracts), `:570-576` (`refreshSpeciesForGems`: **no balance check at all** in the provider — only the UI guards it at `store_dialog.dart:2223`)
- Same pattern: `upgradeBuilding`, `expandTerritoryWithGems/Coins`, `spinRoulette`.

**Bug:** Every spend is "read in-memory balance → await → unconditional SQL decrement". Two interleaved spends (double-tap a buy/place button — `_placeBuilding` in `game_screen_tap_handlers.dart:141-214` is reachable per tap with awaits inside) both pass the check and both decrement; the resources row goes negative and stays negative.

**Safe fix:** Make `subtractResources` conditional and authoritative:
```sql
UPDATE resources SET coins = coins - ?, ... WHERE id = 1
  AND coins >= ? AND gems >= ? AND wood >= ? AND metal >= ?
```
Return the updated-row count; callers treat `0` as failure (refund nothing, abort the operation before inserting the building/etc.). Then refresh in-memory values from the DB. This single change closes all the races without restructuring callers.

### H4. Splash swallows every initialization error and enters the game with empty state

**File:** `lib/infrastructure/ui/screens/splash_screen.dart:178-256`; `lib/adapters/repositories/villager_favorites.dart:14-26`

**Bug:** The entire init sequence (village load → language → favorites → tags → books) is in one `try { … } catch (_) { … }` that just sets progress to 1.0 and navigates to `GameScreen` anyway. `VillagerFavorites.load()` (no internal try/catch, runs at step 0.6) throwing aborts the sequence **before `tagProvider.loadTags()` and `bookProvider.loadData()`**, so a user can land in the game with their whole library invisible and no error shown. A corrupt DB row behaves the same.

**Blast radius:** Any load-time failure looks like total data loss; the user's likely next move (re-import or reset) makes it real data loss.

**Safe fix:** Catch per-step, log, and on failure of the critical steps (village/books/tags) show a kawaii-styled error state with a retry button instead of navigating. Wrap `VillagerFavorites.load()` defensively (empty list fallback) since it's cosmetic.

### H5. Import: generic failures invisible; any backup `version >= 1` accepted with no schema reconciliation

**Files:** `lib/infrastructure/ui/widgets/dialogs/settings_dialog.dart:111-169`; `lib/application/services/backup_service.dart:102-120`; `lib/infrastructure/persistence/database_helper_backup_operations.dart:25-57 (exports version 3), 104-143`

**Bug:** `_validateBackup` accepts any `version is int && version >= 1` but the importer blindly `INSERT`s every key/column from the file. A backup from an older schema (extra/renamed columns) throws `DatabaseException` inside the transaction, which bubbles into `_handleImport`'s final `catch (_) {}` (settings_dialog.dart:168) — the user taps Import and **nothing happens, no message**. (The transaction does roll back, so no corruption — the failure is purely silent.)

**Safe fix:** In `importAllTables`, filter each row's keys against the live table's column list (`PRAGMA table_info`) before insert; reject files with `version > 3`. In `_handleImport`, replace the trailing `catch (_) {}` with the same error toast used for `FormatException`.

---

## MEDIUM

### M1. Imported book covers collide on filename (same-millisecond timestamps)

**File:** `lib/infrastructure/persistence/database_helper_backup_operations.dart:128-131` (also pattern in `lib/adapters/services/image_service_adapter.dart:43,66`)

**Bug:** Restored covers are written as `cover_${DateTime.now().millisecondsSinceEpoch}$ext` inside a tight loop; several books restored within the same millisecond share one filename — later writes overwrite earlier covers and multiple books point at the same file.

**Fix:** Append the loop index or book id (`cover_${ts}_${rowIndex}$ext`).

### M2. Restore-purchases flow: 2-second sleep as synchronization, single product slot, and it's the only restore path

**Files:** `lib/infrastructure/ui/widgets/dialogs/settings_dialog.dart:1411-1448`; `lib/application/services/store_service.dart:83-92, 154-166`

**Bugs:**
- `await Future.delayed(const Duration(seconds: 2))` is the only thing standing between `restorePurchases()` and reading results; slow networks deliver after the window → "nothing restored", and then the service is `dispose()`d so late events are dropped (subscription cancelled).
- `_pendingProductId` is a single slot; when Google delivers several restored purchases in one stream batch, each `_completePurchase` overwrites the previous ID before the consume loop runs → only the last species restored.
- This dialog (shown only after an import stripped purchased species) is the **only** restore entry point in the app; combined with C1 there is no working recovery for paying users after reinstall.

**Fix:** Replace `_pendingProductId` with a `List<String>` queue (`consumeAll()`); resolve restore completion by listening for the stream batch (and/or a generous timeout), not a fixed 2s; add a "Restore purchases" button to the general settings store/info section using the singleton service from C1.

### M3. `VillagerService.updateVillagerHappiness` fires DB writes without awaiting

**File:** `lib/application/services/villager_service.dart:88-117` (line 114)

**Bug:** A synchronous method kicks off `_repo.updateVillagerHappiness(...)` futures and drops them: failures are unobserved (silent swallow), writes can interleave with a concurrent `loadData()`/import, and tests can't see completion.

**Fix:** Make the method `Future<void>`, await the writes (or batch them in one transaction); update the ~6 call sites in `village_provider.dart` to `await` it.

### M4. Concurrent-modification hazards around `_placedBuildings` during gameplay timer

**Files:** `lib/adapters/providers/village_provider.dart:349-370` (`_crystallizeExpiredSpeedups` — `for (final b in _placedBuildings)` with `await` inside); `lib/infrastructure/ui/screens/game_screen.dart:736` (`_villageProvider.loadData();` un-awaited from the minigames `onReturn`, while the 1-second `_constructionTimer` keeps running)

**Bug:** `loadData()` can run mid-session concurrently with user taps (`placeBuilding` appends to the same list) and the construction timer. Mutating `_placedBuildings` while `_crystallizeExpiredSpeedups` is suspended inside its `for-in` throws `ConcurrentModificationError`; un-awaited `loadData` followed immediately by `_syncGameState()` also syncs stale state.

**Fix:** Iterate over `List.of(_placedBuildings)` in `_crystallizeExpiredSpeedups`; `await` the `loadData()` at game_screen.dart:736 before `_syncGameState()`. Optionally add a simple `_loading` reentrancy flag to `loadData`.

### M5. Daily ad limits, daily free spin, and "free gems seen" trust raw device date

**File:** `lib/adapters/providers/village_provider.dart:159-166 (canSpinDailyFree), 144-150, 1209-1230 (_todayStr/_resetAdDailyIfNeeded)`

**Bug:** All daily resets compare against `DateTime.now()` even though `TimeVerificationService.trustedNow()` exists and is already used for store discounts/events three lines away. Rolling the device date back/forward re-grants the daily free spin and resets the 3-ads-per-day counters — exactly the abuse CLAUDE.md task 2 ("BUSINESS CRITICAL: cambios de fecha") targets. `docs/specs/VULNERABILITIES.md` already specs this; the wiring is just incomplete.

**Fix:** Route every `_todayStr()` / `canSpinDailyFree` / `_currentIsoWeek()` computation through `trustedNow()` (after fixing C4 so trustedNow is reliable).

### M6. Mission species reward lost if app dies between claim and grant

**Files:** `lib/infrastructure/ui/widgets/common/missions_active_tab.dart:543-550`; `lib/application/services/mission_service.dart:456-484`; `lib/adapters/providers/village_provider.dart:1139-1198`

**Bug:** `claimMissionReward` marks the mission claimed (persisted) and only **returns** the speciesId; the UI then calls `applySpeciesBonus`. A crash between the two permanently consumes the mission with no species unlocked. (Coins/gems are safe — they're persisted inside the service.)

**Fix:** Unlock the species inside `MissionService.claimMissionReward` (same place coins/gems are granted), and have the UI only present the popup.

### M7. `editSession` updates `is_completed` but never `completed_at`

**File:** `lib/application/services/reading_service.dart:220-282`

**Bug:** Completing a book by editing a session up (or un-completing by editing down / `deleteSession`) leaves `completed_at` stale or null, which silently corrupts the completed-books-by-period stats (`database_helper_book_operations.dart:190-242`).

**Fix:** In `editSession`/`deleteSession`, set `completed_at = now` when transitioning to completed and `completed_at = NULL` when transitioning out.

---

## LOW / DEAD CODE & DEAD CONFIG

### L1. Foreign keys are declared but never enforced
`database_helper.dart:36-41` opens the DB without `PRAGMA foreign_keys = ON` (sqflite default is OFF), so the `ON DELETE CASCADE` clauses on `book_tags` (`:69-77`) are dead config; the code already works around it by manually deleting children (`database_helper_book_operations.dart:47-52, 281-285`). **Fix:** add `onConfigure: (db) => db.execute('PRAGMA foreign_keys = ON')` *or* delete the FK clauses; don't leave the misleading half-state. (Keeping the manual deletes is fine either way.)

### L2. `cleanupExpiredPowerups` is dead — and calling it would be harmful
`village_provider.dart:1037-1042` / `inventory_service.dart:219-222` have no callers. If someone wires it up later, it deletes expired `sandwich_speed` rows **without** running `_crystallizeExpiredSpeedups`, silently extending in-progress constructions (the boost credit lives only in the powerup row). **Fix:** delete it, or make it crystallize first; add a note in `_crystallizeExpiredSpeedups` ordering (must run before any expired-powerup deletion, as `loadData` currently does at lines 419-420).

### L3. `InventoryItem.displayName` / `.description` — dead, hardcoded English
`lib/domain/entities/inventory_item.dart:12-40` are unused by the UI (which uses localized keys). If ever used they'd violate the localization rule. **Fix:** remove both getters.

### L4. Reading EXP is dead config
`ReadingService.logPages` always returns `'exp': 0` (`reading_service.dart:207-217`); `log_pages_dialog.dart:284,293-295` reads it and has an `addExp` branch that can never run. **Fix:** remove the dead field + branch, reading must not give exp as the owner says

### L5. `tz.setLocalLocation(tz.local)` is a no-op
`notification_service.dart:59` assigns the local location to itself; the device timezone is never actually resolved (would need e.g. `flutter_timezone`). Benign today because all scheduling goes through absolute epoch ms (`_fromDeviceMs`), but it's misleading. **Fix:** delete the line (and the try/catch around it).

### L6. Starter species list duplicated
`database_helper_backup_operations.dart:80` hardcodes `['cat', 'dog', 'rabbit']`; the source of truth is `SpeciesRules.starterSpecies` (`species_rules.dart:196`). They match today; they'll drift. **Fix:** import and use the constant.

### L7. Export failures are silent; share-path success is assumed
`settings_dialog.dart:96-109`: `catch (_) {}` hides export errors entirely, and the share path (`backup_service.dart:90-99`) returns `true` regardless of whether the user completed the share. **Fix:** show an error toast in the catch; treat share completion as best-effort but at least surface exceptions.

### L8. ISO-week calculation duplicated
`village_provider.dart:134-139` (`_currentIsoWeek`) and `species_rules.dart` (`_isoWeek`) implement the same formula independently — drift here would desync "weekly species" from the spin-week counter. **Fix:** single shared helper in a rules file.

### L9. `StoreService` purchase stream `onError: (_) {}`
`store_service.dart:52` swallows stream errors; at minimum set `_purchaseState = error` and notify, so the UI doesn't hang in `pending`.

### L10. Imported `game_state` not propagated to in-memory services
After import (`settings_dialog.dart:126-133`) the code reloads providers but never calls `LanguageProvider.load(...)` with the imported language, and `AnalyticsService._consent` stays cached from launch. UI language and consent state are stale until app restart. **Fix:** after `village.loadData()`, call `sl<LanguageProvider>().load(village.language)` and re-read analytics consent.

---

## Suggested implementation order

1. **C3 + C4 together** (they interact: fix rollback false-positives and the speed-up persistence in one PR; verify with: speed up a building with gems → toggle device clock back → relaunch → building must stay constructed).
2. **H3** (conditional `subtractResources`) — small, closes many races at once.
3. **H1, H2, M6** (reward-grant atomicity cluster: roulette, reading, missions).
4. **C1 + C2 + M2 + L10** (IAP delivery rework — one PR; must be done before flipping `playStore = true`; update `PLAY_STORE.md` per CLAUDE.md rule 6).
5. **H4, H5, M1, L8, L11** (import/export + startup robustness).
6. **M3, M4, M7, M5** (consistency fixes).
7. **L-items** as a cleanup pass.

## Verification notes for the fixing session

- There are no existing tests covering these paths; for C3/C4/H3 add focused unit tests (`BuildingService`, `TimeVerificationService` with injectable clock, conditional `subtractResources`).
- `flutter analyze` and a manual smoke run (`flutter run`) after each cluster; the DB may be wiped freely (no users, schema stays at version 1 per CLAUDE.md).
- Do not change the kawaii UI, localization keys, or DB version. Any new user-facing strings must be added to all 5 locale files (`assets/messages/{en,es,fr,it,pt}/*.json`).
- `docs/specs/VULNERABILITIES.md` (repo root) already specs the owner-bound backup and time-verification features — keep these fixes consistent with that spec; M5/C4 partially overlap it.
