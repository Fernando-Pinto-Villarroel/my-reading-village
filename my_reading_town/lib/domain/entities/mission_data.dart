import 'mission.dart';

class MissionData {
  static const List<String> buildingTypes = [
    'water_plant', 'power_plant', 'school', 'restaurant', 'park', 'library', 'hospital',
  ];

  static const List<String> allBuildingTypes = [
    'house', 'water_plant', 'power_plant', 'school', 'restaurant', 'park', 'library', 'hospital',
  ];

  static List<Mission> get allMissions => [
    ..._basicConstructionBranch,
    ..._advancedConstructionBranch,
    ..._decoratorBranch,
    ..._villagerBranch,
    ..._bookTrackingBranch,
    ..._halloweenBranch,
    ..._christmasBranch,
    ..._easterBranch,
  ];

  static final List<Mission> _basicConstructionBranch = [
    for (int i = 0; i < buildingTypes.length; i++)
      Mission(
        id: 'bc_buy_${buildingTypes[i]}',
        branch: MissionBranch.basicConstruction,
        checkType: MissionCheckType.bm,
        conditionType: MissionConditionType.buyBuilding,
        buildingType: buildingTypes[i],
        reward: MissionReward(exp: i < 5 ? 20 + i * 5 : 25 + i * 5, coins: i == 6 ? 20 : 0),
        orderInBranch: i < 5 ? i : i + 1,
      ),

    Mission(
      id: 'bc_houses_4_lv1',
      branch: MissionBranch.basicConstruction,
      checkType: MissionCheckType.bm,
      conditionType: MissionConditionType.reachBuildingCount,
      buildingType: 'house',
      targetLevel: 1,
      targetCount: 4,
      reward: MissionReward(exp: 45),
      orderInBranch: 5,
    ),

    for (int i = 0; i < allBuildingTypes.length; i++)
      Mission(
        id: 'bc_upgrade_${allBuildingTypes[i]}_lv2',
        branch: MissionBranch.basicConstruction,
        checkType: MissionCheckType.bm,
        conditionType: MissionConditionType.upgradeBuilding,
        buildingType: allBuildingTypes[i],
        targetLevel: 2,
        reward: MissionReward(exp: i < 6 ? 40 + i * 5 : 45 + i * 5, coins: i < 6 ? 30 + i * 10 : 40 + i * 10),
        orderInBranch: i < 6 ? 8 + i : 9 + i,
      ),

    Mission(
      id: 'bc_houses_8_lv1',
      branch: MissionBranch.basicConstruction,
      checkType: MissionCheckType.bm,
      conditionType: MissionConditionType.reachBuildingCount,
      buildingType: 'house',
      targetLevel: 1,
      targetCount: 8,
      reward: MissionReward(exp: 70, coins: 90),
      orderInBranch: 14,
    ),

    for (int i = 0; i < allBuildingTypes.length; i++)
      Mission(
        id: 'bc_upgrade_${allBuildingTypes[i]}_lv3',
        branch: MissionBranch.basicConstruction,
        checkType: MissionCheckType.bm,
        conditionType: MissionConditionType.upgradeBuilding,
        buildingType: allBuildingTypes[i],
        targetLevel: 3,
        reward: MissionReward(exp: i < 6 ? 60 + i * 10 : 70 + i * 10, coins: i < 6 ? 50 + i * 15 : 65 + i * 15, gems: i < 6 ? 8 + i * 3 : 11 + i * 3),
        orderInBranch: i < 6 ? 17 + i : 18 + i,
      ),

    Mission(
      id: 'bc_houses_12_lv1',
      branch: MissionBranch.basicConstruction,
      checkType: MissionCheckType.bm,
      conditionType: MissionConditionType.reachBuildingCount,
      buildingType: 'house',
      targetLevel: 1,
      targetCount: 12,
      reward: MissionReward(exp: 120, coins: 140, gems: 26),
      orderInBranch: 23,
    ),
  ];

  static const List<Mission> _decoratorBranch = [
    Mission(
      id: 'dc_deco_1_coin50',
      branch: MissionBranch.decorator,
      checkType: MissionCheckType.bm,
      conditionType: MissionConditionType.haveDecorationMinCoinCost,
      targetCount: 1,
      targetMinCost: 50,
      reward: MissionReward(exp: 10),
      orderInBranch: 0,
    ),
    Mission(
      id: 'dc_tiles_25',
      branch: MissionBranch.decorator,
      checkType: MissionCheckType.bm,
      conditionType: MissionConditionType.reachSpecialTileCount,
      targetCount: 25,
      reward: MissionReward(exp: 20),
      orderInBranch: 1,
    ),
    Mission(
      id: 'dc_deco_3_coin80',
      branch: MissionBranch.decorator,
      checkType: MissionCheckType.bm,
      conditionType: MissionConditionType.haveDecorationMinCoinCost,
      targetCount: 3,
      targetMinCost: 80,
      reward: MissionReward(exp: 30),
      orderInBranch: 2,
    ),
    Mission(
      id: 'dc_tiles_40',
      branch: MissionBranch.decorator,
      checkType: MissionCheckType.bm,
      conditionType: MissionConditionType.reachSpecialTileCount,
      targetCount: 40,
      reward: MissionReward(exp: 40),
      orderInBranch: 3,
    ),
    Mission(
      id: 'dc_deco_1_gem10',
      branch: MissionBranch.decorator,
      checkType: MissionCheckType.bm,
      conditionType: MissionConditionType.haveDecorationMinGemCost,
      targetCount: 1,
      targetMinCost: 10,
      reward: MissionReward(exp: 50, coins: 20),
      orderInBranch: 4,
    ),
    Mission(
      id: 'dc_tiles_60',
      branch: MissionBranch.decorator,
      checkType: MissionCheckType.bm,
      conditionType: MissionConditionType.reachSpecialTileCount,
      targetCount: 60,
      reward: MissionReward(exp: 60, coins: 30),
      orderInBranch: 5,
    ),
    Mission(
      id: 'dc_deco_1_gem30',
      branch: MissionBranch.decorator,
      checkType: MissionCheckType.bm,
      conditionType: MissionConditionType.haveDecorationMinGemCost,
      targetCount: 1,
      targetMinCost: 30,
      reward: MissionReward(exp: 50, coins: 40),
      orderInBranch: 6,
    ),
    Mission(
      id: 'dc_tiles_80',
      branch: MissionBranch.decorator,
      checkType: MissionCheckType.bm,
      conditionType: MissionConditionType.reachSpecialTileCount,
      targetCount: 80,
      reward: MissionReward(exp: 60, gems: 5),
      orderInBranch: 7,
    ),
    Mission(
      id: 'dc_deco_5_coin100',
      branch: MissionBranch.decorator,
      checkType: MissionCheckType.bm,
      conditionType: MissionConditionType.haveDecorationMinCoinCost,
      targetCount: 5,
      targetMinCost: 100,
      reward: MissionReward(exp: 70, gems: 10),
      orderInBranch: 8,
    ),
  ];

  static final List<Mission> _advancedConstructionBranch = [
    for (int i = 0; i < allBuildingTypes.length; i++)
      Mission(
        id: 'ac_count_${allBuildingTypes[i]}_lv1',
        branch: MissionBranch.advancedConstruction,
        checkType: MissionCheckType.bm,
        conditionType: MissionConditionType.reachBuildingCount,
        buildingType: allBuildingTypes[i],
        targetLevel: 1,
        targetCount: _advCount(allBuildingTypes[i]),
        reward: MissionReward(exp: 50 + i * 10, coins: 40 + i * 10),
        orderInBranch: i,
      ),

    for (int i = 0; i < allBuildingTypes.length; i++)
      Mission(
        id: 'ac_count_${allBuildingTypes[i]}_lv2',
        branch: MissionBranch.advancedConstruction,
        checkType: MissionCheckType.bm,
        conditionType: MissionConditionType.reachBuildingCount,
        buildingType: allBuildingTypes[i],
        targetLevel: 2,
        targetCount: _advCount(allBuildingTypes[i]),
        reward: MissionReward(exp: 80 + i * 10, coins: 60 + i * 15, gems: 10 + i * 3),
        orderInBranch: 8 + i,
      ),

    for (int i = 0; i < allBuildingTypes.length; i++)
      Mission(
        id: 'ac_count_${allBuildingTypes[i]}_lv3',
        branch: MissionBranch.advancedConstruction,
        checkType: MissionCheckType.bm,
        conditionType: MissionConditionType.reachBuildingCount,
        buildingType: allBuildingTypes[i],
        targetLevel: 3,
        targetCount: _advCount(allBuildingTypes[i]),
        reward: MissionReward(exp: 120 + i * 15, coins: 100 + i * 20, gems: 20 + i * 5),
        orderInBranch: 16 + i,
      ),
  ];

  static const List<Mission> _villagerBranch = [
    Mission(
      id: 'vl_happy_1',
      branch: MissionBranch.villager,
      checkType: MissionCheckType.am,
      conditionType: MissionConditionType.villagerHappiness,
      targetCount: 1,
      reward: MissionReward(exp: 30, coins: 20),
      orderInBranch: 0,
    ),
    Mission(
      id: 'vl_book_happy',
      branch: MissionBranch.villager,
      checkType: MissionCheckType.am,
      conditionType: MissionConditionType.villagerHappinessWithBook,
      targetCount: 1,
      reward: MissionReward(exp: 40, coins: 30),
      orderInBranch: 1,
    ),
    Mission(
      id: 'vl_happy_3',
      branch: MissionBranch.villager,
      checkType: MissionCheckType.am,
      conditionType: MissionConditionType.villagerHappiness,
      targetCount: 3,
      reward: MissionReward(exp: 60, coins: 50),
      orderInBranch: 2,
    ),
    Mission(
      id: 'vl_happy_5',
      branch: MissionBranch.villager,
      checkType: MissionCheckType.am,
      conditionType: MissionConditionType.villagerHappiness,
      targetCount: 5,
      reward: MissionReward(exp: 80, coins: 70, gems: 10),
      orderInBranch: 3,
    ),
    Mission(
      id: 'vl_happy_10',
      branch: MissionBranch.villager,
      checkType: MissionCheckType.am,
      conditionType: MissionConditionType.villagerHappiness,
      targetCount: 10,
      reward: MissionReward(exp: 120, coins: 100, gems: 20),
      orderInBranch: 4,
    ),
    Mission(
      id: 'vl_happy_12_natural',
      branch: MissionBranch.villager,
      checkType: MissionCheckType.am,
      conditionType: MissionConditionType.villagerHappinessNatural,
      targetCount: 12,
      reward: MissionReward(exp: 200, coins: 150, gems: 50),
      orderInBranch: 5,
    ),
  ];

  static const List<Mission> _bookTrackingBranch = [
    Mission(
      id: 'bt_pages_100',
      branch: MissionBranch.bookTracking,
      checkType: MissionCheckType.bm,
      conditionType: MissionConditionType.totalPagesRead,
      targetCount: 100,
      reward: MissionReward(exp: 25, gems: 5),
      orderInBranch: 0,
    ),
    Mission(
      id: 'bt_pages_300',
      branch: MissionBranch.bookTracking,
      checkType: MissionCheckType.bm,
      conditionType: MissionConditionType.totalPagesRead,
      targetCount: 300,
      reward: MissionReward(exp: 40, coins: 20, gems: 10),
      orderInBranch: 1,
    ),
    Mission(
      id: 'bt_books_1',
      branch: MissionBranch.bookTracking,
      checkType: MissionCheckType.bm,
      conditionType: MissionConditionType.booksCompleted,
      targetCount: 1,
      reward: MissionReward(exp: 50, coins: 30, gems: 15),
      orderInBranch: 2,
    ),
    Mission(
      id: 'bt_pages_500',
      branch: MissionBranch.bookTracking,
      checkType: MissionCheckType.bm,
      conditionType: MissionConditionType.totalPagesRead,
      targetCount: 500,
      reward: MissionReward(exp: 60, coins: 40, gems: 20),
      orderInBranch: 3,
    ),
    Mission(
      id: 'bt_pages_750',
      branch: MissionBranch.bookTracking,
      checkType: MissionCheckType.bm,
      conditionType: MissionConditionType.totalPagesRead,
      targetCount: 750,
      reward: MissionReward(exp: 70, coins: 50, gems: 25),
      orderInBranch: 4,
    ),
    Mission(
      id: 'bt_books_2',
      branch: MissionBranch.bookTracking,
      checkType: MissionCheckType.bm,
      conditionType: MissionConditionType.booksCompleted,
      targetCount: 2,
      reward: MissionReward(exp: 80, coins: 60, gems: 30),
      orderInBranch: 5,
    ),
    Mission(
      id: 'bt_pages_1000',
      branch: MissionBranch.bookTracking,
      checkType: MissionCheckType.bm,
      conditionType: MissionConditionType.totalPagesRead,
      targetCount: 1000,
      reward: MissionReward(exp: 100, coins: 80, gems: 35),
      orderInBranch: 6,
    ),
    Mission(
      id: 'bt_pages_1500',
      branch: MissionBranch.bookTracking,
      checkType: MissionCheckType.bm,
      conditionType: MissionConditionType.totalPagesRead,
      targetCount: 1500,
      reward: MissionReward(exp: 120, coins: 100, gems: 40),
      orderInBranch: 7,
    ),
    Mission(
      id: 'bt_books_4',
      branch: MissionBranch.bookTracking,
      checkType: MissionCheckType.bm,
      conditionType: MissionConditionType.booksCompleted,
      targetCount: 4,
      reward: MissionReward(exp: 140, coins: 120, gems: 45),
      orderInBranch: 8,
    ),
    Mission(
      id: 'bt_pages_2500',
      branch: MissionBranch.bookTracking,
      checkType: MissionCheckType.bm,
      conditionType: MissionConditionType.totalPagesRead,
      targetCount: 2500,
      reward: MissionReward(exp: 180, coins: 150, gems: 50),
      orderInBranch: 9,
    ),
    Mission(
      id: 'bt_books_8',
      branch: MissionBranch.bookTracking,
      checkType: MissionCheckType.bm,
      conditionType: MissionConditionType.booksCompleted,
      targetCount: 8,
      reward: MissionReward(exp: 250, coins: 200, gems: 60),
      orderInBranch: 10,
    ),
  ];

  static const List<Mission> _halloweenBranch = [
    Mission(
      id: 'hw_enter',
      branch: MissionBranch.halloween,
      checkType: MissionCheckType.am,
      conditionType: MissionConditionType.enterAppDuringEvent,
      reward: MissionReward(exp: 10, coins: 50),
      orderInBranch: 0,
    ),
    Mission(
      id: 'hw_happy_5',
      branch: MissionBranch.halloween,
      checkType: MissionCheckType.am,
      conditionType: MissionConditionType.villagerHappiness,
      targetCount: 5,
      reward: MissionReward(exp: 20, gems: 3),
      orderInBranch: 1,
    ),
    Mission(
      id: 'hw_pages_500',
      branch: MissionBranch.halloween,
      checkType: MissionCheckType.bm,
      conditionType: MissionConditionType.totalPagesRead,
      targetCount: 500,
      reward: MissionReward(exp: 30, speciesId: 'polar_bear'),
      orderInBranch: 2,
    ),
  ];

  static const List<Mission> _christmasBranch = [
    Mission(
      id: 'xmas_enter',
      branch: MissionBranch.christmas,
      checkType: MissionCheckType.am,
      conditionType: MissionConditionType.enterAppDuringEvent,
      reward: MissionReward(exp: 10, coins: 50),
      orderInBranch: 0,
    ),
    Mission(
      id: 'xmas_happy_3',
      branch: MissionBranch.christmas,
      checkType: MissionCheckType.am,
      conditionType: MissionConditionType.villagerHappiness,
      targetCount: 3,
      reward: MissionReward(exp: 15, gems: 2),
      orderInBranch: 1,
    ),
    Mission(
      id: 'xmas_pages_1000',
      branch: MissionBranch.christmas,
      checkType: MissionCheckType.bm,
      conditionType: MissionConditionType.totalPagesRead,
      targetCount: 1000,
      reward: MissionReward(exp: 25, gems: 5),
      orderInBranch: 2,
    ),
    Mission(
      id: 'xmas_happy_10',
      branch: MissionBranch.christmas,
      checkType: MissionCheckType.am,
      conditionType: MissionConditionType.villagerHappiness,
      targetCount: 10,
      reward: MissionReward(exp: 40, speciesId: 'panda_bear'),
      orderInBranch: 3,
    ),
  ];

  static const List<Mission> _easterBranch = [
    Mission(
      id: 'easter_enter',
      branch: MissionBranch.easter,
      checkType: MissionCheckType.am,
      conditionType: MissionConditionType.enterAppDuringEvent,
      reward: MissionReward(exp: 10, coins: 50),
      orderInBranch: 0,
    ),
    Mission(
      id: 'easter_bunny_happy_3',
      branch: MissionBranch.easter,
      checkType: MissionCheckType.am,
      conditionType: MissionConditionType.villagerSpeciesHappiness,
      speciesType: 'rabbit',
      targetCount: 3,
      reward: MissionReward(exp: 15, gems: 2),
      orderInBranch: 1,
    ),
    Mission(
      id: 'easter_pages_300',
      branch: MissionBranch.easter,
      checkType: MissionCheckType.bm,
      conditionType: MissionConditionType.totalPagesRead,
      targetCount: 300,
      reward: MissionReward(exp: 20, gems: 3),
      orderInBranch: 2,
    ),
    Mission(
      id: 'easter_happy_5',
      branch: MissionBranch.easter,
      checkType: MissionCheckType.am,
      conditionType: MissionConditionType.villagerHappiness,
      targetCount: 5,
      reward: MissionReward(exp: 20, gems: 3, speciesId: 'monkey'),
      orderInBranch: 3,
    ),
  ];

  static int _advCount(String type) => type == 'house' ? 16 : 3;

  static Mission? getMissionById(String id) {
    try {
      return allMissions.firstWhere((m) => m.id == id);
    } catch (_) {
      return null;
    }
  }

  static List<Mission> getMissionsForBranch(MissionBranch branch) {
    return allMissions.where((m) => m.branch == branch).toList()
      ..sort((a, b) => a.orderInBranch.compareTo(b.orderInBranch));
  }

  static List<MissionBranch> branchDependencies(MissionBranch branch) {
    switch (branch) {
      case MissionBranch.advancedConstruction:
        return [MissionBranch.basicConstruction];
      default:
        return [];
    }
  }
}
