part of 'database_helper.dart';

extension DatabaseHelperBackupOperations on DatabaseHelper {
  static const List<String> _allTables = [
    'books',
    'tags',
    'book_tags',
    'reading_sessions',
    'resources',
    'villagers',
    'placed_buildings',
    'road_tiles',
    'special_tiles',
    'unlocked_chunks',
    'game_state',
    'inventory_items',
    'minigame_cooldowns',
    'active_powerups',
    'mission_progress',
    'species_unlocks',
    'pending_villager_choices',
  ];

  Future<Map<String, dynamic>> exportAllTables() async {
    final db = await database;
    final result = <String, dynamic>{
      'version': 3,
      'exported_at': DateTime.now().toIso8601String(),
    };
    for (final table in _allTables) {
      final rows = await db.query(table);
      if (table == 'books') {
        result[table] = await Future.wait(rows.map((row) async {
          final mutable = Map<String, dynamic>.from(row);
          final path = mutable['cover_image_path'] as String?;
          if (path != null && path.isNotEmpty) {
            final file = File(path);
            if (await file.exists()) {
              final bytes = await file.readAsBytes();
              mutable['cover_image_data'] = base64Encode(bytes);
              mutable['cover_image_ext'] = p.extension(path).isNotEmpty ? p.extension(path) : '.jpg';
            }
          }
          return mutable;
        }));
      } else {
        result[table] = rows;
      }
    }
    return result;
  }

  Future<void> importAllTables(Map<String, dynamic> data) async {
    final db = await database;
    final dir = await getApplicationDocumentsDirectory();
    final coverDir = Directory(p.join(dir.path, 'book_covers'));
    if (!coverDir.existsSync()) coverDir.createSync(recursive: true);

    await db.transaction((txn) async {
      for (final table in _allTables.reversed) {
        await txn.delete(table);
      }
      for (final table in _allTables) {
        final rows = data[table] as List<dynamic>?;
        if (rows == null) continue;
        for (final row in rows) {
          final mutable = Map<String, dynamic>.from(row as Map);
          if (table == 'books') {
            final imageData = mutable.remove('cover_image_data') as String?;
            final imageExt = mutable.remove('cover_image_ext') as String? ?? '.jpg';
            if (imageData != null && imageData.isNotEmpty) {
              final bytes = base64Decode(imageData);
              final filename = 'cover_${DateTime.now().millisecondsSinceEpoch}$imageExt';
              final file = File(p.join(coverDir.path, filename));
              await file.writeAsBytes(bytes);
              mutable['cover_image_path'] = file.path;
            }
          }
          await txn.insert(
            table,
            mutable,
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }
      }
    });
  }

  Future<void> resetDatabase() async {
    final db = await database;
    await db.close();
    DatabaseHelper._database = null;
    final path = join(await getDatabasesPath(), 'my_reading_town.db');
    await deleteDatabase(path);
  }
}
