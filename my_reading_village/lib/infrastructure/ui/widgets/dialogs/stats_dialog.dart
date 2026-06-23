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

typedef _ChartBundle = ({
  Map<int, int> barData,
  int periodReadMinutes,
  List<Map<String, dynamic>> bookPages,
});

class _ChartsContent extends StatefulWidget {
  const _ChartsContent();

  @override
  State<_ChartsContent> createState() => _ChartsContentState();
}

class _ChartsContentState extends State<_ChartsContent> {
  int _mode = 0;
  int _metric = 0;
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

  static const Color _lineColor = AppTheme.skyBlue;
  static const Color _piePrimary = AppTheme.lavender;
  static const Color _pieSecondary = AppTheme.mint;

  static const List<Color> _donutColors = [
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
    if (_mode == 0) return _mondayOf(_anchor).isBefore(_mondayOf(now));
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
    if (_mode == 1) return DateFormat('MMMM yyyy', locale).format(_anchor);
    return '${_anchor.year}';
  }

  ({String start, String end}) _periodDates() {
    String pad(int v, [int w = 2]) => v.toString().padLeft(w, '0');
    if (_mode == 0) {
      final monday = _mondayOf(_anchor);
      final end = monday.add(const Duration(days: 7));
      return (
        start: '${pad(monday.year, 4)}-${pad(monday.month)}-${pad(monday.day)}',
        end: '${pad(end.year, 4)}-${pad(end.month)}-${pad(end.day)}',
      );
    }
    if (_mode == 1) {
      final nextMonth = DateTime(_anchor.year, _anchor.month + 1);
      return (
        start: '${pad(_anchor.year, 4)}-${pad(_anchor.month)}-01',
        end: '${pad(nextMonth.year, 4)}-${pad(nextMonth.month)}-01',
      );
    }
    return (
      start: '${_anchor.year}-01-01',
      end: '${_anchor.year + 1}-01-01',
    );
  }

  int _totalPeriodMinutes() {
    if (_mode == 0) return 7 * 24 * 60;
    if (_mode == 1) {
      final days = DateUtils.getDaysInMonth(_anchor.year, _anchor.month);
      return days * 24 * 60;
    }
    final isLeap = (_anchor.year % 4 == 0 &&
            _anchor.year % 100 != 0) ||
        _anchor.year % 400 == 0;
    return (isLeap ? 366 : 365) * 24 * 60;
  }

  Future<_ChartBundle> _loadAll() async {
    final db = DatabaseHelper();
    final dates = _periodDates();
    final Map<int, int> barData;
    if (_metric == 0) {
      if (_mode == 0) {
        barData = await db.getPagesByDayOfWeek(_mondayOf(_anchor));
      } else if (_mode == 1) {
        barData = await db.getPagesByWeekOfMonth(_anchor.year, _anchor.month);
      } else {
        barData = await db.getPagesByMonthOfYear(_anchor.year);
      }
    } else {
      if (_mode == 0) {
        barData = await db.getCompletedBooksByDayOfWeek(_mondayOf(_anchor));
      } else if (_mode == 1) {
        barData = await db.getCompletedBooksByWeekOfMonth(_anchor.year, _anchor.month);
      } else {
        barData = await db.getCompletedBooksByMonthOfYear(_anchor.year);
      }
    }
    final readMinutes = await db.getReadingMinutesInPeriod(dates.start, dates.end);
    final bookPages = _metric == 0
        ? await db.getPagesByBookInPeriod(dates.start, dates.end)
        : <Map<String, dynamic>>[];
    return (barData: barData, periodReadMinutes: readMinutes, bookPages: bookPages);
  }

  List<String> _buildLabels(BuildContext context, String locale) {
    if (_mode == 0) {
      final monday = _mondayOf(_anchor);
      return List.generate(7, (i) => DateFormat.E(locale).format(monday.add(Duration(days: i))));
    }
    if (_mode == 1) {
      final daysInMonth = DateUtils.getDaysInMonth(_anchor.year, _anchor.month);
      final weeksCount = ((daysInMonth - 1) ~/ 7) + 1;
      return List.generate(weeksCount, (i) => context.t('chart_week_n').replaceAll('{n}', '${i + 1}'));
    }
    return List.generate(12, (i) {
      final abbr = DateFormat.MMM(locale).format(DateTime(_anchor.year, i + 1));
      return abbr.length > 3 ? abbr.substring(0, 3) : abbr;
    });
  }

  double _barWidth(int count) {
    if (count <= 7) return 18;
    if (count <= 12) return 14;
    return 10;
  }

  @override
  Widget build(BuildContext context) {
    final landscape = isLandscape(context);
    final locale = context.read<LanguageProvider>().currentLocale;
    final barChartH = landscape ? 150.0 : 220.0;
    final lineChartH = landscape ? 130.0 : 180.0;
    final pieSize = landscape ? 100.0 : 130.0;
    final donutSize = landscape ? 110.0 : 140.0;

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          _ModePills(
            mode: _mode,
            onChanged: (m) => setState(() {
              _mode = m;
              _anchor = DateTime.now();
            }),
          ),
          const SizedBox(height: 8),
          _MetricPills(
            metric: _metric,
            onChanged: (m) => setState(() => _metric = m),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: _prev,
                icon: Icon(Icons.chevron_left, color: AppTheme.darkLavender),
              ),
              Text(
                _periodLabel(locale),
                style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.darkText, fontSize: 13),
              ),
              IconButton(
                onPressed: _canGoNext ? _next : null,
                icon: Icon(Icons.chevron_right,
                    color: _canGoNext ? AppTheme.darkLavender : Colors.transparent),
              ),
            ],
          ),
          FutureBuilder<_ChartBundle>(
            future: _loadAll(),
            builder: (ctx, snap) {
              if (!snap.hasData) {
                return SizedBox(
                  height: barChartH,
                  child: const Center(child: CircularProgressIndicator()),
                );
              }
              final bundle = snap.data!;
              final labels = _buildLabels(ctx, locale);
              final maxVal = bundle.barData.values.isEmpty ? 0 : bundle.barData.values.reduce(max);
              final metricUnit = _metric == 0
                  ? ctx.read<LanguageProvider>().translate('chart_pages').toLowerCase()
                  : ctx.read<LanguageProvider>().translate('chart_books').toLowerCase();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ChartTitle(text: ctx.t(_metric == 0 ? 'chart_title_bar_pages' : 'chart_title_bar_books')),
                  SizedBox(
                    height: barChartH,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                      child: maxVal == 0
                          ? _noDataWidget(ctx)
                          : _buildBarChart(ctx, bundle.barData, labels, metricUnit),
                    ),
                  ),
                  const SizedBox(height: 8),
                  _ChartTitle(text: ctx.t('chart_title_line')),
                  SizedBox(
                    height: lineChartH,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                      child: maxVal == 0
                          ? _noDataWidget(ctx)
                          : _buildLineChart(ctx, bundle.barData, labels, metricUnit),
                    ),
                  ),
                  if (bundle.periodReadMinutes > 0) ...[
                    const SizedBox(height: 8),
                    _ChartTitle(text: ctx.t('chart_title_pie')),
                    _buildPieChart(ctx, bundle.periodReadMinutes, locale, pieSize),
                  ],
                  if (_metric == 0 && bundle.bookPages.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    _ChartTitle(text: ctx.t('chart_title_donut')),
                    _buildDonutChart(ctx, bundle.bookPages, locale, donutSize),
                  ],
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _noDataWidget(BuildContext context) => Center(
        child: Text(
          context.t('chart_no_data'),
          style: TextStyle(color: AppTheme.darkText.withValues(alpha: 0.5), fontSize: 13),
          textAlign: TextAlign.center,
        ),
      );

  Widget _buildBarChart(BuildContext ctx, Map<int, int> data, List<String> labels, String unit) {
    final count = labels.length;
    final maxVal = data.values.reduce(max);
    final groups = List.generate(count, (i) => BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: (data[i] ?? 0).toDouble(),
              color: _barColors[i % _barColors.length],
              width: _barWidth(count),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
            ),
          ],
        ));

    return BarChart(BarChartData(
      barGroups: groups,
      maxY: maxVal * 1.3,
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        getDrawingHorizontalLine: (_) =>
            FlLine(color: AppTheme.darkText.withValues(alpha: 0.08), strokeWidth: 1),
      ),
      borderData: FlBorderData(show: false),
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
          getTooltipColor: (_) => AppTheme.darkLavender.withValues(alpha: 0.9),
          getTooltipItem: (_, __, rod, ___) => BarTooltipItem(
            '${rod.toY.toInt()} $unit',
            const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      titlesData: FlTitlesData(
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 32,
            getTitlesWidget: (v, meta) {
              if (v == 0 || v == meta.max) return const SizedBox.shrink();
              return Text('${v.toInt()}',
                  style: TextStyle(fontSize: 10, color: AppTheme.darkText.withValues(alpha: 0.55)));
            },
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (v, _) {
              final i = v.toInt();
              if (i < 0 || i >= labels.length) return const SizedBox.shrink();
              return Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(labels[i],
                    style: TextStyle(fontSize: _mode == 2 ? 8 : 9, color: AppTheme.darkText)),
              );
            },
          ),
        ),
      ),
    ));
  }

  Widget _buildLineChart(BuildContext ctx, Map<int, int> data, List<String> labels, String unit) {
    final count = labels.length;
    final spots = List.generate(count, (i) => FlSpot(i.toDouble(), (data[i] ?? 0).toDouble()));
    final maxVal = spots.map((s) => s.y).reduce(max);

    return LineChart(LineChartData(
      minY: 0,
      maxY: maxVal == 0 ? 1 : maxVal * 1.3,
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        getDrawingHorizontalLine: (_) =>
            FlLine(color: AppTheme.darkText.withValues(alpha: 0.08), strokeWidth: 1),
      ),
      borderData: FlBorderData(show: false),
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          getTooltipColor: (_) => AppTheme.darkLavender.withValues(alpha: 0.9),
          getTooltipItems: (spots) => spots
              .map((s) => LineTooltipItem(
                    '${s.y.toInt()} $unit',
                    const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                  ))
              .toList(),
        ),
      ),
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          color: _lineColor,
          barWidth: 2.5,
          dotData: FlDotData(
            show: true,
            getDotPainter: (spot, _, __, ___) => FlDotCirclePainter(
              radius: 3,
              color: _lineColor,
              strokeWidth: 1.5,
              strokeColor: Colors.white,
            ),
          ),
          belowBarData: BarAreaData(
            show: true,
            color: _lineColor.withValues(alpha: 0.1),
          ),
        ),
      ],
      titlesData: FlTitlesData(
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 32,
            getTitlesWidget: (v, meta) {
              if (v == 0 || v == meta.max) return const SizedBox.shrink();
              return Text('${v.toInt()}',
                  style: TextStyle(fontSize: 10, color: AppTheme.darkText.withValues(alpha: 0.55)));
            },
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (v, _) {
              final i = v.toInt();
              if (i < 0 || i >= labels.length) return const SizedBox.shrink();
              return Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(labels[i],
                    style: TextStyle(fontSize: _mode == 2 ? 8 : 9, color: AppTheme.darkText)),
              );
            },
          ),
        ),
      ),
    ));
  }

  Widget _buildPieChart(BuildContext ctx, int readMinutes, String locale, double size) {
    final totalMinutes = _totalPeriodMinutes();
    final readH = readMinutes ~/ 60;
    final readM = readMinutes % 60;
    final readLabel = readM > 0 ? '${readH}h ${readM}m' : '${readH}h';

    double totalHours = totalMinutes / 60;
    double readHours = readMinutes / 60;
    if (readHours > totalHours) readHours = totalHours;

    final sections = [
      PieChartSectionData(
        value: readHours,
        color: _piePrimary,
        title: readLabel,
        titleStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
        radius: 52,
      ),
      PieChartSectionData(
        value: totalHours - readHours,
        color: _pieSecondary.withValues(alpha: 0.35),
        title: '',
        radius: 46,
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          SizedBox(
            height: size,
            width: size,
            child: PieChart(PieChartData(
              sections: sections,
              centerSpaceRadius: 0,
              sectionsSpace: 2,
              startDegreeOffset: -90,
            )),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _LegendDot(color: _piePrimary, label: ctx.t('chart_pie_read')),
                const SizedBox(height: 6),
                _LegendDot(
                  color: _pieSecondary.withValues(alpha: 0.5),
                  label: ctx.t('chart_pie_available'),
                ),
                const SizedBox(height: 10),
                Text(
                  ctx.t('chart_pie_subtitle'),
                  style: TextStyle(
                    fontSize: 11,
                    color: AppTheme.darkText.withValues(alpha: 0.5),
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDonutChart(
      BuildContext ctx, List<Map<String, dynamic>> rawRows, String locale, double size) {
    final rows = rawRows.take(6).toList();
    final otherPages = rawRows.length > 6
        ? rawRows.skip(6).fold<int>(0, (s, r) => s + ((r['pages'] as int?) ?? 0))
        : 0;

    final sections = <PieChartSectionData>[];
    final legends = <_LegendDot>[];

    for (int i = 0; i < rows.length; i++) {
      final pages = (rows[i]['pages'] as int?) ?? 0;
      final title = rows[i]['title'] as String;
      final color = _donutColors[i % _donutColors.length];
      sections.add(PieChartSectionData(
        value: pages.toDouble(),
        color: color,
        title: '',
        radius: 30,
      ));
      legends.add(_LegendDot(
        color: color,
        label: '${title.length > 18 ? '${title.substring(0, 16)}…' : title} ($pages)',
      ));
    }

    if (otherPages > 0) {
      sections.add(PieChartSectionData(
        value: otherPages.toDouble(),
        color: AppTheme.darkText.withValues(alpha: 0.2),
        title: '',
        radius: 28,
      ));
      legends.add(_LegendDot(
        color: AppTheme.darkText.withValues(alpha: 0.3),
        label: '${ctx.t('chart_donut_other')} ($otherPages)',
      ));
    }

    final totalPages = (rawRows.fold<int>(0, (s, r) => s + ((r['pages'] as int?) ?? 0)));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: size,
            width: size,
            child: Stack(
              alignment: Alignment.center,
              children: [
                PieChart(PieChartData(
                  sections: sections,
                  centerSpaceRadius: size * 0.28,
                  sectionsSpace: 2,
                  startDegreeOffset: -90,
                )),
                Text(
                  '$totalPages\n${ctx.read<LanguageProvider>().translate('chart_pages').toLowerCase()}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.darkText,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final l in legends) ...[l, const SizedBox(height: 4)],
                const SizedBox(height: 4),
                Text(
                  ctx.t('chart_donut_subtitle'),
                  style: TextStyle(
                    fontSize: 11,
                    color: AppTheme.darkText.withValues(alpha: 0.5),
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ChartTitle extends StatelessWidget {
  final String text;
  const _ChartTitle({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 10, 16, 2),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: AppTheme.darkText.withValues(alpha: 0.7),
        ),
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;
  const _LegendDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            label,
            style: TextStyle(fontSize: 11, color: AppTheme.darkText.withValues(alpha: 0.75)),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _MetricPills extends StatelessWidget {
  final int metric;
  final ValueChanged<int> onChanged;
  const _MetricPills({required this.metric, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _MetricPill(
          icon: Icons.auto_stories,
          label: context.t('chart_metric_pages'),
          selected: metric == 0,
          onTap: () => onChanged(0),
        ),
        const SizedBox(width: 8),
        _MetricPill(
          icon: Icons.menu_book,
          label: context.t('chart_metric_books'),
          selected: metric == 1,
          onTap: () => onChanged(1),
        ),
      ],
    );
  }
}

class _MetricPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _MetricPill({required this.icon, required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        decoration: BoxDecoration(
          color: selected ? AppTheme.pink : AppTheme.pink.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: selected ? AppTheme.darkText.withValues(alpha: 0.3) : AppTheme.pink),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: selected ? AppTheme.darkText : AppTheme.darkText.withValues(alpha: 0.6)),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                color: selected ? AppTheme.darkText : AppTheme.darkText.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      ),
    );
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
          label: context.t('chart_tab_weekly'),
          selected: mode == 0,
          onTap: () => onChanged(0),
        ),
        const SizedBox(width: 8),
        _Pill(
          label: context.t('chart_tab_monthly'),
          selected: mode == 1,
          onTap: () => onChanged(1),
        ),
        const SizedBox(width: 8),
        _Pill(
          label: context.t('chart_tab_annual'),
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
