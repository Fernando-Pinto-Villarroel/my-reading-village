import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:my_reading_village/adapters/providers/book_provider.dart';
import 'package:my_reading_village/adapters/providers/village_provider.dart';
import 'package:my_reading_village/infrastructure/persistence/database_helper.dart';
import 'package:my_reading_village/infrastructure/ui/config/app_theme.dart';
import 'package:my_reading_village/infrastructure/ui/localization/context_ext.dart';
import 'package:my_reading_village/infrastructure/ui/localization/language_provider.dart';
import 'package:my_reading_village/infrastructure/ui/widgets/common/resource_icon.dart';
import 'package:my_reading_village/infrastructure/ui/widgets/common/shared_utils.dart';

void showStatsDialog(
    BuildContext context, VillageProvider village, BookProvider bookProvider) {
  showDialog(
    context: context,
    builder: (ctx) =>
        _StatsDialog(village: village, bookProvider: bookProvider),
  );
}

class _StatsDialog extends StatefulWidget {
  final VillageProvider village;
  final BookProvider bookProvider;

  const _StatsDialog({required this.village, required this.bookProvider});

  @override
  State<_StatsDialog> createState() => _StatsDialogState();
}

class _StatsDialogState extends State<_StatsDialog>
    with SingleTickerProviderStateMixin {
  late TabController _tabs;
  int _currentTab = 0;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 2, vsync: this);
    _tabs.addListener(() {
      if (!_tabs.indexIsChanging) return;
      setState(() => _currentTab = _tabs.index);
    });
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final landscape = isLandscape(context);
    final screenH = MediaQuery.of(context).size.height;
    final maxTabH = (screenH - (landscape ? 120.0 : 140.0)).clamp(200.0, 800.0);
    return Dialog(
      insetPadding: EdgeInsets.symmetric(
        horizontal: landscape ? 40 : 24,
        vertical: landscape ? 8 : 16,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 620),
        decoration: BoxDecoration(
          color: AppTheme.cream,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 8, 0),
              child: Row(
                children: [
                  Icon(Icons.bar_chart, size: 24, color: AppTheme.lavender),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      context.t('village_stats'),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.darkText,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            TabBar(
              controller: _tabs,
              labelColor: AppTheme.darkLavender,
              unselectedLabelColor: AppTheme.darkText.withValues(alpha: 0.45),
              indicatorColor: AppTheme.lavender,
              indicatorWeight: 3,
              tabs: [
                Tab(text: context.t('stats_tab')),
                Tab(text: context.t('charts_tab')),
              ],
            ),
            Flexible(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: maxTabH),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 160),
                  transitionBuilder: (child, anim) =>
                      FadeTransition(opacity: anim, child: child),
                  child: KeyedSubtree(
                    key: ValueKey(_currentTab),
                    child: _currentTab == 0
                        ? _StatsContent(
                            village: widget.village,
                            bookProvider: widget.bookProvider,
                          )
                        : const _ChartsContent(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Stats tab (unchanged content)
// ---------------------------------------------------------------------------

class _StatsContent extends StatelessWidget {
  final VillageProvider village;
  final BookProvider bookProvider;

  const _StatsContent({required this.village, required this.bookProvider});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          StatRow(
              icon: ResourceIcon.coin(size: 28),
              label: context.t('coins'),
              value: '${village.coins}'),
          StatRow(
              icon: ResourceIcon.gem(size: 28),
              label: context.t('gems'),
              value: '${village.gems}'),
          StatRow(
              icon: ResourceIcon.wood(size: 28),
              label: context.t('wood'),
              value: '${village.wood}'),
          StatRow(
              icon: ResourceIcon.metal(size: 28),
              label: context.t('metal'),
              value: '${village.metal}'),
          const Divider(),
          FutureBuilder<Map<String, int>>(
            future: _loadStats(),
            builder: (ctx, snapshot) {
              final stats = snapshot.data ??
                  {
                    'totalPages': 0,
                    'completedBooks': 0,
                    'totalSessions': 0,
                    'totalTimeMinutes': 0,
                  };
              return Column(
                children: [
                  StatRow(
                      icon: Icon(Icons.auto_stories,
                          size: 28, color: AppTheme.lavender),
                      label: ctx.t('pages_read'),
                      value: '${stats['totalPages']}'),
                  StatRow(
                      icon:
                          Icon(Icons.menu_book, size: 28, color: AppTheme.pink),
                      label: ctx.t('books_stat'),
                      value: '${bookProvider.books.length}'),
                  StatRow(
                      icon:
                          Icon(Icons.star, size: 28, color: AppTheme.coinGold),
                      label: ctx.t('completed'),
                      value: '${stats['completedBooks']}'),
                  StatRow(
                      icon: Icon(Icons.history,
                          size: 28, color: AppTheme.skyBlue),
                      label: ctx.t('sessions'),
                      value: '${stats['totalSessions']}'),
                  if ((stats['totalTimeMinutes'] ?? 0) > 0)
                    StatRow(
                        icon: Icon(Icons.timer, size: 28, color: AppTheme.mint),
                        label: ctx.t('reading_time'),
                        value: _formatTotalTime(stats['totalTimeMinutes']!)),
                ],
              );
            },
          ),
          const Divider(),
          StatRow(
              icon: Icon(Icons.house, size: 28, color: AppTheme.mint),
              label: context.t('buildings'),
              value:
                  '${village.placedBuildings.where((b) => b.isConstructed).length}'),
          StatRow(
              icon: Icon(Icons.favorite, size: 28, color: AppTheme.pink),
              label: context.t('happiness'),
              value: '${village.villageHappiness}%'),
          StatRow(
              icon: Icon(Icons.pets, size: 28, color: AppTheme.peach),
              label: context.t('villagers'),
              value: '${village.villagers.length}'),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Charts tab
// ---------------------------------------------------------------------------

class _ChartsContent extends StatefulWidget {
  const _ChartsContent();

  @override
  State<_ChartsContent> createState() => _ChartsContentState();
}

class _ChartsContentState extends State<_ChartsContent> {
  int _mode = 0;
  DateTime _anchor = DateTime.now();

  static const _barColors = [
    AppTheme.lavender,
    AppTheme.pink,
    AppTheme.mint,
    AppTheme.skyBlue,
    AppTheme.peach,
    AppTheme.gemPurple,
    AppTheme.coinGold,
  ];

  DateTime _mondayOf(DateTime d) => d.subtract(Duration(days: d.weekday - 1));

  void _prev() => setState(() {
        if (_mode == 0) {
          _anchor = _anchor.subtract(const Duration(days: 7));
        } else if (_mode == 1) {
          _anchor = DateTime(_anchor.year, _anchor.month - 1);
        } else {
          _anchor = DateTime(_anchor.year - 1);
        }
      });

  void _next() => setState(() {
        if (_mode == 0) {
          _anchor = _anchor.add(const Duration(days: 7));
        } else if (_mode == 1) {
          _anchor = DateTime(_anchor.year, _anchor.month + 1);
        } else {
          _anchor = DateTime(_anchor.year + 1);
        }
      });

  bool get _canGoNext {
    final now = DateTime.now();
    if (_mode == 0) {
      return _mondayOf(_anchor).isBefore(_mondayOf(now));
    }
    if (_mode == 1) {
      return _anchor.year < now.year ||
          (_anchor.year == now.year && _anchor.month < now.month);
    }
    return _anchor.year < now.year;
  }

  String _periodLabel(String locale) {
    if (_mode == 0) {
      final monday = _mondayOf(_anchor);
      final sunday = monday.add(const Duration(days: 6));
      final fmt = DateFormat('d MMM', locale);
      return '${fmt.format(monday)} – ${fmt.format(sunday)}';
    }
    if (_mode == 1) {
      return DateFormat('MMMM yyyy', locale).format(_anchor);
    }
    return '${_anchor.year}';
  }

  Future<Map<int, int>> _loadData() {
    final db = DatabaseHelper();
    if (_mode == 0) return db.getPagesByDayOfWeek(_mondayOf(_anchor));
    if (_mode == 1) {
      return db.getPagesByWeekOfMonth(_anchor.year, _anchor.month);
    }
    return db.getPagesByMonthOfYear(_anchor.year);
  }

  @override
  Widget build(BuildContext context) {
    final landscape = isLandscape(context);
    final chartH = landscape ? 150.0 : 260.0;
    final locale = context.read<LanguageProvider>().currentLocale;
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          _ModePills(
            mode: _mode,
            onChanged: (m) => setState(() {
              _mode = m;
              _anchor = DateTime.now();
            }),
          ),
          const SizedBox(height: 2),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: _prev,
                icon: Icon(Icons.chevron_left, color: AppTheme.darkLavender),
              ),
              Text(
                _periodLabel(locale),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.darkText,
                  fontSize: 13,
                ),
              ),
              IconButton(
                onPressed: _canGoNext ? _next : null,
                icon: Icon(
                  Icons.chevron_right,
                  color:
                      _canGoNext ? AppTheme.darkLavender : Colors.transparent,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.auto_stories, size: 12, color: AppTheme.lavender),
                const SizedBox(width: 4),
                Text(
                  context.t('pages_read'),
                  style: TextStyle(
                    fontSize: 11,
                    fontStyle: FontStyle.italic,
                    color: AppTheme.darkText.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: chartH,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: FutureBuilder<Map<int, int>>(
                future: _loadData(),
                builder: (ctx, snap) {
                  if (!snap.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return _buildChart(ctx, snap.data!, locale);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChart(BuildContext context, Map<int, int> data, String locale) {
    final pagesLabel =
        context.read<LanguageProvider>().translate('chart_pages').toLowerCase();
    final labels = _buildLabels(context, locale);
    final count = labels.length;

    final maxVal = data.values.isEmpty ? 0 : data.values.reduce(max);

    if (maxVal == 0) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            context.t('chart_no_data'),
            style: TextStyle(
              color: AppTheme.darkText.withValues(alpha: 0.5),
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    final groups = List.generate(
      count,
      (i) => BarChartGroupData(
        x: i,
        barRods: [
          BarChartRodData(
            toY: (data[i] ?? 0).toDouble(),
            color: _barColors[i % _barColors.length],
            width: _barWidth(count),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
          ),
        ],
      ),
    );

    return BarChart(
      BarChartData(
        barGroups: groups,
        maxY: maxVal * 1.3,
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (_) => FlLine(
            color: AppTheme.darkText.withValues(alpha: 0.08),
            strokeWidth: 1,
          ),
        ),
        borderData: FlBorderData(show: false),
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            getTooltipColor: (BarChartGroupData group) =>
                AppTheme.darkLavender.withValues(alpha: 0.9),
            getTooltipItem: (
              BarChartGroupData group,
              int groupIndex,
              BarChartRodData rod,
              int rodIndex,
            ) =>
                BarTooltipItem(
              '${rod.toY.toInt()} $pagesLabel',
              const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        titlesData: FlTitlesData(
          topTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 32,
              getTitlesWidget: (v, meta) {
                if (v == 0 || v == meta.max) {
                  return const SizedBox.shrink();
                }
                return Text(
                  '${v.toInt()}',
                  style: TextStyle(
                    fontSize: 10,
                    color: AppTheme.darkText.withValues(alpha: 0.55),
                  ),
                );
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (v, _) {
                final i = v.toInt();
                if (i < 0 || i >= labels.length) {
                  return const SizedBox.shrink();
                }
                return Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    labels[i],
                    style: TextStyle(
                      fontSize: _mode == 2 ? 8 : 9,
                      color: AppTheme.darkText,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  List<String> _buildLabels(BuildContext context, String locale) {
    if (_mode == 0) {
      final monday = _mondayOf(_anchor);
      return List.generate(
        7,
        (i) => DateFormat.E(locale).format(monday.add(Duration(days: i))),
      );
    }
    if (_mode == 1) {
      final daysInMonth = DateUtils.getDaysInMonth(_anchor.year, _anchor.month);
      final weeksCount = ((daysInMonth - 1) ~/ 7) + 1;
      return List.generate(
        weeksCount,
        (i) => context.t('chart_week_n').replaceAll('{n}', '${i + 1}'),
      );
    }
    return List.generate(
      12,
      (i) {
        final abbr =
            DateFormat.MMM(locale).format(DateTime(_anchor.year, i + 1));
        return abbr.length > 3 ? abbr.substring(0, 3) : abbr;
      },
    );
  }

  double _barWidth(int count) {
    if (count <= 7) return 18;
    if (count <= 12) return 14;
    return 10;
  }
}

// ---------------------------------------------------------------------------
// Shared widgets
// ---------------------------------------------------------------------------

class _ModePills extends StatelessWidget {
  final int mode;
  final ValueChanged<int> onChanged;

  const _ModePills({required this.mode, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _Pill(
          label: context.t('chart_daily'),
          selected: mode == 0,
          onTap: () => onChanged(0),
        ),
        const SizedBox(width: 8),
        _Pill(
          label: context.t('chart_weekly'),
          selected: mode == 1,
          onTap: () => onChanged(1),
        ),
        const SizedBox(width: 8),
        _Pill(
          label: context.t('chart_monthly'),
          selected: mode == 2,
          onTap: () => onChanged(2),
        ),
      ],
    );
  }
}

class _Pill extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _Pill(
      {required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: selected
              ? AppTheme.lavender
              : AppTheme.lavender.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? AppTheme.darkLavender : AppTheme.lavender,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
            color: selected
                ? AppTheme.darkLavender
                : AppTheme.darkText.withValues(alpha: 0.65),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Stat row (kept for use by _StatsContent)
// ---------------------------------------------------------------------------

class StatRow extends StatelessWidget {
  final Widget icon;
  final String label;
  final String value;

  const StatRow(
      {super.key,
      required this.icon,
      required this.label,
      required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          icon,
          const SizedBox(width: 12),
          Text(label, style: TextStyle(fontSize: 15, color: AppTheme.darkText)),
          const Spacer(),
          Text(value,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.darkText)),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

String _formatTotalTime(int minutes) {
  if (minutes < 60) return '${minutes}m';
  final h = minutes ~/ 60;
  final m = minutes % 60;
  return m > 0 ? '${h}h ${m}m' : '${h}h';
}

Future<Map<String, int>> _loadStats() async {
  final db = DatabaseHelper();
  return {
    'totalPages': await db.getTotalPagesRead(),
    'completedBooks': await db.getCompletedBooksCount(),
    'totalSessions': await db.getTotalSessionsCount(),
    'totalTimeMinutes': await db.getTotalTimeMinutes(),
  };
}
