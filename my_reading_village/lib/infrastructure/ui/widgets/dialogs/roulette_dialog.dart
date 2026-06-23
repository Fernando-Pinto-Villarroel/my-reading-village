import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:confetti/confetti.dart';
import 'package:provider/provider.dart';
import 'package:my_reading_village/infrastructure/ui/config/app_theme.dart';
import 'package:my_reading_village/adapters/providers/village_provider.dart';
import 'package:my_reading_village/application/services/ad_service.dart';
import 'package:my_reading_village/application/services/notification_service.dart';
import 'package:my_reading_village/application/services/audio_service.dart';
import 'package:my_reading_village/infrastructure/di/service_locator.dart';
import 'package:my_reading_village/infrastructure/ui/localization/language_provider.dart';
import 'package:my_reading_village/infrastructure/ui/widgets/common/resource_icon.dart';
import 'package:my_reading_village/domain/rules/roulette_rules.dart';
import 'package:my_reading_village/infrastructure/ui/widgets/common/app_toast.dart';
import 'package:my_reading_village/domain/rules/species_rules.dart';
import 'package:my_reading_village/infrastructure/ui/widgets/common/species_bonus_popup.dart';
import 'package:my_reading_village/application/services/time_verification_service.dart';

// Circus palette — bold, vivid, alternating so adjacent segments never share a hue
const List<Color> _circusColors = [
  Color(0xFFD32F2F), // deep red
  Color(0xFF1565C0), // royal blue
  Color(0xFFF9A825), // golden amber
  Color(0xFF2E7D32), // forest green
  Color(0xFF6A1B9A), // deep purple
  Color(0xFFD84315), // burnt orange
  Color(0xFF00695C), // dark teal
  Color(0xFFC62828), // crimson
  Color(0xFF283593), // indigo
  Color(0xFF558B2F), // olive green
  Color(0xFF6A1B9A), // cyan teal
];

class _RouletteReward {
  final String key;
  final String type;
  final int? amount;
  final String assetPath;
  final Widget Function(double size) iconBuilder;
  final Color? color;

  const _RouletteReward({
    required this.key,
    required this.type,
    this.amount,
    required this.assetPath,
    required this.iconBuilder,
    this.color,
  });
}

List<_RouletteReward> _buildRewards(VillagerSpeciesData? weeklySpecies) {
  final speciesAsset =
      'assets/images/villagers/${weeklySpecies!.id}/${weeklySpecies.id}_villager.png';

  return [
    _RouletteReward(
      key: 'coins_30',
      type: 'coins',
      amount: 30,
      assetPath: 'assets/images/resources/coin.png',
      iconBuilder: (s) => ResourceIcon.coin(size: s),
    ),
    _RouletteReward(
      key: 'gems_5',
      type: 'gems',
      amount: 5,
      assetPath: 'assets/images/resources/gem.png',
      iconBuilder: (s) => ResourceIcon.gem(size: s),
    ),
    _RouletteReward(
      key: 'wood_30',
      type: 'wood',
      amount: 30,
      assetPath: 'assets/images/resources/wood.png',
      iconBuilder: (s) => ResourceIcon.wood(size: s),
    ),
    _RouletteReward(
      key: 'sandwich',
      type: 'sandwich',
      assetPath: 'assets/images/items/sandwich_item.png',
      iconBuilder: (s) => Image.asset('assets/images/items/sandwich_item.png',
          width: s, height: s),
    ),
    _RouletteReward(
      key: 'species',
      type: 'species',
      assetPath: speciesAsset,
      color: AppTheme.gemPurple,
      iconBuilder: (s) => Image.asset(
        speciesAsset,
        width: s,
        height: s,
        errorBuilder: (_, __, ___) =>
            Icon(Icons.pets, size: s, color: AppTheme.darkLavender),
      ),
    ),
    _RouletteReward(
      key: 'metal_15',
      type: 'metal',
      amount: 15,
      assetPath: 'assets/images/resources/metal.png',
      iconBuilder: (s) => ResourceIcon.metal(size: s),
    ),
    _RouletteReward(
      key: 'gems_15',
      type: 'gems',
      amount: 15,
      assetPath: 'assets/images/resources/gem.png',
      iconBuilder: (s) => ResourceIcon.gem(size: s),
    ),
    _RouletteReward(
      key: 'hammer',
      type: 'hammer',
      assetPath: 'assets/images/items/hammer_item.png',
      iconBuilder: (s) => Image.asset('assets/images/items/hammer_item.png',
          width: s, height: s),
    ),
    _RouletteReward(
      key: 'book',
      type: 'book',
      assetPath: 'assets/images/items/book_item.png',
      iconBuilder: (s) =>
          Image.asset('assets/images/items/book_item.png', width: s, height: s),
    ),
    _RouletteReward(
      key: 'glasses',
      type: 'glasses',
      assetPath: 'assets/images/items/glasses_item.png',
      iconBuilder: (s) => Image.asset('assets/images/items/glasses_item.png',
          width: s, height: s),
    ),
  ];
}

void showRouletteDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => _RouletteDialog(),
  );
}

class _RouletteDialog extends StatefulWidget {
  @override
  State<_RouletteDialog> createState() => _RouletteDialogState();
}

class _RouletteDialogState extends State<_RouletteDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;
  bool _isSpinning = false;
  bool _showingReward = false;
  bool _watchingAdForSpin = false;
  double _currentAngle = 0.0;
  final Random _random = Random();
  Timer? _adCooldownTimer;

  late List<_RouletteReward> _rewards;
  VillagerSpeciesData? _weeklySpecies;
  late List<ui.Image?> _segmentImages;
  bool _imagesLoaded = false;

  @override
  void initState() {
    super.initState();
    _weeklySpecies = SpeciesRules.weeklySpeciesReward(
        now: sl<TimeVerificationService>().trustedNow());
    _rewards = _buildRewards(_weeklySpecies);
    _segmentImages = List.filled(_rewards.length, null);
    _controller = AnimationController(vsync: this);
    _controller.addListener(() {
      setState(() => _currentAngle = _rotationAnimation.value);
    });
    _loadImages();
  }

  Future<void> _loadImages() async {
    for (int i = 0; i < _rewards.length; i++) {
      try {
        final data = await rootBundle.load(_rewards[i].assetPath);
        final codec = await ui.instantiateImageCodec(
          data.buffer.asUint8List(),
          targetWidth: 64,
        );
        final frame = await codec.getNextFrame();
        if (mounted) _segmentImages[i] = frame.image;
      } catch (_) {}
    }
    if (mounted) setState(() => _imagesLoaded = true);
  }

  @override
  void dispose() {
    _adCooldownTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _startAdCooldownTimer() {
    _adCooldownTimer?.cancel();
    _adCooldownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) {
        _adCooldownTimer?.cancel();
        return;
      }
      final village = context.read<VillageProvider>();
      final remaining = village.adCooldownRemainingFor('roulette');
      if (remaining == null) {
        _adCooldownTimer?.cancel();
        _adCooldownTimer = null;
      }
      setState(() {});
    });
  }

  Future<bool> _showGemConfirmDialog(
      BuildContext context, LanguageProvider lang, int gemCost) async {
    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: AppTheme.softWhite,
        title: Row(
          children: [
            ResourceIcon.gem(size: 22),
            SizedBox(width: 8),
            Text(
              lang.translate('store_confirm_title'),
              style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.darkText),
            ),
          ],
        ),
        content: Text(
          lang.translate('store_confirm_body').replaceAll('{gems}', '$gemCost'),
          style: TextStyle(fontSize: 14, color: AppTheme.darkText),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(
              lang.translate('cancel'),
              style: TextStyle(color: AppTheme.darkText.withValues(alpha: 0.6)),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.darkLavender,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: Text(
              lang.translate('store_confirm_buy'),
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
    return confirmed == true;
  }

  Future<void> _watchAdForSpin() async {
    if (_watchingAdForSpin || _isSpinning || _showingReward) return;
    final village = context.read<VillageProvider>();
    final lang = context.read<LanguageProvider>();
    if (!village.canWatchAdForRoulette) return;
    if (village.adCooldownRemainingFor('roulette') != null) return;
    village.recordAdCooldown('roulette');
    setState(() => _watchingAdForSpin = true);
    final earned = await sl<AdService>().showRewardedAd(context, lang);
    if (!mounted) return;
    if (earned) {
      await village.watchAdForRoulette();
      if (mounted && village.hasAdFreeSpin) {
        showSuccessToast(context, lang.translate('ad_roulette_spin_ready'));
      }
    }
    if (mounted) {
      setState(() => _watchingAdForSpin = false);
      _startAdCooldownTimer();
    }
  }

  Future<void> _spin() async {
    if (_isSpinning || _showingReward) return;

    final village = context.read<VillageProvider>();
    final lang = context.read<LanguageProvider>();
    final wasDailyFree = village.canSpinDailyFree;
    final isFree = village.canSpinRouletteForFree;
    if (!isFree) {
      final gemCost = RouletteRules.gemCostPerSpin;
      if (village.gems < gemCost) {
        if (mounted) {
          showErrorToast(context, lang.translate('store_not_enough_gems'));
        }
        return;
      }
      final confirmed = await _showGemConfirmDialog(context, lang, gemCost);
      if (!confirmed || !mounted) return;
    }

    setState(() => _isSpinning = true);

    final canSpin = await village.spinRoulette();
    if (!canSpin) {
      if (mounted) setState(() => _isSpinning = false);
      return;
    }
    if (wasDailyFree && mounted) {
      final remaining = village.rouletteNextFreeSpinIn;
      sl<NotificationService>().scheduleRouletteFreeSpin(
        remaining: remaining,
        title: lang.translate('notif_roulette_spin_title'),
        body: lang.translate('notif_roulette_spin_body'),
      );
    }

    sl<AudioService>().startWheelSpinSound(const Duration(milliseconds: 4000));

    final isGuaranteed = village.rouletteSpinIsGuaranteed;
    final speciesIndex = _rewards.indexWhere((r) => r.type == 'species');

    final targetIndex = (isGuaranteed && speciesIndex >= 0)
        ? speciesIndex
        : RouletteRules.pickWeightedIndex(
            _random,
            _rewards.map((r) => r.key).toList(),
          );

    final reward = _rewards[targetIndex];

    Map<String, dynamic>? rewardData;
    ({bool isDuplicate, String speciesId, String speciesNameKey})? speciesResult;
    if (reward.type == 'species' && _weeklySpecies != null) {
      speciesResult = await village.applySpeciesBonus(_weeklySpecies!.id);
      if (speciesResult != null) await village.resetRouletteSpinWeekCount();
    } else {
      rewardData = {'type': reward.type, 'amount': reward.amount};
      await village.applyRouletteReward(rewardData, persistOnly: true);
    }

    if (!mounted) return;

    final segmentAngle = 2 * pi / _rewards.length;
    final desiredAngle = -(targetIndex * segmentAngle + segmentAngle / 2);
    final extraSpins = (6 + _random.nextInt(4)) * 2 * pi;
    final base = _currentAngle - extraSpins;
    double diff = (desiredAngle - base) % (2 * pi);
    if (diff > 0) diff -= 2 * pi;
    final finalTarget = base + diff;

    _rotationAnimation = Tween<double>(
      begin: _currentAngle,
      end: finalTarget,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    ));

    _controller
      ..reset()
      ..duration = const Duration(milliseconds: 4000);

    await _controller.forward();
    sl<AudioService>().stopWheelSpinSound();

    if (!mounted) return;
    setState(() {
      _isSpinning = false;
      _showingReward = true;
    });

    if (reward.type == 'species' && _weeklySpecies != null && speciesResult != null) {
      final speciesData = _weeklySpecies!;
      final isDuplicate = speciesResult.isDuplicate;
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => SpeciesBonusPopup(
          speciesData: speciesData,
          isDuplicate: isDuplicate,
        ),
      );
    } else if (rewardData != null) {
      if (!mounted) return;
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => _RouletteRewardPopup(
          reward: reward,
          lang: lang,
        ),
      );
      await village.refreshResources();
    }

    if (!mounted) return;
    setState(() => _showingReward = false);
  }

  @override
  Widget build(BuildContext context) {
    final village = context.watch<VillageProvider>();
    final lang = context.read<LanguageProvider>();
    final isFree = village.canSpinRouletteForFree;
    final isDailyFree = village.canSpinDailyFree;
    final gems = village.gems;
    final gemCost = RouletteRules.gemCostPerSpin;
    final canAfford = isFree || gems >= gemCost;
    final timeLeft = village.rouletteNextFreeSpinIn;

    final canDismiss = !_isSpinning && !_showingReward && !_watchingAdForSpin;

    return PopScope(
      canPop: canDismiss,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          if (canDismiss) Navigator.of(context).pop();
        },
        child: Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          backgroundColor: AppTheme.cream,
          insetPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: GestureDetector(
            onTap: () {},
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header
                    Row(
                      children: [
                        Text(
                          lang.translate('roulette'),
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.darkText,
                          ),
                        ),
                        Spacer(),
                        if (!_isSpinning && !_showingReward)
                          IconButton(
                            icon: Icon(Icons.close),
                            onPressed: () => Navigator.pop(context),
                          ),
                      ],
                    ),

                    SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.workspace_premium,
                            size: 14, color: AppTheme.gemPurple),
                        SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            lang.translate('roulette_grand_prize_guarantee'),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.gemPurple,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),

                    if (!isDailyFree && !_isSpinning && !_showingReward) ...[
                      SizedBox(height: 4),
                      Text(
                        lang
                            .translate('roulette_next_free')
                            .replaceAll('{hours}', '${timeLeft.inHours}')
                            .replaceAll(
                                '{minutes}', '${timeLeft.inMinutes % 60}')
                            .replaceAll(
                                '{seconds}', '${timeLeft.inSeconds % 60}'),
                        style: TextStyle(
                          fontSize: 12,
                          color: AppTheme.darkText.withValues(alpha: 0.5),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],

                    SizedBox(height: 20),

                    // ── Wheel ──────────────────────────────────────────────────
                    // Outer Stack: wheel + fixed pointer (clips none so pointer
                    // can overlap the gold ring from above)
                    Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.topCenter,
                      children: [
                        // Gold-ringed wheel container
                        Container(
                          width: 296,
                          height: 296,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [Color(0xFFFFD700), Color(0xFFB8860B)],
                              stops: [0.93, 1.0],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xFFB8860B).withValues(alpha: 0.5),
                                blurRadius: 14,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(8),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                // Spinning wheel
                                Transform.rotate(
                                  angle: _currentAngle,
                                  child: CustomPaint(
                                    size: Size(280, 280),
                                    painter: _WheelPainter(
                                      rewards: _rewards,
                                      images: _segmentImages,
                                      imagesLoaded: _imagesLoaded,
                                    ),
                                  ),
                                ),
                                // Centre pin
                                Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: Color(0xFFB8860B), width: 3),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black
                                            .withValues(alpha: 0.25),
                                        blurRadius: 6,
                                      ),
                                    ],
                                  ),
                                  child: Icon(Icons.casino,
                                      size: 22, color: Color(0xFFB8860B)),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // ▼ Fixed pointer — sits outside the spinning part, at 12 o'clock
                        // `top: -18` so the tip lands on the wheel's outer gold ring
                        Positioned(
                          top: -18,
                          child: CustomPaint(
                            size: Size(32, 36),
                            painter: _PointerPainter(),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 24),

                    // ── Spin button area ───────────────────────────────────────
                    // "Not enough gems" only shown after the reward popup is gone
                    if (!_isSpinning && !_showingReward && !canAfford)
                      Padding(
                        padding: EdgeInsets.only(bottom: 12),
                        child: Text(
                          lang
                              .translate('roulette_not_enough_gems')
                              .replaceAll('{gems}', '$gemCost'),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.red.shade400,
                          ),
                        ),
                      ),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed:
                            (!_isSpinning && !_showingReward && canAfford)
                                ? _spin
                                : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              isFree ? AppTheme.coinGold : AppTheme.gemPurple,
                          foregroundColor: AppTheme.darkText,
                          padding: EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (isFree) ...[
                              Icon(Icons.stars, size: 20),
                              SizedBox(width: 8),
                              Text(
                                lang.translate('roulette_free_spin'),
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ] else ...[
                              ResourceIcon.gem(size: 20),
                              SizedBox(width: 6),
                              Text(
                                '$gemCost ${lang.translate('gems')} — ${lang.translate('roulette_spin')}',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),

                    if (!_isSpinning && !_showingReward) ...[
                      SizedBox(height: 16),
                      _AdForSpinSection(
                        village: village,
                        lang: lang,
                        onWatchAd: _watchAdForSpin,
                        isWatching: _watchingAdForSpin,
                        cooldown: village.adCooldownRemainingFor('roulette'),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Ad-for-spin section ────────────────────────────────────────────────────────

class _AdForSpinSection extends StatelessWidget {
  final VillageProvider village;
  final LanguageProvider lang;
  final VoidCallback onWatchAd;
  final bool isWatching;
  final Duration? cooldown;

  const _AdForSpinSection({
    required this.village,
    required this.lang,
    required this.onWatchAd,
    required this.isWatching,
    this.cooldown,
  });

  @override
  Widget build(BuildContext context) {
    final hasPending = village.hasAdFreeSpin;
    final spinsToday = village.adRouletteSpinsToday;
    final adsToday = village.adRouletteAdsToday;
    final maxReached = spinsToday >= 3;

    final Color sectionColor = AppTheme.darkSkyBlue;
    final Color bgColor = AppTheme.skyBlue.withValues(alpha: 0.25);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border:
            Border.all(color: sectionColor.withValues(alpha: 0.4), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.play_circle_outline, size: 16, color: sectionColor),
              SizedBox(width: 6),
              Expanded(
                child: Text(
                  lang.translate('ad_roulette_section_title'),
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: sectionColor),
                ),
              ),
              Text(
                lang.translate('ad_daily_limit_label'),
                style: TextStyle(
                    fontSize: 10, color: sectionColor.withValues(alpha: 0.6)),
              ),
            ],
          ),
          SizedBox(height: 8),
          if (maxReached) ...[
            Text(
              lang.translate('ad_roulette_max_today'),
              style: TextStyle(
                  fontSize: 12,
                  color: AppTheme.darkText.withValues(alpha: 0.6)),
            ),
          ] else if (hasPending) ...[
            Row(
              children: [
                Icon(Icons.stars, size: 16, color: AppTheme.coinGold),
                SizedBox(width: 6),
                Text(
                  lang.translate('ad_roulette_spin_ready'),
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.darkText),
                ),
              ],
            ),
            SizedBox(height: 4),
            Text(
              lang.translate('ad_roulette_has_pending'),
              style: TextStyle(
                  fontSize: 11,
                  color: AppTheme.darkText.withValues(alpha: 0.6)),
            ),
          ] else ...[
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        lang
                            .translate('ad_roulette_progress')
                            .replaceAll('{count}', '$adsToday'),
                        style:
                            TextStyle(fontSize: 12, color: AppTheme.darkText),
                      ),
                      SizedBox(height: 4),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: adsToday / 3.0,
                          backgroundColor: sectionColor.withValues(alpha: 0.15),
                          valueColor:
                              AlwaysStoppedAnimation<Color>(sectionColor),
                          minHeight: 6,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 10),
                SizedBox(
                  height: 34,
                  child: ElevatedButton.icon(
                    onPressed:
                        (isWatching || cooldown != null) ? null : onWatchAd,
                    icon: isWatching
                        ? SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white),
                          )
                        : Icon(Icons.play_arrow, size: 16),
                    label: Text(
                      cooldown != null
                          ? '${lang.translate('ad_roulette_watch_ad_btn')} (${cooldown!.inSeconds}s)'
                          : lang.translate('ad_roulette_watch_ad_btn'),
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: sectionColor,
                      foregroundColor: Colors.white,
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
              ],
            ),
            if (spinsToday > 0) ...[
              SizedBox(height: 4),
              Text(
                '${lang.translate('ad_roulette_spins_used')}: $spinsToday/3',
                style: TextStyle(
                    fontSize: 10,
                    color: AppTheme.darkText.withValues(alpha: 0.5)),
              ),
            ],
          ],
        ],
      ),
    );
  }
}

// ── Reward popup modal ─────────────────────────────────────────────────────────

class _RouletteRewardPopup extends StatefulWidget {
  final _RouletteReward reward;
  final LanguageProvider lang;

  const _RouletteRewardPopup({required this.reward, required this.lang});

  @override
  State<_RouletteRewardPopup> createState() => _RouletteRewardPopupState();
}

class _RouletteRewardPopupState extends State<_RouletteRewardPopup>
    with SingleTickerProviderStateMixin {
  late AnimationController _animCtrl;
  late Animation<double> _scaleAnim;
  late ConfettiController _confettiCtrl;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _scaleAnim = CurvedAnimation(parent: _animCtrl, curve: Curves.bounceOut);
    _confettiCtrl = ConfettiController(duration: const Duration(seconds: 2));
    _animCtrl.forward();
    _confettiCtrl.play();
    sl<AudioService>().playWinnerSound();
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    _confettiCtrl.dispose();
    super.dispose();
  }

  String _label() {
    final lang = widget.lang;
    final r = widget.reward;
    if (r.amount != null) {
      switch (r.type) {
        case 'coins':
          return '+${r.amount} ${lang.translate('coins')}';
        case 'gems':
          return '+${r.amount} ${lang.translate('gems')}';
        case 'wood':
          return '+${r.amount} ${lang.translate('wood')}';
        case 'metal':
          return '+${r.amount} ${lang.translate('metal')}';
      }
    }
    switch (r.type) {
      case 'sandwich':
        return lang.translate('constructor_sandwich');
      case 'hammer':
        return lang.translate('constructor_hammer');
      case 'book':
        return lang.translate('happiness_book');
      case 'glasses':
        return lang.translate('magic_glasses');
    }
    return r.type;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withValues(alpha: 0.4),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Confetti at top-centre
          Positioned(
            top: 0,
            child: ConfettiWidget(
              confettiController: _confettiCtrl,
              blastDirectionality: BlastDirectionality.explosive,
              numberOfParticles: 25,
              gravity: 0.25,
              colors: [
                AppTheme.pink,
                AppTheme.lavender,
                AppTheme.mint,
                AppTheme.coinGold,
                AppTheme.peach,
              ],
            ),
          ),
          // Popup card
          ScaleTransition(
            scale: _scaleAnim,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 40),
              padding: EdgeInsets.symmetric(horizontal: 28, vertical: 32),
              decoration: BoxDecoration(
                color: AppTheme.softWhite,
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.coinGold.withValues(alpha: 0.4),
                    blurRadius: 24,
                    spreadRadius: 4,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Title
                  Text(
                    widget.lang.translate('roulette_you_won'),
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.coinGold,
                    ),
                  ),
                  SizedBox(height: 20),
                  // Reward icon
                  widget.reward.iconBuilder(72),
                  SizedBox(height: 16),
                  // Reward label
                  Text(
                    _label(),
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.darkText,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 28),
                  // Claim button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.coinGold,
                        foregroundColor: AppTheme.darkText,
                        padding: EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                      ),
                      child: Text(
                        widget.lang.translate('claim_reward'),
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Fixed downward-pointing pointer ───────────────────────────────────────────

class _PointerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // White shadow/outline pass
    final outlinePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeJoin = StrokeJoin.round;

    // Red fill
    final fillPaint = Paint()
      ..color = const Color(0xFFD32F2F)
      ..style = PaintingStyle.fill;

    // Triangle pointing DOWN: apex at bottom-centre, base at top
    final path = Path()
      ..moveTo(size.width / 2, size.height) // tip  (bottom)
      ..lineTo(0, 0) // top-left
      ..lineTo(size.width, 0) // top-right
      ..close();

    canvas.drawPath(path, fillPaint);
    canvas.drawPath(path, outlinePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ── Wheel painter ──────────────────────────────────────────────────────────────

class _WheelPainter extends CustomPainter {
  final List<_RouletteReward> rewards;
  final List<ui.Image?> images;
  final bool imagesLoaded;

  _WheelPainter({
    required this.rewards,
    required this.images,
    required this.imagesLoaded,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final segmentAngle = 2 * pi / rewards.length;

    final fillPaint = Paint()..style = PaintingStyle.fill;
    final dividerPaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.white
      ..strokeWidth = 2.5;

    // Filled segments
    for (int i = 0; i < rewards.length; i++) {
      final startAngle = i * segmentAngle - pi / 2;
      fillPaint.color =
          rewards[i].color ?? _circusColors[i % _circusColors.length];
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        segmentAngle,
        true,
        fillPaint,
      );
    }

    // White divider lines
    for (int i = 0; i < rewards.length; i++) {
      final angle = i * segmentAngle - pi / 2;
      canvas.drawLine(
        center,
        Offset(
            center.dx + radius * cos(angle), center.dy + radius * sin(angle)),
        dividerPaint,
      );
    }

    // Outer white ring
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..style = PaintingStyle.stroke
        ..color = Colors.white.withValues(alpha: 0.9)
        ..strokeWidth = 3,
    );

    // Per-segment content: image + amount label
    for (int i = 0; i < rewards.length; i++) {
      final startAngle = i * segmentAngle - pi / 2;
      final midAngle = startAngle + segmentAngle / 2;

      // Content anchor at ~62 % of radius
      final contentRadius = radius * 0.62;
      final contentCenter = Offset(
        center.dx + contentRadius * cos(midAngle),
        center.dy + contentRadius * sin(midAngle),
      );

      canvas.save();
      canvas.translate(contentCenter.dx, contentCenter.dy);
      // Rotate so image/text reads radially outward
      canvas.rotate(midAngle + pi / 2);

      // Asset image — toward the rim, drawn at natural aspect ratio
      final img = images[i];
      if (img != null) {
        const maxDim = 34.0;
        final imgW = img.width.toDouble();
        final imgH = img.height.toDouble();
        final scale = (imgW >= imgH) ? maxDim / imgW : maxDim / imgH;
        final drawW = imgW * scale;
        final drawH = imgH * scale;
        final src = Rect.fromLTWH(0, 0, imgW, imgH);
        final dst = Rect.fromCenter(
          center: const Offset(0, -18),
          width: drawW,
          height: drawH,
        );
        canvas.drawImageRect(
            img, src, dst, Paint()..filterQuality = FilterQuality.medium);
      }

      // Amount label — toward the centre, with black outline
      final label = _amountLabel(rewards[i]);
      if (label.isNotEmpty) {
        _drawOutlinedText(canvas, label, const Offset(0, 17), 11);
      }

      canvas.restore();
    }
  }

  String _amountLabel(_RouletteReward reward) {
    if (reward.amount != null) return '+${reward.amount}';
    return '';
  }

  void _drawOutlinedText(
      Canvas canvas, String text, Offset center, double fontSize) {
    const offsets = [
      Offset(-1.5, -1.5),
      Offset(1.5, -1.5),
      Offset(-1.5, 1.5),
      Offset(1.5, 1.5),
      Offset(0, -1.5),
      Offset(0, 1.5),
      Offset(-1.5, 0),
      Offset(1.5, 0),
    ];

    TextPainter make(Color color) {
      final tp = TextPainter(
        text: TextSpan(
          text: text,
          style: TextStyle(
            color: color,
            fontSize: fontSize,
            fontWeight: FontWeight.w900,
          ),
        ),
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center,
      )..layout(maxWidth: 56);
      return tp;
    }

    final outline = make(Colors.black);
    for (final off in offsets) {
      outline.paint(
          canvas, center + off - Offset(outline.width / 2, outline.height / 2));
    }
    final fill = make(Colors.white);
    fill.paint(canvas, center - Offset(fill.width / 2, fill.height / 2));
  }

  @override
  bool shouldRepaint(covariant _WheelPainter old) =>
      old.imagesLoaded != imagesLoaded;
}
