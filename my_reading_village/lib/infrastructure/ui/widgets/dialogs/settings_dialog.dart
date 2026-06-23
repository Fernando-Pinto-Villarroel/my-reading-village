import 'dart:async';
import 'dart:convert';
import 'package:my_reading_village/infrastructure/ui/widgets/common/app_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:my_reading_village/infrastructure/ui/config/app_theme.dart';
import 'package:my_reading_village/domain/rules/village_rules.dart';
import 'package:my_reading_village/adapters/providers/village_provider.dart';
import 'package:my_reading_village/adapters/providers/book_provider.dart';
import 'package:my_reading_village/adapters/providers/tag_provider.dart';
import 'package:my_reading_village/adapters/repositories/villager_favorites.dart';
import 'package:my_reading_village/infrastructure/ui/widgets/common/shared_utils.dart';
import 'package:my_reading_village/infrastructure/ui/localization/language_provider.dart';
import 'package:my_reading_village/infrastructure/ui/localization/context_ext.dart';
import 'package:my_reading_village/infrastructure/di/service_locator.dart';
import 'package:my_reading_village/infrastructure/persistence/database_helper.dart';
import 'package:my_reading_village/application/services/audio_service.dart';
import 'package:my_reading_village/application/services/backup_service.dart';
import 'package:my_reading_village/application/services/building_service.dart';
import 'package:my_reading_village/application/services/notification_service.dart';
import 'package:my_reading_village/app_constants.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:my_reading_village/application/services/analytics_service.dart';
import 'package:my_reading_village/application/services/store_service.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void showSettingsDialog(BuildContext context, VillageProvider village,
    {VoidCallback? onRetakeTutorial}) {
  showDialog(
    context: context,
    builder: (ctx) => _SettingsDialog(
      village: village,
      onRetakeTutorial: onRetakeTutorial,
    ),
  );
}

class _SettingsDialog extends StatefulWidget {
  final VillageProvider village;
  final VoidCallback? onRetakeTutorial;

  const _SettingsDialog({required this.village, this.onRetakeTutorial});

  @override
  State<_SettingsDialog> createState() => _SettingsDialogState();
}

class _SettingsDialogState extends State<_SettingsDialog>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late TextEditingController _usernameCtrl;
  late TextEditingController _townNameCtrl;
  String? _usernameError;
  String? _townNameError;
  int _currentTab = 0;
  bool _analyticsEnabled = false;
  bool _restoringPurchases = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _tabController.addListener(() {
      if (mounted && _tabController.index != _currentTab) {
        setState(() => _currentTab = _tabController.index);
      }
    });
    _usernameCtrl = TextEditingController(text: widget.village.username);
    _townNameCtrl = TextEditingController(text: widget.village.townName);
    _analyticsEnabled = sl<AnalyticsService>().isEnabled;
  }

  @override
  void dispose() {
    _tabController.dispose();
    _usernameCtrl.dispose();
    _townNameCtrl.dispose();
    super.dispose();
  }

  void _saveGeneral() {
    final username = _usernameCtrl.text.trim();
    final townName = _townNameCtrl.text.trim();
    final minMsg = context.t('tour_input_min_chars');
    final uErr = username.isNotEmpty && username.length < 3 ? minMsg : null;
    final tErr = townName.isNotEmpty && townName.length < 3 ? minMsg : null;
    setState(() {
      _usernameError = uErr;
      _townNameError = tErr;
    });
    if (uErr != null || tErr != null) return;
    if (username.isNotEmpty) widget.village.updateUsername(username);
    if (townName.isNotEmpty) widget.village.updateTownName(townName);
    Navigator.pop(context);
  }

  Future<void> _handleExport() async {
    final result = await _showExportOptionsDialog(context);
    if (result == null || !mounted) return;
    try {
      final saved = await sl<BackupService>().exportData(
        categories: result.categories,
        saveToDownloads: result.saveToDownloads,
      );
      if (saved && result.saveToDownloads && mounted) {
        showSuccessToast(context, context.t('export_saved_to_downloads'));
        sl<AnalyticsService>().logDataExported();
      }
    } catch (_) {
      if (mounted) {
        showAppToast(context, context.t('export_error'),
            backgroundColor: const Color(0xFFE53935),
            icon: Icons.error_outline,
            duration: const Duration(seconds: 4));
      }
    }
  }

  Future<void> _handleImport() async {
    final confirmed = await _showImportWarning(context);
    if (confirmed != true || !mounted) return;
    try {
      final backup = sl<BackupService>();
      final picked = await backup.pickAndValidate();
      if (picked == null || !mounted) return;

      bool countForMissions = false;
      if (picked.hasBooksData) {
        final choice = await _showReadingMissionsChoice(context);
        if (choice == null || !mounted) return;
        countForMissions = choice;
      }

      await backup.doImport(picked.data);
      if (!mounted) return;

      await widget.village.loadData();
      await sl<LanguageProvider>().load(widget.village.language);
      await sl<AnalyticsService>().initialize();
      await sl<BookProvider>().loadData();
      await sl<TagProvider>().loadTags();
      VillagerFavorites.setLocale(widget.village.language);
      await VillagerFavorites.load();
      if (!mounted) return;

      if (picked.hadPurchasedSpeciesStripped) {
        await _showPurchasedSpeciesStrippedDialog(context);
        if (!mounted) return;
      }

      if (picked.hasBooksData) {
        if (countForMissions) {
          final totals = await backup.parseImportedReadingTotals(picked.data);
          if (!mounted) return;
          await widget.village.bulkPrecompleteMissionsForImport(
            totalPages: totals.totalPages,
            completedBooks: totals.completedBooks,
          );
          await widget.village.applyReadingMissionExclusions(pages: 0, books: 0);
        } else {
          final totals = await backup.parseImportedReadingTotals(picked.data);
          if (!mounted) return;
          await widget.village.applyReadingMissionExclusions(
            pages: totals.totalPages,
            books: totals.completedBooks,
          );
        }
      }

      sl<AnalyticsService>().logDataImported();
      if (mounted) Navigator.pop(context);
    } on FormatException catch (e) {
      if (!mounted) return;
      final msg = _importErrorMessage(context, e.message);
      showAppToast(context, msg,
          backgroundColor: const Color(0xFFE53935),
          icon: Icons.error_outline,
          duration: const Duration(seconds: 4));
    } catch (_) {
      if (!mounted) return;
      showAppToast(context, context.t('import_failed'),
          backgroundColor: const Color(0xFFE53935),
          icon: Icons.error_outline,
          duration: const Duration(seconds: 4));
    }
  }

  Future<void> _handleRestorePurchases() async {
    setState(() => _restoringPurchases = true);
    try {
      final anyRestored = await sl<StoreService>().restoreAndCollectResults();
      if (!mounted) return;
      await widget.village.refreshResources();
      await widget.village.refreshSpeciesUnlocks();
      if (!mounted) return;
      showSuccessToast(
          context,
          anyRestored
              ? context.t('restore_purchases_success')
              : context.t('restore_purchases_nothing'));
    } catch (_) {
      if (!mounted) return;
      showAppToast(context, context.t('restore_purchases_error'),
          backgroundColor: const Color(0xFFE53935),
          icon: Icons.error_outline,
          duration: const Duration(seconds: 4));
    } finally {
      if (mounted) setState(() => _restoringPurchases = false);
    }
  }

  Future<void> _handleReset() async {
    final confirmed = await _showResetWarning(context);
    if (confirmed != true || !mounted) return;
    await sl<BackupService>().resetData();
    if (!mounted) return;
    await widget.village.loadData();
    await sl<BookProvider>().loadData();
    await sl<TagProvider>().loadTags();
    VillagerFavorites.setLocale(widget.village.language);
    await VillagerFavorites.load();
    if (mounted) Navigator.pop(context);
  }

  Future<void> _rescheduleAllNotifications() async {
    final db = DatabaseHelper();
    final settings = await db.getNotificationSettings();
    final daysStr = settings['days_enabled'] as String;
    final activeDays = daysStr.split('').map((c) => c == '1').toList();
    if (activeDays.length != 7) return;
    final startHour = settings['start_hour'] as int;
    final endHour = settings['end_hour'] as int;
    final perDay = settings['per_day'] as int;
    final locale = sl<LanguageProvider>().currentLocale;
    final messages = await _loadNotificationMessages(locale);
    await sl<NotificationService>().scheduleNotifications(
      activeDays: activeDays,
      startHour: startHour,
      endHour: endHour,
      notificationsPerDay: perDay,
      messages: messages,
    );
    final lang = sl<LanguageProvider>();
    final notif = sl<NotificationService>();
    for (final b in widget.village.placedBuildings) {
      if (b.isConstructed || b.id == null) continue;
      final remaining = BuildingService.effectiveRemainingTime(
          b, widget.village.activePowerups);
      if (remaining <= Duration.zero) continue;
      await notif.scheduleConstructionComplete(
        buildingId: b.id!,
        buildingName:
            lang.translate('building_name_${b.type}', fallback: b.name),
        remaining: remaining,
        title: lang.translate('notification_construction_title'),
        body: lang.translate('notification_construction_body'),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final landscape = isLandscape(context);
    final mq = MediaQuery.of(context);
    final screenH = mq.size.height;
    final keyboardH = mq.viewInsets.bottom;
    // Reserve space for header (~52) + tabbar (~44) + dialog vertical padding + keyboard.
    final maxTabH = (screenH - keyboardH - (landscape ? 112.0 : 132.0)).clamp(
      landscape ? 160.0 : 240.0,
      landscape ? 310.0 : 530.0,
    );

    return Dialog(
      insetPadding: EdgeInsets.symmetric(
        horizontal: landscape ? 50 : 18,
        vertical: landscape ? 10 : 22,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 540),
        decoration: BoxDecoration(
          color: AppTheme.cream,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(),
            _buildTabBar(),
            Flexible(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: maxTabH),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 160),
                  transitionBuilder: (child, anim) =>
                      FadeTransition(opacity: anim, child: child),
                  child: KeyedSubtree(
                    key: ValueKey(_currentTab),
                    child: _buildCurrentTab(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentTab() {
    switch (_currentTab) {
      case 1:
        return _buildMusicTab();
      case 2:
        return _buildNotificationsTab();
      case 3:
        return _buildDataTab();
      case 4:
        return _buildInfoTab();
      default:
        return _buildGeneralTab();
    }
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 14, 8, 10),
      decoration: BoxDecoration(
        color: AppTheme.lavender.withValues(alpha: 0.18),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.settings_rounded, size: 22, color: AppTheme.darkLavender),
          const SizedBox(width: 8),
          Text(
            context.t('settings'),
            style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.darkText),
          ),
          const Spacer(),
          IconButton(
            icon: Icon(Icons.close_rounded,
                color: AppTheme.darkText.withValues(alpha: 0.55)),
            onPressed: () => Navigator.pop(context),
            visualDensity: VisualDensity.compact,
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      decoration: BoxDecoration(
        border: Border(
            bottom:
                BorderSide(color: AppTheme.darkText.withValues(alpha: 0.08))),
      ),
      child: TabBar(
        controller: _tabController,
        labelColor: AppTheme.darkLavender,
        unselectedLabelColor: AppTheme.darkText.withValues(alpha: 0.35),
        indicatorColor: AppTheme.darkLavender,
        indicatorWeight: 2.5,
        tabs: const [
          Tab(icon: Icon(Icons.tune_rounded, size: 20), height: 42),
          Tab(icon: Icon(Icons.music_note_rounded, size: 20), height: 42),
          Tab(icon: Icon(Icons.notifications_rounded, size: 20), height: 42),
          Tab(icon: Icon(Icons.storage_rounded, size: 20), height: 42),
          Tab(icon: Icon(Icons.info_outline_rounded, size: 20), height: 42),
        ],
      ),
    );
  }

  Widget _buildGeneralTab() {
    final village = widget.village;
    final progress = VillageRules.expProgressToNextLevel(village.exp);
    final expToNext = VillageRules.expToNextLevel(village.exp);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.lavender.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Text(
                  '${context.t('player_level')} ${village.playerLevel}',
                  style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.darkText),
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                        color: AppTheme.darkText.withValues(alpha: 0.3),
                        width: 1),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 10,
                      backgroundColor: Colors.grey.shade200,
                      valueColor:
                          const AlwaysStoppedAnimation(AppTheme.lavender),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${village.exp} EXP ($expToNext ${context.t('exp_to_next_level')})',
                  style: TextStyle(
                      fontSize: 12,
                      color: AppTheme.darkText.withValues(alpha: 0.6)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _usernameCtrl,
            inputFormatters: [LengthLimitingTextInputFormatter(40)],
            decoration: InputDecoration(
              labelText: context.t('username'),
              errorText: _usernameError,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: _usernameError != null
                      ? AppTheme.pink
                      : AppTheme.lavender.withValues(alpha: 0.5),
                ),
              ),
            ),
            textCapitalization: TextCapitalization.words,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _townNameCtrl,
            inputFormatters: [LengthLimitingTextInputFormatter(40)],
            decoration: InputDecoration(
              labelText: context.t('town_name'),
              errorText: _townNameError,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: _townNameError != null
                      ? AppTheme.pink
                      : AppTheme.lavender.withValues(alpha: 0.5),
                ),
              ),
            ),
            textCapitalization: TextCapitalization.words,
          ),
          const SizedBox(height: 14),
          _LanguageSelector(onLanguageChanged: _rescheduleAllNotifications),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 44,
            child: ElevatedButton(
              onPressed: _saveGeneral,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
              ),
              child: Text(context.t('save')),
            ),
          ),
          if (widget.onRetakeTutorial != null) ...[
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.replay_rounded, color: AppTheme.pink),
                label: Text(context.t('retake_tutorial')),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.pink,
                  side: BorderSide(color: AppTheme.pink.withValues(alpha: 0.6)),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  widget.onRetakeTutorial!();
                },
              ),
            ),
          ],
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildMusicTab() {
    return const SingleChildScrollView(
      padding: EdgeInsets.all(18),
      child: _MusicSettingsSection(),
    );
  }

  Widget _buildNotificationsTab() {
    return const SingleChildScrollView(
      padding: EdgeInsets.all(18),
      child: _NotificationSettingsSection(),
    );
  }

  Widget _buildDataTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.bar_chart_rounded,
                  size: 20, color: AppTheme.darkLavender),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  context.t('analytics_settings_title'),
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.darkText),
                ),
              ),
              Switch(
                value: _analyticsEnabled,
                activeThumbColor: AppTheme.darkLavender,
                activeTrackColor: AppTheme.lavender,
                onChanged: (v) async {
                  setState(() => _analyticsEnabled = v);
                  await sl<AnalyticsService>().setConsent(v);
                },
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            context.t('analytics_settings_desc'),
            style: TextStyle(
                fontSize: 12, color: AppTheme.darkText.withValues(alpha: 0.60)),
          ),
          const SizedBox(height: 6),
          GestureDetector(
            onTap: () async {
              final uri = Uri.parse('https://myreadingvillage.com/privacy');
              try {
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              } catch (_) {}
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.open_in_new, size: 13, color: AppTheme.darkLavender),
                const SizedBox(width: 4),
                Text(
                  context.t('analytics_privacy_link'),
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.darkLavender,
                    decoration: TextDecoration.underline,
                    decorationColor: AppTheme.darkLavender,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Divider(color: AppTheme.darkText.withValues(alpha: 0.15)),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.storage_rounded, size: 20, color: AppTheme.darkMint),
              const SizedBox(width: 8),
              Text(
                context.t('data_management'),
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.darkText),
              ),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              icon: const Icon(Icons.upload_file, color: AppTheme.darkMint),
              label: Text(context.t('export_data')),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.darkText,
                side: const BorderSide(color: AppTheme.darkMint),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              onPressed: _handleExport,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              icon: const Icon(Icons.download_rounded,
                  color: AppTheme.darkSkyBlue),
              label: Text(context.t('import_data')),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.darkText,
                side: const BorderSide(color: AppTheme.darkSkyBlue),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              onPressed: _handleImport,
            ),
          ),
          if (AppConstants.playStore) ...[
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                icon: _restoringPurchases
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.restore_rounded,
                        color: AppTheme.darkLavender),
                label: Text(context.t('restore_purchases')),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.darkText,
                  side: const BorderSide(color: AppTheme.darkLavender),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onPressed: _restoringPurchases ? null : _handleRestorePurchases,
              ),
            ),
          ],
          const SizedBox(height: 16),
          Divider(color: AppTheme.darkText.withValues(alpha: 0.15)),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.delete_forever, color: Colors.white),
              label: Text(context.t('reset_all_data'),
                  style: const TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF6B6B),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              onPressed: _handleReset,
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildInfoTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppTheme.lavender.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(14),
              border:
                  Border.all(color: AppTheme.lavender.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppTheme.lavender.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.auto_stories_rounded,
                      color: AppTheme.darkLavender, size: 26),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'My Reading Village',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.darkText),
                    ),
                    Text(
                      '${context.t('info_app_version')} ${AppConstants.appVersion}',
                      style: TextStyle(
                          fontSize: 12,
                          color: AppTheme.darkText.withValues(alpha: 0.6)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              const Icon(Icons.contact_support_rounded,
                  size: 20, color: AppTheme.darkPink),
              const SizedBox(width: 8),
              Text(
                context.t('info_contact'),
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.darkText),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            context.t('info_contact_subtitle'),
            style: TextStyle(
                fontSize: 12, color: AppTheme.darkText.withValues(alpha: 0.6)),
          ),
          const SizedBox(height: 12),
          _ContactItem(
            icon: const Icon(Icons.email_rounded,
                size: 20, color: AppTheme.darkPink),
            label: context.t('info_email'),
            value: 'myreadingvillage@gmail.com',
            url: 'mailto:myreadingvillage@gmail.com',
            color: AppTheme.darkPink,
          ),
          const SizedBox(height: 8),
          _ContactItem(
            icon: const FaIcon(FontAwesomeIcons.instagram,
                size: 18, color: AppTheme.mediumOrange),
            label: context.t('info_instagram'),
            value: '@myreadingvillage',
            url: 'https://www.instagram.com/myreadingvillage',
            color: AppTheme.mediumOrange,
          ),
          const SizedBox(height: 8),
          _ContactItem(
            icon: const FaIcon(FontAwesomeIcons.facebook,
                size: 18, color: AppTheme.darkSkyBlue),
            label: context.t('info_facebook'),
            value: '@myreadingvillage',
            url: 'https://www.facebook.com/myreadingvillage',
            color: AppTheme.darkSkyBlue,
          ),
          const SizedBox(height: 8),
          _ContactItem(
            icon: const FaIcon(FontAwesomeIcons.youtube,
                size: 18, color: AppTheme.darkOrange),
            label: context.t('info_youtube'),
            value: '@myreadingvillage',
            url: 'https://www.youtube.com/@myreadingvillage',
            color: AppTheme.darkOrange,
          ),
          const SizedBox(height: 8),
          _ContactItem(
            icon: const FaIcon(FontAwesomeIcons.reddit,
                size: 18, color: AppTheme.darkMint),
            label: context.t('info_reddit'),
            value: 'u/myreadingvillage',
            url: 'https://www.reddit.com/user/myreadingvillage/',
            color: AppTheme.darkMint,
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppTheme.gemPurple.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                  color: AppTheme.gemPurple.withValues(alpha: 0.3)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.auto_awesome_rounded,
                    color: AppTheme.darkLavender, size: 22),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.t('info_secret_codes_cta_title'),
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.darkLavender,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        context.t('info_secret_codes_cta_body'),
                        style: TextStyle(
                          fontSize: 12,
                          color: AppTheme.darkText.withValues(alpha: 0.75),
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _ContactItem extends StatelessWidget {
  final Widget icon;
  final String label;
  final String value;
  final String url;
  final Color color;

  const _ContactItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.url,
    required this.color,
  });

  Future<void> _open(BuildContext context) async {
    final uri = Uri.parse(url);
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      if (context.mounted) {
        showErrorToast(context, context.t('error_prefix') + url);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _open(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.07),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.25)),
        ),
        child: Row(
          children: [
            SizedBox(width: 20, child: Center(child: icon)),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.darkText.withValues(alpha: 0.55)),
                  ),
                  Text(
                    value,
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.darkText),
                  ),
                ],
              ),
            ),
            Icon(Icons.open_in_new_rounded,
                size: 15, color: color.withValues(alpha: 0.55)),
          ],
        ),
      ),
    );
  }
}

Future<({Set<String> categories, bool saveToDownloads})?>
    _showExportOptionsDialog(BuildContext context) {
  return showDialog<({Set<String> categories, bool saveToDownloads})>(
    context: context,
    builder: (ctx) => const _ExportOptionsDialog(),
  );
}

class _ExportOptionsDialog extends StatefulWidget {
  const _ExportOptionsDialog();

  @override
  State<_ExportOptionsDialog> createState() => _ExportOptionsDialogState();
}

class _ExportOptionsDialogState extends State<_ExportOptionsDialog> {
  final Set<String> _selected = {
    'books_reading',
    'resources',
    'village',
    'progress',
    'missions',
    'extras',
  };
  bool _saveToDownloads = false;

  static final _categoryDefs = [
    (
      'books_reading',
      Icons.menu_book_rounded,
      AppTheme.darkLavender,
      'export_category_books',
      'export_category_books_desc'
    ),
    (
      'resources',
      Icons.account_balance_wallet_rounded,
      AppTheme.mediumOrange,
      'export_category_resources',
      'export_category_resources_desc'
    ),
    (
      'village',
      Icons.holiday_village_rounded,
      AppTheme.darkMint,
      'export_category_village',
      'export_category_village_desc'
    ),
    (
      'progress',
      Icons.trending_up_rounded,
      AppTheme.darkSkyBlue,
      'export_category_progress',
      'export_category_progress_desc'
    ),
    (
      'missions',
      Icons.task_alt_rounded,
      AppTheme.mediumOrange,
      'export_category_missions',
      'export_category_missions_desc'
    ),
    (
      'extras',
      Icons.extension_rounded,
      AppTheme.darkLavender,
      'export_category_extras',
      'export_category_extras_desc'
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final landscape = isLandscape(context);
    final screenH = MediaQuery.sizeOf(context).height;
    final maxH = landscape
        ? (screenH * 0.90).clamp(280.0, 420.0)
        : (screenH * 0.88).clamp(480.0, 620.0);

    return Dialog(
      insetPadding: EdgeInsets.symmetric(
          horizontal: landscape ? 70 : 20, vertical: landscape ? 10 : 36),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Container(
        constraints: BoxConstraints(maxWidth: 500, maxHeight: maxH),
        decoration: BoxDecoration(
            color: AppTheme.cream, borderRadius: BorderRadius.circular(24)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(16, 14, 8, 10),
              decoration: BoxDecoration(
                color: AppTheme.darkMint.withValues(alpha: 0.1),
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.upload_file,
                      size: 20, color: AppTheme.darkMint),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.t('export_select_title'),
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.darkText),
                        ),
                        Text(
                          context.t('export_select_subtitle'),
                          style: TextStyle(
                              fontSize: 11,
                              color: AppTheme.darkText.withValues(alpha: 0.6)),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close_rounded,
                        color: AppTheme.darkText.withValues(alpha: 0.55)),
                    onPressed: () => Navigator.pop(context),
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 0),
                child: Column(
                  children: [
                    ..._categoryDefs.map((def) {
                      final (id, icon, color, titleKey, descKey) = def;
                      final checked = _selected.contains(id);
                      return GestureDetector(
                        onTap: () => setState(() {
                          if (checked) {
                            _selected.remove(id);
                          } else {
                            _selected.add(id);
                          }
                        }),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 6),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 11, vertical: 8),
                          decoration: BoxDecoration(
                            color: checked
                                ? color.withValues(alpha: 0.08)
                                : AppTheme.cream,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: checked
                                  ? color.withValues(alpha: 0.35)
                                  : AppTheme.darkText.withValues(alpha: 0.12),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(icon,
                                  size: 18,
                                  color: checked
                                      ? color
                                      : AppTheme.darkText
                                          .withValues(alpha: 0.3)),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      context.t(titleKey),
                                      style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: checked
                                              ? AppTheme.darkText
                                              : AppTheme.darkText
                                                  .withValues(alpha: 0.4)),
                                    ),
                                    Text(
                                      context.t(descKey),
                                      style: TextStyle(
                                          fontSize: 11,
                                          color: AppTheme.darkText
                                              .withValues(alpha: 0.5)),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(
                                checked
                                    ? Icons.check_box_rounded
                                    : Icons.check_box_outline_blank_rounded,
                                color: checked
                                    ? color
                                    : AppTheme.darkText.withValues(alpha: 0.28),
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppTheme.darkText.withValues(alpha: 0.04),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: AppTheme.darkText.withValues(alpha: 0.1)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.t('export_method_title'),
                            style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.darkText),
                          ),
                          const SizedBox(height: 8),
                          _ExportMethodOption(
                            icon: Icons.share_rounded,
                            label: context.t('export_method_share'),
                            desc: context.t('export_method_share_desc'),
                            color: AppTheme.darkLavender,
                            selected: !_saveToDownloads,
                            onTap: () =>
                                setState(() => _saveToDownloads = false),
                          ),
                          const SizedBox(height: 6),
                          _ExportMethodOption(
                            icon: Icons.folder_rounded,
                            label: context.t('export_method_download'),
                            desc: context.t('export_method_download_desc'),
                            color: AppTheme.darkMint,
                            selected: _saveToDownloads,
                            onTap: () =>
                                setState(() => _saveToDownloads = true),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.upload_file, size: 18),
                  label: Text(context.t('export_button')),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.darkMint,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 13),
                  ),
                  onPressed: () {
                    if (_selected.isEmpty) {
                      showAppToast(
                          context, context.t('export_nothing_selected'));
                      return;
                    }
                    Navigator.pop(context, (
                      categories: _selected,
                      saveToDownloads: _saveToDownloads
                    ));
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ExportMethodOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final String desc;
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  const _ExportMethodOption({
    required this.icon,
    required this.label,
    required this.desc,
    required this.color,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 140),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? color.withValues(alpha: 0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected
                ? color.withValues(alpha: 0.4)
                : AppTheme.darkText.withValues(alpha: 0.1),
          ),
        ),
        child: Row(
          children: [
            Icon(icon,
                size: 18,
                color: selected
                    ? color
                    : AppTheme.darkText.withValues(alpha: 0.35)),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: selected
                            ? AppTheme.darkText
                            : AppTheme.darkText.withValues(alpha: 0.45)),
                  ),
                  Text(
                    desc,
                    style: TextStyle(
                        fontSize: 10,
                        color: AppTheme.darkText.withValues(alpha: 0.5)),
                  ),
                ],
              ),
            ),
            Icon(
              selected
                  ? Icons.radio_button_checked_rounded
                  : Icons.radio_button_unchecked_rounded,
              color:
                  selected ? color : AppTheme.darkText.withValues(alpha: 0.28),
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}

Future<bool?> _showReadingMissionsChoice(BuildContext context) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (ctx) {
      bool? selected;
      return StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: AppTheme.cream,
          title: Row(
            children: [
              const Icon(Icons.auto_stories, color: AppTheme.darkLavender),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  ctx.t('import_reading_missions_title'),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: AppTheme.darkText),
                ),
              ),
            ],
          ),
          content: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(ctx).size.height * 0.5,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _ReadingMissionChoiceTile(
                    icon: Icons.radio_button_unchecked,
                    iconColor: AppTheme.darkMint,
                    label: ctx.t('import_reading_missions_yes'),
                    description: ctx.t('import_reading_missions_yes_desc'),
                    isSelected: selected == true,
                    onTap: () => setState(() => selected = true),
                  ),
                  const SizedBox(height: 10),
                  _ReadingMissionChoiceTile(
                    icon: Icons.radio_button_unchecked,
                    iconColor: AppTheme.darkLavender,
                    label: ctx.t('import_reading_missions_no'),
                    description: ctx.t('import_reading_missions_no_desc'),
                    isSelected: selected == false,
                    onTap: () => setState(() => selected = false),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, null),
              child: Text(ctx.t('cancel'),
                  style: const TextStyle(color: AppTheme.darkText)),
            ),
            TextButton(
              onPressed:
                  selected != null ? () => Navigator.pop(ctx, selected) : null,
              child: Text(
                ctx.t('continue'),
                style: TextStyle(
                  color: selected != null
                      ? AppTheme.darkLavender
                      : AppTheme.darkText.withValues(alpha: 0.3),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}

class _ReadingMissionChoiceTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String description;
  final bool isSelected;
  final VoidCallback onTap;

  const _ReadingMissionChoiceTile({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.description,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected
              ? iconColor.withValues(alpha: 0.18)
              : iconColor.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? iconColor.withValues(alpha: 0.8)
                : iconColor.withValues(alpha: 0.3),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              isSelected ? Icons.check_circle : icon,
              color: iconColor,
              size: 22,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: AppTheme.darkText,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 11,
                      color: AppTheme.darkText.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<bool?> _showImportWarning(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: AppTheme.cream,
      title: Row(
        children: [
          const Icon(Icons.warning_amber_rounded, color: AppTheme.mediumOrange),
          const SizedBox(width: 8),
          Expanded(
            child: Text(ctx.t('import_warning_title'),
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: AppTheme.darkText)),
          ),
        ],
      ),
      content: Text(ctx.t('import_warning_body'),
          style: const TextStyle(color: AppTheme.darkText)),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: Text(ctx.t('cancel'),
              style: const TextStyle(color: AppTheme.darkText)),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(ctx, true),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.darkSkyBlue,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: Text(ctx.t('import_confirm'),
              style: const TextStyle(color: Colors.white)),
        ),
      ],
    ),
  );
}

Future<bool?> _showResetWarning(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: AppTheme.cream,
      title: Row(
        children: [
          const Icon(Icons.warning_rounded, color: Color(0xFFFF6B6B)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(ctx.t('reset_warning_title'),
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Color(0xFFFF6B6B))),
          ),
        ],
      ),
      content: Text(ctx.t('reset_warning_body'),
          style: const TextStyle(color: AppTheme.darkText)),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: Text(ctx.t('cancel'),
              style: const TextStyle(color: AppTheme.darkText)),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(ctx, true),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFF6B6B),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: Text(ctx.t('reset_confirm'),
              style: const TextStyle(color: Colors.white)),
        ),
      ],
    ),
  );
}

String _importErrorMessage(BuildContext context, String errorCode) {
  final lang = context.read<LanguageProvider>();
  if (errorCode == 'invalid_backup_not_json') {
    return lang.translate('import_error_not_json');
  }
  if (errorCode == 'tampered_backup') {
    return lang.translate('import_error_tampered');
  }
  return lang.translate('import_error_invalid_file');
}

Future<void> _showPurchasedSpeciesStrippedDialog(BuildContext context) async {
  final lang = context.read<LanguageProvider>();
  final village = context.read<VillageProvider>();
  await showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => _PurchasedSpeciesStrippedDialog(
      lang: lang,
      village: village,
    ),
  );
}

class _PurchasedSpeciesStrippedDialog extends StatefulWidget {
  final LanguageProvider lang;
  final VillageProvider village;
  const _PurchasedSpeciesStrippedDialog({
    required this.lang,
    required this.village,
  });

  @override
  State<_PurchasedSpeciesStrippedDialog> createState() =>
      _PurchasedSpeciesStrippedDialogState();
}

class _PurchasedSpeciesStrippedDialogState
    extends State<_PurchasedSpeciesStrippedDialog> {
  bool _restoring = false;

  Future<void> _handleRestorePurchases() async {
    setState(() => _restoring = true);
    try {
      final anyRestored = await sl<StoreService>().restoreAndCollectResults();

      if (!mounted) return;

      await widget.village.refreshResources();
      await widget.village.refreshSpeciesUnlocks();

      if (!mounted) return;
      final msg = anyRestored
          ? widget.lang.translate('restore_purchases_success')
          : widget.lang.translate('restore_purchases_nothing');
      // ignore: use_build_context_synchronously
      showSuccessToast(context, msg);
    } catch (_) {
      if (!mounted) return;
      showAppToast(
        context,
        widget.lang.translate('restore_purchases_error'),
        backgroundColor: const Color(0xFFE53935),
        icon: Icons.error_outline,
        duration: const Duration(seconds: 4),
      );
    } finally {
      if (mounted) setState(() => _restoring = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final landscape = mq.size.width > mq.size.height;
    final maxH = mq.size.height * (landscape ? 0.85 : 0.75);
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: AppTheme.cream,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 480, maxHeight: maxH),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!landscape) ...[
                Icon(Icons.lock_outline,
                    color: AppTheme.darkLavender, size: 40),
                const SizedBox(height: 12),
              ],
              Text(
                widget.lang.translate('import_purchased_species_title'),
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.darkText,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                widget.lang.translate('import_purchased_species_body'),
                style: TextStyle(
                  fontSize: 13,
                  color: AppTheme.darkText.withValues(alpha: 0.8),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              if (_restoring)
                const CircularProgressIndicator()
              else ...[
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _handleRestorePurchases,
                    icon: const Icon(Icons.restore_rounded, size: 18),
                    label: Text(
                      widget.lang.translate('restore_purchases'),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.darkSkyBlue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    widget.lang.translate('close'),
                    style: TextStyle(
                        color: AppTheme.darkText.withValues(alpha: 0.6)),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

Future<List<Map<String, String>>> _loadNotificationMessages(
    String locale) async {
  try {
    final data = await rootBundle
        .loadString('assets/messages/$locale/notification_messages.json');
    final json = jsonDecode(data) as Map<String, dynamic>;
    final list = json['messages'] as List;
    return list
        .map((e) => {
              'title': e['title'] as String,
              'body': e['body'] as String,
            })
        .toList();
  } catch (_) {
    return [
      {'title': 'Time to read!', 'body': 'Your village is waiting!'}
    ];
  }
}

class _MusicSettingsSection extends StatefulWidget {
  const _MusicSettingsSection();

  @override
  State<_MusicSettingsSection> createState() => _MusicSettingsSectionState();
}

class _MusicSettingsSectionState extends State<_MusicSettingsSection> {
  static const int _maxLevel = 5;
  static const int _barCount = 5;

  static const Color _musicBarActiveColor = Color(0xFF4CAF50);
  static const Color _effectsBarActiveColor = Color(0xFF7C4DFF);
  static const Color _barInactiveColor = Color(0xFFDDDDDD);

  late int _musicLevel;
  late int _effectsLevel;

  @override
  void initState() {
    super.initState();
    _musicLevel = sl<AudioService>().musicLevel;
    _effectsLevel = sl<AudioService>().effectsLevel;
  }

  Future<void> _setMusicLevel(int level) async {
    if (level < 0 || level > _maxLevel) return;
    setState(() => _musicLevel = level);
    await sl<AudioService>().setMusicVolume(level);
  }

  Future<void> _setEffectsLevel(int level) async {
    if (level < 0 || level > _maxLevel) return;
    setState(() => _effectsLevel = level);
    await sl<AudioService>().setEffectsVolume(level);
  }

  Widget _buildVolumeRow({
    required int level,
    required Color activeColor,
    required VoidCallback onDecrement,
    required VoidCallback onIncrement,
    required void Function(int) onBarTap,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _VolumeButton(
          icon: Icons.chevron_left_rounded,
          enabled: level > 0,
          activeColor: activeColor,
          onTap: onDecrement,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(_barCount, (i) {
              final filled = i < level;
              return Expanded(
                child: GestureDetector(
                  onTap: () => onBarTap(i + 1),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 160),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    height: 28,
                    decoration: BoxDecoration(
                      color: filled ? activeColor : _barInactiveColor,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: filled
                            ? activeColor.withValues(alpha: 0.7)
                            : _barInactiveColor.withValues(alpha: 0.5),
                        width: 1,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
        const SizedBox(width: 10),
        _VolumeButton(
          icon: Icons.chevron_right_rounded,
          enabled: level < _maxLevel,
          activeColor: activeColor,
          onTap: onIncrement,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              _musicLevel == 0
                  ? Icons.music_off_rounded
                  : Icons.music_note_rounded,
              size: 20,
              color: AppTheme.darkMint,
            ),
            const SizedBox(width: 8),
            Text(
              context.t('music_settings'),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppTheme.darkText,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Text(
          context.t('music_volume'),
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppTheme.darkText.withValues(alpha: 0.7),
          ),
        ),
        const SizedBox(height: 10),
        _buildVolumeRow(
          level: _musicLevel,
          activeColor: _musicBarActiveColor,
          onDecrement: () => _setMusicLevel(_musicLevel - 1),
          onIncrement: () => _setMusicLevel(_musicLevel + 1),
          onBarTap: _setMusicLevel,
        ),
        const SizedBox(height: 8),
        Center(
          child: Text(
            '${(_musicLevel * 20)}%',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppTheme.darkMint,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          context.t('effects_volume'),
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppTheme.darkText.withValues(alpha: 0.7),
          ),
        ),
        const SizedBox(height: 10),
        _buildVolumeRow(
          level: _effectsLevel,
          activeColor: _effectsBarActiveColor,
          onDecrement: () => _setEffectsLevel(_effectsLevel - 1),
          onIncrement: () => _setEffectsLevel(_effectsLevel + 1),
          onBarTap: _setEffectsLevel,
        ),
        const SizedBox(height: 8),
        Center(
          child: Text(
            '${(_effectsLevel * 20)}%',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: _effectsBarActiveColor,
            ),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}

class _VolumeButton extends StatelessWidget {
  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;
  final Color activeColor;

  const _VolumeButton({
    required this.icon,
    required this.enabled,
    required this.onTap,
    this.activeColor = AppTheme.darkMint,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: enabled
              ? activeColor.withValues(alpha: 0.15)
              : AppTheme.darkText.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: enabled
                ? activeColor.withValues(alpha: 0.5)
                : AppTheme.darkText.withValues(alpha: 0.15),
          ),
        ),
        child: Icon(
          icon,
          size: 22,
          color:
              enabled ? activeColor : AppTheme.darkText.withValues(alpha: 0.3),
        ),
      ),
    );
  }
}

class _NotificationSettingsSection extends StatefulWidget {
  const _NotificationSettingsSection();

  @override
  State<_NotificationSettingsSection> createState() =>
      _NotificationSettingsSectionState();
}

class _NotificationSettingsSectionState
    extends State<_NotificationSettingsSection> {
  List<bool> _activeDays = List.filled(7, true);
  int _startHour = 8;
  int _endHour = 22;
  int _perDay = 2;
  bool _loading = true;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final db = DatabaseHelper();
    final s = await db.getNotificationSettings();
    final daysStr = s['days_enabled'] as String;
    setState(() {
      _activeDays = daysStr.split('').map((c) => c == '1').toList();
      if (_activeDays.length != 7) _activeDays = List.filled(7, true);
      _startHour = s['start_hour'] as int;
      _endHour = s['end_hour'] as int;
      _perDay = s['per_day'] as int;
      _loading = false;
    });
  }

  Future<void> _saveSettings() async {
    if (_saving) return;
    setState(() => _saving = true);
    try {
      final daysStr = _activeDays.map((b) => b ? '1' : '0').join();
      final db = DatabaseHelper();
      await db.saveNotificationSettings(
        daysEnabled: daysStr,
        startHour: _startHour,
        endHour: _endHour,
        perDay: _perDay,
      );
      final lang =
          mounted ? context.read<LanguageProvider>().currentLocale : 'en';
      final messages = await _loadNotificationMessages(lang);
      await sl<NotificationService>().scheduleNotifications(
        activeDays: _activeDays,
        startHour: _startHour,
        endHour: _endHour,
        notificationsPerDay: _perDay,
        messages: messages,
      );
      if (mounted) {
        showSuccessToast(context, context.t('notification_saved'));
      }
    } catch (_) {}
    if (mounted) setState(() => _saving = false);
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.read<LanguageProvider>();
    final dayKeys = [
      'notification_day_mon',
      'notification_day_tue',
      'notification_day_wed',
      'notification_day_thu',
      'notification_day_fri',
      'notification_day_sat',
      'notification_day_sun',
    ];

    if (_loading) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child:
            Center(child: CircularProgressIndicator(color: AppTheme.lavender)),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.notifications_rounded,
                size: 20, color: AppTheme.lavender),
            const SizedBox(width: 8),
            Text(
              context.t('notification_settings'),
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.darkText),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          context.t('notification_days_label'),
          style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppTheme.darkText.withValues(alpha: 0.7)),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: List.generate(7, (i) {
            final isActive = _activeDays[i];
            return GestureDetector(
              onTap: () => setState(() => _activeDays[i] = !_activeDays[i]),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                decoration: BoxDecoration(
                  color: isActive
                      ? AppTheme.lavender
                      : AppTheme.lavender.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isActive
                        ? AppTheme.darkLavender
                        : AppTheme.lavender.withValues(alpha: 0.35),
                  ),
                ),
                child: Text(
                  lang.translate(dayKeys[i]),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: isActive
                        ? AppTheme.darkText
                        : AppTheme.darkText.withValues(alpha: 0.45),
                  ),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 14),
        Text(
          context.t('notification_hours_label'),
          style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppTheme.darkText.withValues(alpha: 0.7)),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _HourPicker(
                label: context.t('notification_from_label'),
                value: _startHour,
                min: 0,
                max: _endHour - 1,
                onChanged: (v) => setState(() => _startHour = v),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _HourPicker(
                label: context.t('notification_to_label'),
                value: _endHour,
                min: _startHour + 1,
                max: 23,
                onChanged: (v) => setState(() => _endHour = v),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Text(
          context.t('notification_count_label'),
          style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppTheme.darkText.withValues(alpha: 0.7)),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            IconButton(
              onPressed: _perDay > 1 ? () => setState(() => _perDay--) : null,
              icon: const Icon(Icons.remove_circle_outline_rounded),
              color: AppTheme.lavender,
              disabledColor: AppTheme.lavender.withValues(alpha: 0.3),
            ),
            Expanded(
              child: Center(
                child: Text(
                  '$_perDay',
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.darkText),
                ),
              ),
            ),
            IconButton(
              onPressed: _perDay < 10 ? () => setState(() => _perDay++) : null,
              icon: const Icon(Icons.add_circle_outline_rounded),
              color: AppTheme.lavender,
              disabledColor: AppTheme.lavender.withValues(alpha: 0.3),
            ),
          ],
        ),
        const SizedBox(height: 14),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            icon: _saving
                ? SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                        color: Colors.white, strokeWidth: 2))
                : const Icon(Icons.notifications_active_rounded, size: 18),
            label: Text(context.t('notification_save')),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.lavender,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            onPressed: _saving ? null : _saveSettings,
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}

class _HourPicker extends StatelessWidget {
  final String label;
  final int value;
  final int min;
  final int max;
  final ValueChanged<int> onChanged;

  const _HourPicker({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.lavender.withValues(alpha: 0.08),
        border: Border.all(color: AppTheme.lavender.withValues(alpha: 0.4)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: TextStyle(
                        fontSize: 11,
                        color: AppTheme.darkText.withValues(alpha: 0.55))),
                Text(
                  '${value.toString().padLeft(2, '0')}:00',
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.darkLavender),
                ),
              ],
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: value < max ? () => onChanged(value + 1) : null,
                child: Icon(Icons.keyboard_arrow_up_rounded,
                    size: 20,
                    color: value < max
                        ? AppTheme.lavender
                        : AppTheme.lavender.withValues(alpha: 0.3)),
              ),
              GestureDetector(
                onTap: value > min ? () => onChanged(value - 1) : null,
                child: Icon(Icons.keyboard_arrow_down_rounded,
                    size: 20,
                    color: value > min
                        ? AppTheme.lavender
                        : AppTheme.lavender.withValues(alpha: 0.3)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LanguageSelector extends StatelessWidget {
  final Future<void> Function()? onLanguageChanged;

  const _LanguageSelector({this.onLanguageChanged});

  @override
  Widget build(BuildContext context) {
    final languageProvider = context.watch<LanguageProvider>();
    final currentLocale = languageProvider.currentLocale;

    return Row(
      children: [
        const Icon(Icons.language, size: 24, color: AppTheme.lavender),
        const SizedBox(width: 8),
        Text(context.t('language'),
            style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: AppTheme.darkText)),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: AppTheme.lavender.withValues(alpha: 0.1),
            border: Border.all(color: AppTheme.lavender.withValues(alpha: 0.4)),
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: currentLocale,
              isDense: true,
              borderRadius: BorderRadius.circular(12),
              dropdownColor: AppTheme.cream,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppTheme.lavender,
              ),
              icon: const Icon(Icons.keyboard_arrow_down,
                  size: 18, color: AppTheme.lavender),
              items: LanguageProvider.supportedLanguages.entries.map((entry) {
                return DropdownMenuItem<String>(
                  value: entry.key,
                  child: Text(
                    entry.value['name']!,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: entry.key == currentLocale
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: AppTheme.darkText,
                    ),
                  ),
                );
              }).toList(),
              onChanged: (locale) {
                if (locale != null) {
                  VillagerFavorites.setLocale(locale);
                  VillagerFavorites.load();
                  sl<AnalyticsService>().logLanguageChanged(locale);
                  context
                      .read<LanguageProvider>()
                      .changeLanguage(locale)
                      .then((_) => onLanguageChanged?.call());
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}
