abstract class VillageRepository {
  Future<List<Map<String, dynamic>>> getPlacedBuildings();
  Future<int> insertPlacedBuilding(Map<String, dynamic> building);
  Future<void> updateConstructionStart(int buildingId, String constructionStart);
  Future<void> markBuildingConstructed(int buildingId);
  Future<void> upgradePlacedBuilding(int id, int newLevel, String constructionStart, int constructionMinutes);
  Future<void> deletePlacedBuilding(int buildingId);
  Future<void> revertBuildingUpgrade(int id, int previousLevel, int previousMinutes);
  Future<void> movePlacedBuilding(int id, int tileX, int tileY);
  Future<void> flipBuilding(int id, bool isFlipped);
  Future<void> insertRoadTile(int x, int y);
  Future<void> deleteRoadTile(int x, int y);
  Future<List<Map<String, dynamic>>> getRoadTiles();
  Future<List<Map<String, dynamic>>> getSpecialTiles();
  Future<void> upsertSpecialTile(int x, int y, String type);
  Future<void> deleteSpecialTile(int x, int y);
  Future<List<Map<String, dynamic>>> getUnlockedChunks();
  Future<void> insertUnlockedChunk(int chunkX, int chunkY);
  Future<Map<String, dynamic>> getResources();
  Future<void> addResources({int coins = 0, int gems = 0, int wood = 0, int metal = 0});
  Future<void> subtractResources({int coins = 0, int gems = 0, int wood = 0, int metal = 0});
  Future<List<Map<String, dynamic>>> getVillagers();
  Future<int> insertVillager(String name, String species, int houseId);
  Future<void> updateVillagerHappiness(int villagerId, int happiness);
  Future<void> renameVillager(int villagerId, String newName);
  Future<Map<String, dynamic>> getGameState();
  Future<void> incrementExpansionCount();
  Future<void> addExp(int amount);
  Future<void> updatePlayerLevel(int level);
  Future<void> updateUsername(String username);
  Future<void> updateTownName(String townName);
  Future<void> setTutorialCompleted();
  Future<String?> getRouletteLastFreeSpin();
  Future<void> setRouletteLastFreeSpin(String isoDate);
  Future<({String? week, int count})> getRouletteSpinWeekData();
  Future<void> setRouletteSpinWeekData(String week, int count);
  Future<List<String>> getUnlockedSpeciesIds();
  Future<void> unlockSpecies(String speciesId);
  Future<bool> isSpeciesUnlocked(String speciesId);
  Future<Map<String, String>> getEventSpeciesOverrides();
  Future<void> setEventSpeciesOverrides(Map<String, String> overrides);
  Future<List<Map<String, dynamic>>> getPendingVillagerChoices();
  Future<int> insertPendingVillagerChoice(int houseId, String species1,
      String species2, String species3, String name1, String name2, String name3);
  Future<void> deletePendingVillagerChoice(int id);
  Future<bool> isSecretCodeUsed(String code);
  Future<void> markSecretCodeUsed(String code);
  Future<
      ({
        int rouletteAdsToday,
        int rouletteSpinsToday,
        bool roulettePendingSpin,
        String? rouletteDate,
        int gemsAdsToday,
        bool gemsClaimed,
        String? gemsDate,
      })> getAdState();
  Future<void> saveAdState({
    required int rouletteAdsToday,
    required int rouletteSpinsToday,
    required bool roulettePendingSpin,
    required String? rouletteDate,
    required int gemsAdsToday,
    required bool gemsClaimed,
    required String? gemsDate,
  });
  Future<({String discountSeenKey, String gemSeenDate})> getStoreSeenData();
  Future<void> saveStoreDiscountSeenKey(String key);
  Future<void> saveStoreGemSeenDate(String date);
}
