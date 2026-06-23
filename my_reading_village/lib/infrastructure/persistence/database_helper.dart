import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:my_reading_village/app_constants.dart';
import 'package:my_reading_village/domain/rules/village_rules.dart';
import 'package:my_reading_village/domain/rules/species_rules.dart';

part 'database_helper_book_operations.dart';
part 'database_helper_building_operations.dart';
part 'database_helper_game_state_operations.dart';
part 'database_helper_inventory_operations.dart';
part 'database_helper_backup_operations.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'my_reading_village.db');
    if (AppConstants.testMode) {
      await deleteDatabase(path); // DEBUG: reset DB on each launch
    }
    return await openDatabase(
      path,
      version: 1,
      onConfigure: (db) => db.execute('PRAGMA foreign_keys = ON'),
      onCreate: _createTables,
    );
  }

  Future<void> _createTables(Database db, int version) async {
    await db.execute('''
      CREATE TABLE books (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        author TEXT,
        total_pages INTEGER NOT NULL,
        pages_read INTEGER NOT NULL DEFAULT 0,
        is_completed INTEGER NOT NULL DEFAULT 0,
        max_rewarded_pages INTEGER NOT NULL DEFAULT 0,
        cover_image_path TEXT,
        created_at TEXT NOT NULL,
        rating INTEGER,
        notes TEXT,
        completed_at TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE tags (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        color_value INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE book_tags (
        book_id INTEGER NOT NULL,
        tag_id INTEGER NOT NULL,
        PRIMARY KEY (book_id, tag_id),
        FOREIGN KEY (book_id) REFERENCES books(id) ON DELETE CASCADE,
        FOREIGN KEY (tag_id) REFERENCES tags(id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE reading_sessions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        book_id INTEGER NOT NULL,
        pages_read INTEGER NOT NULL,
        coins_earned INTEGER NOT NULL,
        gems_earned INTEGER NOT NULL,
        wood_earned INTEGER NOT NULL DEFAULT 0,
        metal_earned INTEGER NOT NULL DEFAULT 0,
        date TEXT NOT NULL,
        time_taken_minutes INTEGER,
        FOREIGN KEY (book_id) REFERENCES books(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE resources (
        id INTEGER PRIMARY KEY CHECK (id = 1),
        coins INTEGER NOT NULL DEFAULT 0,
        gems INTEGER NOT NULL DEFAULT 0,
        wood INTEGER NOT NULL DEFAULT 0,
        metal INTEGER NOT NULL DEFAULT 0
      )
    ''');

    await db.execute('''
      CREATE TABLE villagers (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        species TEXT NOT NULL,
        happiness INTEGER NOT NULL DEFAULT 50,
        house_id INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE placed_buildings (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        type TEXT NOT NULL,
        name TEXT NOT NULL,
        tile_x INTEGER NOT NULL,
        tile_y INTEGER NOT NULL,
        tile_width INTEGER NOT NULL DEFAULT 1,
        tile_height INTEGER NOT NULL DEFAULT 1,
        level INTEGER NOT NULL DEFAULT 1,
        coin_cost INTEGER NOT NULL,
        gem_cost INTEGER NOT NULL DEFAULT 0,
        wood_cost INTEGER NOT NULL DEFAULT 0,
        metal_cost INTEGER NOT NULL DEFAULT 0,
        happiness_bonus INTEGER NOT NULL DEFAULT 0,
        construction_start TEXT,
        construction_duration_minutes INTEGER NOT NULL DEFAULT 60,
        is_constructed INTEGER NOT NULL DEFAULT 0,
        is_flipped INTEGER NOT NULL DEFAULT 0,
        is_decoration INTEGER NOT NULL DEFAULT 0,
        completes_at TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE processed_purchases (
        purchase_key TEXT PRIMARY KEY,
        processed_at TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE road_tiles (
        tile_x INTEGER NOT NULL,
        tile_y INTEGER NOT NULL,
        PRIMARY KEY (tile_x, tile_y)
      )
    ''');

    await db.execute('''
      CREATE TABLE special_tiles (
        tile_x INTEGER NOT NULL,
        tile_y INTEGER NOT NULL,
        tile_type TEXT NOT NULL,
        PRIMARY KEY (tile_x, tile_y)
      )
    ''');

    await db.execute('''
      CREATE TABLE unlocked_chunks (
        chunk_x INTEGER NOT NULL,
        chunk_y INTEGER NOT NULL,
        PRIMARY KEY (chunk_x, chunk_y)
      )
    ''');

    await db.execute('''
      CREATE TABLE game_state (
        id INTEGER PRIMARY KEY CHECK (id = 1),
        expansion_count INTEGER NOT NULL DEFAULT 0,
        exp INTEGER NOT NULL DEFAULT 0,
        player_level INTEGER NOT NULL DEFAULT 1,
        username TEXT NOT NULL DEFAULT '',
        town_name TEXT NOT NULL DEFAULT 'My Village',
        language TEXT NOT NULL DEFAULT 'en',
        tutorial_completed INTEGER NOT NULL DEFAULT 0,
        roulette_last_free_spin TEXT,
        roulette_spin_week TEXT,
        roulette_spin_week_count INTEGER NOT NULL DEFAULT 0,
        notif_days_enabled TEXT NOT NULL DEFAULT '1111111',
        notif_start_hour INTEGER NOT NULL DEFAULT 8,
        notif_end_hour INTEGER NOT NULL DEFAULT 22,
        notif_per_day INTEGER NOT NULL DEFAULT 2,
        event_notifs_scheduled TEXT,
        event_species_overrides TEXT NOT NULL DEFAULT '{}',
        ad_roulette_pending_spin INTEGER NOT NULL DEFAULT 0,
        ad_roulette_ads_today INTEGER NOT NULL DEFAULT 0,
        ad_roulette_spins_today INTEGER NOT NULL DEFAULT 0,
        ad_roulette_date TEXT,
        ad_gems_ads_today INTEGER NOT NULL DEFAULT 0,
        ad_gems_claimed_today INTEGER NOT NULL DEFAULT 0,
        ad_gems_date TEXT,
        music_volume INTEGER NOT NULL DEFAULT 3,
        effects_volume INTEGER NOT NULL DEFAULT 3,
        store_discount_seen_key TEXT NOT NULL DEFAULT '',
        store_gems_seen_date TEXT NOT NULL DEFAULT '',
        species_manual_refresh_seed INTEGER NOT NULL DEFAULT 0,
        reading_mission_excluded_pages INTEGER NOT NULL DEFAULT 0,
        reading_mission_excluded_books INTEGER NOT NULL DEFAULT 0,
        analytics_consent INTEGER NOT NULL DEFAULT -1,
        analytics_id TEXT NOT NULL DEFAULT '',
        last_seen_at TEXT,
        last_trusted_at TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE inventory_items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        type TEXT NOT NULL UNIQUE,
        quantity INTEGER NOT NULL DEFAULT 0
      )
    ''');

    await db.execute('''
      CREATE TABLE minigame_cooldowns (
        minigame_id TEXT PRIMARY KEY,
        cooldown_end TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE active_powerups (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        type TEXT NOT NULL,
        target_villager_id INTEGER,
        activated_at TEXT NOT NULL,
        duration_hours INTEGER NOT NULL DEFAULT 24
      )
    ''');

    await db.execute('''
      CREATE TABLE mission_progress (
        mission_id TEXT PRIMARY KEY,
        is_completed INTEGER NOT NULL DEFAULT 0,
        is_claimed INTEGER NOT NULL DEFAULT 0,
        activated_at TEXT,
        pages_at_activation INTEGER,
        books_at_activation INTEGER,
        building_count_at_activation INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE species_unlocks (
        species_id TEXT PRIMARY KEY,
        unlocked_at TEXT NOT NULL,
        is_purchased INTEGER NOT NULL DEFAULT 0
      )
    ''');

    await db.execute('''
      CREATE TABLE pending_villager_choices (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        house_id INTEGER NOT NULL,
        species1 TEXT NOT NULL,
        species2 TEXT NOT NULL,
        species3 TEXT NOT NULL,
        name1 TEXT NOT NULL,
        name2 TEXT NOT NULL,
        name3 TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS used_secret_codes (
        code TEXT PRIMARY KEY,
        redeemed_at TEXT NOT NULL
      )
    ''');

    for (final type in ['book', 'sandwich', 'hammer', 'glasses']) {
      await db.insert('inventory_items', {'type': type, 'quantity': 0});
    }

    await db.insert('resources', {
      'id': 1,
      'coins': AppConstants.testMode ? 99999 : VillageRules.startingCoins,
      'gems': AppConstants.testMode ? 99999 : VillageRules.startingGems,
      'wood': AppConstants.testMode ? 99999 : VillageRules.startingWood,
      'metal': AppConstants.testMode ? 99999 : VillageRules.startingMetal,
    });

    await db.insert('game_state', {
      'id': 1,
      'expansion_count': 0,
      'exp': 0,
      'player_level': 1,
      'username': '',
      'town_name': 'My Village',
      'language': 'en',
      'tutorial_completed': 0,
    });

    final defaultStart = VillageRules.defaultChunkStart;
    final defaultEnd = VillageRules.defaultChunkEnd;
    for (int cx = defaultStart; cx <= defaultEnd; cx++) {
      for (int cy = defaultStart; cy <= defaultEnd; cy++) {
        await db.insert('unlocked_chunks', {'chunk_x': cx, 'chunk_y': cy},
            conflictAlgorithm: ConflictAlgorithm.ignore);
      }
    }

    final centerTile = VillageRules.defaultAreaCenterTile;
    for (int dx = -3; dx <= 3; dx++) {
      await db.insert(
          'road_tiles', {'tile_x': centerTile + dx, 'tile_y': centerTile},
          conflictAlgorithm: ConflictAlgorithm.ignore);
    }
    for (int dy = -3; dy <= 3; dy++) {
      if (dy == 0) continue;
      await db.insert(
          'road_tiles', {'tile_x': centerTile, 'tile_y': centerTile + dy},
          conflictAlgorithm: ConflictAlgorithm.ignore);
    }

    final houseId = await db.insert('placed_buildings', {
      'type': 'house',
      'name': 'Home',
      'tile_x': centerTile + 1,
      'tile_y': centerTile - 2,
      'tile_width': VillageRules.buildingTileWidth('house'),
      'tile_height': VillageRules.buildingTileHeight('house'),
      'level': 1,
      'coin_cost': 0,
      'gem_cost': 0,
      'wood_cost': 0,
      'metal_cost': 0,
      'happiness_bonus': 10,
      'construction_start':
          DateTime.now().subtract(Duration(hours: 1)).toIso8601String(),
      'construction_duration_minutes': 1,
      'is_constructed': 1,
    });

    final now = DateTime.now().toIso8601String();
    for (final id in SpeciesRules.starterSpecies) {
      await db.insert(
          'species_unlocks',
          {
            'species_id': id,
            'unlocked_at': now,
          },
          conflictAlgorithm: ConflictAlgorithm.ignore);
    }

    final random = Random();
    final starterList = SpeciesRules.starterSpecies;
    final species = starterList[random.nextInt(starterList.length)];
    final name = VillageRules
        .villagerNames[random.nextInt(VillageRules.villagerNames.length)];
    await db.insert('villagers', {
      'name': name,
      'species': species,
      'happiness': 50,
      'house_id': houseId
    });
  }
}
