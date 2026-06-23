import 'package:package_info_plus/package_info_plus.dart';

class AppConstants {
  static const bool testMode = false;
  static const bool isNightTime = false;
  static const bool playStore = false;
  static const bool unityAds = false;

  static String _appVersion = '1.0.0';
  static String get appVersion => _appVersion;

  static Future<void> loadVersion() async {
    try {
      final info = await PackageInfo.fromPlatform();
      _appVersion = info.version;
    } catch (_) {}
  }

  static const int adSkipCooldownMs = unityAds ? 30000 : 1500;

  static const String unityGameId = '800005941';
  static const String unityPlacementId = 'Rewarded_Android';
}
