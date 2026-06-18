// Run from the repo root: dart run tools/encrypt_backup.dart
import 'dart:convert';
import 'dart:io';

import '../my_reading_village/lib/infrastructure/security/backup_cipher.dart';

void main() async {
  final scriptDir = File(Platform.script.toFilePath()).parent;
  final inputDir = Directory('${scriptDir.path}/json-to-encrypt');
  final outputDir = Directory('${inputDir.path}/output');

  if (!inputDir.existsSync()) {
    stderr.writeln('Input directory not found: ${inputDir.path}');
    exit(1);
  }

  outputDir.createSync(recursive: true);

  final jsonFiles = inputDir
      .listSync()
      .whereType<File>()
      .where((f) => f.path.endsWith('.json'))
      .toList()
    ..sort((a, b) => a.path.compareTo(b.path));

  if (jsonFiles.isEmpty) {
    stdout.writeln('No .json files found in ${inputDir.path}');
    return;
  }

  stdout.writeln('Found ${jsonFiles.length} file(s) in ${inputDir.path}');
  stdout.writeln('Output directory: ${outputDir.path}');
  stdout.writeln();

  for (final file in jsonFiles) {
    final name = file.uri.pathSegments.last;
    final stem = name.substring(0, name.length - '.json'.length);
    final outputFile = File('${outputDir.path}/$stem.mrvb');

    try {
      final jsonString = await file.readAsString();
      json.decode(jsonString);
      final encrypted = BackupCipher.encrypt(jsonString);
      await outputFile.writeAsBytes(encrypted);
      stdout.writeln('  [OK] $name -> $stem.mrvb');
    } catch (e) {
      stderr.writeln('  [FAIL] $name: $e');
    }
  }

  stdout.writeln();
  stdout.writeln('Done.');
}
