part of 'database_helper.dart';

extension DatabaseHelperBuildingOperations on DatabaseHelper {
  Future<int> insertPlacedBuilding(Map<String, dynamic> building) async {
    final db = await database;
    return db.insert('placed_buildings', building);
  }

  Future<List<Map<String, dynamic>>> getPlacedBuildings() async {
    final db = await database;
    return db.query('placed_buildings');
  }

  Future<void> updateConstructionStart(int buildingId, String constructionStart) async {
    final db = await database;
    await db.update('placed_buildings', {'construction_start': constructionStart},
        where: 'id = ?', whereArgs: [buildingId]);
  }

  Future<void> markBuildingConstructed(
      int buildingId, String completedAt) async {
    final db = await database;
    await db.update(
        'placed_buildings', {'is_constructed': 1, 'completes_at': completedAt},
        where: 'id = ?', whereArgs: [buildingId]);
  }

  Future<void> upgradePlacedBuilding(int buildingId, int newLevel, String constructionStart, int constructionMinutes) async {
    final db = await database;
    await db.update('placed_buildings', {
      'level': newLevel,
      'is_constructed': 0,
      'construction_start': constructionStart,
      'construction_duration_minutes': constructionMinutes,
      'completes_at': null,
    }, where: 'id = ?', whereArgs: [buildingId]);
  }

  Future<void> deletePlacedBuilding(int buildingId) async {
    final db = await database;
    await db.delete('placed_buildings', where: 'id = ?', whereArgs: [buildingId]);
  }

  Future<void> revertBuildingUpgrade(int buildingId, int previousLevel, int constructionMinutes) async {
    final db = await database;
    await db.update('placed_buildings', {
      'level': previousLevel,
      'is_constructed': 1,
      'construction_start': null,
      'construction_duration_minutes': constructionMinutes,
      'completes_at': null,
    }, where: 'id = ?', whereArgs: [buildingId]);
  }

  Future<void> movePlacedBuilding(int buildingId, int newTileX, int newTileY) async {
    final db = await database;
    await db.update('placed_buildings', {
      'tile_x': newTileX,
      'tile_y': newTileY,
    }, where: 'id = ?', whereArgs: [buildingId]);
  }

  Future<void> flipBuilding(int buildingId, bool isFlipped) async {
    final db = await database;
    await db.update('placed_buildings', {
      'is_flipped': isFlipped ? 1 : 0,
    }, where: 'id = ?', whereArgs: [buildingId]);
  }

  Future<void> insertRoadTile(int x, int y) async {
    final db = await database;
    await db.insert('road_tiles', {'tile_x': x, 'tile_y': y},
        conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  Future<void> deleteRoadTile(int x, int y) async {
    final db = await database;
    await db.delete('road_tiles',
        where: 'tile_x = ? AND tile_y = ?', whereArgs: [x, y]);
  }

  Future<List<Map<String, dynamic>>> getRoadTiles() async {
    final db = await database;
    return db.query('road_tiles');
  }

  Future<List<Map<String, dynamic>>> getSpecialTiles() async {
    final db = await database;
    return db.query('special_tiles');
  }

  Future<void> upsertSpecialTile(int x, int y, String type) async {
    final db = await database;
    await db.insert(
      'special_tiles',
      {'tile_x': x, 'tile_y': y, 'tile_type': type},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteSpecialTile(int x, int y) async {
    final db = await database;
    await db.delete('special_tiles',
        where: 'tile_x = ? AND tile_y = ?', whereArgs: [x, y]);
  }

  static const Duration _fraudSlack = Duration(minutes: 2);

  bool _isFraudulentRow(Map<String, dynamic> row, DateTime trustedNow) {
    final start = row['construction_start'] as String?;
    final completes = row['completes_at'] as String?;
    final startInFuture =
        start != null && DateTime.parse(start).isAfter(trustedNow.add(_fraudSlack));
    final completesInFuture = completes != null &&
        DateTime.parse(completes).isAfter(trustedNow.add(_fraudSlack));
    return startInFuture || completesInFuture;
  }

  Future<({int count, DateTime? latestTimestamp})> getFraudulentConstructionsInfo(
      DateTime trustedNow) async {
    final db = await database;
    final buildings =
        await db.query('placed_buildings', where: 'is_constructed = 1');
    int count = 0;
    DateTime? latest;
    for (final b in buildings) {
      if (!_isFraudulentRow(b, trustedNow)) continue;
      count++;
      for (final key in ['construction_start', 'completes_at']) {
        final value = b[key] as String?;
        if (value == null) continue;
        final ts = DateTime.parse(value);
        if (latest == null || ts.isAfter(latest)) latest = ts;
      }
    }
    return (count: count, latestTimestamp: latest);
  }

  Future<int> rollbackFraudulentConstructions(DateTime trustedNow) async {
    final db = await database;
    final buildings =
        await db.query('placed_buildings', where: 'is_constructed = 1');
    int count = 0;
    for (final b in buildings) {
      if (!_isFraudulentRow(b, trustedNow)) continue;
      final start = b['construction_start'] as String?;
      final values = <String, dynamic>{
        'is_constructed': 0,
        'completes_at': null,
      };
      if (start != null && DateTime.parse(start).isAfter(trustedNow)) {
        values['construction_start'] = trustedNow.toIso8601String();
      }
      await db.update(
        'placed_buildings',
        values,
        where: 'id = ?',
        whereArgs: [b['id']],
      );
      count++;
    }
    return count;
  }

  Future<List<Map<String, dynamic>>> getUnlockedChunks() async {
    final db = await database;
    return db.query('unlocked_chunks');
  }

  Future<void> insertUnlockedChunk(int chunkX, int chunkY) async {
    final db = await database;
    await db.insert(
        'unlocked_chunks', {'chunk_x': chunkX, 'chunk_y': chunkY},
        conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  Future<List<Map<String, dynamic>>> getPendingVillagerChoices() async {
    final db = await database;
    return db.query('pending_villager_choices');
  }

  Future<int> insertPendingVillagerChoice(int houseId, String species1,
      String species2, String species3, String name1, String name2,
      String name3) async {
    final db = await database;
    return db.insert('pending_villager_choices', {
      'house_id': houseId,
      'species1': species1,
      'species2': species2,
      'species3': species3,
      'name1': name1,
      'name2': name2,
      'name3': name3,
    });
  }

  Future<void> deletePendingVillagerChoice(int id) async {
    final db = await database;
    await db.delete('pending_villager_choices',
        where: 'id = ?', whereArgs: [id]);
  }
}
