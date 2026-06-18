# Security Vulnerabilities — Implementation Spec

This document is the single source of truth for three business-critical security features.
It is written to be self-contained so any engineer starting from zero can implement all
three tasks without needing additional context.

---

## Global constraints (from CLAUDE.md)

- **No DB migrations.** Only modify `CREATE TABLE` statements in `database_helper.dart`.
  The DB resets from scratch (no production users). Version stays at `1`, never bumped.
- **All 5 languages.** Every new translation key goes into:
  `assets/messages/en/en.json`, `es/es.json`, `pt/pt.json`, `fr/fr.json`, `it/it.json`
- **Kawaii-pastel UI.** Use `AppTheme` color constants (never raw hex values inline).
  Key colors: `AppTheme.pink`, `AppTheme.lavender`, `AppTheme.cream`, `AppTheme.darkText`,
  `AppTheme.darkPink`, `AppTheme.darkLavender`, `AppTheme.mint`, `AppTheme.darkMint`,
  `AppTheme.skyBlue`, `AppTheme.darkSkyBlue`. Add new colors to `AppTheme` if needed.
- **Icons not emojis** (unless emojis already exist in the touched file — don't remove them).
- **Responsive.** All new UI must work in both portrait and landscape.
- **Import/export consistency.** Any schema change must be reflected in the backup logic
  (`database_helper_backup_operations.dart` and `backup_service.dart`).
- **No comments in code** unless the WHY is non-obvious.

---

## Task 1 — Species Purchase Protection

### Problem

A user can export their backup JSON, share it with a friend, and the friend imports it,
gaining all paid species (priced $1.99–$13.99 each) for free. This directly bypasses
in-app purchases.

### Solution overview

Add an `is_purchased` boolean column to `species_unlocks`. Only the real IAP flow sets it
to `1`. On import, three tables are sanitized before any data reaches the DB:

1. `species_unlocks` — rows with `is_purchased = 1` are stripped entirely. Their
   `species_id` values are collected into a `strippedIds` set used by the steps below.
2. `villagers` — any villager whose `species` field is in `strippedIds` has their species
   replaced with a random starter species (cat, dog, or rabbit), preserving the villager
   itself (name, happiness, house assignment).
3. `pending_villager_choices` — any pending choice row where **any** of its three
   species options (`species1`, `species2`, `species3`) is in `strippedIds` is removed
   entirely. The user will receive a new villager choice naturally through normal gameplay.

A scary ToS warning dialog is shown with a "Restore Purchases" button that lets
legitimate users (e.g. reinstalling on a new device) recover their paid species via
Google Play.

### 1.1 DB schema change

File: `my_reading_village/lib/infrastructure/persistence/database_helper.dart`

In `_createTables`, replace the existing `species_unlocks` CREATE TABLE with:

```sql
CREATE TABLE species_unlocks (
  species_id TEXT PRIMARY KEY,
  unlocked_at TEXT NOT NULL,
  is_purchased INTEGER NOT NULL DEFAULT 0
)
```

No other schema changes for Task 1.

### 1.2 `unlockSpecies` signature chain

Every layer that calls `unlockSpecies` must gain an optional `isPurchased` parameter
defaulting to `false`. Only the real IAP path passes `true`.

**`database_helper_game_state_operations.dart`**
```dart
Future<void> unlockSpecies(String speciesId, {bool isPurchased = false}) async {
  final db = await database;
  await db.insert(
    'species_unlocks',
    {
      'species_id': speciesId,
      'unlocked_at': DateTime.now().toIso8601String(),
      'is_purchased': isPurchased ? 1 : 0,
    },
    conflictAlgorithm: ConflictAlgorithm.ignore,
  );
}
```

**`village_repository.dart`** (port interface):
```dart
Future<void> unlockSpecies(String speciesId, {bool isPurchased = false});
```

**`sqlite_village_repository.dart`** (adapter):
```dart
Future<void> unlockSpecies(String speciesId, {bool isPurchased = false}) =>
    _db.unlockSpecies(speciesId, isPurchased: isPurchased);
```

**`village_provider.dart`** — `applySpeciesBonus`:
```dart
Future<SpeciesBonusResult?> applySpeciesBonus(
    String speciesId, {bool isPurchased = false}) async {
  // existing logic unchanged, but pass isPurchased to _repo.unlockSpecies
  await _repo.unlockSpecies(speciesId, isPurchased: isPurchased);
  // ...
}
```

Also update `unlockSpeciesFromStore` (already exists, used for gem-currency purchases):
- Gem-currency purchases → `isPurchased: false` (gems are earned, not real money)

**`player_service.dart`** (level unlock path):
- Default `false` — no change needed to call site since default handles it.

**Roulette, missions, secret codes** — no change needed (default `false`).

### 1.3 IAP call sites in `store_dialog.dart`

There are three `applySpeciesBonus` call sites. Only the real IAP paths get `true`:

| Line (approx) | Context | `isPurchased` |
|---|---|---|
| Inside `_applyAndShowSpeciesBonus` | Called after successful pack IAP | `true` |
| `!AppConstants.playStore` simulated path | Test/debug mode only | `false` |
| After `purchaseSpecies` real IAP result | Real species IAP purchase | `true` |

Change each real IAP call site:
```dart
final speciesResult = await village.applySpeciesBonus(speciesId, isPurchased: true);
```
Leave the simulated (`!AppConstants.playStore`) path unchanged at `false`.

### 1.4 Import stripping logic

File: `my_reading_village/lib/infrastructure/persistence/database_helper_backup_operations.dart`

Add a new method `stripPurchasedSpecies` that mutates the data map before the transaction
and returns a `bool` indicating whether anything was stripped:

```dart
bool _stripPurchasedSpecies(Map<String, dynamic> data) {
  final speciesRows = data['species_unlocks'] as List<dynamic>?;
  if (speciesRows == null) return false;

  final strippedIds = <String>{};
  final cleanSpecies = <dynamic>[];
  for (final row in speciesRows) {
    final map = row as Map<String, dynamic>;
    if ((map['is_purchased'] as int? ?? 0) == 1) {
      strippedIds.add(map['species_id'] as String);
    } else {
      cleanSpecies.add(row);
    }
  }

  if (strippedIds.isEmpty) return false;

  data['species_unlocks'] = cleanSpecies;

  // Reassign villagers whose species was stripped to a random starter
  final villagerRows = data['villagers'] as List<dynamic>?;
  if (villagerRows != null) {
    const starters = ['cat', 'dog', 'rabbit'];
    final rng = Random();
    data['villagers'] = villagerRows.map((row) {
      final map = Map<String, dynamic>.from(row as Map);
      if (strippedIds.contains(map['species'] as String?)) {
        map['species'] = starters[rng.nextInt(starters.length)];
      }
      return map;
    }).toList();
  }

  // Remove pending villager choices that reference any stripped species
  final choiceRows = data['pending_villager_choices'] as List<dynamic>?;
  if (choiceRows != null) {
    data['pending_villager_choices'] = choiceRows.where((row) {
      final map = row as Map<String, dynamic>;
      return !strippedIds.contains(map['species1'] as String?) &&
             !strippedIds.contains(map['species2'] as String?) &&
             !strippedIds.contains(map['species3'] as String?);
    }).toList();
  }

  return true;
}
```

Call this in `importAllTables` **before** the DB transaction begins, and return/expose
the `hadStripped` flag up the call chain.

### 1.5 `BackupService` changes

File: `my_reading_village/lib/application/services/backup_service.dart`

Update `pickAndValidate` return type to include the stripped flag:
```dart
Future<({Map<String, dynamic> data, bool hasBooksData, bool hadPurchasedSpeciesStripped})?>
    pickAndValidate() async { ... }
```

After the existing validation, call:
```dart
final hadStripped = _db.stripPurchasedSpeciesFromData(data);
// (expose _stripPurchasedSpecies via a public method on DatabaseHelper or
//  call it inline in BackupService after parsing)
```

Return `hadPurchasedSpeciesStripped: hadStripped` in the record.

### 1.6 Warning dialog + Restore Purchases UI

File: `my_reading_village/lib/infrastructure/ui/widgets/dialogs/settings_dialog.dart`

After `await backup.doImport(picked.data)` succeeds, check `picked.hadPurchasedSpeciesStripped`.
If `true`, show a dialog before `Navigator.pop`:

**Dialog design (kawaii-pastel):**
- Background: `AppTheme.cream`
- Rounded corners: `BorderRadius.circular(20)`
- Icon: `Icons.lock_outline`, color: `AppTheme.darkLavender`
- Title: localized `import_purchased_species_title`, style bold, `AppTheme.darkText`
- Body: localized `import_purchased_species_body` — must include the ToS ban threat
- Primary button: localized `restore_purchases`, color `AppTheme.darkSkyBlue`,
  onPressed → calls `_handleRestorePurchases(context)`
- Secondary button: localized `ok` (existing key), closes dialog

**`_handleRestorePurchases` flow:**
1. Call `sl<StoreService>().restorePurchases()`
2. Show loading indicator briefly
3. Listen for `StoreService` state changes via the purchase stream
4. On each `PurchaseStatus.restored` result → `village.applySpeciesBonus(speciesId, isPurchased: true)`
5. On completion show toast: `restore_purchases_success` if any restored,
   `restore_purchases_nothing` if none found, `restore_purchases_error` on exception

### 1.7 `StoreService` — new `restorePurchases` method

File: `my_reading_village/lib/application/services/store_service.dart`

```dart
Future<void> restorePurchases() async {
  if (!_available) return;
  _purchaseState = StorePurchaseState.pending;
  notifyListeners();
  await _iap.restorePurchases();
  // The existing _onPurchaseUpdated listener handles PurchaseStatus.restored
  // by calling _completePurchase which sets _pendingProductId and notifies.
  // The UI layer processes each notified pending ID and unlocks the species.
}
```

The existing `_onPurchaseUpdated` already handles `PurchaseStatus.restored` identically
to `PurchaseStatus.purchased` — no change needed there.

### 1.8 Translation keys — Task 1

Add to all 5 language files:

| Key | English value |
|---|---|
| `import_purchased_species_title` | Species Transfer Blocked |
| `import_purchased_species_body` | This backup contains purchased species that cannot be transferred between accounts. Use Restore Purchases to recover them on this device. Importing paid content from others is a violation of our Terms of Service and may result in a permanent account ban. |
| `restore_purchases` | Restore Purchases |
| `restore_purchases_success` | Purchases restored successfully. |
| `restore_purchases_nothing` | No purchases found to restore. |
| `restore_purchases_error` | Could not connect to the store. Please try again. |

### 1.9 Files changed — Task 1

| File | Change |
|---|---|
| `lib/infrastructure/persistence/database_helper.dart` | Add `is_purchased` column to `species_unlocks` CREATE TABLE |
| `lib/infrastructure/persistence/database_helper_game_state_operations.dart` | `unlockSpecies` gains `{bool isPurchased = false}` param |
| `lib/infrastructure/persistence/database_helper_backup_operations.dart` | Add `_stripPurchasedSpecies`, call before import transaction |
| `lib/domain/ports/village_repository.dart` | Update `unlockSpecies` signature |
| `lib/adapters/repositories/sqlite_village_repository.dart` | Update `unlockSpecies` signature |
| `lib/adapters/providers/village_provider.dart` | `applySpeciesBonus` gains `{bool isPurchased = false}` |
| `lib/application/services/store_service.dart` | Add `restorePurchases()` method |
| `lib/application/services/backup_service.dart` | `pickAndValidate` returns `hadPurchasedSpeciesStripped` |
| `lib/infrastructure/ui/widgets/dialogs/store_dialog.dart` | Real IAP call sites pass `isPurchased: true` |
| `lib/infrastructure/ui/widgets/dialogs/settings_dialog.dart` | Show ToS warning + Restore Purchases button |
| All 5 translation JSON files | 6 new keys |

---

## Task 2 — Device Time Manipulation Detection

### Problem

Users change the device date/time to:
- Jump to a holiday month to access seasonal events (Christmas, Halloween, etc.)
- Skip ahead hours to complete building construction instantly
- Reset daily limits (roulette free spin, ad cooldowns, store rotation)

After manipulating the clock, users return to real time (manually or via internet).
The return is always detectable as a backward jump from the manipulated time to real time.

### Solution overview

A `TimeVerificationService` is introduced that:
1. Uses a monotonic `Stopwatch` to detect clock changes **within a session** (including
   while the app is in the background — `Stopwatch` uses `CLOCK_MONOTONIC` which is immune
   to system clock changes).
2. Detects the **return to real time** after out-of-session manipulation by comparing
   `DateTime.now()` against `last_seen_at` (the device time stored on last app open).
   Since `last_seen_at` is written with whatever time the device had (including manipulated),
   the return trip (e.g. from December 2025 back to June 2025) shows as a backward jump.
3. On internet connection, uses a HEAD request to `https://www.google.com` and parses the
   `Date` response header to get server time (no dedicated NTP API needed, Google is
   always available). NTP confirmation can clear false positives.
4. Exposes `trustedNow()` which is used everywhere `DateTime.now()` was used for
   date-sensitive logic.
5. When manipulation is detected, rolls back building constructions and shows a
   kawaii warning banner with a ToS ban threat.

**Remaining gap (acceptable):** If the app is fully killed (not backgrounded), the
Stopwatch is lost. If the user then changes the clock forward offline and never returns
to real time, detection is impossible. This scenario requires permanent offline usage
with a permanently wrong clock — practically impossible for real users.

### 2.1 DB schema change

File: `my_reading_village/lib/infrastructure/persistence/database_helper.dart`

Add two nullable columns to the `game_state` CREATE TABLE:

```sql
last_seen_at TEXT,
last_trusted_at TEXT
```

Both nullable — the initial INSERT in `_createTables` does not need to change.

`last_seen_at` — written with `DateTime.now()` on every app open. Intentionally stores
the device's current time even if manipulated, because the return-to-real-time trip
(from manipulated future back to present) is detectable as a backward jump.

`last_trusted_at` — written only when a successful NTP check confirms the real time.

### 2.2 DB operations

File: `my_reading_village/lib/infrastructure/persistence/database_helper_game_state_operations.dart`

Add:
```dart
Future<DateTime?> getLastSeenAt() async {
  final state = await getGameState();
  final val = state['last_seen_at'] as String?;
  return val != null ? DateTime.parse(val) : null;
}

Future<void> setLastSeenAt(DateTime dt) async {
  final db = await database;
  await db.update('game_state', {'last_seen_at': dt.toIso8601String()},
      where: 'id = 1');
}

Future<DateTime?> getLastTrustedAt() async {
  final state = await getGameState();
  final val = state['last_trusted_at'] as String?;
  return val != null ? DateTime.parse(val) : null;
}

Future<void> setLastTrustedAt(DateTime dt) async {
  final db = await database;
  await db.update('game_state', {'last_trusted_at': dt.toIso8601String()},
      where: 'id = 1');
}
```

### 2.3 Building rollback operation

File: `my_reading_village/lib/infrastructure/persistence/database_helper_building_operations.dart`

Add:
```dart
Future<int> rollbackFraudulentConstructions(DateTime trustedNow) async {
  final db = await database;
  final buildings = await db.query(
    'placed_buildings',
    where: 'is_constructed = 1 AND construction_start IS NOT NULL',
  );
  int count = 0;
  for (final b in buildings) {
    final start = b['construction_start'] as String?;
    final duration = b['construction_duration_minutes'] as int? ?? 0;
    if (start == null) continue;
    final completesAt =
        DateTime.parse(start).add(Duration(minutes: duration));
    if (completesAt.isAfter(trustedNow)) {
      await db.update(
        'placed_buildings',
        {'is_constructed': 0},
        where: 'id = ?',
        whereArgs: [b['id']],
      );
      count++;
    }
  }
  return count;
}
```

### 2.4 New service

File: `my_reading_village/lib/application/services/time_verification_service.dart`

```dart
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:my_reading_village/infrastructure/persistence/database_helper.dart';

class TimeVerificationService {
  final DatabaseHelper _db;

  final Stopwatch _stopwatch = Stopwatch();
  DateTime? _sessionStart;
  bool _isSuspicious = false;
  bool _dismissed = false; // user dismissed banner for this session

  TimeVerificationService(this._db);

  bool get isSuspicious => _isSuspicious && !_dismissed;
  void dismissForSession() => _dismissed = true;

  DateTime trustedNow() {
    if (_sessionStart == null) return DateTime.now();
    return _sessionStart!.add(_stopwatch.elapsed);
  }

  Future<int> initialize() async {
    // Step 1 — check for backward jump from last known device time
    final lastSeen = await _db.getLastSeenAt();
    final deviceNow = DateTime.now();
    if (lastSeen != null &&
        deviceNow.isBefore(lastSeen.subtract(const Duration(minutes: 5)))) {
      _isSuspicious = true;
    }

    // Step 2 — record current device time as the new last_seen_at
    await _db.setLastSeenAt(deviceNow);

    // Step 3 — start monotonic clock
    _sessionStart = deviceNow;
    _stopwatch.start();

    // Step 4 — attempt NTP check
    int rolledBack = 0;
    if (_isSuspicious) {
      rolledBack = await _db.rollbackFraudulentConstructions(trustedNow());
    }
    await _syncWithNetwork(); // may clear or confirm _isSuspicious
    if (_isSuspicious) {
      rolledBack += await _db.rollbackFraudulentConstructions(trustedNow());
    }
    return rolledBack;
  }

  Future<void> onResume() async {
    // Called from AppLifecycleState.resume
    final deviceNow = DateTime.now();
    final trusted = trustedNow();
    final drift = deviceNow.difference(trusted).abs();
    if (drift > const Duration(minutes: 2)) {
      _isSuspicious = true;
      _dismissed = false;
      await _db.rollbackFraudulentConstructions(trustedNow());
    }
    await _syncWithNetwork();
  }

  Future<void> _syncWithNetwork() async {
    try {
      final response = await http
          .head(Uri.parse('https://www.google.com'))
          .timeout(const Duration(seconds: 5));
      final dateStr = response.headers['date'];
      if (dateStr == null) return;
      final serverTime = HttpDate.parse(dateStr).toLocal();
      final drift = DateTime.now().difference(serverTime);
      if (drift.abs() > const Duration(minutes: 5)) {
        _isSuspicious = true;
        _dismissed = false;
        // Recalibrate session base to server time
        _sessionStart = serverTime;
        _stopwatch.reset();
        _stopwatch.start();
      } else {
        _isSuspicious = false; // NTP clears offline false positives
        _sessionStart = serverTime;
        _stopwatch.reset();
        _stopwatch.start();
      }
      await _db.setLastTrustedAt(serverTime);
    } catch (_) {
      // Offline — keep current suspicion state from step 1
    }
  }
}
```

Note: `HttpDate.parse` is in `dart:io` — import it. The `http` package is already in
`pubspec.yaml`.

### 2.5 Register in service locator

File: `my_reading_village/lib/infrastructure/di/service_locator.dart`

Register and initialize `TimeVerificationService` **after** `DatabaseHelper` is ready
and **before** `VillageProvider` loads. Capture the rollback count:

```dart
sl.registerSingleton<TimeVerificationService>(
    TimeVerificationService(sl<DatabaseHelper>()));
final rolledBackCount = await sl<TimeVerificationService>().initialize();
// Pass rolledBackCount to the first frame so the HUD can show the toast
```

### 2.6 Hook `onResume` in game screen

File: `my_reading_village/lib/infrastructure/ui/screens/game_screen.dart`

`_GameScreenState` already has `TickerProviderStateMixin`. Add `WidgetsBindingObserver`:

```dart
class _GameScreenState extends State<GameScreen>
    with TickerProviderStateMixin, _GameTapHandlers
    implements WidgetsBindingObserver {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // ... existing initState code
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    // ... existing dispose code
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      sl<TimeVerificationService>().onResume().then((_) {
        if (mounted) setState(() {});
      });
    }
  }
}
```

### 2.7 Replace `DateTime.now()` in date-sensitive paths

**`mission_service.dart`** (line ~28):
```dart
// Before:
if (event.isActive(DateTime.now())) return true;
// After:
if (event.isActive(sl<TimeVerificationService>().trustedNow())) return true;
```

**`species_rules.dart`** — `getAvailableForStore` and `weeklySpeciesReward`:

Add `DateTime now` parameter to both static methods:
```dart
static List<VillagerSpeciesData> getAvailableForStore(
    List<String> unlockedIds, {int manualSeed = 0, required DateTime now}) { ... }

static VillagerSpeciesData? weeklySpeciesReward({required DateTime now}) { ... }
```

Callers (e.g. `village_provider.dart`) pass `sl<TimeVerificationService>().trustedNow()`.

**`store_rules.dart`** — all methods that call `DateTime.now()` internally:

Replace each `final now = DateTime.now()` with a `DateTime now` parameter passed in.
Callers pass `trustedNow()`.

### 2.8 Warning banner in game screen HUD

In the `build` method of `_GameScreenState`, inside the existing `Stack`, add a
`Positioned` banner at the bottom (or top, whichever doesn't overlap resource HUD)
that is only shown when `sl<TimeVerificationService>().isSuspicious`:

**Design:**
- Background: `AppTheme.pink.withValues(alpha: 0.92)` with a subtle red tint
  (e.g. `Color.lerp(AppTheme.pink, Colors.red, 0.3)`)
- Icon: `Icons.schedule_rounded`, color white
- Text: `clock_warning_body` (localized), white, small font
- Close (X) button: calls `sl<TimeVerificationService>().dismissForSession()` + `setState`
- Responsive: full-width in portrait; max 480px centered in landscape
- If buildings were rolled back (count > 0): additionally show a toast using `showAppToast`
  with `clock_buildings_rolled_back` key

### 2.9 Translation keys — Task 2

| Key | English value |
|---|---|
| `clock_warning_title` | Clock Issue Detected |
| `clock_warning_body` | Your device clock appears incorrect. Date-based features are unavailable. Manipulating system time is a violation of our Terms of Service and may result in a permanent account ban. |
| `clock_buildings_rolled_back` | Some buildings were reset because they were completed with an incorrect device time. |

### 2.10 Files changed — Task 2

| File | Change |
|---|---|
| `lib/infrastructure/persistence/database_helper.dart` | Add `last_seen_at`, `last_trusted_at` to `game_state` CREATE TABLE |
| `lib/infrastructure/persistence/database_helper_game_state_operations.dart` | Add get/set for both timestamps |
| `lib/infrastructure/persistence/database_helper_building_operations.dart` | Add `rollbackFraudulentConstructions` |
| `lib/application/services/time_verification_service.dart` | New file |
| `lib/infrastructure/di/service_locator.dart` | Register + initialize service |
| `lib/infrastructure/ui/screens/game_screen.dart` | Add `WidgetsBindingObserver`, `onResume` hook, suspicious banner |
| `lib/application/services/mission_service.dart` | Use `trustedNow()` |
| `lib/domain/rules/species_rules.dart` | Parameterize `now` in `getAvailableForStore` and `weeklySpeciesReward` |
| `lib/domain/rules/store_rules.dart` | Parameterize `now` in event-sensitive methods |
| `lib/adapters/providers/village_provider.dart` | Pass `trustedNow()` to parameterized callers |
| All 5 translation JSON files | 3 new keys |

---

## Task 3 — Encrypted Backup Format (.mrvb)

### Problem

The exported backup is plain JSON. Any user who opens it in a text editor can:
- Set `gems`, `coins`, `wood`, `metal` to arbitrary values
- Add species to `species_unlocks` manually
- Alter mission progress, building counts, etc.

### Solution overview

Replace plain JSON export with AES-256-GCM encrypted binary files using the `.mrvb`
extension (My Reading Village Backup). The encryption key is hardcoded in a file that
is `.gitignore`d and never committed. Since there are no production users, there is
**no backwards compatibility** with plain JSON — the app only accepts `.mrvb`. A
developer-only CLI tool in `tools/` converts old JSON files to `.mrvb` for personal
use.

AES-256-GCM was chosen because the 16-byte auth tag detects any tampering of the
ciphertext — even a single bit flip causes decryption to fail. This protects against
both reading and modification.

**Security model:** This stops 99.9% of users (those who open files in a text editor).
A sophisticated attacker who decompiles the APK could extract the key. This is
acceptable — the threat model is casual cheaters, not APK reverse engineers.

### 3.1 New dependency

File: `my_reading_village/pubspec.yaml`

```yaml
dependencies:
  # ... existing
  encrypt: ^5.0.3
```

Run `flutter pub get`.

### 3.2 `.gitignore`

File: `.gitignore` (project root or `my_reading_village/.gitignore`)

Add:
```
lib/infrastructure/security/backup_key.dart
```

### 3.3 Key file (never committed)

File: `my_reading_village/lib/infrastructure/security/backup_key.dart`

The developer creates this file locally. It must never be committed. Contents:

```dart
const List<int> kBackupKey = [
  // 32 cryptographically random bytes — generate once, keep secret
  // Example (replace with real random bytes):
  // 0x3A, 0x7F, 0xC2, ...
];
```

Generate 32 random bytes using a secure method (e.g. `dart:math` `Random.secure`,
Python `os.urandom(32).hex()`, or `openssl rand -hex 32`).

### 3.4 Cipher implementation

File: `my_reading_village/lib/infrastructure/security/backup_cipher.dart`

Binary format of a `.mrvb` file:
```
Bytes 0–3   : Magic header [0x4D, 0x52, 0x56, 0x42] ("MRVB")
Bytes 4–15  : Random 12-byte IV (fresh per export, AES-GCM standard size)
Bytes 16–N  : AES-256-GCM ciphertext with 16-byte auth tag appended
```

```dart
import 'dart:typed_data';
import 'package:encrypt/encrypt.dart';
import 'backup_key.dart';

class BackupCipher {
  static const List<int> _magic = [0x4D, 0x52, 0x56, 0x42];
  static final Key _key = Key(Uint8List.fromList(kBackupKey));

  static Uint8List encrypt(String jsonText) {
    final iv = IV.fromSecureRandom(12);
    final encrypter = Encrypter(AES(_key, mode: AESMode.gcm));
    final encrypted = encrypter.encrypt(jsonText, iv: iv);
    return Uint8List.fromList([
      ..._magic,
      ...iv.bytes,
      ...encrypted.bytes,
    ]);
  }

  static String decrypt(Uint8List bytes) {
    if (!isMrvb(bytes)) {
      throw const FormatException('tampered_backup');
    }
    final iv = IV(bytes.sublist(4, 16));
    final cipherBytes = Encrypted(bytes.sublist(16));
    final encrypter = Encrypter(AES(_key, mode: AESMode.gcm));
    try {
      return encrypter.decrypt(cipherBytes, iv: iv);
    } catch (_) {
      throw const FormatException('tampered_backup');
    }
  }

  static bool isMrvb(Uint8List bytes) {
    if (bytes.length < 4) return false;
    for (int i = 0; i < 4; i++) {
      if (bytes[i] != _magic[i]) return false;
    }
    return true;
  }
}
```

### 3.5 `BackupService` changes

File: `my_reading_village/lib/application/services/backup_service.dart`

**Export (`exportData`):**
- Generate `jsonString` as before
- Encrypt: `final bytes = BackupCipher.encrypt(jsonString);`
- Change filename extension from `.json` to `.mrvb`
- Write `bytes` (Uint8List) instead of `jsonString` (String)
- Use `file.writeAsBytes(bytes)` and `SharePlus` with the `.mrvb` file

**Import (`pickAndValidate`):**
- Read file as bytes: `final bytes = await File(filePath).readAsBytes();`
- Check: if `!BackupCipher.isMrvb(bytes)` → `throw FormatException('tampered_backup')`
- Decrypt: `final jsonString = BackupCipher.decrypt(bytes);` — already throws
  `FormatException('tampered_backup')` if auth tag invalid (file was modified)
- Continue with existing `json.decode(jsonString)` and `_validateBackup` logic

**FilePicker:**
```dart
// In exportData:
allowedExtensions: ['mrvb'],

// In pickAndValidate:
allowedExtensions: ['mrvb'],
```

**Error handling in `settings_dialog.dart`** — add to `_importErrorMessage`:
```dart
if (errorCode == 'tampered_backup') {
  return lang.translate('import_error_tampered');
}
```

### 3.6 Developer CLI tool

File: `tools/encrypt_backup.dart`

This script is committed to the repo (the key file is not). The developer runs it
locally to convert old plain JSON backups to the new `.mrvb` format.

```dart
// Usage: dart run tools/encrypt_backup.dart input.json output.mrvb
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

// Relative imports — must be run from the my_reading_village/ project root
import '../my_reading_village/lib/infrastructure/security/backup_cipher.dart';

void main(List<String> args) async {
  if (args.length != 2) {
    stderr.writeln('Usage: dart run tools/encrypt_backup.dart input.json output.mrvb');
    exit(1);
  }

  final inputFile = File(args[0]);
  if (!inputFile.existsSync()) {
    stderr.writeln('Input file not found: ${args[0]}');
    exit(1);
  }

  final jsonString = await inputFile.readAsString();
  try {
    json.decode(jsonString); // validate JSON
  } catch (e) {
    stderr.writeln('Invalid JSON: $e');
    exit(1);
  }

  final encrypted = BackupCipher.encrypt(jsonString);
  await File(args[1]).writeAsBytes(encrypted);
  stdout.writeln('Encrypted backup written to: ${args[1]}');
}
```

Run from the repo root:
```bash
dart run tools/encrypt_backup.dart my_old_backup.json my_backup.mrvb
```

### 3.7 Translation keys — Task 3

| Key | English value |
|---|---|
| `import_error_tampered` | This backup file appears to have been modified and cannot be imported. |

### 3.8 Files changed — Task 3

| File | Change |
|---|---|
| `my_reading_village/pubspec.yaml` | Add `encrypt: ^5.0.3` |
| `.gitignore` | Add `lib/infrastructure/security/backup_key.dart` |
| `lib/infrastructure/security/backup_key.dart` | New file, gitignored, never committed |
| `lib/infrastructure/security/backup_cipher.dart` | New file — AES-256-GCM encrypt/decrypt |
| `lib/application/services/backup_service.dart` | Encrypt on export, decrypt on import, only `.mrvb` |
| `lib/infrastructure/ui/widgets/dialogs/settings_dialog.dart` | Handle `tampered_backup` error code |
| `tools/encrypt_backup.dart` | New CLI tool for developer use |
| All 5 translation JSON files | 1 new key |

---

## Complete file change index

| File | Tasks |
|---|---|
| `lib/infrastructure/persistence/database_helper.dart` | 1 (`is_purchased`), 2 (`last_seen_at`, `last_trusted_at`) |
| `lib/infrastructure/persistence/database_helper_game_state_operations.dart` | 1 (`unlockSpecies` + flag), 2 (timestamps get/set) |
| `lib/infrastructure/persistence/database_helper_building_operations.dart` | 2 (`rollbackFraudulentConstructions`) |
| `lib/infrastructure/persistence/database_helper_backup_operations.dart` | 1 (strip paid species before import) |
| `lib/domain/ports/village_repository.dart` | 1 (signature) |
| `lib/adapters/repositories/sqlite_village_repository.dart` | 1 (signature) |
| `lib/adapters/providers/village_provider.dart` | 1 (`applySpeciesBonus` + `isPurchased`), 2 (pass `trustedNow()`) |
| `lib/application/services/store_service.dart` | 1 (`restorePurchases()` method) |
| `lib/application/services/backup_service.dart` | 1 (`hadPurchasedSpeciesStripped`), 3 (encrypt/decrypt, only `.mrvb`) |
| `lib/application/services/mission_service.dart` | 2 (`trustedNow()`) |
| `lib/application/services/time_verification_service.dart` | 2 (new file) |
| `lib/domain/rules/species_rules.dart` | 2 (parameterize `now`) |
| `lib/domain/rules/store_rules.dart` | 2 (parameterize `now`) |
| `lib/infrastructure/di/service_locator.dart` | 2 (register + init service) |
| `lib/infrastructure/ui/screens/game_screen.dart` | 2 (`WidgetsBindingObserver`, banner, `onResume`) |
| `lib/infrastructure/ui/widgets/dialogs/store_dialog.dart` | 1 (IAP call sites → `isPurchased: true`) |
| `lib/infrastructure/ui/widgets/dialogs/settings_dialog.dart` | 1 (ToS warning + Restore Purchases), 3 (`tampered_backup` error) |
| `lib/infrastructure/security/backup_key.dart` | 3 (new, gitignored) |
| `lib/infrastructure/security/backup_cipher.dart` | 3 (new) |
| `tools/encrypt_backup.dart` | 3 (new CLI tool) |
| `pubspec.yaml` | 3 (`encrypt: ^5.0.3`) |
| `.gitignore` | 3 (`backup_key.dart`) |
| `assets/messages/en/en.json` | 1, 2, 3 (10 new keys total) |
| `assets/messages/es/es.json` | 1, 2, 3 (10 new keys total) |
| `assets/messages/pt/pt.json` | 1, 2, 3 (10 new keys total) |
| `assets/messages/fr/fr.json` | 1, 2, 3 (10 new keys total) |
| `assets/messages/it/it.json` | 1, 2, 3 (10 new keys total) |

---

## All new translation keys (10 total)

| Key | Task | English |
|---|---|---|
| `import_purchased_species_title` | 1 | Species Transfer Blocked |
| `import_purchased_species_body` | 1 | This backup contains purchased species that cannot be transferred between accounts. Use Restore Purchases to recover them on this device. Importing paid content from others is a violation of our Terms of Service and may result in a permanent account ban. |
| `restore_purchases` | 1 | Restore Purchases |
| `restore_purchases_success` | 1 | Purchases restored successfully. |
| `restore_purchases_nothing` | 1 | No purchases found to restore. |
| `restore_purchases_error` | 1 | Could not connect to the store. Please try again. |
| `clock_warning_title` | 2 | Clock Issue Detected |
| `clock_warning_body` | 2 | Your device clock appears incorrect. Date-based features are unavailable. Manipulating system time is a violation of our Terms of Service and may result in a permanent account ban. |
| `clock_buildings_rolled_back` | 2 | Some buildings were reset because they were completed with an incorrect device time. |
| `import_error_tampered` | 3 | This backup file appears to have been modified and cannot be imported. |
