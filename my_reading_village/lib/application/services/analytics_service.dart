import 'dart:math';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:my_reading_village/infrastructure/persistence/database_helper.dart';

class AnalyticsService {
  final DatabaseHelper _db;

  int _consent = -1;
  String? _analyticsId;

  AnalyticsService(this._db);

  bool get isEnabled => _consent == 1;
  bool get isConsentPending => _consent == -1;

  Future<void> initialize() async {
    try {
      _consent = await _db.getAnalyticsConsent();
      _analyticsId = await _db.getAnalyticsId();
      if (_analyticsId == null || _analyticsId!.isEmpty) {
        _analyticsId = _generateId();
        await _db.setAnalyticsId(_analyticsId!);
      }
      await FirebaseAnalytics.instance
          .setAnalyticsCollectionEnabled(_consent == 1);
      await FirebaseCrashlytics.instance
          .setCrashlyticsCollectionEnabled(_consent == 1);
      if (_consent == 1) {
        await FirebaseAnalytics.instance.setUserId(id: _analyticsId);
      }
    } catch (_) {}
  }

  Future<void> setConsent(bool enabled) async {
    try {
      _consent = enabled ? 1 : 0;
      await _db.setAnalyticsConsent(_consent);
      if (enabled) {
        await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);
        await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
        if (_analyticsId != null) {
          await FirebaseAnalytics.instance.setUserId(id: _analyticsId);
        }
        await _log('analytics_consent_given');
      } else {
        await _log('analytics_consent_revoked');
        await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(false);
        await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
      }
    } catch (_) {}
  }

  Future<void> _log(String name, [Map<String, Object>? params]) async {
    if (_consent != 1) return;
    try {
      await FirebaseAnalytics.instance
          .logEvent(name: name, parameters: params);
    } catch (_) {}
  }

  Future<void> updateUserProperties({
    int? playerLevel,
    int? buildingCount,
    int? villagerCount,
    int? expansionCount,
    int? totalBooksCompleted,
    int? totalPagesRead,
    bool? hasMadeIap,
    String? language,
  }) async {
    if (_consent != 1) return;
    try {
      final fa = FirebaseAnalytics.instance;
      if (playerLevel != null) {
        await fa.setUserProperty(
            name: 'player_level', value: playerLevel.toString());
      }
      if (buildingCount != null) {
        await fa.setUserProperty(
            name: 'building_count', value: buildingCount.toString());
      }
      if (villagerCount != null) {
        await fa.setUserProperty(
            name: 'villager_count', value: villagerCount.toString());
      }
      if (expansionCount != null) {
        await fa.setUserProperty(
            name: 'expansion_count', value: expansionCount.toString());
      }
      if (totalBooksCompleted != null) {
        await fa.setUserProperty(
            name: 'total_books_completed',
            value: totalBooksCompleted.toString());
      }
      if (totalPagesRead != null) {
        await fa.setUserProperty(
            name: 'total_pages_read', value: totalPagesRead.toString());
      }
      if (hasMadeIap != null) {
        await fa.setUserProperty(
            name: 'has_made_iap', value: hasMadeIap ? 'true' : 'false');
      }
      if (language != null) {
        await fa.setUserProperty(name: 'language', value: language);
      }
    } catch (_) {}
  }

  Future<void> logPagesLogged(int pages, int estimatedMinutes) =>
      _log('pages_logged',
          {'pages': pages, 'estimated_minutes': estimatedMinutes});

  Future<void> logBookCompleted(int totalPages) =>
      _log('book_completed', {'total_pages': totalPages});

  Future<void> logBookRated(int rating) =>
      _log('book_rated', {'rating': rating});

  Future<void> logBookNoteSaved() => _log('book_note_saved');

  Future<void> logReadingStreak(int streakDays) =>
      _log('reading_streak', {'streak_days': streakDays});

  Future<void> logBuildingPlaced(
          String buildingType, int costCoins, int costWood, int costMetal,
          int playerLevel) =>
      _log('building_placed', {
        'building_type': buildingType,
        'cost_coins': costCoins,
        'cost_wood': costWood,
        'cost_metal': costMetal,
        'player_level': playerLevel,
      });

  Future<void> logChunkUnlocked(int expansionNumber) =>
      _log('chunk_unlocked', {'expansion_number': expansionNumber});

  Future<void> logLevelUp(int newLevel) =>
      _log('level_up', {'new_level': newLevel});

  Future<void> logMissionCompleted(
          String missionId, String missionType, int rewardGems) =>
      _log('mission_completed', {
        'mission_id': missionId,
        'mission_type': missionType,
        'reward_gems': rewardGems,
      });

  Future<void> logMissionClaimed(String missionId, int rewardGems) =>
      _log('mission_claimed',
          {'mission_id': missionId, 'reward_gems': rewardGems});

  Future<void> logVillagerChoiceMade(String speciesChosen) =>
      _log('villager_choice_made', {'species_chosen': speciesChosen});

  Future<void> logSpeciesUnlocked(
          String speciesId, String rarity, String unlockMethod) =>
      _log('species_unlocked', {
        'species_id': speciesId,
        'rarity': rarity,
        'unlock_method': unlockMethod,
      });

  Future<void> logRouletteSpin(String spinType) =>
      _log('roulette_spun', {'spin_type': spinType});

  Future<void> logMinigamePlayed(String minigameType, String result) =>
      _log('minigame_played',
          {'minigame_type': minigameType, 'result': result});

  Future<void> logIapPurchase(String productId) =>
      _log('iap_purchase', {'product_id': productId});

  Future<void> logStoreItemPurchased(
          String itemType, String currency, int price) =>
      _log('store_item_purchased',
          {'item_type': itemType, 'currency': currency, 'price': price});

  Future<void> logGemsSpent(int amount, String purpose) =>
      _log('gems_spent', {'amount': amount, 'purpose': purpose});

  Future<void> logCoinsSpent(int amount, String purpose) =>
      _log('coins_spent', {'amount': amount, 'purpose': purpose});

  Future<void> logAdWatched(String placement) =>
      _log('ad_watched', {'placement': placement});

  Future<void> logReadingModalOpened() => _log('reading_modal_opened');

  Future<void> logStatsDialogOpened(String periodTab, String metric) =>
      _log('stats_dialog_opened',
          {'period_tab': periodTab, 'metric': metric});

  Future<void> logBackpackOpened() => _log('backpack_opened');

  Future<void> logSpeciesGalleryOpened() => _log('species_gallery_opened');

  Future<void> logStoreOpened() => _log('store_opened');

  Future<void> logSettingsOpened() => _log('settings_opened');

  Future<void> logPhotoTaken(String type) =>
      _log('photo_taken', {'type': type});

  Future<void> logDataExported() => _log('data_exported');

  Future<void> logDataImported() => _log('data_imported');

  Future<void> logLanguageChanged(String languageCode) =>
      _log('language_changed', {'language_code': languageCode});

  Future<void> logTutorialCompleted(int durationMinutes) =>
      _log('tutorial_completed', {'duration_minutes': durationMinutes});

  static String _generateId() {
    final rand = Random.secure();
    final ts = DateTime.now().millisecondsSinceEpoch.toRadixString(16);
    final suffix =
        List.generate(16, (_) => rand.nextInt(16).toRadixString(16)).join();
    return '$ts$suffix';
  }
}
