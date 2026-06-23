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
        ..._booksCompletedBranch,
        ..._pageReadingBranch,
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

  static final List<int> _booksCompletedMilestones = _buildBooksMilestones();

  static List<int> _buildBooksMilestones() {
    final milestones = <int>[];
    for (int i = 1; i <= 10; i++) {
      milestones.add(i);
    }
    for (int i = 12; i <= 30; i += 2) {
      milestones.add(i);
    }
    int n = 33;
    while (n < 100) {
      milestones.add(n);
      n += 3;
    }
    milestones.add(100);
    return milestones;
  }

  static final List<int> _pageReadingMilestones = _buildPageMilestones();

  static List<int> _buildPageMilestones() {
    final milestones = <int>[
      100, 200, 300, 500, 700, 900, 1100, 1350, 1600,
      1850, 2100, 2350, 2600, 2900, 3200,
    ];
    int p = 3500;
    while (p < 30000) {
      milestones.add(p);
      p += 300;
    }
    milestones.add(30000);
    return milestones;
  }

  static final List<Mission> _booksCompletedBranch = [
    for (int i = 0; i < _booksCompletedMilestones.length; i++)
      Mission(
        id: 'bc2_books_${_booksCompletedMilestones[i]}',
        branch: MissionBranch.booksCompleted,
        checkType: MissionCheckType.bm,
        conditionType: MissionConditionType.booksCompleted,
        targetCount: _booksCompletedMilestones[i],
        reward: MissionReward(
          exp: 20 + i * 5,
          gems: (_booksCompletedMilestones[i] ~/ 10) * 2 + 3,
        ),
        orderInBranch: i,
      ),
  ];

  static final List<Mission> _pageReadingBranch = [
    for (int i = 0; i < _pageReadingMilestones.length; i++)
      Mission(
        id: 'pr_pages_${_pageReadingMilestones[i]}',
        branch: MissionBranch.pageReading,
        checkType: MissionCheckType.bm,
        conditionType: MissionConditionType.totalPagesRead,
        targetCount: _pageReadingMilestones[i],
        reward: MissionReward(
          exp: 15 + i * 3,
          gems: ((_pageReadingMilestones[i] - 1) ~/ 1500) + 2,
        ),
        orderInBranch: i,
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
