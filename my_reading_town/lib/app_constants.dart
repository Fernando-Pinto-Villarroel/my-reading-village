class AppConstants {
  static const bool testMode = true;
  static const bool isNightTime = false;
  static const bool playStore = false;
  static const bool googleAds = false;
  static const String appVersion = '1.0.0';

  // Ad cooldown duration (NO_REWARDED_AD_RELOAD_PERIOD_SECONDS)
  // In production: 30-60 seconds minimum between rewarded ads per building (AdMob policy)
  // In test mode: minimal cooldown for rapid iteration
  static const int adSkipCooldownMs = googleAds ? 30000 : 1500;

  static const String _adUnitIdReal = 'ca-app-pub-REPLACE_WITH_YOUR_AD_UNIT_ID';
  static const String _adUnitIdTest = 'ca-app-pub-3940256099942544/5224354917';
  static const String rewardedAdUnitId =
      googleAds ? _adUnitIdReal : _adUnitIdTest;
}
