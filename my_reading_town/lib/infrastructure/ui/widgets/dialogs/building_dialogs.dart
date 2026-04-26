import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_reading_town/infrastructure/ui/config/app_theme.dart';
import 'package:my_reading_town/domain/rules/village_rules.dart';
import 'package:my_reading_town/domain/entities/placed_building.dart';
import 'package:my_reading_town/adapters/providers/village_provider.dart';
import 'package:my_reading_town/application/services/ad_service.dart';
import 'package:my_reading_town/application/services/building_service.dart';
import 'package:my_reading_town/application/services/notification_service.dart';
import 'package:my_reading_town/infrastructure/ui/widgets/common/app_toast.dart';
import 'package:my_reading_town/infrastructure/ui/widgets/common/resource_icon.dart';
import 'package:my_reading_town/infrastructure/ui/widgets/common/shared_utils.dart';
import 'package:my_reading_town/infrastructure/ui/localization/language_provider.dart';
import 'package:my_reading_town/infrastructure/ui/localization/context_ext.dart';
import 'package:my_reading_town/application/services/audio_service.dart';
import 'package:my_reading_town/infrastructure/di/service_locator.dart';

Future<void> showConstructionCompleteDialog(
    BuildContext context, PlacedBuilding building) {
  sl<AudioService>().playConstructionCompletedSound();
  final langProvider = context.read<LanguageProvider>();
  final isUpgrade = building.level > 1;
  final template = VillageRules.findTemplate(building.type);
  final baseExp = template?['exp'] as int? ?? 20;
  final expEarned = isUpgrade
      ? (baseExp * VillageRules.upgradeExpMultiplier).round()
      : baseExp;

  return showDialog(
    context: context,
    builder: (ctx) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Container(
        padding: EdgeInsets.fromLTRB(24, 20, 24, 20),
        decoration: BoxDecoration(
          color: AppTheme.cream,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    isUpgrade
                        ? langProvider.translate('upgrade_complete')
                        : langProvider.translate('construction_complete'),
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.darkText),
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(ctx),
                  child: Icon(Icons.close,
                      size: 20,
                      color: AppTheme.darkText.withValues(alpha: 0.4)),
                ),
              ],
            ),
            SizedBox(height: 12),
            Image.asset(
              'assets/images/${VillageRules.spriteForBuilding(building.type, building.level)}',
              width: 80,
              height: 80,
              filterQuality: FilterQuality.medium,
              errorBuilder: (_, __, ___) =>
                  Icon(Icons.park, size: 80, color: AppTheme.mint),
            ),
            SizedBox(height: 8),
            Text(
              isUpgrade
                  ? '${context.t('building_name_${building.type}', fallback: building.name)} upgraded to Lv${building.level}!'
                  : '${context.t('building_name_${building.type}', fallback: building.name)} is ready!',
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.darkText),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 6),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppTheme.coinGold.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.star, size: 14, color: const Color(0xFFB8860B)),
                  SizedBox(width: 4),
                  Text('+$expEarned EXP',
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFB8860B))),
                ],
              ),
            ),
            SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(ctx),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.mint,
                  foregroundColor: AppTheme.darkText,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                ),
                child: Text(langProvider.translate('yay'),
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

void showConstructingBuildingSheet(
  BuildContext context, {
  required PlacedBuilding building,
  required VillageProvider village,
  required VoidCallback onSpeedUp,
  required VoidCallback onCancel,
}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    useSafeArea: true,
    isScrollControlled: true,
    constraints: sheetConstraints(context),
    builder: (_) => ConstructionSheetContent(
      building: building,
      village: village,
      onSpeedUp: onSpeedUp,
      onCancel: onCancel,
    ),
  );
}

class ConstructionSheetContent extends StatefulWidget {
  final PlacedBuilding building;
  final VillageProvider village;
  final VoidCallback onSpeedUp;
  final VoidCallback onCancel;

  const ConstructionSheetContent({
    super.key,
    required this.building,
    required this.village,
    required this.onSpeedUp,
    required this.onCancel,
  });

  @override
  State<ConstructionSheetContent> createState() =>
      _ConstructionSheetContentState();
}

class _ConstructionSheetContentState extends State<ConstructionSheetContent> {
  Timer? _timer;
  bool _watchingAd = false;

  @override
  void initState() {
    super.initState();
    final remaining = BuildingService.effectiveRemainingTime(
        widget.building, widget.village.activePowerups);
    if (remaining.inSeconds <= 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _closeOwnRoute());
      return;
    }
    _startTimer();
  }

  void _closeOwnRoute() {
    if (!mounted) return;
    final route = ModalRoute.of(context);
    if (route == null) return;
    final navigator = Navigator.of(context);
    if (route.isCurrent) {
      navigator.pop();
    } else {
      navigator.removeRoute(route);
    }
  }

  Future<void> _watchAdForTimeSkip() async {
    if (_watchingAd) return;
    // Check cooldown before showing ad
    final cooldown = widget.village.constructionSkipCooldownRemaining(widget.building.id!);
    if (cooldown != null) return; // Cooldown active, button should be disabled anyway
    setState(() => _watchingAd = true);
    final lang = context.read<LanguageProvider>();
    final village = context.read<VillageProvider>();
    final earned = await sl<AdService>().showRewardedAd(context, lang);
    if (!mounted) return;
    if (earned && widget.building.id != null) {
      await village.skipConstructionTime(
          widget.building.id!, const Duration(minutes: 10));
      final remaining = BuildingService.effectiveRemainingTime(
          widget.building, village.activePowerups);
      sl<NotificationService>().scheduleConstructionComplete(
        buildingId: widget.building.id!,
        buildingName: widget.building.name,
        remaining: remaining,
        title: lang.translate('notification_construction_title'),
        body: lang.translate('notification_construction_body'),
      );
      if (mounted) showSuccessToast(context, lang.translate('ad_construction_skipped'));
    }
    if (mounted) setState(() => _watchingAd = false);
  }

  void _startTimer() {
    _timer?.cancel();
    final interval = widget.village.isSpeedBoostActive
        ? const Duration(milliseconds: 500)
        : const Duration(seconds: 1);
    _timer = Timer.periodic(interval, (_) {
      if (!mounted) return;
      final remaining = BuildingService.effectiveRemainingTime(
          widget.building, widget.village.activePowerups);
      if (remaining.inSeconds <= 0) {
        _timer?.cancel();
        _closeOwnRoute();
        return;
      }
      setState(() {});
    });
  }

  @override
  void didUpdateWidget(ConstructionSheetContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.village.isSpeedBoostActive !=
        widget.village.isSpeedBoostActive) {
      _startTimer();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final remaining = BuildingService.effectiveRemainingTime(
        widget.building, widget.village.activePowerups);
    final gemCost = VillageRules.gemCostToSpeedUp(remaining);
    final hours = remaining.inHours;
    final mins = remaining.inMinutes % 60;
    final secs = remaining.inSeconds % 60;
    final remainingLabel = context.t('remaining');
    final timeText = hours > 0
        ? '${hours}h ${mins}m ${secs}s $remainingLabel'
        : '${mins}m ${secs}s $remainingLabel';

    // Check ad cooldown
    final cooldown = widget.village.constructionSkipCooldownRemaining(widget.building.id!);
    final bool canWatchAd = !_watchingAd && cooldown == null;
    final String adButtonText = cooldown != null
        ? '${context.t('ad_construction_skip_btn')} (${cooldown.inSeconds}s)'
        : context.t('ad_construction_skip_btn');

    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewPadding.bottom),
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppTheme.cream,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _dragHandle(),
              SizedBox(height: 16),
              Image.asset('assets/images/buildings/building_construction.png',
                  width: 88, height: 88, filterQuality: FilterQuality.medium),
              SizedBox(height: 8),
              Text(
                '${context.t('building_name_${widget.building.type}', fallback: widget.building.name)} (Lv${widget.building.level})',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.darkText),
              ),
              SizedBox(height: 4),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset('assets/images/cat_constructor.png',
                      width: 40,
                      height: 40,
                      cacheWidth: 120,
                      cacheHeight: 120,
                      filterQuality: FilterQuality.medium),
                  SizedBox(width: 6),
                  Text(context.t('under_construction'),
                      style: TextStyle(
                          fontSize: 14,
                          color: AppTheme.darkOrange,
                          fontWeight: FontWeight.bold)),
                ],
              ),
              SizedBox(height: 8),
              Text(timeText,
                  style: TextStyle(
                      fontSize: 16,
                      color: AppTheme.darkText,
                      fontWeight: FontWeight.bold)),
              SizedBox(height: 16),
              if (gemCost > 0)
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: widget.village.gems >= gemCost
                        ? widget.onSpeedUp
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: widget.village.gems >= gemCost
                          ? AppTheme.gemPurple
                          : Colors.grey.shade300,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.flash_on, size: 20),
                        SizedBox(width: 8),
                        Text(context.t('speed_up'),
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        SizedBox(width: 8),
                        ResourceIcon.gem(size: 20),
                        SizedBox(width: 4),
                        Text('$gemCost',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
               if (remaining.inSeconds > 0) ...[
                 SizedBox(height: 8),
                 SizedBox(
                   width: double.infinity,
                   height: 46,
                   child: OutlinedButton.icon(
                     onPressed: canWatchAd ? _watchAdForTimeSkip : null,
                     icon: _watchingAd
                         ? SizedBox(
                             width: 18,
                             height: 18,
                             child: CircularProgressIndicator(
                                 strokeWidth: 2,
                                 color: AppTheme.darkSkyBlue),
                           )
                         : Icon(Icons.play_circle_outline, size: 20),
                     label: Text(
                       adButtonText,
                       style: TextStyle(
                           fontSize: 15, fontWeight: FontWeight.bold),
                     ),
                     style: OutlinedButton.styleFrom(
                       foregroundColor: canWatchAd ? AppTheme.darkSkyBlue : AppTheme.darkSkyBlue.withValues(alpha: 0.4),
                       side: BorderSide(
                           color: canWatchAd
                               ? AppTheme.darkSkyBlue.withValues(alpha: 0.6)
                               : AppTheme.darkSkyBlue.withValues(alpha: 0.2),
                           width: 1.5),
                       shape: RoundedRectangleBorder(
                           borderRadius: BorderRadius.circular(16)),
                     ),
                   ),
                 ),
               ],
              SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                height: 44,
                child: OutlinedButton(
                  onPressed: widget.onCancel,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red.shade400,
                    side: BorderSide(color: Colors.red.shade300),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                  ),
                  child: Text(
                    widget.building.level > 1
                        ? context.t('cancel_upgrade')
                        : context.t('cancel_construction'),
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(height: 4),
              Text(context.t('full_resource_refund'),
                  style: TextStyle(
                      fontSize: 11,
                      color: AppTheme.darkText.withValues(alpha: 0.5))),
              SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _dragHandle() {
  return Container(
    width: 40,
    height: 4,
    decoration: BoxDecoration(
      color: Colors.grey.shade300,
      borderRadius: BorderRadius.circular(2),
    ),
  );
}
