import 'dart:typed_data';
import 'package:encrypt/encrypt.dart';
import 'backup_key.dart';

class BackupCipher {
  static const List<int> _magic = [0x4D, 0x52, 0x56, 0x42];
  static final Key _key = Key(Uint8List.fromList(kBackupKey));

  static Uint8List encrypt(String jsonText) {
    final iv = IV.fromSecureRandom(12);
    final encrypter = Encrypter(AES(_key, mode: AESMode.gcm));
    final encrypted = encrypter.encrypt(jsonText, iv: iv);
    return Uint8List.fromList([
      ..._magic,
      ...iv.bytes,
      ...encrypted.bytes,
    ]);
  }

  static String decrypt(Uint8List bytes) {
    if (!isMrvb(bytes)) {
      throw const FormatException('tampered_backup');
    }
    final iv = IV(bytes.sublist(4, 16));
    final cipherBytes = Encrypted(bytes.sublist(16));
    final encrypter = Encrypter(AES(_key, mode: AESMode.gcm));
    try {
      return encrypter.decrypt(cipherBytes, iv: iv);
    } catch (_) {
      throw const FormatException('tampered_backup');
    }
  }

  static bool isMrvb(Uint8List bytes) {
    if (bytes.length < 4) return false;
    for (int i = 0; i < 4; i++) {
      if (bytes[i] != _magic[i]) return false;
    }
    return true;
  }
}
