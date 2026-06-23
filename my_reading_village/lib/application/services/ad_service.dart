import 'dart:async';
import 'package:flutter/material.dart';
import 'package:unity_ads_plugin/unity_ads_plugin.dart';
import 'package:my_reading_village/app_constants.dart';
import 'package:my_reading_village/infrastructure/persistence/database_helper.dart';
import 'package:my_reading_village/infrastructure/ui/config/app_theme.dart';
import 'package:my_reading_village/infrastructure/ui/localization/language_provider.dart';

class AdService {
  final DatabaseHelper _db;

  bool _isAdLoaded = false;
  bool _isShowing = false;

  AdService(this._db);

  Future<void> initialize() async {
    if (!AppConstants.unityAds) return;
    await UnityAds.init(
      gameId: AppConstants.unityGameId,
      testMode: !AppConstants.playStore,
      onComplete: () async {
        await _applyStoredConsent();
        _loadAd();
      },
      onFailed: (_, __) {},
    );
  }

  Future<void> setConsent(bool consent) async {
    if (!AppConstants.unityAds) return;
    try {
      await UnityAds.setPrivacyConsent(PrivacyConsentType.gdpr, consent);
    } catch (_) {}
  }

  Future<void> _applyStoredConsent() async {
    try {
      final stored = await _db.getAnalyticsConsent();
      if (stored == 1 || stored == 0) {
        await UnityAds.setPrivacyConsent(
            PrivacyConsentType.gdpr, stored == 1);
      }
    } catch (_) {}
  }

  void _loadAd() {
    if (!AppConstants.unityAds) return;
    UnityAds.load(
      placementId: AppConstants.unityPlacementId,
      onComplete: (_) => _isAdLoaded = true,
      onFailed: (_, __, ___) => _isAdLoaded = false,
    );
  }

  Future<bool> showRewardedAd(
      BuildContext context, LanguageProvider lang) async {
    if (_isShowing) return false;

    if (!AppConstants.unityAds) {
      return _showTestDialog(context, lang);
    }

    if (!_isAdLoaded) {
      _loadAd();
      return false;
    }

    _isShowing = true;
    final completer = Completer<bool>();

    void finish(bool rewarded) {
      _isShowing = false;
      _isAdLoaded = false;
      _loadAd();
      if (!completer.isCompleted) completer.complete(rewarded);
    }

    UnityAds.showVideoAd(
      placementId: AppConstants.unityPlacementId,
      onStart: (_) {},
      onSkipped: (_) => finish(false),
      onComplete: (_) => finish(true),
      onFailed: (_, __, ___) => finish(false),
    );

    return completer.future;
  }

  Future<bool> _showTestDialog(
      BuildContext context, LanguageProvider lang) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: AppTheme.softWhite,
        title: Row(
          children: [
            Icon(Icons.play_circle_outline,
                color: AppTheme.darkSkyBlue, size: 26),
            SizedBox(width: 8),
            Flexible(
              child: Text(
                lang.translate('ad_test_mode_title'),
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.darkText),
              ),
            ),
          ],
        ),
        content: Text(
          lang.translate('ad_test_mode_body'),
          style: TextStyle(
              fontSize: 13, color: AppTheme.darkText.withValues(alpha: 0.72)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(lang.translate('cancel'),
                style:
                    TextStyle(color: AppTheme.darkText.withValues(alpha: 0.6))),
          ),
          ElevatedButton.icon(
            onPressed: () => Navigator.pop(ctx, true),
            icon: Icon(Icons.check_circle_outline, size: 18),
            label: Text(lang.translate('ad_simulate_watched')),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.darkSkyBlue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ],
      ),
    );
    return result == true;
  }
}
