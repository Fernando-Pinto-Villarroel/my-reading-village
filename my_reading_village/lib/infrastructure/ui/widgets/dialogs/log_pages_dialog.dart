import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_reading_village/infrastructure/ui/config/app_theme.dart';
import 'package:my_reading_village/infrastructure/persistence/database_helper.dart';
import 'package:my_reading_village/adapters/providers/book_provider.dart';
import 'package:my_reading_village/adapters/providers/village_provider.dart';
import 'package:my_reading_village/infrastructure/ui/widgets/popups/reward_popup.dart';
import 'package:my_reading_village/infrastructure/ui/localization/language_provider.dart';
import 'package:my_reading_village/domain/rules/reading_rules.dart';
import 'package:my_reading_village/infrastructure/di/service_locator.dart';
import 'package:my_reading_village/application/services/audio_service.dart';
import 'package:my_reading_village/application/services/analytics_service.dart';

Completer<void>? _activeCompletionFlow;
Future<void>? get activeBookCompletionFlow => _activeCompletionFlow?.future;

void showLogPagesDialog(BuildContext context, int bookId) {
  final bookProvider = context.read<BookProvider>();
  final villageProvider = context.read<VillageProvider>();
  final langProvider = context.read<LanguageProvider>();
  final pagesController = TextEditingController();
  final timeController = TextEditingController();
  final book = bookProvider.books.firstWhere((b) => b.id == bookId);
  final remainingPages = book.totalPages - book.pagesRead;
  DateTime selectedDate = DateTime.now();

  showDialog(
    context: context,
    builder: (dialogCtx) {
      String? pagesError;
      String? timeError;
      return StatefulBuilder(
        builder: (dialogCtx, setDialogState) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(langProvider.translate('log_reading_session')),
          content: SingleChildScrollView(
              child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(langProvider.translate('how_many_pages'),
                  style: TextStyle(
                      color: AppTheme.darkText.withValues(alpha: 0.7))),
              SizedBox(height: 4),
              Text(
                  '$remainingPages ${langProvider.translate('pages_remaining')}',
                  style: TextStyle(
                      fontSize: 12,
                      color: AppTheme.darkText.withValues(alpha: 0.5))),
              SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextField(
                      controller: pagesController,
                      decoration: InputDecoration(
                        labelText:
                            '${langProvider.translate('pages_read_label')} $remainingPages)',
                        hintText: langProvider.translate('pages_read_hint'),
                        errorText: pagesError,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      keyboardType: TextInputType.number,
                      autofocus: true,
                    ),
                  ),
                  SizedBox(width: 8),
                  Tooltip(
                    message: langProvider.translate('calculator_tooltip'),
                    child: InkWell(
                      onTap: () async {
                        final result = await _showPageCalculatorModal(
                          dialogCtx,
                          langProvider,
                          book.pagesRead,
                          book.totalPages,
                        );
                        if (result != null) {
                          pagesController.text = result.toString();
                          setDialogState(() => pagesError = null);
                        }
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        width: 50,
                        height: 58,
                        decoration: BoxDecoration(
                          color: AppTheme.lavender.withValues(alpha: 0.15),
                          border: Border.all(
                              color: AppTheme.lavender.withValues(alpha: 0.5)),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(Icons.calculate_rounded,
                            color: AppTheme.lavender, size: 26),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              TextField(
                controller: timeController,
                decoration: InputDecoration(
                  labelText: langProvider.translate('time_minutes_label'),
                  hintText: langProvider.translate('time_minutes_hint'),
                  errorText: timeError,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  suffixText: langProvider.translate('time_unit'),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 12),
              InkWell(
                onTap: () async {
                  final now = DateTime.now();
                  final earliest = now.subtract(const Duration(days: 6));
                  final picked = await showDatePicker(
                    context: dialogCtx,
                    initialDate: selectedDate,
                    firstDate:
                        DateTime(earliest.year, earliest.month, earliest.day),
                    lastDate: DateTime(now.year, now.month, now.day),
                    builder: (ctx, child) => Theme(
                      data: Theme.of(ctx).copyWith(
                        colorScheme: Theme.of(ctx).colorScheme.copyWith(
                              primary: AppTheme.lavender,
                              onPrimary: AppTheme.darkText,
                            ),
                      ),
                      child: child!,
                    ),
                  );
                  if (picked != null) {
                    setDialogState(() => selectedDate = picked);
                  }
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: AppTheme.lavender.withValues(alpha: 0.5)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.calendar_today,
                          size: 18, color: AppTheme.lavender),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '${langProvider.translate('session_date_label')}: ${selectedDate.year.toString().padLeft(4, '0')}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}',
                          style:
                              TextStyle(color: AppTheme.darkText, fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogCtx),
              child: Text(langProvider.translate('cancel')),
            ),
            ElevatedButton(
              onPressed: () async {
                final pages = int.tryParse(pagesController.text.trim());
                if (pages == null || pages <= 0) {
                  setDialogState(() => pagesError =
                      langProvider.translate('enter_valid_number'));
                  return;
                }
                if (pages > remainingPages) {
                  setDialogState(() => pagesError =
                      '${langProvider.translate('cannot_exceed')} $remainingPages ${langProvider.translate('remaining_pages_suffix')}');
                  return;
                }

                int? timeMins;
                final timeText = timeController.text.trim();
                if (timeText.isNotEmpty) {
                  timeMins = int.tryParse(timeText);
                  if (timeMins == null || timeMins <= 0) {
                    setDialogState(() => timeError =
                        langProvider.translate('enter_valid_minutes'));
                    return;
                  }
                }
                setDialogState(() => timeError = null);

                final db = DatabaseHelper();
                final int pagesToLog = pages;
                if (pagesToLog <= 0) return;
                final todayPagesBefore =
                    await db.getPagesReadForDate(selectedDate);

                if (!dialogCtx.mounted) return;
                Navigator.pop(dialogCtx);

                final rewards = await bookProvider.logPages(bookId, pagesToLog,
                    timeTakenMinutes: timeMins,
                    sessionDate: selectedDate,
                    resourceMultiplier:
                        villageProvider.readingResourceMultiplier);
                final coinsEarned = rewards['coins'] as int;
                final gemsEarned = rewards['gems'] as int;
                final woodEarned = rewards['wood'] as int;
                final metalEarned = rewards['metal'] as int;

                await villageProvider.addResources(
                  coins: coinsEarned,
                  gems: gemsEarned,
                  wood: woodEarned,
                  metal: metalEarned,
                );
                final totalPages = await db.getTotalPagesRead();
                final completedBooksCount = await db.getCompletedBooksCount();
                await villageProvider.checkMissions(
                    totalPagesRead: totalPages,
                    completedBooks: completedBooksCount);

                final todayPagesAfter =
                    await db.getPagesReadForDate(selectedDate);
                final showCelebration = todayPagesBefore <
                        ReadingRules.dailyPageCelebrationThreshold &&
                    todayPagesAfter >=
                        ReadingRules.dailyPageCelebrationThreshold;

                if (context.mounted) {
                  sl<AudioService>().playVillagerUnlockedSound();
                  _showRewardPopup(
                    context,
                    rewards['coins'] as int,
                    rewards['gems'] as int,
                    rewards['wood'] as int,
                    rewards['metal'] as int,
                    rewards['bookCompleted'] as bool,
                    rewards['rewardablePages'] as int,
                    rewards['shortBookNoGems'] as bool? ?? false,
                    bookId: bookId,
                    bookProvider: bookProvider,
                    showCelebration: showCelebration,
                    todayTotalPages: todayPagesAfter,
                    langProvider: langProvider,
                  );
                }
              },
              child: Text(langProvider.translate('log_button')),
            ),
          ],
        ),
      );
    },
  );
}

Future<int?> _showPageCalculatorModal(
  BuildContext context,
  LanguageProvider langProvider,
  int pagesAlreadyRead,
  int totalPages,
) {
  final currentPageController = TextEditingController();
  return showDialog<int>(
    context: context,
    builder: (ctx) {
      String? calcError;
      return StatefulBuilder(
        builder: (ctx, setCalcState) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: AppTheme.cream,
          title: Row(
            children: [
              Icon(Icons.calculate_rounded, color: AppTheme.lavender, size: 24),
              SizedBox(width: 8),
              Text(
                langProvider.translate('calculator_title'),
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.darkText),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                langProvider
                    .translate('calculator_subtitle')
                    .replaceAll('{read}', '$pagesAlreadyRead')
                    .replaceAll('{total}', '$totalPages'),
                style: TextStyle(
                    fontSize: 13,
                    color: AppTheme.darkText.withValues(alpha: 0.65)),
              ),
              SizedBox(height: 14),
              TextField(
                controller: currentPageController,
                autofocus: true,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: langProvider.translate('calculator_page_label'),
                  hintText: '${pagesAlreadyRead + 1}',
                  errorText: calcError,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                        color: AppTheme.lavender.withValues(alpha: 0.5)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppTheme.lavender),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(langProvider.translate('cancel'),
                  style: TextStyle(
                      color: AppTheme.darkText.withValues(alpha: 0.6))),
            ),
            ElevatedButton.icon(
              icon: Icon(Icons.check_rounded, size: 18),
              label: Text(langProvider.translate('calculator_calculate')),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.lavender,
                foregroundColor: AppTheme.darkText,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                final currentPage =
                    int.tryParse(currentPageController.text.trim());
                if (currentPage == null || currentPage <= 0) {
                  setCalcState(() => calcError =
                      langProvider.translate('calculator_error_invalid'));
                  return;
                }
                if (currentPage <= pagesAlreadyRead) {
                  setCalcState(() => calcError =
                      langProvider.translate('calculator_error_already_read'));
                  return;
                }
                if (currentPage > totalPages) {
                  setCalcState(() => calcError =
                      langProvider.translate('calculator_error_exceeds_total'));
                  return;
                }
                Navigator.pop(ctx, currentPage - pagesAlreadyRead);
              },
            ),
          ],
        ),
      );
    },
  );
}

void _showRewardPopup(
    BuildContext context,
    int coins,
    int gems,
    int wood,
    int metal,
    bool bookCompleted,
    int rewardablePages,
    bool shortBookNoGems, {
    int? bookId,
    BookProvider? bookProvider,
    bool showCelebration = false,
    int todayTotalPages = 0,
    LanguageProvider? langProvider,
  }) {
  final completer = Completer<void>();
  _activeCompletionFlow = completer;

  late OverlayEntry overlayEntry;
  overlayEntry = OverlayEntry(
    builder: (_) => RewardPopup(
      coinsEarned: coins,
      gemsEarned: gems,
      woodEarned: wood,
      metalEarned: metal,
      bookCompleted: bookCompleted,
      rewardablePages: rewardablePages,
      onDismiss: () {
        overlayEntry.remove();
        _processPostRewardDialogs(
          context,
          showCelebration: showCelebration,
          todayTotalPages: todayTotalPages,
          showShortBookReflection: shortBookNoGems,
          bookCompleted: bookCompleted,
          bookId: bookId,
          bookProvider: bookProvider,
          langProvider: langProvider,
        ).whenComplete(() {
          if (!completer.isCompleted) completer.complete();
          _activeCompletionFlow = null;
        });
      },
    ),
  );
  Overlay.of(context).insert(overlayEntry);
}

Future<void> _processPostRewardDialogs(
  BuildContext context, {
  required bool showCelebration,
  required int todayTotalPages,
  required bool showShortBookReflection,
  required bool bookCompleted,
  int? bookId,
  BookProvider? bookProvider,
  LanguageProvider? langProvider,
}) async {
  final lang = langProvider ?? context.read<LanguageProvider>();
  if (!context.mounted) return;
  if (showCelebration) {
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: AppTheme.cream,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.auto_awesome, color: AppTheme.pink, size: 22),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                lang.translate('reading_celebration_title'),
                style: TextStyle(
                  color: AppTheme.darkText,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(width: 8),
            Icon(Icons.auto_awesome, color: AppTheme.pink, size: 22),
          ],
        ),
        content: Text(
          lang
              .translate('reading_celebration_message')
              .replaceAll('{pages}', '$todayTotalPages'),
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppTheme.darkText.withAlpha(200),
            fontSize: 14,
            height: 1.5,
          ),
        ),
        actions: [
          Center(
            child: ElevatedButton(
              onPressed: () => Navigator.pop(ctx),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.pink,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
              ),
              child: Text(lang.translate('got_it')),
            ),
          ),
        ],
      ),
    );
  }
  if (!context.mounted) return;
  if (showShortBookReflection) {
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: AppTheme.cream,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.menu_book_rounded,
                color: AppTheme.lavender, size: 22),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                lang.translate('short_book_no_gems_title'),
                style: TextStyle(
                  color: AppTheme.darkText,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
        content: Text(
          lang.translate('short_book_no_gems_message'),
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppTheme.darkText.withAlpha(200),
            fontSize: 14,
            height: 1.5,
          ),
        ),
        actions: [
          Center(
            child: ElevatedButton(
              onPressed: () => Navigator.pop(ctx),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.lavender,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
              ),
              child: Text(lang.translate('got_it')),
            ),
          ),
        ],
      ),
    );
  }
  if (!context.mounted) return;
  if (bookCompleted && bookId != null && bookProvider != null) {
    await _showRatingDialog(context, bookId, bookProvider);
    if (!context.mounted) return;
    await showBookNotesDialog(context, bookId, bookProvider);
  }
}

Future<void> _showRatingDialog(
    BuildContext context, int bookId, BookProvider bookProvider) async {
  int selectedRating = 0;
  final langProvider = context.read<LanguageProvider>();

  await showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setState) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: AppTheme.cream,
        title: Column(
          children: [
            Text(
              langProvider.translate('rate_your_book'),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.darkText,
              ),
            ),
            SizedBox(height: 4),
            Text(
              langProvider.translate('rate_book_subtitle'),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.darkText.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (i) {
            final starValue = i + 1;
            return GestureDetector(
              onTap: () => setState(() => selectedRating = starValue),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 4),
                child: Icon(
                  selectedRating >= starValue ? Icons.star : Icons.star_border,
                  size: 40,
                  color: AppTheme.coinGold,
                ),
              ),
            );
          }),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              langProvider.translate('skip_rating'),
              style: TextStyle(color: AppTheme.darkText.withValues(alpha: 0.6)),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              if (selectedRating > 0) {
                await bookProvider.rateBook(bookId, selectedRating);
                sl<AnalyticsService>().logBookRated(selectedRating);
              }
              if (ctx.mounted) Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.coinGold,
              foregroundColor: AppTheme.darkText,
            ),
            child: Text(langProvider.translate('save_rating')),
          ),
        ],
      ),
    ),
  );
}

Future<void> showBookNotesDialog(
    BuildContext context, int bookId, BookProvider bookProvider,
    {String? initialNote}) async {
  final langProvider = context.read<LanguageProvider>();
  final notesController = TextEditingController(text: initialNote ?? '');

  await showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => OrientationBuilder(
      builder: (ctx, orientation) {
        final landscape = orientation == Orientation.landscape;
        return StatefulBuilder(
          builder: (ctx, setState) => AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            backgroundColor: AppTheme.cream,
            titlePadding: EdgeInsets.fromLTRB(20, landscape ? 12 : 20, 20, 0),
            contentPadding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
            title: Column(
              children: [
                if (!landscape) ...[
                  Icon(Icons.note_alt_outlined, size: 28, color: AppTheme.lavender),
                  SizedBox(height: 6),
                ],
                Text(
                  langProvider.translate('book_note_title'),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: landscape ? 16 : 20,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.darkText,
                  ),
                ),
                if (!landscape) ...[
                  SizedBox(height: 4),
                  Text(
                    langProvider.translate('book_note_subtitle'),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      color: AppTheme.darkText.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ],
            ),
            content: SingleChildScrollView(
              child: TextField(
                controller: notesController,
                maxLength: 500,
                maxLines: landscape ? 2 : 4,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  hintText: langProvider.translate('book_note_hint'),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppTheme.lavender.withValues(alpha: 0.4)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppTheme.lavender.withValues(alpha: 0.4)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppTheme.lavender),
                  ),
                  counterStyle: TextStyle(
                    fontSize: 11,
                    color: notesController.text.length >= 480
                        ? AppTheme.pink
                        : AppTheme.darkText.withValues(alpha: 0.45),
                  ),
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text(
                  langProvider.translate('skip_note'),
                  style: TextStyle(color: AppTheme.darkText.withValues(alpha: 0.6)),
                ),
              ),
              ElevatedButton(
                onPressed: notesController.text.trim().isEmpty
                    ? null
                    : () async {
                        Navigator.pop(ctx);
                        await bookProvider.saveBookNote(
                            bookId, notesController.text.trim());
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.lavender,
                  foregroundColor: AppTheme.darkText,
                  disabledBackgroundColor: AppTheme.lavender.withValues(alpha: 0.3),
                ),
                child: Text(langProvider.translate('save_note')),
              ),
            ],
          ),
        );
      },
    ),
  );
}
