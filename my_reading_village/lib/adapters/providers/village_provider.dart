import 'dart:math';
import 'package:flutter/material.dart';
import 'package:my_reading_village/app_constants.dart';
import 'package:my_reading_village/domain/rules/holiday_rules.dart';
import 'package:my_reading_village/domain/entities/placed_building.dart';
import 'package:my_reading_village/domain/entities/villager.dart';
import 'package:my_reading_village/domain/entities/inventory_item.dart';
import 'package:my_reading_village/domain/entities/mission.dart';
import 'package:my_reading_village/domain/entities/mission_data.dart';
import 'package:my_reading_village/domain/entities/pending_villager_choice.dart';
import 'package:my_reading_village/domain/ports/village_repository.dart';
import 'package:my_reading_village/domain/ports/book_repository.dart';
import 'package:my_reading_village/application/services/building_service.dart';
import 'package:my_reading_village/application/services/villager_service.dart';
import 'package:my_reading_village/application/services/inventory_service.dart';
import 'package:my_reading_village/application/services/mission_service.dart';
import 'package:my_reading_village/application/services/player_service.dart';
import 'package:my_reading_village/domain/rules/roulette_rules.dart';
import 'package:my_reading_village/domain/rules/minigame_rules.dart';
import 'package:my_reading_village/domain/rules/species_rules.dart';
import 'package:my_reading_village/domain/rules/village_rules.dart';
import 'package:my_reading_village/domain/rules/store_rules.dart';
import 'package:my_reading_village/domain/rules/secret_codes_rules.dart';

class VillageProvider extends ChangeNotifier {
  final VillageRepository _repo;
  final BookRepository _bookRepo;
  final BuildingService _buildingSvc;
  final VillagerService _villagerSvc;
  final InventoryService _inventorySvc;
  final MissionService _missionSvc;
  final PlayerService _playerSvc;

  VillageProvider(this._repo, this._bookRepo, this._buildingSvc,
      this._villagerSvc, this._inventorySvc, this._missionSvc, this._playerSvc);

  VillagerService get villagerService => _villagerSvc;

  List<PlacedBuilding> _placedBuildings = [];
  List<Villager> _villagers = [];
  int _coins = 0;
  int _gems = 0;
  int _wood = 0;
  int _metal = 0;
  Set<String> _roadTiles = {};
  Map<String, String> _specialTiles = {};
  Set<String> _unlockedChunks = {};
  int _expansionCount = 0;
  int _exp = 0;
  int _playerLevel = 1;
  String _username = '';
  String _townName = 'My Village';

  List<InventoryItem> _inventoryItems = [];
  List<ActivePowerup> _activePowerups = [];
  List<MinigameCooldown> _minigameCooldowns = [];

  Map<String, MissionProgress> _missionProgress = {};
  int _booksUsedSinceActive = 0;
  int? _pendingLevelUp;
  String _language = 'en';
  bool _tutorialCompleted = false;
  String? _rouletteLastFreeSpin;
  String? _rouletteSpinWeek;
  int _rouletteSpinWeekCount = 0;
  bool _hasNewBackpackItems = false;
  int _lastTotalPagesRead = 0;
  int _lastCompletedBooks = 0;
  List<String> _unlockedSpeciesIds = [];
  String? _pendingNewSpeciesId;
  Map<String, String> _eventSpeciesOverrides = {};
  List<PendingVillagerChoice> _pendingVillagerChoices = [];

  int _adRouletteAdsToday = 0;
  int _adRouletteSpinsToday = 0;
  bool _adRouletteHasPendingSpin = false;
  String? _adRouletteDate;
  int _adGemsAdsToday = 0;
  bool _adGemsClaimed = false;
  String? _adGemsDate;

  final Map<int, DateTime> _constructionSkipCooldowns = {};
  final Map<String, DateTime> _adCooldownTimes = {};
  final Set<int> _newlyConfirmedVillagerIds = {};

  String _storeDiscountSeenKey = '';
  String _storeGemSeenDate = '';
  int _speciesManualRefreshSeed = 0;

  List<PlacedBuilding> get placedBuildings => _placedBuildings;
  List<Villager> get villagers => _villagers;
  List<PendingVillagerChoice> get pendingVillagerChoices =>
      _pendingVillagerChoices;
  int get coins => _coins;
  int get gems => _gems;
  int get wood => _wood;
  int get metal => _metal;
  Set<String> get roadTiles => _roadTiles;
  Map<String, String> get specialTiles => _specialTiles;
  Set<String> get walkableTiles {
    final result = Set<String>.from(_roadTiles);
    for (final entry in _specialTiles.entries) {
      if (entry.value == 'sand') {
        final parts = entry.key.split(',');
        final x = int.parse(parts[0]);
        final y = int.parse(parts[1]);
        if (!_placedBuildings.any((b) => b.occupiesTile(x, y))) {
          result.add(entry.key);
        }
      }
    }
    return result;
  }

  Set<String> get unlockedChunks => _unlockedChunks;
  int get expansionCount => _expansionCount;
  int get exp => _exp;
  int get playerLevel => _playerLevel;
  int? get pendingLevelUp => _pendingLevelUp;
  String get username => _username;
  String get townName => _townName;
  String get language => _language;
  bool get tutorialCompleted => _tutorialCompleted;
  String? get rouletteLastFreeSpin => _rouletteLastFreeSpin;
  int get rouletteSpinWeekCount => _rouletteSpinWeekCount;
  bool get rouletteSpinIsGuaranteed =>
      _rouletteSpinWeekCount >= RouletteRules.guaranteedSpeciesAfterSpins;

  static String _currentIsoWeek() {
    final now = DateTime.now();
    final dayOfYear = now.difference(DateTime(now.year, 1, 1)).inDays + 1;
    final weekNum = ((dayOfYear - now.weekday + 10) ~/ 7);
    return '${now.year}-W${weekNum.toString().padLeft(2, '0')}';
  }

  bool get canSpinRouletteForFree =>
      canSpinDailyFree || _adRouletteHasPendingSpin;

  Duration get rouletteNextFreeSpinIn {
    if (canSpinDailyFree) return Duration.zero;
    final last = DateTime.parse(_rouletteLastFreeSpin!);
    final nextDay = DateTime(last.year, last.month, last.day + 1);
    final remaining = nextDay.difference(DateTime.now());
    return remaining.isNegative ? Duration.zero : remaining;
  }

  bool get hasNewBackpackItems => _hasNewBackpackItems;
  List<String> get unlockedSpeciesIds => _unlockedSpeciesIds;
  String? get pendingNewSpeciesId => _pendingNewSpeciesId;

  bool isSpeciesUnlocked(String speciesId) =>
      _unlockedSpeciesIds.contains(speciesId);

  bool get canSpinDailyFree {
    if (_rouletteLastFreeSpin == null) return true;
    final last = DateTime.parse(_rouletteLastFreeSpin!);
    final now = DateTime.now();
    return !(last.year == now.year &&
        last.month == now.month &&
        last.day == now.day);
  }

  bool get hasAdFreeSpin => _adRouletteHasPendingSpin;
  int get adRouletteAdsToday => _adRouletteAdsToday;
  int get adRouletteSpinsToday => _adRouletteSpinsToday;
  bool get canWatchAdForRoulette =>
      !_adRouletteHasPendingSpin && _adRouletteSpinsToday < 3;
  bool get adGemsClaimed => _adGemsClaimed;
  int get adGemsAdsToday => _adGemsAdsToday;

  bool get hasUnseenStoreDiscount {
    final key = StoreRules.computeActiveDiscountKey();
    if (key == null) return false;
    return key != _storeDiscountSeenKey;
  }

  bool get hasUnseenFreeGems =>
      !_adGemsClaimed && _storeGemSeenDate != _todayStr();

  bool get hasStoreNotification => hasUnseenStoreDiscount || hasUnseenFreeGems;

  Future<void> markStoreDiscountSeen() async {
    final key = StoreRules.computeActiveDiscountKey();
    if (key == null || key == _storeDiscountSeenKey) return;
    _storeDiscountSeenKey = key;
    await _repo.saveStoreDiscountSeenKey(key);
    notifyListeners();
  }

  Future<void> markStoreFreeGemsSeen() async {
    final today = _todayStr();
    if (_storeGemSeenDate == today) return;
    _storeGemSeenDate = today;
    await _repo.saveStoreGemSeenDate(today);
    notifyListeners();
  }

  void clearNewBackpackItems() {
    if (!_hasNewBackpackItems) return;
    _hasNewBackpackItems = false;
    notifyListeners();
  }

  String? consumePendingNewSpecies() {
    final id = _pendingNewSpeciesId;
    _pendingNewSpeciesId = null;
    return id;
  }

  List<InventoryItem> get inventoryItems => _inventoryItems;
  List<ActivePowerup> get activePowerups => _activePowerups;
  List<MinigameCooldown> get minigameCooldowns => _minigameCooldowns;
  Map<String, MissionProgress> get missionProgress => _missionProgress;

  int? consumeLevelUp() {
    final level = _pendingLevelUp;
    _pendingLevelUp = null;
    return level;
  }

  int get maxConstructors => _inventorySvc.maxConstructors(_activePowerups);
  int get busyConstructors =>
      _placedBuildings.where((b) => !b.isConstructed).length;
  bool get canStartConstruction => busyConstructors < maxConstructors;
  bool get isSpeedBoostActive =>
      _inventorySvc.isSpeedBoostActive(_activePowerups);
  double get constructionSpeedMultiplier =>
      _inventorySvc.constructionSpeedMultiplier(_activePowerups);
  bool get isHammerActive => _inventorySvc.isHammerActive(_activePowerups);
  bool get isGlassesActive => _inventorySvc.isGlassesActive(_activePowerups);
  double get readingResourceMultiplier =>
      _inventorySvc.readingResourceMultiplier(_activePowerups);
  int get villageHappiness => _villagerSvc.villageHappiness(_villagers);

  bool villagerHasHappinessBoost(int villagerId) =>
      _inventorySvc.villagerHasHappinessBoost(villagerId, _activePowerups);

  int itemQuantity(String type) =>
      _inventorySvc.itemQuantity(type, _inventoryItems);

  bool isMinigameOnCooldown(String minigameId) =>
      _inventorySvc.isMinigameOnCooldown(minigameId, _minigameCooldowns);

  Duration minigameCooldownRemaining(String minigameId) =>
      _inventorySvc.minigameCooldownRemaining(minigameId, _minigameCooldowns);

  bool get hasAnyMinigameAvailable =>
      MinigameRules.configs.keys.any((id) => !isMinigameOnCooldown(id));

  bool _prevMinigameAvailable = false;

  void tickCooldowns() {
    final current = hasAnyMinigameAvailable;
    if (current != _prevMinigameAvailable) {
      _prevMinigameAvailable = current;
      notifyListeners();
    }
  }

  List<String> get missingBuildingTypes => _villagerSvc.missingBuildingTypes(
      _villagers, _placedBuildings, walkableTiles, _playerLevel);

  bool isBuildingRoadConnected(PlacedBuilding b) =>
      _buildingSvc.isBuildingRoadConnected(b, walkableTiles, _placedBuildings);

  bool isTileUnlocked(int tileX, int tileY) =>
      _buildingSvc.isTileUnlocked(tileX, tileY, _unlockedChunks);

  bool isRoadTile(int x, int y) => _buildingSvc.isRoadTile(x, y, _roadTiles);

  bool hasBuildingAt(int x, int y) =>
      _buildingSvc.hasBuildingAt(x, y, _placedBuildings);

  PlacedBuilding? getBuildingAt(int x, int y) =>
      _buildingSvc.getBuildingAt(x, y, _placedBuildings);

  bool canPlaceBuildingAtArea(int x, int y, int width, int height) =>
      _buildingSvc.canPlaceBuildingAtArea(x, y, width, height, _placedBuildings,
          _roadTiles, _unlockedChunks, _specialTiles);

  ({int x, int y})? findValidPlacement(
          int tapX, int tapY, int width, int height) =>
      _buildingSvc.findValidPlacement(tapX, tapY, width, height,
          _placedBuildings, _roadTiles, _unlockedChunks, _specialTiles);

  bool isChunkAdjacentToUnlocked(int chunkX, int chunkY) =>
      _buildingSvc.isChunkAdjacentToUnlocked(chunkX, chunkY, _unlockedChunks);

  int buildingCountOfType(String type) =>
      _buildingSvc.buildingCountOfType(type, _placedBuildings);

  bool canPlaceBuildingType(String type) =>
      _buildingSvc.canPlaceBuildingType(type, _playerLevel, _placedBuildings);

  List<Villager> villagersInHouse(int houseId) =>
      _villagerSvc.villagersInHouse(houseId, _villagers);

  Map<int, String> get houseAdjacentRoadTiles =>
      _buildingSvc.houseAdjacentRoadTiles(_placedBuildings, walkableTiles);

  String? adjacentRoadTile(PlacedBuilding b) =>
      _buildingSvc.adjacentRoadTile(b, walkableTiles);

  static String tileKey(int x, int y) => BuildingService.tileKey(x, y);

  List<String> missingNeedsForVillager(Villager villager) =>
      _villagerSvc.missingNeedsForVillager(
          villager, _villagers, _placedBuildings, walkableTiles, _playerLevel);

  // --- Branch / Mission delegation ---

  bool isBranchUnlocked(MissionBranch branch) =>
      _missionSvc.isBranchUnlocked(branch, _missionProgress);
  bool isBranchFullyCompleted(MissionBranch branch) =>
      _missionSvc.isBranchFullyCompleted(branch, _missionProgress);
  Mission? getActiveMission(MissionBranch branch) =>
      _missionSvc.getActiveMission(branch, _missionProgress);
  List<Mission> getActiveMissions() =>
      _missionSvc.getActiveMissions(_missionProgress);

  int get unclaimedCompletedMissionCount =>
      _missionSvc.unclaimedCompletedMissionCount(_missionProgress);

  ({int current, int target}) getMissionProgressValues(Mission mission,
      {int? totalPagesRead, int? completedBooks}) {
    return _missionSvc.getMissionProgressValues(
      mission,
      _missionProgress[mission.id],
      _placedBuildings,
      _villagers,
      _activePowerups,
      _booksUsedSinceActive,
      totalPagesRead: totalPagesRead,
      completedBooks: completedBooks,
      nonGrassTileCount: _roadTiles.length + _specialTiles.length,
      expansionCount: _expansionCount,
    );
  }

  Future<void> _crystallizeExpiredSpeedups() async {
    final expiredMaps = await _inventorySvc.getExpiredSpeedupPowerups();
    if (expiredMaps.isEmpty) return;
    for (final row in expiredMaps) {
      final boostStart = DateTime.parse(row['activated_at'] as String);
      final boostDurationHours = row['duration_hours'] as int;
      final boostEnd = boostStart.add(Duration(hours: boostDurationHours));
      for (final b in _placedBuildings) {
        if (b.isConstructed || b.constructionStart == null || b.id == null) {
          continue;
        }
        final constructStart = DateTime.parse(b.constructionStart!);
        final overlapStart =
            constructStart.isAfter(boostStart) ? constructStart : boostStart;
        if (!boostEnd.isAfter(overlapStart)) continue;
        final bonus = boostEnd.difference(overlapStart);
        final newStart = constructStart.subtract(bonus);
        b.constructionStart = newStart.toIso8601String();
        await _repo.updateConstructionStart(b.id!, b.constructionStart!);
      }
    }
  }

  // --- Data loading ---

  Future<void> loadData() async {
    final placedMaps = await _repo.getPlacedBuildings();
    _placedBuildings =
        placedMaps.map((m) => PlacedBuilding.fromMap(m)).toList();

    final villagerMaps = await _repo.getVillagers();
    _villagers = villagerMaps.map((m) => Villager.fromMap(m)).toList();

    final resources = await _repo.getResources();
    _coins = resources['coins'] as int? ?? 0;
    _gems = resources['gems'] as int? ?? 0;
    _wood = resources['wood'] as int? ?? 0;
    _metal = resources['metal'] as int? ?? 0;

    final roadMaps = await _repo.getRoadTiles();
    _roadTiles = roadMaps
        .map((m) => tileKey(m['tile_x'] as int, m['tile_y'] as int))
        .toSet();

    final specialMaps = await _repo.getSpecialTiles();
    _specialTiles = {
      for (final m in specialMaps)
        tileKey(m['tile_x'] as int, m['tile_y'] as int):
            m['tile_type'] as String,
    };

    final chunkMaps = await _repo.getUnlockedChunks();
    _unlockedChunks = chunkMaps
        .map((m) => tileKey(m['chunk_x'] as int, m['chunk_y'] as int))
        .toSet();

    final gameState = await _repo.getGameState();
    _expansionCount = gameState['expansion_count'] as int;
    _exp = gameState['exp'] as int;
    _playerLevel = gameState['player_level'] as int;
    _username = gameState['username'] as String;
    _townName = gameState['town_name'] as String;
    _language = gameState['language'] as String? ?? 'en';
    _tutorialCompleted = (gameState['tutorial_completed'] as int? ?? 0) == 1;
    _rouletteLastFreeSpin = gameState['roulette_last_free_spin'] as String?;
    final spinWeekData = await _repo.getRouletteSpinWeekData();
    _rouletteSpinWeek = spinWeekData.week;
    _rouletteSpinWeekCount = spinWeekData.count;

    _inventoryItems = await _inventorySvc.loadInventoryItems();
    await _crystallizeExpiredSpeedups();
    _activePowerups = await _inventorySvc.loadActivePowerups();
    _minigameCooldowns = await _inventorySvc.loadMinigameCooldowns();
    _missionProgress = await _missionSvc.loadMissionProgress();
    _lastTotalPagesRead = await _bookRepo.getTotalPagesRead();
    _lastCompletedBooks = await _bookRepo.getCompletedBooksCount();
    _unlockedSpeciesIds = await _repo.getUnlockedSpeciesIds();
    _eventSpeciesOverrides = await _repo.getEventSpeciesOverrides();
    await _resolveEventSpeciesRewards();

    final adState = await _repo.getAdState();
    _adRouletteAdsToday = adState.rouletteAdsToday;
    _adRouletteSpinsToday = adState.rouletteSpinsToday;
    _adRouletteHasPendingSpin = adState.roulettePendingSpin;
    _adRouletteDate = adState.rouletteDate;
    _adGemsAdsToday = adState.gemsAdsToday;
    _adGemsClaimed = adState.gemsClaimed;
    _adGemsDate = adState.gemsDate;
    await _resetAdDailyIfNeeded();

    final storeSeenData = await _repo.getStoreSeenData();
    _storeDiscountSeenKey = storeSeenData.discountSeenKey;
    _storeGemSeenDate = storeSeenData.gemSeenDate;
    _speciesManualRefreshSeed = await _repo.getSpeciesManualRefreshSeed();

    final choiceMaps = await _repo.getPendingVillagerChoices();
    _pendingVillagerChoices =
        choiceMaps.map((m) => PendingVillagerChoice.fromMap(m)).toList();

    final pendingCountByHouse = <int, int>{};
    for (final c in _pendingVillagerChoices) {
      pendingCountByHouse[c.houseId] =
          (pendingCountByHouse[c.houseId] ?? 0) + 1;
    }

    _villagers = await _villagerSvc.reconcileVillagers(
        _villagers, _placedBuildings, walkableTiles,
        unlockedSpeciesIds: _unlockedSpeciesIds,
        pendingChoiceCountByHouse: pendingCountByHouse);
    _villagerSvc.updateVillagerHappiness(_villagers, _placedBuildings,
        walkableTiles, _activePowerups, _playerLevel);
    notifyListeners();
  }

  Future<void> markTutorialCompleted() async {
    await _repo.setTutorialCompleted();
    _tutorialCompleted = true;
    notifyListeners();
  }

  static int get rouletteGemCost => RouletteRules.gemCostPerSpin;

  Future<bool> spinRoulette() async {
    final isDailyFree = canSpinDailyFree;
    final isAdFree = _adRouletteHasPendingSpin;
    final isFree = isDailyFree || isAdFree;
    if (!isFree && _gems < rouletteGemCost) return false;
    if (!isFree) {
      await _repo.subtractResources(gems: rouletteGemCost);
      _gems -= rouletteGemCost;
    } else if (isDailyFree) {
      final now = DateTime.now().toIso8601String();
      await _repo.setRouletteLastFreeSpin(now);
      _rouletteLastFreeSpin = now;
    } else {
      _adRouletteHasPendingSpin = false;
      await _persistAdState();
    }
    final currentWeek = _currentIsoWeek();
    if (_rouletteSpinWeek != currentWeek) {
      _rouletteSpinWeekCount = 0;
      _rouletteSpinWeek = currentWeek;
    }
    _rouletteSpinWeekCount++;
    await _repo.setRouletteSpinWeekData(
        _rouletteSpinWeek!, _rouletteSpinWeekCount);
    notifyListeners();
    return true;
  }

  bool get wasDailyFreeForNotification => canSpinDailyFree;

  Future<void> resetRouletteSpinWeekCount() async {
    _rouletteSpinWeekCount = 0;
    await _repo.setRouletteSpinWeekData(
        _rouletteSpinWeek ?? _currentIsoWeek(), 0);
    notifyListeners();
  }

  Future<void> applyRouletteReward(Map<String, dynamic> reward) async {
    final type = reward['type'] as String;
    switch (type) {
      case 'coins':
        await addResources(coins: reward['amount'] as int);
        break;
      case 'gems':
        await addResources(gems: reward['amount'] as int);
        break;
      case 'wood':
        await addResources(wood: reward['amount'] as int);
        break;
      case 'metal':
        await addResources(metal: reward['amount'] as int);
        break;
      case 'book':
      case 'sandwich':
      case 'hammer':
      case 'glasses':
        await addItemToInventory(type);
        _hasNewBackpackItems = true;
        break;
    }
  }

  Future<({bool isDuplicate, String speciesId, String speciesNameKey})?>
      applySpeciesBonus(String speciesId) async {
    final alreadyOwned = _unlockedSpeciesIds.contains(speciesId);
    if (alreadyOwned) {
      await addResources(gems: SpeciesRules.duplicateSpeciesGemCompensation);
    } else {
      await _repo.unlockSpecies(speciesId);
      _unlockedSpeciesIds = await _repo.getUnlockedSpeciesIds();
    }
    final speciesData = SpeciesRules.findById(speciesId);
    notifyListeners();
    return (
      isDuplicate: alreadyOwned,
      speciesId: speciesId,
      speciesNameKey: speciesData?.nameKey ?? speciesId,
    );
  }

  Future<void> unlockSpeciesFromStore(String speciesId) async {
    if (_unlockedSpeciesIds.contains(speciesId)) return;
    await _repo.unlockSpecies(speciesId);
    _unlockedSpeciesIds = await _repo.getUnlockedSpeciesIds();
    notifyListeners();
  }

  List<VillagerSpeciesData> get storeSpeciesAvailable =>
      SpeciesRules.getAvailableForStore(_unlockedSpeciesIds,
          manualSeed: _speciesManualRefreshSeed);

  static const int speciesManualRefreshCost = 20;

  Future<void> refreshSpeciesForGems() async {
    await _repo.subtractResources(gems: speciesManualRefreshCost);
    _gems -= speciesManualRefreshCost;
    await _repo.incrementSpeciesManualRefreshSeed();
    _speciesManualRefreshSeed++;
    notifyListeners();
  }

  Future<void> addResources(
      {int coins = 0, int gems = 0, int wood = 0, int metal = 0}) async {
    await _repo.addResources(
        coins: coins, gems: gems, wood: wood, metal: metal);
    _coins += coins;
    _gems += gems;
    _wood += wood;
    _metal += metal;
    notifyListeners();
  }

  Future<void> refreshResources() async {
    final resources = await _repo.getResources();
    _coins = resources['coins'] as int? ?? 0;
    _gems = resources['gems'] as int? ?? 0;
    _wood = resources['wood'] as int? ?? 0;
    _metal = resources['metal'] as int? ?? 0;
    notifyListeners();
  }

  // --- Building operations ---

  Future<PlacedBuilding?> placeBuilding({
    required String type,
    required String name,
    required int tileX,
    required int tileY,
    required int coinCost,
    required int gemCost,
    required int woodCost,
    required int metalCost,
    required int happinessBonus,
    required int constructionMinutes,
    bool isFlipped = false,
    int tileWidth = 1,
    int tileHeight = 1,
    bool isDecoration = false,
  }) async {
    if (_coins < coinCost ||
        _gems < gemCost ||
        _wood < woodCost ||
        _metal < metalCost) {
      return null;
    }
    if (!canStartConstruction) return null;

    final saved = await _buildingSvc.placeBuilding(
      type: type,
      name: name,
      tileX: tileX,
      tileY: tileY,
      coinCost: coinCost,
      gemCost: gemCost,
      woodCost: woodCost,
      metalCost: metalCost,
      happinessBonus: happinessBonus,
      constructionMinutes: constructionMinutes,
      isFlipped: isFlipped,
      tileWidth: tileWidth,
      tileHeight: tileHeight,
      isDecoration: isDecoration,
    );
    if (saved == null) return null;

    _coins -= coinCost;
    _gems -= gemCost;
    _wood -= woodCost;
    _metal -= metalCost;
    _placedBuildings.add(saved);
    notifyListeners();
    return saved;
  }

  Future<List<PlacedBuilding>> checkAndCompleteConstructions() async {
    final completed = await _buildingSvc.checkAndCompleteConstructions(
        _placedBuildings, _activePowerups);
    if (completed.isNotEmpty) {
      for (final b in completed) {
        await addExp(_buildingSvc.getExpForConstruction(b));
        await _createPendingChoicesForHouse(b);
      }
      final pendingCountByHouse = <int, int>{};
      for (final c in _pendingVillagerChoices) {
        pendingCountByHouse[c.houseId] =
            (pendingCountByHouse[c.houseId] ?? 0) + 1;
      }
      _villagers = await _villagerSvc.reconcileVillagers(
          _villagers, _placedBuildings, walkableTiles,
          unlockedSpeciesIds: _unlockedSpeciesIds,
          pendingChoiceCountByHouse: pendingCountByHouse);
      _villagerSvc.updateVillagerHappiness(_villagers, _placedBuildings,
          walkableTiles, _activePowerups, _playerLevel);
      notifyListeners();
    }
    return completed;
  }

  Future<void> _createPendingChoicesForHouse(PlacedBuilding building) async {
    if (building.type != 'house') return;
    if (building.id == null) return;

    final level = _buildingSvc.effectiveBuildingLevel(building);
    if (level <= 0) return;
    final cap = VillageRules.villagersPerHouse(level);
    final currentInHouse =
        _villagers.where((v) => v.houseId == building.id).length;
    final pendingForHouse =
        _pendingVillagerChoices.where((c) => c.houseId == building.id).length;
    final newSlots = cap - currentInHouse - pendingForHouse;

    final availableSpecies = _unlockedSpeciesIds.isNotEmpty
        ? _unlockedSpeciesIds
        : VillageRules.villagerSpecies;

    for (int i = 0; i < newSlots; i++) {
      final seed = DateTime.now().millisecondsSinceEpoch + i * 31337;
      final random = Random(seed);
      final options =
          _villagerSvc.generateSpeciesOptions(availableSpecies, seed: seed);
      final n1 = VillageRules.randomVillagerName(random.nextInt(10000));
      final n2 = VillageRules.randomVillagerName(random.nextInt(10000));
      final n3 = VillageRules.randomVillagerName(random.nextInt(10000));
      final choiceId = await _repo.insertPendingVillagerChoice(
          building.id!, options[0], options[1], options[2], n1, n2, n3);
      _pendingVillagerChoices.add(PendingVillagerChoice(
        id: choiceId,
        houseId: building.id!,
        species1: options[0],
        species2: options[1],
        species3: options[2],
        name1: n1,
        name2: n2,
        name3: n3,
      ));
    }
  }

  Future<bool> upgradeBuilding(int buildingId) async {
    if (!canStartConstruction) return false;
    final result = await _buildingSvc.upgradeBuilding(
      buildingId,
      _placedBuildings,
      coins: _coins,
      wood: _wood,
      metal: _metal,
    );
    if (result) {
      await refreshResources();
      final placedMaps = await _repo.getPlacedBuildings();
      _placedBuildings =
          placedMaps.map((m) => PlacedBuilding.fromMap(m)).toList();
      notifyListeners();
    }
    return result;
  }

  Future<int?> speedUpConstruction(int buildingId) async {
    final idx = _placedBuildings.indexWhere((b) => b.id == buildingId);
    if (idx == -1) return null;
    final building = _placedBuildings[idx];

    final result = await _buildingSvc.speedUpConstruction(
        buildingId, _placedBuildings, _gems, _activePowerups);
    if (!result) return null;

    final expAmount = _buildingSvc.getExpForConstruction(building);
    building.isConstructed = true;
    building.constructionStart =
        DateTime.now().subtract(Duration(hours: 24)).toIso8601String();

    final placedMaps = await _repo.getPlacedBuildings();
    _placedBuildings =
        placedMaps.map((m) => PlacedBuilding.fromMap(m)).toList();
    final villagerMaps = await _repo.getVillagers();
    _villagers = villagerMaps.map((m) => Villager.fromMap(m)).toList();

    final completedBuilding =
        _placedBuildings.firstWhere((b) => b.id == buildingId);
    await _createPendingChoicesForHouse(completedBuilding);

    final pendingCountByHouse = <int, int>{};
    for (final c in _pendingVillagerChoices) {
      pendingCountByHouse[c.houseId] =
          (pendingCountByHouse[c.houseId] ?? 0) + 1;
    }
    _villagers = await _villagerSvc.reconcileVillagers(
        _villagers, _placedBuildings, walkableTiles,
        unlockedSpeciesIds: _unlockedSpeciesIds,
        pendingChoiceCountByHouse: pendingCountByHouse);
    _villagerSvc.updateVillagerHappiness(_villagers, _placedBuildings,
        walkableTiles, _activePowerups, _playerLevel);
    await refreshResources();
    notifyListeners();
    return expAmount;
  }

  Future<bool> cancelConstruction(int buildingId) async {
    final idx = _placedBuildings.indexWhere((b) => b.id == buildingId);
    if (idx == -1) return false;
    final building = _placedBuildings[idx];
    final isUpgrade = building.level > 1;

    final result =
        await _buildingSvc.cancelConstruction(buildingId, _placedBuildings);
    if (!result) return false;

    if (!isUpgrade) {
      _placedBuildings.removeAt(idx);
    }

    await refreshResources();
    if (isUpgrade) {
      final placedMaps = await _repo.getPlacedBuildings();
      _placedBuildings =
          placedMaps.map((m) => PlacedBuilding.fromMap(m)).toList();
    }
    final pendingCountByHouse = <int, int>{};
    for (final c in _pendingVillagerChoices) {
      pendingCountByHouse[c.houseId] =
          (pendingCountByHouse[c.houseId] ?? 0) + 1;
    }
    _villagers = await _villagerSvc.reconcileVillagers(
        _villagers, _placedBuildings, walkableTiles,
        unlockedSpeciesIds: _unlockedSpeciesIds,
        pendingChoiceCountByHouse: pendingCountByHouse);
    _villagerSvc.updateVillagerHappiness(_villagers, _placedBuildings,
        walkableTiles, _activePowerups, _playerLevel);
    notifyListeners();
    return true;
  }

  Future<bool> moveBuilding(int buildingId, int newTileX, int newTileY) async {
    final result = await _buildingSvc.moveBuilding(buildingId, newTileX,
        newTileY, _placedBuildings, _roadTiles, _unlockedChunks, _specialTiles);
    if (result) notifyListeners();
    return result;
  }

  Future<void> flipBuilding(int buildingId) async {
    await _buildingSvc.flipBuilding(buildingId, _placedBuildings);
    notifyListeners();
  }

  Future<void> toggleRoad(int x, int y) async {
    await _buildingSvc.toggleRoad(x, y, _roadTiles, _specialTiles);
    notifyListeners();
  }

  Future<void> toggleSpecialTile(int x, int y, String type) async {
    await _buildingSvc.toggleSpecialTile(x, y, type, _specialTiles, _roadTiles);
    notifyListeners();
  }

  Future<void> clearToGrass(int x, int y) async {
    await _buildingSvc.clearToGrass(x, y, _roadTiles, _specialTiles);
    notifyListeners();
  }

  bool isSpecialTile(int x, int y) =>
      _buildingSvc.isSpecialTile(x, y, _specialTiles);

  Future<bool> expandTerritoryWithGems(int chunkX, int chunkY) async {
    final result = await _buildingSvc.expandTerritoryWithGems(
        chunkX, chunkY, _gems, _expansionCount, _unlockedChunks);
    if (result) {
      _unlockedChunks.add(tileKey(chunkX, chunkY));
      _expansionCount++;
      await refreshResources();
      notifyListeners();
    }
    return result;
  }

  Future<bool> expandTerritoryWithCoins(int chunkX, int chunkY) async {
    final result = await _buildingSvc.expandTerritoryWithCoins(
        chunkX, chunkY, _coins, _expansionCount, _unlockedChunks);
    if (result) {
      _unlockedChunks.add(tileKey(chunkX, chunkY));
      _expansionCount++;
      await refreshResources();
      notifyListeners();
    }
    return result;
  }

  // --- Player operations ---

  Future<int?> addExp(int amount) async {
    final result = await _playerSvc.addExp(amount, _exp, _playerLevel);
    _exp = result.newExp;
    if (result.leveledUpTo != null) {
      _playerLevel = result.leveledUpTo!;
      _gems += result.gemReward;
      _pendingLevelUp = result.leveledUpTo;
      if (result.newSpeciesId != null) {
        _unlockedSpeciesIds = await _repo.getUnlockedSpeciesIds();
        _pendingNewSpeciesId = result.newSpeciesId;
      }
    }
    notifyListeners();
    return result.leveledUpTo;
  }

  Future<void> confirmVillagerChoice(
      int choiceId, int houseId, String species, String name) async {
    final villagerId = await _repo.insertVillager(name, species, houseId);
    _newlyConfirmedVillagerIds.add(villagerId);
    _villagers.add(Villager(
        id: villagerId,
        name: name,
        species: species,
        happiness: 50,
        houseId: houseId));
    _pendingVillagerChoices.removeWhere((c) => c.id == choiceId);
    await _repo.deletePendingVillagerChoice(choiceId);
    _villagerSvc.updateVillagerHappiness(_villagers, _placedBuildings,
        walkableTiles, _activePowerups, _playerLevel);
    notifyListeners();
  }

  Future<void> renameVillager(int villagerId, String newName) async {
    await _villagerSvc.renameVillager(villagerId, newName, _villagers);
    notifyListeners();
  }

  Future<void> updateUsername(String name) async {
    _username = name;
    await _playerSvc.updateUsername(name);
    notifyListeners();
  }

  Future<void> updateTownName(String name) async {
    _townName = name;
    await _playerSvc.updateTownName(name);
    notifyListeners();
  }

  // --- Inventory operations ---

  Future<void> addItemToInventory(String type, {int amount = 1}) async {
    await _inventorySvc.addItem(type, _inventoryItems, amount: amount);
    notifyListeners();
  }

  Future<({bool found, bool alreadyUsed, List<SecretReward> rewards})>
      redeemSecretCode(String input) async {
    final secretCode = SecretCodesRules.findCode(input);
    if (secretCode == null) {
      return (found: false, alreadyUsed: false, rewards: <SecretReward>[]);
    }

    final normalized = input.trim().toUpperCase();
    final alreadyUsed = await _repo.isSecretCodeUsed(normalized);
    if (alreadyUsed) {
      return (found: true, alreadyUsed: true, rewards: <SecretReward>[]);
    }

    for (final reward in secretCode.rewards) {
      switch (reward.type) {
        case SecretRewardType.coins:
          await addResources(coins: reward.amount);
          break;
        case SecretRewardType.gems:
          await addResources(gems: reward.amount);
          break;
        case SecretRewardType.wood:
          await addResources(wood: reward.amount);
          break;
        case SecretRewardType.metal:
          await addResources(metal: reward.amount);
          break;
        case SecretRewardType.item:
          if (reward.itemType != null) {
            await addItemToInventory(reward.itemType!, amount: reward.amount);
            _hasNewBackpackItems = true;
          }
          break;
        case SecretRewardType.species:
          break;
      }
    }

    await _repo.markSecretCodeUsed(normalized);
    notifyListeners();
    return (found: true, alreadyUsed: false, rewards: secretCode.rewards);
  }

  Future<bool> useBookItem(int villagerId) async {
    final result = await _inventorySvc.useBookItem(
        villagerId, _inventoryItems, _activePowerups);
    if (result) {
      _villagerSvc.updateVillagerHappiness(_villagers, _placedBuildings,
          walkableTiles, _activePowerups, _playerLevel);
      _notifyBookItemUsed();
      notifyListeners();
    }
    return result;
  }

  Future<bool> useSandwichItem() async {
    final result =
        await _inventorySvc.useSandwichItem(_inventoryItems, _activePowerups);
    if (result) notifyListeners();
    return result;
  }

  Future<bool> useHammerItem() async {
    final result =
        await _inventorySvc.useHammerItem(_inventoryItems, _activePowerups);
    if (result) notifyListeners();
    return result;
  }

  Future<bool> useGlassesItem() async {
    final result =
        await _inventorySvc.useGlassesItem(_inventoryItems, _activePowerups);
    if (result) notifyListeners();
    return result;
  }

  Future<void> setMinigameCooldown(String minigameId, int cooldownHours) async {
    await _inventorySvc.setMinigameCooldown(
        minigameId, cooldownHours, _minigameCooldowns);
    notifyListeners();
  }

  Future<String> grantMinigameReward() async {
    final rewardType = await _inventorySvc.grantMinigameReward(_inventoryItems);
    if (rewardType.startsWith('coins_')) {
      final amount = int.parse(rewardType.split('_')[1]);
      _coins += amount;
    } else if (rewardType.startsWith('wood_')) {
      final amount = int.parse(rewardType.split('_')[1]);
      _wood += amount;
    } else if (rewardType == 'gems_5') {
      _gems += 5;
    } else {
      _hasNewBackpackItems = true;
    }
    notifyListeners();
    return rewardType;
  }

  Future<void> cleanupExpiredPowerups() async {
    await _inventorySvc.cleanupExpiredPowerups(_activePowerups);
    _villagerSvc.updateVillagerHappiness(_villagers, _placedBuildings,
        walkableTiles, _activePowerups, _playerLevel);
    notifyListeners();
  }

  // --- Mission operations ---

  Future<void> checkMissions({int? totalPagesRead, int? completedBooks}) async {
    if (totalPagesRead != null) _lastTotalPagesRead = totalPagesRead;
    if (completedBooks != null) _lastCompletedBooks = completedBooks;
    await _missionSvc.checkMissions(
      progress: _missionProgress,
      buildings: _placedBuildings,
      villagers: _villagers,
      activePowerups: _activePowerups,
      booksUsedSinceActive: _booksUsedSinceActive,
      totalPagesRead: _lastTotalPagesRead,
      completedBooks: _lastCompletedBooks,
      nonGrassTileCount: _roadTiles.length + _specialTiles.length,
      expansionCount: _expansionCount,
    );
    notifyListeners();
  }

  Future<void> _resolveEventSpeciesRewards() async {
    final now = DateTime.now();
    final activeEvents = HolidayRules.activeEvents(now);
    bool changed = false;
    for (final event in activeEvents) {
      final key = '${event.id}_${now.year}';
      if (_eventSpeciesOverrides.containsKey(key)) continue;
      final missions = MissionData.getMissionsForBranch(event.branch);
      Mission? target;
      for (final m in missions.reversed) {
        if (m.reward.speciesId != null) {
          target = m;
          break;
        }
      }
      if (target == null) continue;
      final originalId = target.reward.speciesId!;
      String resolvedId;
      final chain = HolidayRules.speciesChainForEvent(event.id);
      if (chain != null && chain.isNotEmpty) {
        String? nextInChain;
        for (final speciesId in chain) {
          if (!_unlockedSpeciesIds.contains(speciesId)) {
            nextInChain = speciesId;
            break;
          }
        }
        resolvedId = nextInChain ??
            (SpeciesRules.pickRandomSpeciesReward(_unlockedSpeciesIds, Random())
                    ?.id ??
                chain.first);
      } else {
        if (!_unlockedSpeciesIds.contains(originalId)) {
          resolvedId = originalId;
        } else {
          resolvedId = SpeciesRules.pickRandomSpeciesReward(
                      _unlockedSpeciesIds, Random())
                  ?.id ??
              originalId;
        }
      }
      _eventSpeciesOverrides[key] = resolvedId;
      changed = true;
    }
    if (changed) await _repo.setEventSpeciesOverrides(_eventSpeciesOverrides);
  }

  String? getEventSpeciesReward(MissionBranch branch) {
    final event = HolidayRules.eventForBranch(branch);
    if (event == null) return null;
    final key = '${event.id}_${DateTime.now().year}';
    return _eventSpeciesOverrides[key];
  }

  Future<
      ({
        bool success,
        bool isDuplicate,
        String? speciesId,
        String? speciesNameKey
      })> claimMissionReward(String missionId) async {
    const empty = (
      success: false,
      isDuplicate: false,
      speciesId: null,
      speciesNameKey: null
    );
    final mission = MissionData.getMissionById(missionId);
    if (mission == null) return empty;

    final reward = mission.reward;
    final result = await _missionSvc.claimMissionReward(
        missionId, _missionProgress,
        totalPagesRead: _lastTotalPagesRead,
        completedBooks: _lastCompletedBooks,
        buildings: _placedBuildings);
    if (!result) return empty;

    if (reward.exp > 0) await addExp(reward.exp);
    if (reward.coins > 0) _coins += reward.coins;
    if (reward.gems > 0) _gems += reward.gems;

    if (mission.conditionType ==
        MissionConditionType.villagerHappinessWithBook) {
      _booksUsedSinceActive = 0;
    }

    if (reward.speciesId != null) {
      String resolvedSpeciesId = reward.speciesId!;
      final event = HolidayRules.eventForBranch(mission.branch);
      if (event != null) {
        final key = '${event.id}_${DateTime.now().year}';
        final override = _eventSpeciesOverrides[key];
        if (override != null) resolvedSpeciesId = override;
      }
      notifyListeners();
      return (
        success: true,
        isDuplicate: false,
        speciesId: resolvedSpeciesId,
        speciesNameKey: null,
      );
    }

    notifyListeners();
    return (
      success: true,
      isDuplicate: false,
      speciesId: null,
      speciesNameKey: null
    );
  }

  void _notifyBookItemUsed() {
    final activeMission = getActiveMission(MissionBranch.villager);
    if (activeMission != null &&
        activeMission.conditionType ==
            MissionConditionType.villagerHappinessWithBook) {
      _booksUsedSinceActive++;
    }
  }

  static String _todayStr() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  Future<void> _resetAdDailyIfNeeded() async {
    final today = _todayStr();
    bool changed = false;
    if (_adRouletteDate != today) {
      _adRouletteAdsToday = 0;
      _adRouletteSpinsToday = 0;
      _adRouletteDate = today;
      changed = true;
    }
    if (_adGemsDate != today) {
      _adGemsAdsToday = 0;
      _adGemsClaimed = false;
      _adGemsDate = today;
      changed = true;
    }
    if (changed) await _persistAdState();
  }

  Future<void> _persistAdState() => _repo.saveAdState(
        rouletteAdsToday: _adRouletteAdsToday,
        rouletteSpinsToday: _adRouletteSpinsToday,
        roulettePendingSpin: _adRouletteHasPendingSpin,
        rouletteDate: _adRouletteDate ?? _todayStr(),
        gemsAdsToday: _adGemsAdsToday,
        gemsClaimed: _adGemsClaimed,
        gemsDate: _adGemsDate ?? _todayStr(),
      );

  Set<int> consumeNewlyConfirmedVillagerIds() {
    final ids = Set<int>.from(_newlyConfirmedVillagerIds);
    _newlyConfirmedVillagerIds.clear();
    return ids;
  }

  Duration? adCooldownRemainingFor(String placement) {
    final lastTime = _adCooldownTimes[placement];
    if (lastTime == null) return null;
    final elapsed = DateTime.now().difference(lastTime);
    final remainingMs = AppConstants.adSkipCooldownMs - elapsed.inMilliseconds;
    return remainingMs > 0 ? Duration(milliseconds: remainingMs) : null;
  }

  void recordAdCooldown(String placement) {
    _adCooldownTimes[placement] = DateTime.now();
    notifyListeners();
  }

  Duration? constructionSkipCooldownRemaining(int buildingId) {
    final lastSkip = _constructionSkipCooldowns[buildingId];
    if (lastSkip == null) return null;
    final elapsed = DateTime.now().difference(lastSkip);
    final remainingMs = AppConstants.adSkipCooldownMs - elapsed.inMilliseconds;
    return remainingMs > 0 ? Duration(milliseconds: remainingMs) : null;
  }

  Future<bool> skipConstructionTime(int buildingId, Duration skipAmount) async {
    // In simulation mode (googleAds=false), apply only a minimal cooldown for rapid testing.
    // In production (googleAds=true), enforce AdMob's minimum 30-second cooldown.
    final cooldownMs = AppConstants.adSkipCooldownMs;
    final lastSkip = _constructionSkipCooldowns[buildingId];
    if (lastSkip != null &&
        DateTime.now().difference(lastSkip).inMilliseconds < cooldownMs) {
      return false;
    }
    final idx = _placedBuildings.indexWhere((b) => b.id == buildingId);
    if (idx == -1) return false;
    final b = _placedBuildings[idx];
    if (b.isConstructed || b.constructionStart == null) return false;
    _constructionSkipCooldowns[buildingId] = DateTime.now();
    final currentStart = DateTime.parse(b.constructionStart!);
    // Calculate real skip duration to achieve exactly skipAmount of effective time reduction
    final realSkip = BuildingService.calculateRealSkipForEffectiveSkip(
        b, activePowerups, skipAmount);
    final newStart = currentStart.subtract(realSkip);
    b.constructionStart = newStart.toIso8601String();
    await _repo.updateConstructionStart(b.id!, b.constructionStart!);
    notifyListeners();
    return true;
  }

  Future<bool> watchAdForRoulette() async {
    await _resetAdDailyIfNeeded();
    if (_adRouletteHasPendingSpin) return false;
    if (_adRouletteSpinsToday >= 3) return false;
    _adRouletteAdsToday++;
    if (_adRouletteAdsToday >= 3) {
      _adRouletteHasPendingSpin = true;
      _adRouletteAdsToday = 0;
      _adRouletteSpinsToday++;
    }
    await _persistAdState();
    notifyListeners();
    return true;
  }

  Future<bool> watchAdForGems() async {
    await _resetAdDailyIfNeeded();
    if (_adGemsClaimed) return false;
    if (_adGemsAdsToday >= 3) return false;
    _adGemsAdsToday++;
    bool claimed = false;
    if (_adGemsAdsToday >= 3) {
      _adGemsClaimed = true;
      await addResources(gems: 5);
      claimed = true;
    }
    await _persistAdState();
    notifyListeners();
    return claimed;
  }
}
