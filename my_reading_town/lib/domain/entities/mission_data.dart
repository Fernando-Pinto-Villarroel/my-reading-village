import 'mission.dart';

class MissionData {
  static const List<String> buildingTypes = [
    'water_plant',
    'power_plant',
    'school',
    'restaurant',
    'park',
    'library',
    'hospital',
  ];

  static const List<String> allBuildingTypes = [
    'house',
    'water_plant',
    'power_plant',
    'school',
    'restaurant',
    'park',
    'library',
    'hospital',
  ];

  static List<Mission> get allMissions => [
        ..._basicConstructionBranch,
        ..._advancedConstructionBranch,
        ..._decoratorBranch,
        ..._villagerBranch,
        ..._bookTrackingBranch,
        ..._halloweenBranch,
        ..._thanksgivingBranch,
        ..._christmasBranch,
        ..._newYearBranch,
        ..._sanValentinBranch,
        ..._carnivalBranch,
        ..._easterBranch,
        ..._workersDayBranch,
        ..._environmentDayBranch,
        ..._chocolateDayBranch,
        ..._friendshipDayBranch,
        ..._youthDayBranch,
        ..._literacyDayBranch,
      ];

  static final List<Mission> _basicConstructionBranch = [
    // BUY BUILDINGS
    for (int i = 0; i < buildingTypes.length; i++)
      Mission(
        id: 'bc_buy_${buildingTypes[i]}',
        branch: MissionBranch.basicConstruction,
        checkType: MissionCheckType.bm,
        conditionType: MissionConditionType.buyBuilding,
        buildingType: buildingTypes[i],
        reward: MissionReward(
          exp: 20 + i * 5,
          coins: 0,
        ),
        orderInBranch: i,
      ),

    // HOUSES 6
    Mission(
      id: 'bc_houses_4_lv1',
      branch: MissionBranch.basicConstruction,
      checkType: MissionCheckType.bm,
      conditionType: MissionConditionType.reachBuildingCount,
      buildingType: 'house',
      targetLevel: 1,
      targetCount: 6,
      reward: MissionReward(
        exp: 20 + buildingTypes.length * 5,
        coins: 10,
      ),
      orderInBranch: buildingTypes.length,
    ),

    // UPGRADE LV2
    for (int i = 0; i < allBuildingTypes.length; i++)
      Mission(
        id: 'bc_upgrade_${allBuildingTypes[i]}_lv2',
        branch: MissionBranch.basicConstruction,
        checkType: MissionCheckType.bm,
        conditionType: MissionConditionType.upgradeBuilding,
        buildingType: allBuildingTypes[i],
        targetLevel: 2,
        reward: MissionReward(
          exp: 25 + (buildingTypes.length + i) * 5,
          coins: 15 + i * 5,
        ),
        orderInBranch: buildingTypes.length + 1 + i,
      ),

    // HOUSES 9
    Mission(
      id: 'bc_houses_8_lv1',
      branch: MissionBranch.basicConstruction,
      checkType: MissionCheckType.bm,
      conditionType: MissionConditionType.reachBuildingCount,
      buildingType: 'house',
      targetLevel: 1,
      targetCount: 9,
      reward: MissionReward(
        exp: 25 + (buildingTypes.length + allBuildingTypes.length) * 5,
        coins: 15 + allBuildingTypes.length * 5,
        gems: 3,
      ),
      orderInBranch: buildingTypes.length + allBuildingTypes.length + 1,
    ),

    // UPGRADE LV3
    for (int i = 0; i < allBuildingTypes.length; i++)
      Mission(
        id: 'bc_upgrade_${allBuildingTypes[i]}_lv3',
        branch: MissionBranch.basicConstruction,
        checkType: MissionCheckType.bm,
        conditionType: MissionConditionType.upgradeBuilding,
        buildingType: allBuildingTypes[i],
        targetLevel: 3,
        reward: MissionReward(
          exp: 30 + (buildingTypes.length + allBuildingTypes.length + i) * 5,
          coins: 20 + i * 5,
          gems: 3 + ((i + 1) ~/ 2),
        ),
        orderInBranch: buildingTypes.length + allBuildingTypes.length + 2 + i,
      ),

    // HOUSES 12
    Mission(
      id: 'bc_houses_12_lv1',
      branch: MissionBranch.basicConstruction,
      checkType: MissionCheckType.bm,
      conditionType: MissionConditionType.reachBuildingCount,
      buildingType: 'house',
      targetLevel: 1,
      targetCount: 12,
      reward: MissionReward(
        exp: 30 + (buildingTypes.length + allBuildingTypes.length * 2) * 5,
        coins: 20 + allBuildingTypes.length * 5,
        gems: 3 + ((allBuildingTypes.length + 1) ~/ 2),
      ),
      orderInBranch: buildingTypes.length + allBuildingTypes.length * 2 + 2,
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
      reward: MissionReward(exp: 20),
      orderInBranch: 0,
    ),
    Mission(
      id: 'dc_tiles_25',
      branch: MissionBranch.decorator,
      checkType: MissionCheckType.bm,
      conditionType: MissionConditionType.reachSpecialTileCount,
      targetCount: 25,
      reward: MissionReward(exp: 30, coins: 5),
      orderInBranch: 1,
    ),
    Mission(
      id: 'dc_land_1',
      branch: MissionBranch.decorator,
      checkType: MissionCheckType.bm,
      conditionType: MissionConditionType.buyTerrainSpace,
      targetCount: 1,
      reward: MissionReward(exp: 35, coins: 8),
      orderInBranch: 2,
    ),
    Mission(
      id: 'dc_deco_3_coin80',
      branch: MissionBranch.decorator,
      checkType: MissionCheckType.bm,
      conditionType: MissionConditionType.haveDecorationMinCoinCost,
      targetCount: 3,
      targetMinCost: 80,
      reward: MissionReward(exp: 40, coins: 10),
      orderInBranch: 3,
    ),
    Mission(
      id: 'dc_tiles_40',
      branch: MissionBranch.decorator,
      checkType: MissionCheckType.bm,
      conditionType: MissionConditionType.reachSpecialTileCount,
      targetCount: 40,
      reward: MissionReward(exp: 50, coins: 12),
      orderInBranch: 4,
    ),
    Mission(
      id: 'dc_land_3',
      branch: MissionBranch.decorator,
      checkType: MissionCheckType.bm,
      conditionType: MissionConditionType.buyTerrainSpace,
      targetCount: 3,
      reward: MissionReward(exp: 55, coins: 15),
      orderInBranch: 5,
    ),
    Mission(
      id: 'dc_deco_1_gem10',
      branch: MissionBranch.decorator,
      checkType: MissionCheckType.bm,
      conditionType: MissionConditionType.haveDecorationMinGemCost,
      targetCount: 1,
      targetMinCost: 10,
      reward: MissionReward(exp: 60, coins: 18),
      orderInBranch: 6,
    ),
    Mission(
      id: 'dc_tiles_60',
      branch: MissionBranch.decorator,
      checkType: MissionCheckType.bm,
      conditionType: MissionConditionType.reachSpecialTileCount,
      targetCount: 60,
      reward: MissionReward(exp: 70, coins: 20),
      orderInBranch: 7,
    ),
    Mission(
      id: 'dc_land_5',
      branch: MissionBranch.decorator,
      checkType: MissionCheckType.bm,
      conditionType: MissionConditionType.buyTerrainSpace,
      targetCount: 5,
      reward: MissionReward(exp: 75, coins: 22, gems: 2),
      orderInBranch: 8,
    ),
    Mission(
      id: 'dc_deco_1_gem30',
      branch: MissionBranch.decorator,
      checkType: MissionCheckType.bm,
      conditionType: MissionConditionType.haveDecorationMinGemCost,
      targetCount: 1,
      targetMinCost: 30,
      reward: MissionReward(exp: 80, coins: 25, gems: 3),
      orderInBranch: 9,
    ),
    Mission(
      id: 'dc_tiles_80',
      branch: MissionBranch.decorator,
      checkType: MissionCheckType.bm,
      conditionType: MissionConditionType.reachSpecialTileCount,
      targetCount: 80,
      reward: MissionReward(exp: 90, coins: 25, gems: 3),
      orderInBranch: 10,
    ),
    Mission(
      id: 'dc_land_8',
      branch: MissionBranch.decorator,
      checkType: MissionCheckType.bm,
      conditionType: MissionConditionType.buyTerrainSpace,
      targetCount: 8,
      reward: MissionReward(exp: 95, coins: 28, gems: 4),
      orderInBranch: 11,
    ),
    Mission(
      id: 'dc_deco_5_coin100',
      branch: MissionBranch.decorator,
      checkType: MissionCheckType.bm,
      conditionType: MissionConditionType.haveDecorationMinCoinCost,
      targetCount: 5,
      targetMinCost: 100,
      reward: MissionReward(exp: 100, coins: 30, gems: 5),
      orderInBranch: 12,
    ),
    Mission(
      id: 'dc_land_12',
      branch: MissionBranch.decorator,
      checkType: MissionCheckType.bm,
      conditionType: MissionConditionType.buyTerrainSpace,
      targetCount: 12,
      reward: MissionReward(exp: 110, coins: 30, gems: 5),
      orderInBranch: 13,
    ),
  ];

  static final List<Mission> _advancedConstructionBranch = [
    // LV1
    for (int i = 0; i < allBuildingTypes.length; i++)
      Mission(
        id: 'ac_count_${allBuildingTypes[i]}_lv1',
        branch: MissionBranch.advancedConstruction,
        checkType: MissionCheckType.bm,
        conditionType: MissionConditionType.reachBuildingCount,
        buildingType: allBuildingTypes[i],
        targetLevel: 1,
        targetCount: _advCount(allBuildingTypes[i], 1),
        reward: MissionReward(
          exp: 150 + i * 5,
          coins: 65 + i * 5,
          gems: 8 + (i ~/ 2),
        ),
        orderInBranch: i,
      ),

    // LV2
    for (int i = 0; i < allBuildingTypes.length; i++)
      Mission(
        id: 'ac_count_${allBuildingTypes[i]}_lv2',
        branch: MissionBranch.advancedConstruction,
        checkType: MissionCheckType.bm,
        conditionType: MissionConditionType.reachBuildingCount,
        buildingType: allBuildingTypes[i],
        targetLevel: 2,
        targetCount: _advCount(allBuildingTypes[i], 2),
        reward: MissionReward(
          exp: 150 + (allBuildingTypes.length + i) * 5,
          coins: 65 + (allBuildingTypes.length + i) * 5,
          gems: 8 + ((allBuildingTypes.length + i) ~/ 2),
        ),
        orderInBranch: allBuildingTypes.length + i,
      ),

    // LV3
    for (int i = 0; i < allBuildingTypes.length; i++)
      Mission(
        id: 'ac_count_${allBuildingTypes[i]}_lv3',
        branch: MissionBranch.advancedConstruction,
        checkType: MissionCheckType.bm,
        conditionType: MissionConditionType.reachBuildingCount,
        buildingType: allBuildingTypes[i],
        targetLevel: 3,
        targetCount: _advCount(allBuildingTypes[i], 3),
        reward: MissionReward(
          exp: 150 + (allBuildingTypes.length * 2 + i) * 5,
          coins: 65 + (allBuildingTypes.length * 2 + i) * 5,
          gems: 8 + ((allBuildingTypes.length * 2 + i) ~/ 2),
        ),
        orderInBranch: allBuildingTypes.length * 2 + i,
      ),
  ];

  static const List<Mission> _villagerBranch = [
    Mission(
      id: 'vl_happy_1',
      branch: MissionBranch.villager,
      checkType: MissionCheckType.am,
      conditionType: MissionConditionType.villagerHappinessNatural,
      targetCount: 1,
      reward: MissionReward(exp: 30, coins: 10),
      orderInBranch: 0,
    ),
    Mission(
      id: 'vl_book_happy',
      branch: MissionBranch.villager,
      checkType: MissionCheckType.am,
      conditionType: MissionConditionType.villagerHappinessWithBook,
      targetCount: 1,
      reward: MissionReward(exp: 40, coins: 15),
      orderInBranch: 1,
    ),
    Mission(
      id: 'vl_happy_4',
      branch: MissionBranch.villager,
      checkType: MissionCheckType.am,
      conditionType: MissionConditionType.villagerHappiness,
      targetCount: 4,
      reward: MissionReward(exp: 60, coins: 20),
      orderInBranch: 2,
    ),
    Mission(
      id: 'vl_happy_8',
      branch: MissionBranch.villager,
      checkType: MissionCheckType.am,
      conditionType: MissionConditionType.villagerHappinessNatural,
      targetCount: 8,
      reward: MissionReward(exp: 80, coins: 25),
      orderInBranch: 3,
    ),
    Mission(
      id: 'vl_happy_12',
      branch: MissionBranch.villager,
      checkType: MissionCheckType.am,
      conditionType: MissionConditionType.villagerHappinessNatural,
      targetCount: 12,
      reward: MissionReward(exp: 100, coins: 30, gems: 4),
      orderInBranch: 4,
    ),
    Mission(
      id: 'vl_happy_16_natural',
      branch: MissionBranch.villager,
      checkType: MissionCheckType.am,
      conditionType: MissionConditionType.villagerHappinessNatural,
      targetCount: 16,
      reward: MissionReward(exp: 130, coins: 35, gems: 4),
      orderInBranch: 5,
    ),
    Mission(
      id: 'vl_happy_20_natural',
      branch: MissionBranch.villager,
      checkType: MissionCheckType.am,
      conditionType: MissionConditionType.villagerHappinessNatural,
      targetCount: 20,
      reward: MissionReward(exp: 160, coins: 40, gems: 5),
      orderInBranch: 6,
    ),
    Mission(
      id: 'vl_books_3',
      branch: MissionBranch.villager,
      checkType: MissionCheckType.am,
      conditionType: MissionConditionType.villagerHappinessWithBook,
      targetCount: 3,
      reward: MissionReward(exp: 180, coins: 45, gems: 5),
      orderInBranch: 7,
    ),
    Mission(
      id: 'vl_happy_25',
      branch: MissionBranch.villager,
      checkType: MissionCheckType.am,
      conditionType: MissionConditionType.villagerHappiness,
      targetCount: 25,
      reward: MissionReward(exp: 200, coins: 50, gems: 6),
      orderInBranch: 8,
    ),
    Mission(
      id: 'vl_happy_30',
      branch: MissionBranch.villager,
      checkType: MissionCheckType.am,
      conditionType: MissionConditionType.villagerHappiness,
      targetCount: 30,
      reward: MissionReward(exp: 230, coins: 55, gems: 6),
      orderInBranch: 9,
    ),
    Mission(
      id: 'vl_happy_35',
      branch: MissionBranch.villager,
      checkType: MissionCheckType.am,
      conditionType: MissionConditionType.villagerHappiness,
      targetCount: 35,
      reward: MissionReward(exp: 260, coins: 60, gems: 7),
      orderInBranch: 10,
    ),
    Mission(
      id: 'vl_books_5',
      branch: MissionBranch.villager,
      checkType: MissionCheckType.am,
      conditionType: MissionConditionType.villagerHappinessWithBook,
      targetCount: 5,
      reward: MissionReward(exp: 290, coins: 65, gems: 7),
      orderInBranch: 11,
    ),
    Mission(
      id: 'vl_happy_40',
      branch: MissionBranch.villager,
      checkType: MissionCheckType.am,
      conditionType: MissionConditionType.villagerHappiness,
      targetCount: 40,
      reward: MissionReward(exp: 320, coins: 70, gems: 8),
      orderInBranch: 12,
    ),
    Mission(
      id: 'vl_happy_45',
      branch: MissionBranch.villager,
      checkType: MissionCheckType.am,
      conditionType: MissionConditionType.villagerHappiness,
      targetCount: 45,
      reward: MissionReward(exp: 360, coins: 75, gems: 8),
      orderInBranch: 13,
    ),
    Mission(
      id: 'vl_happy_50',
      branch: MissionBranch.villager,
      checkType: MissionCheckType.am,
      conditionType: MissionConditionType.villagerHappiness,
      targetCount: 50,
      reward: MissionReward(exp: 400, coins: 80, gems: 9),
      orderInBranch: 14,
    ),
  ];

  static const List<Mission> _bookTrackingBranch = [
    Mission(
      id: 'bt_pages_100',
      branch: MissionBranch.bookTracking,
      checkType: MissionCheckType.bm,
      conditionType: MissionConditionType.totalPagesRead,
      targetCount: 100,
      reward: MissionReward(exp: 25, gems: 3),
      orderInBranch: 0,
    ),
    Mission(
      id: 'bt_pages_300',
      branch: MissionBranch.bookTracking,
      checkType: MissionCheckType.bm,
      conditionType: MissionConditionType.totalPagesRead,
      targetCount: 300,
      reward: MissionReward(exp: 40, coins: 20, gems: 5),
      orderInBranch: 1,
    ),
    Mission(
      id: 'bt_books_1',
      branch: MissionBranch.bookTracking,
      checkType: MissionCheckType.bm,
      conditionType: MissionConditionType.booksCompleted,
      targetCount: 1,
      reward: MissionReward(exp: 50, coins: 30, gems: 10),
      orderInBranch: 2,
    ),
    Mission(
      id: 'bt_pages_500',
      branch: MissionBranch.bookTracking,
      checkType: MissionCheckType.bm,
      conditionType: MissionConditionType.totalPagesRead,
      targetCount: 500,
      reward: MissionReward(exp: 60, coins: 40, gems: 12),
      orderInBranch: 3,
    ),
    Mission(
      id: 'bt_pages_750',
      branch: MissionBranch.bookTracking,
      checkType: MissionCheckType.bm,
      conditionType: MissionConditionType.totalPagesRead,
      targetCount: 750,
      reward: MissionReward(exp: 70, coins: 50, gems: 15),
      orderInBranch: 4,
    ),
    Mission(
      id: 'bt_books_2',
      branch: MissionBranch.bookTracking,
      checkType: MissionCheckType.bm,
      conditionType: MissionConditionType.booksCompleted,
      targetCount: 2,
      reward: MissionReward(exp: 80, coins: 60, gems: 20),
      orderInBranch: 5,
    ),
    Mission(
      id: 'bt_pages_1000',
      branch: MissionBranch.bookTracking,
      checkType: MissionCheckType.bm,
      conditionType: MissionConditionType.totalPagesRead,
      targetCount: 1000,
      reward: MissionReward(exp: 100, coins: 70, gems: 25),
      orderInBranch: 6,
    ),
    Mission(
      id: 'bt_pages_1500',
      branch: MissionBranch.bookTracking,
      checkType: MissionCheckType.bm,
      conditionType: MissionConditionType.totalPagesRead,
      targetCount: 1500,
      reward: MissionReward(exp: 120, coins: 90, gems: 30),
      orderInBranch: 7,
    ),
    Mission(
      id: 'bt_books_4',
      branch: MissionBranch.bookTracking,
      checkType: MissionCheckType.bm,
      conditionType: MissionConditionType.booksCompleted,
      targetCount: 4,
      reward: MissionReward(exp: 140, coins: 100, gems: 35),
      orderInBranch: 8,
    ),
    Mission(
      id: 'bt_pages_2500',
      branch: MissionBranch.bookTracking,
      checkType: MissionCheckType.bm,
      conditionType: MissionConditionType.totalPagesRead,
      targetCount: 2500,
      reward: MissionReward(exp: 180, coins: 120, gems: 40),
      orderInBranch: 9,
    ),
    Mission(
      id: 'bt_books_8',
      branch: MissionBranch.bookTracking,
      checkType: MissionCheckType.bm,
      conditionType: MissionConditionType.booksCompleted,
      targetCount: 8,
      reward: MissionReward(exp: 250, coins: 150, gems: 50),
      orderInBranch: 10,
    ),
  ];

  static const List<Mission> _halloweenBranch = [
    Mission(
      id: 'hw_enter',
      branch: MissionBranch.halloween,
      checkType: MissionCheckType.am,
      conditionType: MissionConditionType.enterAppDuringEvent,
      reward: MissionReward(exp: 20, coins: 20),
      orderInBranch: 0,
    ),
    Mission(
      id: 'hw_pages_500',
      branch: MissionBranch.halloween,
      checkType: MissionCheckType.bm,
      conditionType: MissionConditionType.totalPagesRead,
      targetCount: 500,
      reward: MissionReward(exp: 40, gems: 5),
      orderInBranch: 1,
    ),
    Mission(
      id: 'hw_buy_lamp_post',
      branch: MissionBranch.halloween,
      checkType: MissionCheckType.am,
      conditionType: MissionConditionType.buySpecificDecorationSinceActivation,
      buildingType: 'lamp_post',
      targetCount: 1,
      reward: MissionReward(exp: 60, speciesId: 'bat'),
      orderInBranch: 2,
    ),
  ];

  static const List<Mission> _thanksgivingBranch = [
    Mission(
      id: 'tg_enter',
      branch: MissionBranch.thanksgiving,
      checkType: MissionCheckType.am,
      conditionType: MissionConditionType.enterAppDuringEvent,
      reward: MissionReward(exp: 20, coins: 20),
      orderInBranch: 0,
    ),
    Mission(
      id: 'tg_pages_500',
      branch: MissionBranch.thanksgiving,
      checkType: MissionCheckType.bm,
      conditionType: MissionConditionType.totalPagesRead,
      targetCount: 500,
      reward: MissionReward(exp: 40, gems: 5),
      orderInBranch: 1,
    ),
    Mission(
      id: 'tg_buy_statue',
      branch: MissionBranch.thanksgiving,
      checkType: MissionCheckType.am,
      conditionType: MissionConditionType.buySpecificDecorationSinceActivation,
      buildingType: 'cat_colon_statue',
      targetCount: 1,
      reward: MissionReward(exp: 70, speciesId: 'turkey'),
      orderInBranch: 2,
    ),
  ];

  static const List<Mission> _christmasBranch = [
    Mission(
      id: 'xmas_enter',
      branch: MissionBranch.christmas,
      checkType: MissionCheckType.am,
      conditionType: MissionConditionType.enterAppDuringEvent,
      reward: MissionReward(exp: 20, coins: 20),
      orderInBranch: 0,
    ),
    Mission(
      id: 'xmas_pages_500',
      branch: MissionBranch.christmas,
      checkType: MissionCheckType.bm,
      conditionType: MissionConditionType.totalPagesRead,
      targetCount: 500,
      reward: MissionReward(exp: 50, gems: 5),
      orderInBranch: 1,
    ),
    Mission(
      id: 'xmas_buy_christmas_tree',
      branch: MissionBranch.christmas,
      checkType: MissionCheckType.am,
      conditionType: MissionConditionType.buySpecificDecorationSinceActivation,
      buildingType: 'christmas_tree',
      targetCount: 1,
      reward: MissionReward(exp: 80, speciesId: 'polar_bear'),
      orderInBranch: 2,
    ),
  ];

  static const List<Mission> _newYearBranch = [
    Mission(
      id: 'ny_enter',
      branch: MissionBranch.newYear,
      checkType: MissionCheckType.am,
      conditionType: MissionConditionType.enterAppDuringEvent,
      reward: MissionReward(exp: 20, coins: 20),
      orderInBranch: 0,
    ),
    Mission(
      id: 'ny_pages_300',
      branch: MissionBranch.newYear,
      checkType: MissionCheckType.bm,
      conditionType: MissionConditionType.totalPagesRead,
      targetCount: 300,
      reward: MissionReward(exp: 40, gems: 3),
      orderInBranch: 1,
    ),
    Mission(
      id: 'ny_buy_celebration_arch',
      branch: MissionBranch.newYear,
      checkType: MissionCheckType.am,
      conditionType: MissionConditionType.buySpecificDecorationSinceActivation,
      buildingType: 'celebration_arch',
      targetCount: 1,
      reward: MissionReward(exp: 70, speciesId: 'lion'),
      orderInBranch: 2,
    ),
  ];

  static const List<Mission> _sanValentinBranch = [
    Mission(
      id: 'sv_enter',
      branch: MissionBranch.sanValentin,
      checkType: MissionCheckType.am,
      conditionType: MissionConditionType.enterAppDuringEvent,
      reward: MissionReward(exp: 20, coins: 20),
      orderInBranch: 0,
    ),
    Mission(
      id: 'sv_pages_200',
      branch: MissionBranch.sanValentin,
      checkType: MissionCheckType.bm,
      conditionType: MissionConditionType.totalPagesRead,
      targetCount: 200,
      reward: MissionReward(exp: 40, gems: 3),
      orderInBranch: 1,
    ),
    Mission(
      id: 'sv_buy_bench',
      branch: MissionBranch.sanValentin,
      checkType: MissionCheckType.am,
      conditionType: MissionConditionType.buySpecificDecorationSinceActivation,
      buildingType: 'reading_bench',
      targetCount: 1,
      reward: MissionReward(exp: 60, speciesId: 'otter'),
      orderInBranch: 2,
    ),
  ];

  static const List<Mission> _carnivalBranch = [
    Mission(
      id: 'carn_enter',
      branch: MissionBranch.carnival,
      checkType: MissionCheckType.am,
      conditionType: MissionConditionType.enterAppDuringEvent,
      reward: MissionReward(exp: 20, coins: 20),
      orderInBranch: 0,
    ),
    Mission(
      id: 'carn_pages_500',
      branch: MissionBranch.carnival,
      checkType: MissionCheckType.bm,
      conditionType: MissionConditionType.totalPagesRead,
      targetCount: 500,
      reward: MissionReward(exp: 40, gems: 5),
      orderInBranch: 1,
    ),
    Mission(
      id: 'carn_buy_water_font',
      branch: MissionBranch.carnival,
      checkType: MissionCheckType.am,
      conditionType: MissionConditionType.buySpecificDecorationSinceActivation,
      buildingType: 'water_font',
      targetCount: 1,
      reward: MissionReward(exp: 80, speciesId: 'zebra'),
      orderInBranch: 2,
    ),
  ];

  static const List<Mission> _easterBranch = [
    Mission(
      id: 'easter_enter',
      branch: MissionBranch.easter,
      checkType: MissionCheckType.am,
      conditionType: MissionConditionType.enterAppDuringEvent,
      reward: MissionReward(exp: 20, coins: 20),
      orderInBranch: 0,
    ),
    Mission(
      id: 'easter_pages_400',
      branch: MissionBranch.easter,
      checkType: MissionCheckType.bm,
      conditionType: MissionConditionType.totalPagesRead,
      targetCount: 400,
      reward: MissionReward(exp: 40, gems: 5),
      orderInBranch: 1,
    ),
    Mission(
      id: 'easter_rabbit_happy_5',
      branch: MissionBranch.easter,
      checkType: MissionCheckType.am,
      conditionType: MissionConditionType.villagerSpeciesHappiness,
      speciesType: 'rabbit',
      targetCount: 5,
      reward: MissionReward(exp: 70, speciesId: 'monkey'),
      orderInBranch: 2,
    ),
  ];

  static const List<Mission> _workersDayBranch = [
    Mission(
      id: 'wd_enter',
      branch: MissionBranch.workersDay,
      checkType: MissionCheckType.am,
      conditionType: MissionConditionType.enterAppDuringEvent,
      reward: MissionReward(exp: 20, coins: 20),
      orderInBranch: 0,
    ),
    Mission(
      id: 'wd_pages_250',
      branch: MissionBranch.workersDay,
      checkType: MissionCheckType.bm,
      conditionType: MissionConditionType.totalPagesRead,
      targetCount: 250,
      reward: MissionReward(exp: 40, gems: 3),
      orderInBranch: 1,
    ),
    Mission(
      id: 'wd_buy_gear_monument',
      branch: MissionBranch.workersDay,
      checkType: MissionCheckType.am,
      conditionType: MissionConditionType.buySpecificDecorationSinceActivation,
      buildingType: 'gear_monument',
      targetCount: 1,
      reward: MissionReward(exp: 70, speciesId: 'bull'),
      orderInBranch: 2,
    ),
  ];

  static const List<Mission> _environmentDayBranch = [
    Mission(
      id: 'env_enter',
      branch: MissionBranch.environmentDay,
      checkType: MissionCheckType.am,
      conditionType: MissionConditionType.enterAppDuringEvent,
      reward: MissionReward(exp: 20, coins: 20),
      orderInBranch: 0,
    ),
    Mission(
      id: 'env_pages_250',
      branch: MissionBranch.environmentDay,
      checkType: MissionCheckType.bm,
      conditionType: MissionConditionType.totalPagesRead,
      targetCount: 250,
      reward: MissionReward(exp: 40, gems: 3),
      orderInBranch: 1,
    ),
    Mission(
      id: 'env_buy_flower_garden',
      branch: MissionBranch.environmentDay,
      checkType: MissionCheckType.am,
      conditionType: MissionConditionType.buySpecificDecorationSinceActivation,
      buildingType: 'flower_garden',
      targetCount: 1,
      reward: MissionReward(exp: 75, speciesId: 'red_panda'),
      orderInBranch: 2,
    ),
  ];

  static const List<Mission> _chocolateDayBranch = [
    Mission(
      id: 'choc_enter',
      branch: MissionBranch.chocolateDay,
      checkType: MissionCheckType.am,
      conditionType: MissionConditionType.enterAppDuringEvent,
      reward: MissionReward(exp: 20, coins: 20),
      orderInBranch: 0,
    ),
    Mission(
      id: 'choc_pages_150',
      branch: MissionBranch.chocolateDay,
      checkType: MissionCheckType.bm,
      conditionType: MissionConditionType.totalPagesRead,
      targetCount: 150,
      reward: MissionReward(exp: 30, gems: 2),
      orderInBranch: 1,
    ),
    Mission(
      id: 'choc_buy_chocolate_fountain',
      branch: MissionBranch.chocolateDay,
      checkType: MissionCheckType.am,
      conditionType: MissionConditionType.buySpecificDecorationSinceActivation,
      buildingType: 'chocolate_fountain',
      targetCount: 1,
      reward: MissionReward(exp: 60, speciesId: 'capybara'),
      orderInBranch: 2,
    ),
  ];

  static const List<Mission> _friendshipDayBranch = [
    Mission(
      id: 'fri_enter',
      branch: MissionBranch.friendshipDay,
      checkType: MissionCheckType.am,
      conditionType: MissionConditionType.enterAppDuringEvent,
      reward: MissionReward(exp: 20, coins: 20),
      orderInBranch: 0,
    ),
    Mission(
      id: 'fri_pages_200',
      branch: MissionBranch.friendshipDay,
      checkType: MissionCheckType.bm,
      conditionType: MissionConditionType.totalPagesRead,
      targetCount: 200,
      reward: MissionReward(exp: 40, gems: 3),
      orderInBranch: 1,
    ),
    Mission(
      id: 'fri_buy_friendship_arch',
      branch: MissionBranch.friendshipDay,
      checkType: MissionCheckType.am,
      conditionType: MissionConditionType.buySpecificDecorationSinceActivation,
      buildingType: 'friendship_arch',
      targetCount: 1,
      reward: MissionReward(exp: 70, speciesId: 'horse'),
      orderInBranch: 2,
    ),
  ];

  static const List<Mission> _youthDayBranch = [
    Mission(
      id: 'yd_enter',
      branch: MissionBranch.youthDay,
      checkType: MissionCheckType.am,
      conditionType: MissionConditionType.enterAppDuringEvent,
      reward: MissionReward(exp: 20, coins: 20),
      orderInBranch: 0,
    ),
    Mission(
      id: 'yd_pages_250',
      branch: MissionBranch.youthDay,
      checkType: MissionCheckType.bm,
      conditionType: MissionConditionType.totalPagesRead,
      targetCount: 250,
      reward: MissionReward(exp: 40, gems: 3),
      orderInBranch: 1,
    ),
    Mission(
      id: 'yd_buy_wishing_well',
      branch: MissionBranch.youthDay,
      checkType: MissionCheckType.am,
      conditionType: MissionConditionType.buySpecificDecorationSinceActivation,
      buildingType: 'wishing_well',
      targetCount: 1,
      reward: MissionReward(exp: 70, speciesId: 'kangaroo'),
      orderInBranch: 2,
    ),
  ];

  static const List<Mission> _literacyDayBranch = [
    Mission(
      id: 'ld_enter',
      branch: MissionBranch.literacyDay,
      checkType: MissionCheckType.am,
      conditionType: MissionConditionType.enterAppDuringEvent,
      reward: MissionReward(exp: 20, coins: 20),
      orderInBranch: 0,
    ),
    Mission(
      id: 'ld_pages_500',
      branch: MissionBranch.literacyDay,
      checkType: MissionCheckType.bm,
      conditionType: MissionConditionType.totalPagesRead,
      targetCount: 500,
      reward: MissionReward(exp: 50, gems: 5),
      orderInBranch: 1,
    ),
    Mission(
      id: 'ld_buy_book_stack_monument',
      branch: MissionBranch.literacyDay,
      checkType: MissionCheckType.am,
      conditionType: MissionConditionType.buySpecificDecorationSinceActivation,
      buildingType: 'book_stack_monument',
      targetCount: 1,
      reward: MissionReward(exp: 90, speciesId: 'fox'),
      orderInBranch: 2,
    ),
  ];

  static int _advCount(String type, int level) {
    if (type == 'house') {
      return level == 1 ? 16 : 5;
    }
    return 3;
  }

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
