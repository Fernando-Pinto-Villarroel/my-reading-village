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
    'used_secret_codes',
  ];

  Future<Map<String, dynamic>> exportAllTables({Set<String>? only}) async {
    final db = await database;
    final result = <String, dynamic>{
      'version': 3,
      'exported_at': DateTime.now().toIso8601String(),
    };
    if (only != null && only.length < _allTables.length) {
      result['partial'] = true;
    }
    for (final table in _allTables) {
      if (only != null && !only.contains(table)) continue;
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
              mutable['cover_image_ext'] =
                  p.extension(path).isNotEmpty ? p.extension(path) : '.jpg';
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

  bool stripPurchasedSpeciesFromData(Map<String, dynamic> data) {
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

    final villagerRows = data['villagers'] as List<dynamic>?;
    if (villagerRows != null) {
      const starters = SpeciesRules.starterSpecies;
      final rng = Random();
      data['villagers'] = villagerRows.map((row) {
        final map = Map<String, dynamic>.from(row as Map);
        if (strippedIds.contains(map['species'] as String?)) {
          map['species'] = starters[rng.nextInt(starters.length)];
        }
        return map;
      }).toList();
    }

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

  Future<void> importAllTables(Map<String, dynamic> data) async {
    final db = await database;
    final dir = await getApplicationDocumentsDirectory();
    final coverDir = Directory(p.join(dir.path, 'book_covers'));
    if (!coverDir.existsSync()) coverDir.createSync(recursive: true);

    final tablesToRestore =
        _allTables.where((t) => data.containsKey(t)).toList();

    final tableColumns = <String, Set<String>>{};
    for (final table in tablesToRestore) {
      final info = await db.rawQuery('PRAGMA table_info($table)');
      tableColumns[table] = info.map((r) => r['name'] as String).toSet();
    }

    final importTs = DateTime.now().millisecondsSinceEpoch;

    await db.transaction((txn) async {
      for (final table in tablesToRestore.reversed) {
        await txn.delete(table);
      }
      for (final table in tablesToRestore) {
        final rows = data[table] as List<dynamic>?;
        if (rows == null) continue;
        final validColumns = tableColumns[table]!;
        for (var i = 0; i < rows.length; i++) {
          final mutable = Map<String, dynamic>.from(rows[i] as Map);
          if (table == 'books') {
            final imageData = mutable.remove('cover_image_data') as String?;
            final imageExt =
                mutable.remove('cover_image_ext') as String? ?? '.jpg';
            if (imageData != null && imageData.isNotEmpty) {
              final bytes = base64Decode(imageData);
              final filename = 'cover_${importTs}_$i$imageExt';
              final file = File(p.join(coverDir.path, filename));
              await file.writeAsBytes(bytes);
              mutable['cover_image_path'] = file.path;
            }
          }
          mutable.removeWhere((k, _) => !validColumns.contains(k));
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
    final path = join(await getDatabasesPath(), 'my_reading_village.db');
    await deleteDatabase(path);
  }
}
