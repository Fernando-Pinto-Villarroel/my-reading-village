import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_reading_village/infrastructure/ui/config/app_theme.dart';
import 'package:my_reading_village/adapters/providers/book_provider.dart';
import 'package:my_reading_village/adapters/providers/tag_provider.dart';
import 'package:my_reading_village/infrastructure/ui/widgets/common/book_card.dart';
import 'package:my_reading_village/infrastructure/ui/widgets/sheets/book_detail_sheet.dart';
import 'package:my_reading_village/infrastructure/ui/widgets/common/book_filter_bar.dart';
import 'package:my_reading_village/infrastructure/ui/widgets/dialogs/book_form_dialog.dart';
import 'package:my_reading_village/infrastructure/ui/widgets/dialogs/book_search_dialog.dart';
import 'package:my_reading_village/infrastructure/ui/widgets/dialogs/log_pages_dialog.dart';
import 'package:my_reading_village/infrastructure/ui/widgets/dialogs/reading_calendar_tab.dart';
import 'package:my_reading_village/infrastructure/ui/widgets/common/shared_utils.dart';
import 'package:my_reading_village/infrastructure/ui/widgets/dialogs/tag_manager_dialog.dart';
import 'package:my_reading_village/infrastructure/ui/widgets/dialogs/reading_calculator_dialog.dart';
import 'package:my_reading_village/infrastructure/ui/localization/context_ext.dart';
import 'package:my_reading_village/infrastructure/ui/localization/language_provider.dart';
import 'package:my_reading_village/domain/entities/book_filter.dart';

Future<void> showReadingModal(BuildContext context) {
  final landscape = isLandscape(context);
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    useSafeArea: true,
    constraints: landscape
        ? BoxConstraints(
            maxWidth: 480, maxHeight: MediaQuery.of(context).size.height)
        : null,
    builder: (ctx) => _ReadingSheet(landscape: landscape),
  );
}

class _ReadingSheet extends StatefulWidget {
  final bool landscape;
  const _ReadingSheet({required this.landscape});

  @override
  State<_ReadingSheet> createState() => _ReadingSheetState();
}

class _ReadingSheetState extends State<_ReadingSheet> {
  final _sheetController = DraggableScrollableController();
  bool _dismissing = false;

  static const double _minSize = 0.05;
  double get _initialSize => widget.landscape ? 1.0 : 0.85;

  @override
  void initState() {
    super.initState();
    _sheetController.addListener(_onSheetChanged);
  }

  void _onSheetChanged() {
    if (!_sheetController.isAttached || _dismissing) return;
    if (_sheetController.size <= _minSize + 0.02) {
      _dismissing = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) Navigator.of(context).pop();
      });
    }
  }

  @override
  void dispose() {
    _sheetController.removeListener(_onSheetChanged);
    _sheetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      controller: _sheetController,
      initialChildSize: _initialSize,
      minChildSize: _minSize,
      maxChildSize: 1.0,
      snap: true,
      snapSizes: widget.landscape ? const [1.0] : const [0.85],
      builder: (ctx, scrollController) =>
          _ReadingModalContent(scrollController: scrollController),
    );
  }
}

class _ReadingModalContent extends StatelessWidget {
  final ScrollController scrollController;

  const _ReadingModalContent({required this.scrollController});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxHeight < 120) return const SizedBox.shrink();
        return DefaultTabController(
          length: 2,
          child: Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewPadding.bottom),
            child: Container(
              decoration: BoxDecoration(
                color: AppTheme.cream,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                children: [
                  SizedBox(height: 8),
                  _dragHandle(),
                  Padding(
                    padding: EdgeInsets.fromLTRB(16, 12, 4, 4),
                    child: Row(
                      children: [
                        Icon(Icons.menu_book,
                            size: 24, color: AppTheme.darkText),
                        SizedBox(width: 8),
                        Text(context.t('reading_tracker'),
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.darkText)),
                        Spacer(),
                        IconButton(
                          icon: Icon(Icons.label,
                              size: 22, color: AppTheme.lavender),
                          tooltip: context.t('manage_tags'),
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              backgroundColor: Colors.transparent,
                              isScrollControlled: true,
                              builder: (_) => TagManagerDialog(),
                            );
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.add_circle,
                              size: 30, color: AppTheme.darkPink),
                          onPressed: () => _showAddBookDialog(context),
                        ),
                      ],
                    ),
                  ),
                  TabBar(
                    labelColor: AppTheme.lavender,
                    unselectedLabelColor:
                        AppTheme.darkText.withValues(alpha: 0.4),
                    indicatorColor: AppTheme.lavender,
                    indicatorWeight: 3,
                    labelStyle:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    tabs: [
                      Tab(text: context.t('books_tab')),
                      Tab(text: context.t('calendar_tab')),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        _BooksTab(scrollController: scrollController),
                        ReadingCalendarTab(scrollController: scrollController),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _BooksTab extends StatefulWidget {
  final ScrollController scrollController;

  const _BooksTab({required this.scrollController});

  @override
  State<_BooksTab> createState() => _BooksTabState();
}

class _BooksTabState extends State<_BooksTab> {
  static const int _pageSize = 5;

  int _visibleCount = _pageSize;
  String? _lastFilterSig;
  bool _pendingFillCheck = false;

  static String _filterSig(BookFilter f) =>
      '${f.searchQuery}|${f.selectedTagIds.join(',')}|${f.showCompleted}|${f.sortField.index}|${f.sortDirection.index}';

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_onScroll);
    super.dispose();
  }

  void _onScroll() {
    if (!mounted || !widget.scrollController.hasClients) return;
    final pos = widget.scrollController.position;
    if (pos.pixels >= pos.maxScrollExtent - 300) {
      _loadMore();
    }
  }

  void _loadMore() {
    if (!mounted) return;
    final total = context.read<BookProvider>().filteredBooks.length;
    if (_visibleCount < total) {
      setState(() => _visibleCount = (_visibleCount + _pageSize).clamp(0, total));
    }
  }

  void _scheduleFillCheck() {
    if (_pendingFillCheck) return;
    _pendingFillCheck = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _pendingFillCheck = false;
      if (!mounted || !widget.scrollController.hasClients) return;
      final total = context.read<BookProvider>().filteredBooks.length;
      if (_visibleCount >= total) return;
      try {
        if (widget.scrollController.position.maxScrollExtent <= 0) {
          _loadMore();
        }
      } catch (_) {}
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Consumer2<BookProvider, TagProvider>(
          builder: (ctx, bookProvider, tagProvider, _) {
            return BookFilterBar(
              filter: bookProvider.filter,
              availableTags: tagProvider.tags,
              onFilterChanged: (f) => bookProvider.setFilter(f),
              onCalculatorPressed: () => showReadingCalculatorDialog(ctx),
            );
          },
        ),
        SizedBox(height: 4),
        Expanded(
          child: Consumer<BookProvider>(
            builder: (ctx, bookProvider, _) {
              final books = bookProvider.filteredBooks;

              final sig = _filterSig(bookProvider.filter);
              if (_lastFilterSig != null && sig != _lastFilterSig) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted) setState(() => _visibleCount = _pageSize);
                });
              }
              _lastFilterSig = sig;

              if (bookProvider.books.isEmpty) {
                return SingleChildScrollView(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.auto_stories,
                              size: 60, color: AppTheme.lavender),
                          SizedBox(height: 16),
                          Text(
                            context.t('no_books_yet'),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 16,
                                color:
                                    AppTheme.darkText.withValues(alpha: 0.6)),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }
              if (books.isEmpty) {
                return Center(
                  child: Text(context.t('no_books_match_filters'),
                      style: TextStyle(
                          fontSize: 14,
                          color: AppTheme.darkText.withValues(alpha: 0.5))),
                );
              }

              if (_visibleCount < books.length) _scheduleFillCheck();

              final sliceEnd = _visibleCount.clamp(0, books.length);
              final hasMore = _visibleCount < books.length;

              return ListView.builder(
                controller: widget.scrollController,
                itemCount: sliceEnd + 1,
                itemBuilder: (ctx, i) {
                  if (i == sliceEnd) {
                    return hasMore
                        ? Padding(
                            padding:
                                const EdgeInsets.symmetric(vertical: 16),
                            child: Center(
                              child: SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppTheme.lavender,
                                ),
                              ),
                            ),
                          )
                        : SizedBox(height: 24);
                  }
                  final book = books[i];
                  return BookCard(
                    book: book,
                    onLogPages: book.isCompleted
                        ? () {}
                        : () => showLogPagesDialog(context, book.id!),
                    onTap: () => showBookDetailSheet(context, book),
                    onEdit: () => showDialog(
                      context: context,
                      builder: (_) => BookFormDialog(existingBook: book),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

void _showAddBookDialog(BuildContext context) {
  final langProvider = context.read<LanguageProvider>();
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(
        children: [
          Icon(Icons.add_circle, size: 22, color: AppTheme.darkPink),
          SizedBox(width: 8),
          Text(langProvider.translate('add_a_book'),
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(langProvider.translate('how_to_add_book'),
              style: TextStyle(
                  fontSize: 14,
                  color: AppTheme.darkText.withValues(alpha: 0.7))),
          SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(ctx);
                showDialog(
                    context: context, builder: (_) => BookSearchDialog());
              },
              icon: Icon(Icons.search, size: 18),
              label: Text(langProvider.translate('search_online')),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.lavender,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                Navigator.pop(ctx);
                showDialog(context: context, builder: (_) => BookFormDialog());
              },
              icon: Icon(Icons.edit, size: 18),
              label: Text(langProvider.translate('add_manually')),
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 12),
                side: BorderSide(color: AppTheme.lavender),
              ),
            ),
          ),
        ],
      ),
    ),
  );
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
