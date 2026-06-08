import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:my_reading_village/app_constants.dart';
import 'package:my_reading_village/infrastructure/ui/config/app_theme.dart';
import 'package:my_reading_village/infrastructure/ui/localization/language_provider.dart';

class AdService {
  RewardedAd? _rewardedAd;
  bool _isAdLoaded = false;
  bool _isShowing = false;

  Future<void> initialize() async {
    if (!AppConstants.googleAds) return;
    await MobileAds.instance.initialize();
    _loadAd();
  }

  void _loadAd() {
    if (!AppConstants.googleAds) return;
    RewardedAd.load(
      adUnitId: AppConstants.rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          _isAdLoaded = true;
        },
        onAdFailedToLoad: (_) {
          _rewardedAd = null;
          _isAdLoaded = false;
        },
      ),
    );
  }

  Future<bool> showRewardedAd(
      BuildContext context, LanguageProvider lang) async {
    if (_isShowing) return false;

    if (!AppConstants.googleAds) {
      return _showTestDialog(context, lang);
    }

    if (!_isAdLoaded || _rewardedAd == null) {
      _loadAd();
      return false;
    }

    _isShowing = true;
    final completer = Completer<bool>();

    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        _isShowing = false;
        if (!completer.isCompleted) completer.complete(false);
        ad.dispose();
        _rewardedAd = null;
        _isAdLoaded = false;
        _loadAd();
      },
      onAdFailedToShowFullScreenContent: (ad, _) {
        _isShowing = false;
        if (!completer.isCompleted) completer.complete(false);
        ad.dispose();
        _rewardedAd = null;
        _isAdLoaded = false;
        _loadAd();
      },
    );

    _rewardedAd!.show(
      onUserEarnedReward: (_, __) {
        if (!completer.isCompleted) completer.complete(true);
      },
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
