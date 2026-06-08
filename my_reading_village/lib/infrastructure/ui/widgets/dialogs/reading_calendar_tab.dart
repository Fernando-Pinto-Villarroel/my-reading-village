import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_reading_village/adapters/providers/book_provider.dart';
import 'package:my_reading_village/domain/entities/book.dart';
import 'package:my_reading_village/domain/entities/book_filter.dart';
import 'package:my_reading_village/domain/entities/reading_session.dart';
import 'package:my_reading_village/infrastructure/ui/config/app_theme.dart';
import 'package:my_reading_village/infrastructure/ui/localization/context_ext.dart';

enum _CalendarViewMode { annual, monthly }

class _DayReading {
  final Book book;
  final int pages;
  const _DayReading({required this.book, required this.pages});
}

class ReadingCalendarTab extends StatefulWidget {
  final ScrollController scrollController;
  const ReadingCalendarTab({super.key, required this.scrollController});

  @override
  State<ReadingCalendarTab> createState() => _ReadingCalendarTabState();
}

class _ReadingCalendarTabState extends State<ReadingCalendarTab> {
  int _year = DateTime.now().year;
  int _month = DateTime.now().month;
  _CalendarViewMode _viewMode = _CalendarViewMode.monthly;

  static const _kFireActive = Color(0xFFFF6B35);
  static const _kFireBgActive = Color(0x1FFF6B35);
  static const _kFireBorderActive = Color(0x66FF6B35);

  static const _monthKeys = [
    'january',
    'february',
    'march',
    'april',
    'may',
    'june',
    'july',
    'august',
    'september',
    'october',
    'november',
    'december',
  ];

  static String _dateKey(DateTime dt) =>
      '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';

  ({int streak, bool hasReadToday}) _calculateStreak(
      List<ReadingSession> sessions) {
    final daysWithReading = <String>{};
    for (final s in sessions) {
      try {
        daysWithReading.add(_dateKey(DateTime.parse(s.date)));
      } catch (_) {}
    }
    final today = DateTime.now();
    final hasReadToday = daysWithReading.contains(_dateKey(today));
    int streak = 0;
    var check = hasReadToday ? today : today.subtract(const Duration(days: 1));
    while (daysWithReading.contains(_dateKey(check))) {
      streak++;
      check = check.subtract(const Duration(days: 1));
    }
    return (streak: streak, hasReadToday: hasReadToday);
  }

  Map<int, List<Book>> _buildMonthBookMap(
      List<ReadingSession> sessions, List<Book> books) {
    final bookById = {for (final b in books) b.id: b};
    final result = <int, Set<int>>{};
    for (final s in sessions) {
      try {
        final dt = DateTime.parse(s.date);
        if (dt.year != _year) continue;
        result.putIfAbsent(dt.month, () => <int>{}).add(s.bookId);
      } catch (_) {}
    }
    return {
      for (final e in result.entries)
        e.key: e.value.map((id) => bookById[id]).whereType<Book>().toList(),
    };
  }

  Map<int, List<_DayReading>> _buildDayReadingMap(
      List<ReadingSession> sessions, List<Book> books) {
    final bookById = {for (final b in books) b.id: b};
    final dayData = <int, Map<int, int>>{};
    for (final s in sessions) {
      try {
        final dt = DateTime.parse(s.date);
        if (dt.year != _year || dt.month != _month) continue;
        dayData.putIfAbsent(dt.day, () => <int, int>{});
        dayData[dt.day]![s.bookId] =
            (dayData[dt.day]![s.bookId] ?? 0) + s.pagesRead;
      } catch (_) {}
    }
    return {
      for (final e in dayData.entries)
        e.key: e.value.entries
            .map((r) {
              final b = bookById[r.key];
              return b == null ? null : _DayReading(book: b, pages: r.value);
            })
            .whereType<_DayReading>()
            .toList(),
    };
  }

  void _onBookTapped(BuildContext context, Book book) {
    context.read<BookProvider>().setFilter(BookFilter(searchQuery: book.title));
    DefaultTabController.of(context).animateTo(0);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BookProvider>(
      builder: (ctx, bp, _) {
        final sr = _calculateStreak(bp.sessions);
        return Column(
          children: [
            _buildHeader(context, sr),
            Expanded(
              child: _viewMode == _CalendarViewMode.annual
                  ? _buildAnnualView(ctx, bp)
                  : _buildMonthlyView(ctx, bp, sr),
            ),
          ],
        );
      },
    );
  }

  Widget _buildHeader(
      BuildContext context, ({int streak, bool hasReadToday}) sr) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildViewDropdown(context),
              if (_viewMode == _CalendarViewMode.monthly)
                _buildStreakBadge(sr.streak, sr.hasReadToday),
            ],
          ),
          const SizedBox(height: 2),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildNavigator(context),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildViewDropdown(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: AppTheme.lavender.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppTheme.lavender.withValues(alpha: 0.35)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<_CalendarViewMode>(
          value: _viewMode,
          isDense: true,
          icon: Icon(Icons.arrow_drop_down,
              color: AppTheme.darkLavender, size: 18),
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: AppTheme.darkText,
          ),
          items: [
            DropdownMenuItem(
              value: _CalendarViewMode.annual,
              child: Text(context.t('calendar_annual')),
            ),
            DropdownMenuItem(
              value: _CalendarViewMode.monthly,
              child: Text(context.t('calendar_monthly')),
            ),
          ],
          onChanged: (v) {
            if (v != null) setState(() => _viewMode = v);
          },
        ),
      ),
    );
  }

  Widget _buildNavigator(BuildContext context) {
    final label = _viewMode == _CalendarViewMode.annual
        ? '$_year'
        : '${context.t(_monthKeys[_month - 1])} $_year';
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left),
          color: AppTheme.darkText,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          onPressed: _viewMode == _CalendarViewMode.annual
              ? () => setState(() => _year--)
              : () => setState(() {
                    if (_month == 1) {
                      _month = 12;
                      _year--;
                    } else {
                      _month--;
                    }
                  }),
        ),
        Flexible(
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: AppTheme.darkText,
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.chevron_right),
          color: AppTheme.darkText,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          onPressed: _viewMode == _CalendarViewMode.annual
              ? () => setState(() => _year++)
              : () => setState(() {
                    if (_month == 12) {
                      _month = 1;
                      _year++;
                    } else {
                      _month++;
                    }
                  }),
        ),
      ],
    );
  }

  Widget _buildStreakBadge(int streak, bool hasReadToday) {
    final fireColor = hasReadToday ? _kFireActive : Colors.grey.shade400;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: hasReadToday ? _kFireBgActive : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: hasReadToday ? _kFireBorderActive : Colors.grey.shade300,
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.local_fire_department, color: fireColor, size: 20),
          const SizedBox(width: 3),
          Text(
            '$streak',
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: fireColor),
          ),
        ],
      ),
    );
  }

  Widget _buildAnnualView(BuildContext context, BookProvider bp) {
    final monthBookMap = _buildMonthBookMap(bp.sessions, bp.books);
    if (monthBookMap.isEmpty && bp.sessions.isEmpty) return _buildEmptyState();
    return ListView(
      controller: widget.scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      children: [
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.70,
          ),
          itemCount: 12,
          itemBuilder: (ctx, i) => _MonthCell(
            month: i + 1,
            monthName: context.t(_monthKeys[i]),
            books: monthBookMap[i + 1] ?? [],
            onBookTap: (book) => _onBookTapped(context, book),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildMonthlyView(BuildContext context, BookProvider bp,
      ({int streak, bool hasReadToday}) sr) {
    final dayMap = _buildDayReadingMap(bp.sessions, bp.books);
    final daysInMonth = DateUtils.getDaysInMonth(_year, _month);
    final firstWeekday = DateTime(_year, _month, 1).weekday;
    if (dayMap.isEmpty && bp.sessions.isEmpty) return _buildEmptyState();
    return ListView(
      controller: widget.scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      children: [
        _buildWeekdayRow(),
        const SizedBox(height: 4),
        _buildCalendarGrid(daysInMonth, firstWeekday, dayMap),
        if (dayMap.isNotEmpty) ...[
          const SizedBox(height: 12),
          Divider(color: AppTheme.lavender.withValues(alpha: 0.3), height: 1),
          const SizedBox(height: 8),
          ...(dayMap.keys.toList()..sort()).map((day) => _DayReadingCard(
                day: day,
                month: _month,
                year: _year,
                readings: dayMap[day]!,
                onBookTap: (book) => _onBookTapped(context, book),
              )),
        ],
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildWeekdayRow() {
    const labels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    return Row(
      children: labels
          .map((d) => Expanded(
                child: Center(
                  child: Text(d,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.darkText.withValues(alpha: 0.35),
                      )),
                ),
              ))
          .toList(),
    );
  }

  Widget _buildCalendarGrid(
      int daysInMonth, int firstWeekday, Map<int, List<_DayReading>> dayMap) {
    final today = DateTime.now();
    final cells = <Widget>[];
    for (int i = 1; i < firstWeekday; i++) {
      cells.add(const SizedBox.shrink());
    }
    for (int d = 1; d <= daysInMonth; d++) {
      final hasReading = dayMap[d]?.isNotEmpty == true;
      final isToday =
          today.year == _year && today.month == _month && today.day == d;
      cells.add(
          _CalendarDayCell(day: d, hasReading: hasReading, isToday: isToday));
    }
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 7,
      childAspectRatio: 1.0,
      mainAxisSpacing: 2,
      crossAxisSpacing: 2,
      children: cells,
    );
  }

  Widget _buildEmptyState() {
    return SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.calendar_month, size: 60, color: AppTheme.lavender),
              const SizedBox(height: 16),
              Text(
                context.t('no_reading_sessions'),
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 15,
                    color: AppTheme.darkText.withValues(alpha: 0.6)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CalendarDayCell extends StatelessWidget {
  final int day;
  final bool hasReading;
  final bool isToday;
  const _CalendarDayCell(
      {required this.day, required this.hasReading, required this.isToday});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: hasReading
            ? AppTheme.lavender.withValues(alpha: 0.2)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(6),
        border: isToday
            ? Border.all(color: AppTheme.darkLavender, width: 2)
            : hasReading
                ? Border.all(color: AppTheme.lavender.withValues(alpha: 0.5))
                : null,
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$day',
              style: TextStyle(
                fontSize: 12,
                fontWeight: hasReading ? FontWeight.bold : FontWeight.normal,
                color: hasReading
                    ? AppTheme.darkLavender
                    : AppTheme.darkText.withValues(alpha: 0.35),
              ),
            ),
            if (hasReading)
              Container(
                width: 4,
                height: 4,
                margin: const EdgeInsets.only(top: 1),
                decoration: BoxDecoration(
                    color: AppTheme.lavender, shape: BoxShape.circle),
              ),
          ],
        ),
      ),
    );
  }
}

class _DayReadingCard extends StatelessWidget {
  final int day, month, year;
  final List<_DayReading> readings;
  final void Function(Book) onBookTap;
  static const _dayAbbr = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  const _DayReadingCard({
    required this.day,
    required this.month,
    required this.year,
    required this.readings,
    required this.onBookTap,
  });

  @override
  Widget build(BuildContext context) {
    final dt = DateTime(year, month, day);
    final abbr = _dayAbbr[dt.weekday - 1];
    final total = readings.fold(0, (s, r) => s + r.pages);
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppTheme.lavender.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.lavender.withValues(alpha: 0.25)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            padding: const EdgeInsets.symmetric(vertical: 3),
            decoration: BoxDecoration(
              color: AppTheme.lavender.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('$day',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.darkLavender,
                    )),
                Text(abbr,
                    style: TextStyle(
                      fontSize: 10,
                      color: AppTheme.darkText.withValues(alpha: 0.5),
                    )),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: readings
                  .map((r) => _BookRow(
                        reading: r,
                        onTap: () => onBookTap(r.book),
                      ))
                  .toList(),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppTheme.mint.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '$total p',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppTheme.darkMint,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BookRow extends StatelessWidget {
  final _DayReading reading;
  final VoidCallback onTap;
  static const _placeholderColors = [
    AppTheme.pink,
    AppTheme.lavender,
    AppTheme.mint,
    AppTheme.peach,
    AppTheme.skyBlue,
  ];

  const _BookRow({required this.reading, required this.onTap});

  Widget _placeholder(String title) {
    final ci =
        title.isNotEmpty ? title.codeUnitAt(0) % _placeholderColors.length : 0;
    return Container(
      width: 36,
      height: 50,
      decoration: BoxDecoration(
        color: _placeholderColors[ci].withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Center(
          child: Text(
        _BookCoverThumbnail._abbrev(title),
        textAlign: TextAlign.center,
        style: const TextStyle(
            fontSize: 9, fontWeight: FontWeight.bold, color: AppTheme.darkText),
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasCover = reading.book.coverImagePath?.isNotEmpty == true;
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 5),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: hasCover
                  ? Image.file(
                      File(reading.book.coverImagePath!),
                      width: 26,
                      height: 36,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          _placeholder(reading.book.title),
                    )
                  : _placeholder(reading.book.title),
            ),
            const SizedBox(width: 8),
            Text(
              '${reading.pages}',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppTheme.darkText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MonthCell extends StatelessWidget {
  final int month;
  final String monthName;
  final List<Book> books;
  final void Function(Book) onBookTap;
  const _MonthCell({
    required this.month,
    required this.monthName,
    required this.books,
    required this.onBookTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasBooks = books.isNotEmpty;
    return Container(
      decoration: BoxDecoration(
        color: hasBooks
            ? AppTheme.lavender.withValues(alpha: 0.12)
            : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: hasBooks
              ? AppTheme.lavender.withValues(alpha: 0.4)
              : Colors.grey.shade200,
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 6),
            decoration: BoxDecoration(
              color: hasBooks
                  ? AppTheme.lavender.withValues(alpha: 0.25)
                  : Colors.grey.shade200,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Text(
              monthName,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: hasBooks ? AppTheme.lavender : Colors.grey.shade400,
              ),
            ),
          ),
          Expanded(
            child: hasBooks
                ? Padding(
                    padding: const EdgeInsets.all(5),
                    child: SingleChildScrollView(
                      child: Wrap(
                        spacing: 4,
                        runSpacing: 4,
                        children: books
                            .map((b) => _BookCoverThumbnail(
                                  book: b,
                                  onTap: () => onBookTap(b),
                                ))
                            .toList(),
                      ),
                    ),
                  )
                : Center(
                    child: Icon(Icons.auto_stories,
                        size: 24, color: Colors.grey.shade300)),
          ),
        ],
      ),
    );
  }
}

class _BookCoverThumbnail extends StatelessWidget {
  static const double _w = 36.0;
  static const double _h = 50.0;
  final Book book;
  final VoidCallback onTap;
  const _BookCoverThumbnail({required this.book, required this.onTap});

  static String _abbrev(String title) {
    final t = title.trim();
    if (t.isEmpty) return '?';
    return t.length > 4 ? '${t.substring(0, 4)}...' : t;
  }

  static const _colors = [
    AppTheme.pink,
    AppTheme.lavender,
    AppTheme.mint,
    AppTheme.peach,
    AppTheme.skyBlue,
  ];

  Widget _placeholder() {
    final ci =
        book.title.isNotEmpty ? book.title.codeUnitAt(0) % _colors.length : 0;
    return Container(
      width: _w,
      height: _h,
      decoration: BoxDecoration(
        color: _colors[ci].withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Center(
          child: Text(
        _abbrev(book.title),
        textAlign: TextAlign.center,
        style: const TextStyle(
            fontSize: 9, fontWeight: FontWeight.bold, color: AppTheme.darkText),
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasCover = book.coverImagePath?.isNotEmpty == true;
    return GestureDetector(
      onTap: onTap,
      child: hasCover
          ? ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Image.file(
                File(book.coverImagePath!),
                fit: BoxFit.cover,
                width: _w,
                height: _h,
                errorBuilder: (_, __, ___) => _placeholder(),
              ),
            )
          : _placeholder(),
    );
  }
}
