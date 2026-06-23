import 'package:my_reading_village/domain/entities/placed_building.dart';
import 'package:my_reading_village/domain/entities/villager.dart';
import 'package:my_reading_village/domain/entities/inventory_item.dart';
import 'package:my_reading_village/domain/entities/mission.dart';
import 'package:my_reading_village/domain/entities/mission_data.dart';
import 'package:my_reading_village/domain/ports/inventory_repository.dart';
import 'package:my_reading_village/domain/ports/village_repository.dart';
import 'package:my_reading_village/domain/rules/holiday_rules.dart';
import 'package:my_reading_village/infrastructure/di/service_locator.dart';
import 'package:my_reading_village/application/services/time_verification_service.dart';

class MissionService {
  final InventoryRepository _invRepo;
  final VillageRepository _villageRepo;
  MissionService(this._invRepo, this._villageRepo);

  Future<Map<String, MissionProgress>> loadMissionProgress() async {
    final maps = await _invRepo.getMissionProgress();
    return {
      for (final m in maps)
        m['mission_id'] as String: MissionProgress.fromMap(m),
    };
  }

  bool isBranchUnlocked(
      MissionBranch branch, Map<String, MissionProgress> progress) {
    if (HolidayRules.isHolidayBranch(branch)) {
      final event = HolidayRules.eventForBranch(branch);
      if (event == null) return false;
      if (event.isActive(sl<TimeVerificationService>().trustedNow())) return true;
      return MissionData.getMissionsForBranch(branch)
          .any((m) => progress.containsKey(m.id));
    }
    final deps = MissionData.branchDependencies(branch);
    for (final dep in deps) {
      if (!isBranchFullyCompleted(dep, progress)) return false;
    }
    return true;
  }

  bool isBranchFullyCompleted(
      MissionBranch branch, Map<String, MissionProgress> progress) {
    final missions = MissionData.getMissionsForBranch(branch);
    return missions.every((m) {
      final p = progress[m.id];
      return p != null && p.isClaimed;
    });
  }

  Mission? getActiveMission(
      MissionBranch branch, Map<String, MissionProgress> progress) {
    if (!isBranchUnlocked(branch, progress)) return null;
    final missions = MissionData.getMissionsForBranch(branch);
    for (final mission in missions) {
      final p = progress[mission.id];
      if (p == null || !p.isClaimed) return mission;
    }
    return null;
  }

  List<Mission> getActiveMissions(Map<String, MissionProgress> progress) {
    final result = <Mission>[];
    for (final branch in MissionBranch.values) {
      final active = getActiveMission(branch, progress);
      if (active != null) result.add(active);
    }
    return result;
  }

  MissionProgress _getOrCreateProgress(
      Mission mission, Map<String, MissionProgress> progress) {
    if (!progress.containsKey(mission.id)) {
      progress[mission.id] = MissionProgress(missionId: mission.id);
    }
    return progress[mission.id]!;
  }

  bool _isEventReadingMission(Mission mission) {
    return HolidayRules.isHolidayBranch(mission.branch) &&
        (mission.conditionType == MissionConditionType.totalPagesRead ||
            mission.conditionType == MissionConditionType.booksCompleted);
  }

  bool _isEventDecorationMission(Mission mission) {
    return HolidayRules.isHolidayBranch(mission.branch) &&
        mission.conditionType ==
            MissionConditionType.buySpecificDecorationSinceActivation;
  }

  Future<void> _ensureMissionActivated(
      Mission mission, Map<String, MissionProgress> progress,
      {int? totalPagesRead,
      int? completedBooks,
      List<PlacedBuilding>? buildings}) async {
    final p = _getOrCreateProgress(mission, progress);

    final needsActivationTime = p.activatedAt == null;

    final currentPages = totalPagesRead ?? 0;
    final currentBooks = completedBooks ?? 0;
    final needsPageBaseline =
        _isEventReadingMission(mission) && p.pagesAtActivation == null;

    final needsBuildingBaseline = _isEventDecorationMission(mission) &&
        p.buildingCountAtActivation == null &&
        buildings != null;

    if (!needsActivationTime && !needsPageBaseline && !needsBuildingBaseline) {
      return;
    }

    if (needsActivationTime) {
      p.activatedAt = DateTime.now().toIso8601String();
    }

    int? pagesBaseline;
    int? booksBaseline;
    if (needsPageBaseline) {
      pagesBaseline = currentPages;
      booksBaseline = currentBooks;
      p.pagesAtActivation = pagesBaseline;
      p.booksAtActivation = booksBaseline;
    }

    int? buildingBaseline;
    if (needsBuildingBaseline) {
      buildingBaseline = buildings
          .where((b) => b.type == mission.buildingType && b.isConstructed)
          .length;
      p.buildingCountAtActivation = buildingBaseline;
    }

    await _invRepo.upsertMissionProgress(mission.id,
        activatedAt: needsActivationTime ? p.activatedAt : null,
        pagesAtActivation: pagesBaseline,
        booksAtActivation: booksBaseline,
        buildingCountAtActivation: buildingBaseline);
  }

  Future<void> checkMissions({
    required Map<String, MissionProgress> progress,
    required List<PlacedBuilding> buildings,
    required List<Villager> villagers,
    required List<ActivePowerup> activePowerups,
    required int booksUsedSinceActive,
    int? totalPagesRead,
    int? completedBooks,
    int nonGrassTileCount = 0,
    int expansionCount = 0,
    int readingMissionExcludedPages = 0,
    int readingMissionExcludedBooks = 0,
  }) async {
    for (final branch in MissionBranch.values) {
      final mission = getActiveMission(branch, progress);
      if (mission == null) continue;

      final p = _getOrCreateProgress(mission, progress);
      if (p.isCompleted) continue;

      final effectivePages = _effectivePages(
          mission, totalPagesRead, readingMissionExcludedPages);
      final effectiveBooks = _effectiveBooks(
          mission, completedBooks, readingMissionExcludedBooks);

      await _ensureMissionActivated(mission, progress,
          totalPagesRead: effectivePages,
          completedBooks: effectiveBooks,
          buildings: buildings);

      final isComplete = _checkMissionCondition(mission, p, buildings,
          villagers, activePowerups, booksUsedSinceActive,
          totalPagesRead: effectivePages,
          completedBooks: effectiveBooks,
          nonGrassTileCount: nonGrassTileCount,
          expansionCount: expansionCount);
      if (isComplete) {
        p.isCompleted = true;
        await _invRepo.upsertMissionProgress(mission.id, isCompleted: true);
      }
    }
  }

  int? _effectivePages(Mission mission, int? raw, int excluded) {
    if (mission.branch == MissionBranch.pageReading) {
      return ((raw ?? 0) - excluded).clamp(0, 999999999);
    }
    return raw;
  }

  int? _effectiveBooks(Mission mission, int? raw, int excluded) {
    if (mission.branch == MissionBranch.booksCompleted) {
      return ((raw ?? 0) - excluded).clamp(0, 999999999);
    }
    return raw;
  }

  Future<void> bulkPrecompleteMissionsForImport({
    required Map<String, MissionProgress> progress,
    required int totalPages,
    required int completedBooks,
  }) async {
    final pageBranch = MissionData.getMissionsForBranch(MissionBranch.pageReading);
    for (final mission in pageBranch) {
      if ((mission.targetCount ?? 0) <= totalPages) {
        final p = progress[mission.id] ?? MissionProgress(missionId: mission.id);
        p.isCompleted = true;
        p.isClaimed = true;
        progress[mission.id] = p;
        await _invRepo.upsertMissionProgress(mission.id,
            isCompleted: true, isClaimed: true);
      }
    }
    final bookBranch = MissionData.getMissionsForBranch(MissionBranch.booksCompleted);
    for (final mission in bookBranch) {
      if ((mission.targetCount ?? 0) <= completedBooks) {
        final p = progress[mission.id] ?? MissionProgress(missionId: mission.id);
        p.isCompleted = true;
        p.isClaimed = true;
        progress[mission.id] = p;
        await _invRepo.upsertMissionProgress(mission.id,
            isCompleted: true, isClaimed: true);
      }
    }
  }

  bool _checkMissionCondition(
      Mission mission,
      MissionProgress missionProgress,
      List<PlacedBuilding> buildings,
      List<Villager> villagers,
      List<ActivePowerup> activePowerups,
      int booksUsedSinceActive,
      {int? totalPagesRead,
      int? completedBooks,
      int nonGrassTileCount = 0,
      int expansionCount = 0}) {
    if (_isEventReadingMission(mission)) {
      totalPagesRead =
          (totalPagesRead ?? 0) - (missionProgress.pagesAtActivation ?? 0);
      completedBooks =
          (completedBooks ?? 0) - (missionProgress.booksAtActivation ?? 0);
    }
    switch (mission.conditionType) {
      case MissionConditionType.buyBuilding:
        return buildings
            .any((b) => b.type == mission.buildingType && b.isConstructed);

      case MissionConditionType.upgradeBuilding:
        return buildings.any((b) =>
            b.type == mission.buildingType &&
            b.level >= (mission.targetLevel ?? 1) &&
            b.isConstructed);

      case MissionConditionType.reachBuildingCount:
        final count = buildings
            .where((b) =>
                b.type == mission.buildingType &&
                b.level >= (mission.targetLevel ?? 1) &&
                b.isConstructed)
            .length;
        return count >= (mission.targetCount ?? 1);

      case MissionConditionType.villagerHappiness:
        final happyCount = villagers.where((v) => v.happiness >= 100).length;
        return happyCount >= (mission.targetCount ?? 1);

      case MissionConditionType.villagerHappinessWithBook:
        return booksUsedSinceActive >= (mission.targetCount ?? 1);

      case MissionConditionType.villagerHappinessNatural:
        final boostedIds = activePowerups
            .where((p) =>
                p.type == 'book_happiness' &&
                p.isActive &&
                p.targetVillagerId != null)
            .map((p) => p.targetVillagerId!)
            .toSet();
        final naturallyHappyCount = villagers
            .where((v) => v.happiness >= 100 && !boostedIds.contains(v.id))
            .length;
        return naturallyHappyCount >= (mission.targetCount ?? 1);

      case MissionConditionType.totalPagesRead:
        return (totalPagesRead ?? 0) >= (mission.targetCount ?? 1);

      case MissionConditionType.booksCompleted:
        return (completedBooks ?? 0) >= (mission.targetCount ?? 1);

      case MissionConditionType.enterAppDuringEvent:
        return true;

      case MissionConditionType.villagerSpeciesHappiness:
        final happyCount = villagers
            .where(
                (v) => v.species == mission.speciesType && v.happiness >= 100)
            .length;
        return happyCount >= (mission.targetCount ?? 1);

      case MissionConditionType.haveDecorationMinCoinCost:
        final minCost = mission.targetMinCost ?? 0;
        final count = buildings
            .where((b) =>
                b.isDecoration && b.isConstructed && b.coinCost >= minCost)
            .length;
        return count >= (mission.targetCount ?? 1);

      case MissionConditionType.haveDecorationMinGemCost:
        final minGemCost = mission.targetMinCost ?? 0;
        final gemCount = buildings
            .where((b) =>
                b.isDecoration && b.isConstructed && b.gemCost >= minGemCost)
            .length;
        return gemCount >= (mission.targetCount ?? 1);

      case MissionConditionType.reachSpecialTileCount:
        return nonGrassTileCount >= (mission.targetCount ?? 1);

      case MissionConditionType.buySpecificDecorationSinceActivation:
        final baseline = missionProgress.buildingCountAtActivation ?? 0;
        final current = buildings
            .where((b) => b.type == mission.buildingType && b.isConstructed)
            .length;
        return current - baseline >= (mission.targetCount ?? 1);

      case MissionConditionType.buyTerrainSpace:
        return expansionCount >= (mission.targetCount ?? 1);
    }
  }

  ({int current, int target}) getMissionProgressValues(
      Mission mission,
      MissionProgress? missionProgress,
      List<PlacedBuilding> buildings,
      List<Villager> villagers,
      List<ActivePowerup> activePowerups,
      int booksUsedSinceActive,
      {int? totalPagesRead,
      int? completedBooks,
      int nonGrassTileCount = 0,
      int expansionCount = 0,
      int readingMissionExcludedPages = 0,
      int readingMissionExcludedBooks = 0}) {
    totalPagesRead =
        _effectivePages(mission, totalPagesRead, readingMissionExcludedPages);
    completedBooks =
        _effectiveBooks(mission, completedBooks, readingMissionExcludedBooks);
    if (_isEventReadingMission(mission) && missionProgress != null) {
      totalPagesRead =
          ((totalPagesRead ?? 0) - (missionProgress.pagesAtActivation ?? 0))
              .clamp(0, 999999);
      completedBooks =
          ((completedBooks ?? 0) - (missionProgress.booksAtActivation ?? 0))
              .clamp(0, 999999);
    }
    final target = mission.targetCount ?? 1;
    int current = 0;

    switch (mission.conditionType) {
      case MissionConditionType.buyBuilding:
        current = buildings
            .where((b) => b.type == mission.buildingType && b.isConstructed)
            .length;
        return (current: current.clamp(0, 1), target: 1);

      case MissionConditionType.upgradeBuilding:
        current = buildings
            .where((b) =>
                b.type == mission.buildingType &&
                b.level >= (mission.targetLevel ?? 1) &&
                b.isConstructed)
            .length;
        return (current: current.clamp(0, 1), target: 1);

      case MissionConditionType.reachBuildingCount:
        current = buildings
            .where((b) =>
                b.type == mission.buildingType &&
                b.level >= (mission.targetLevel ?? 1) &&
                b.isConstructed)
            .length;
        return (current: current.clamp(0, target), target: target);

      case MissionConditionType.villagerHappiness:
        current = villagers.where((v) => v.happiness >= 100).length;
        return (current: current.clamp(0, target), target: target);

      case MissionConditionType.villagerHappinessWithBook:
        current = booksUsedSinceActive.clamp(0, target);
        return (current: current, target: target);

      case MissionConditionType.villagerHappinessNatural:
        final boostedIds = activePowerups
            .where((p) =>
                p.type == 'book_happiness' &&
                p.isActive &&
                p.targetVillagerId != null)
            .map((p) => p.targetVillagerId!)
            .toSet();
        current = villagers
            .where((v) => v.happiness >= 100 && !boostedIds.contains(v.id))
            .length;
        return (current: current.clamp(0, target), target: target);

      case MissionConditionType.totalPagesRead:
        current = totalPagesRead ?? 0;
        return (current: current.clamp(0, target), target: target);

      case MissionConditionType.booksCompleted:
        current = completedBooks ?? 0;
        return (current: current.clamp(0, target), target: target);

      case MissionConditionType.enterAppDuringEvent:
        return (current: 1, target: 1);

      case MissionConditionType.villagerSpeciesHappiness:
        current = villagers
            .where(
                (v) => v.species == mission.speciesType && v.happiness >= 100)
            .length;
        return (current: current.clamp(0, target), target: target);

      case MissionConditionType.haveDecorationMinCoinCost:
        final minCost = mission.targetMinCost ?? 0;
        current = buildings
            .where((b) =>
                b.isDecoration && b.isConstructed && b.coinCost >= minCost)
            .length;
        return (current: current.clamp(0, target), target: target);

      case MissionConditionType.haveDecorationMinGemCost:
        final minGemCost = mission.targetMinCost ?? 0;
        current = buildings
            .where((b) =>
                b.isDecoration && b.isConstructed && b.gemCost >= minGemCost)
            .length;
        return (current: current.clamp(0, target), target: target);

      case MissionConditionType.reachSpecialTileCount:
        current = nonGrassTileCount;
        return (current: current.clamp(0, target), target: target);

      case MissionConditionType.buySpecificDecorationSinceActivation:
        final baseline = missionProgress?.buildingCountAtActivation ?? 0;
        current = buildings
            .where((b) => b.type == mission.buildingType && b.isConstructed)
            .length;
        current = (current - baseline).clamp(0, target);
        return (current: current, target: target);

      case MissionConditionType.buyTerrainSpace:
        current = expansionCount.clamp(0, target);
        return (current: current, target: target);
    }
  }

  Future<void> resetReadingMissionsIfOverExclusion({
    required Map<String, MissionProgress> progress,
    required int effectivePages,
    required int effectiveBooks,
  }) async {
    final pairs = [
      (MissionBranch.pageReading, effectivePages),
      (MissionBranch.booksCompleted, effectiveBooks),
    ];
    for (final (branch, effective) in pairs) {
      for (final mission in MissionData.getMissionsForBranch(branch)) {
        final p = progress[mission.id];
        if (p == null) continue;
        if (effective < (mission.targetCount ?? 1)) {
          progress.remove(mission.id);
          await _invRepo.deleteMissionProgress(mission.id);
        }
      }
    }
  }

  Future<bool> claimMissionReward(
      String missionId, Map<String, MissionProgress> progress,
      {int? totalPagesRead,
      int? completedBooks,
      List<PlacedBuilding>? buildings}) async {
    final mission = MissionData.getMissionById(missionId);
    if (mission == null) return false;

    final p = progress[missionId];
    if (p == null || !p.isCompleted || p.isClaimed) return false;

    final reward = mission.reward;
    if (reward.coins > 0 || reward.gems > 0) {
      await _villageRepo.addResources(coins: reward.coins, gems: reward.gems);
    }

    p.isClaimed = true;
    await _invRepo.upsertMissionProgress(missionId, isClaimed: true);

    final nextMission = getActiveMission(mission.branch, progress);
    if (nextMission != null) {
      await _ensureMissionActivated(nextMission, progress,
          totalPagesRead: totalPagesRead,
          completedBooks: completedBooks,
          buildings: buildings);
    }

    return true;
  }

  int unclaimedCompletedMissionCount(Map<String, MissionProgress> progress) {
    int count = 0;
    for (final branch in MissionBranch.values) {
      final mission = getActiveMission(branch, progress);
      if (mission != null) {
        final p = progress[mission.id];
        if (p != null && p.isCompleted && !p.isClaimed) count++;
      }
    }
    return count;
  }
}
