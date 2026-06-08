import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:my_reading_village/infrastructure/persistence/database_helper.dart';

class BackupService {
  final DatabaseHelper _db;

  BackupService(this._db);

  static const Map<String, List<String>> categoryTables = {
    'books_reading': ['books', 'tags', 'book_tags', 'reading_sessions'],
    'resources': ['resources', 'inventory_items', 'active_powerups'],
    'village': [
      'placed_buildings',
      'road_tiles',
      'special_tiles',
      'unlocked_chunks',
      'villagers',
      'species_unlocks',
      'pending_villager_choices',
    ],
    'progress': ['game_state'],
    'missions': ['mission_progress'],
    'extras': ['used_secret_codes', 'minigame_cooldowns'],
  };

  static const List<String> _requiredTables = [
    'books',
    'villagers',
    'placed_buildings',
    'game_state',
    'resources',
  ];

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

  Future<bool> exportData(
      {Set<String>? categories, bool saveToDownloads = false}) async {
    Set<String> tablesToExport;
    if (categories == null || categories.length >= categoryTables.length) {
      tablesToExport = Set.from(_allTables);
    } else {
      tablesToExport = {};
      for (final cat in categories) {
        tablesToExport.addAll(categoryTables[cat] ?? []);
      }
    }

    final data = await _db.exportAllTables(only: tablesToExport);
    final jsonString = const JsonEncoder.withIndent('  ').convert(data);
    final timestamp = DateTime.now()
        .toIso8601String()
        .replaceAll(':', '-')
        .replaceAll('.', '-');
    final filename = 'my_reading_village_backup_$timestamp.json';

    if (saveToDownloads) {
      final bytes = Uint8List.fromList(utf8.encode(jsonString));
      final savedPath = await FilePicker.platform.saveFile(
        dialogTitle: 'Save Backup',
        fileName: filename,
        type: FileType.custom,
        allowedExtensions: ['json'],
        bytes: bytes,
      );
      return savedPath != null;
    } else {
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/$filename');
      await file.writeAsString(jsonString);
      await SharePlus.instance.share(ShareParams(
        files: [XFile(file.path)],
        text: 'My Reading Village Backup',
      ));
      return true;
    }
  }

  String? _validateBackup(Map<String, dynamic> data) {
    if (!data.containsKey('version')) return 'missing_version';
    final version = data['version'];
    if (version is! int || version < 1) return 'invalid_version';
    final isPartial = data['partial'] == true;
    if (!isPartial) {
      for (final table in _requiredTables) {
        if (!data.containsKey(table)) return 'missing_table';
        if (data[table] is! List) return 'invalid_table_format';
      }
    }
    for (final key in data.keys) {
      if (key == 'version' || key == 'exported_at' || key == 'partial')
        continue;
      if (!_allTables.contains(key)) return 'unknown_table';
      if (data[key] is! List) return 'invalid_table_format';
    }
    return null;
  }

  Future<bool> importData() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );
    if (result == null || result.files.isEmpty) return false;
    final filePath = result.files.single.path;
    if (filePath == null) return false;
    final jsonString = await File(filePath).readAsString();
    late Map<String, dynamic> data;
    try {
      data = json.decode(jsonString) as Map<String, dynamic>;
    } catch (_) {
      throw const FormatException('invalid_backup_not_json');
    }
    final error = _validateBackup(data);
    if (error != null) throw FormatException(error);
    await _db.importAllTables(data);
    return true;
  }

  Future<void> resetData() async {
    await _db.resetDatabase();
  }
}
