import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:my_reading_village/infrastructure/persistence/database_helper.dart';
import 'package:my_reading_village/infrastructure/security/backup_cipher.dart';

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
    final encrypted = BackupCipher.encrypt(jsonString);
    final timestamp = DateTime.now()
        .toIso8601String()
        .replaceAll(':', '-')
        .replaceAll('.', '-');
    final filename = 'my_reading_village_backup_$timestamp.mrvb';

    if (saveToDownloads) {
      final savedPath = await FilePicker.platform.saveFile(
        dialogTitle: 'Save Backup',
        fileName: filename,
        type: FileType.custom,
        allowedExtensions: ['mrvb'],
        bytes: encrypted,
      );
      return savedPath != null;
    } else {
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/$filename');
      await file.writeAsBytes(encrypted);
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
    if (version is! int || version < 1 || version > 3) return 'invalid_version';
    final isPartial = data['partial'] == true;
    if (!isPartial) {
      for (final table in _requiredTables) {
        if (!data.containsKey(table)) return 'missing_table';
        if (data[table] is! List) return 'invalid_table_format';
      }
    }
    for (final key in data.keys) {
      if (key == 'version' || key == 'exported_at' || key == 'partial') {
        continue;
      }
      if (!_allTables.contains(key)) return 'unknown_table';
      if (data[key] is! List) return 'invalid_table_format';
    }
    return null;
  }

  Future<
      ({
        Map<String, dynamic> data,
        bool hasBooksData,
        bool hadPurchasedSpeciesStripped
      })?> pickAndValidate() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mrvb'],
    );
    if (result == null || result.files.isEmpty) return null;
    final filePath = result.files.single.path;
    if (filePath == null) return null;
    final bytes = await File(filePath).readAsBytes();
    if (!BackupCipher.isMrvb(bytes)) {
      throw const FormatException('tampered_backup');
    }
    late String jsonString;
    try {
      jsonString = BackupCipher.decrypt(bytes);
    } catch (_) {
      throw const FormatException('tampered_backup');
    }
    late Map<String, dynamic> data;
    try {
      data = json.decode(jsonString) as Map<String, dynamic>;
    } catch (_) {
      throw const FormatException('tampered_backup');
    }
    final error = _validateBackup(data);
    if (error != null) throw FormatException(error);
    final hadStripped = _db.stripPurchasedSpeciesFromData(data);
    final hasBooksData =
        data.containsKey('books') || data.containsKey('reading_sessions');
    return (
      data: data,
      hasBooksData: hasBooksData,
      hadPurchasedSpeciesStripped: hadStripped,
    );
  }

  Future<({int totalPages, int completedBooks})> parseImportedReadingTotals(
      Map<String, dynamic> data) async {
    int totalPages = 0;
    int completedBooks = 0;
    final books = data['books'] as List<dynamic>?;
    if (books != null) {
      for (final row in books) {
        final map = row as Map<String, dynamic>;
        totalPages += (map['pages_read'] as int? ?? 0);
        if ((map['is_completed'] as int? ?? 0) == 1) completedBooks++;
      }
    }
    return (totalPages: totalPages, completedBooks: completedBooks);
  }

  Future<bool> doImport(Map<String, dynamic> data) async {
    await _db.importAllTables(data);
    return true;
  }

  Future<bool> importData() async {
    final picked = await pickAndValidate();
    if (picked == null) return false;
    await _db.importAllTables(picked.data);
    return true;
  }

  Future<void> resetData() async {
    await _db.resetDatabase();
  }
}
