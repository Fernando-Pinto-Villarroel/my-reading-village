import 'dart:io';
import 'package:in_app_update/in_app_update.dart';
import 'package:my_reading_village/app_constants.dart';

class AppUpdateService {
  static bool _isForceUpdateRequired(int availableVersionCode) {
    final parts = AppConstants.appVersion.split('.');
    final major = int.tryParse(parts[0]) ?? 0;
    final minor = parts.length > 1 ? (int.tryParse(parts[1]) ?? 0) : 0;
    final installedMajorMinor = major * 1000 + minor;
    final availableMajorMinor = availableVersionCode ~/ 1000;
    return availableMajorMinor > installedMajorMinor;
  }

  static Future<void> checkAndPrompt() async {
    if (!AppConstants.playStore) return;
    if (!Platform.isAndroid) return;
    try {
      final info = await InAppUpdate.checkForUpdate();
      if (info.updateAvailability != UpdateAvailability.updateAvailable) return;
      final available = info.availableVersionCode ?? 0;
      if (_isForceUpdateRequired(available)) {
        await InAppUpdate.performImmediateUpdate();
      }
    } catch (_) {}
  }
}
