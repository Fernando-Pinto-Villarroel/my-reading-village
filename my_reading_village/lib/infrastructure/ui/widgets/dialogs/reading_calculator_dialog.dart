import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:my_reading_village/infrastructure/ui/config/app_theme.dart';
import 'package:my_reading_village/infrastructure/ui/localization/context_ext.dart';
import 'package:my_reading_village/infrastructure/ui/widgets/common/resource_icon.dart';
import 'package:my_reading_village/domain/rules/reading_rules.dart';
import 'package:my_reading_village/adapters/providers/village_provider.dart';

void showReadingCalculatorDialog(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (_) => const _ReadingCalculatorContent(),
  );
}

enum _ResourceType { coins, gems, wood, metal }

enum _CalcMode { net, goal }

class _ReadingCalculatorContent extends StatefulWidget {
  const _ReadingCalculatorContent();

  @override
  State<_ReadingCalculatorContent> createState() =>
      _ReadingCalculatorContentState();
}

class _ReadingCalculatorContentState extends State<_ReadingCalculatorContent> {
  _CalcMode _calcMode = _CalcMode.net;
  _ResourceType _selectedResource = _ResourceType.coins;
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _goalController = TextEditingController();
  _CalculationResult? _result;
  String? _error;
  bool _goalRangeError = false;

  @override
  void dispose() {
    _amountController.dispose();
    _goalController.dispose();
    super.dispose();
  }

  int _getCurrentAmount() {
    final village = Provider.of<VillageProvider>(context, listen: false);
    switch (_selectedResource) {
      case _ResourceType.coins:
        return village.coins;
      case _ResourceType.gems:
        return village.gems;
      case _ResourceType.wood:
        return village.wood;
      case _ResourceType.metal:
        return village.metal;
    }
  }

  void _calculate() {
    if (_calcMode == _CalcMode.net) {
      _calculateNet();
    } else {
      _calculateGoal();
    }
  }

  void _calculateNet() {
    final text = _amountController.text.trim();
    if (text.isEmpty) {
      setState(() {
        _error = context.t('calculator_enter_amount');
        _result = null;
      });
      return;
    }
    final amount = int.tryParse(text);
    if (amount == null || amount <= 0) {
      setState(() {
        _error = context.t('calculator_invalid_amount');
        _result = null;
      });
      return;
    }
    setState(() {
      _error = null;
      _result = _computeResult(_selectedResource, amount);
    });
  }

  void _calculateGoal() {
    final current = _getCurrentAmount();
    final goalText = _goalController.text.trim();
    if (goalText.isEmpty) {
      setState(() {
        _error = context.t('calculator_enter_amount');
        _result = null;
        _goalRangeError = false;
      });
      return;
    }
    final goal = int.tryParse(goalText);
    if (goal == null || goal <= 0) {
      setState(() {
        _error = context.t('calculator_invalid_amount');
        _result = null;
        _goalRangeError = false;
      });
      return;
    }
    if (goal <= current) {
      setState(() {
        _error = null;
        _result = null;
        _goalRangeError = true;
      });
      return;
    }
    final needed = goal - current;
    setState(() {
      _error = null;
      _result = _computeResult(_selectedResource, needed);
      _goalRangeError = false;
    });
  }

  _CalculationResult _computeResult(_ResourceType type, int target) {
    switch (type) {
      case _ResourceType.coins:
        final pagesForCoins = (target / ReadingRules.coinsPerPage).ceil();
        final booksForCoins =
            (target / ReadingRules.bookCompletionCoinBonus).ceil();
        return _CalculationResult(
          resourceType: type,
          target: target,
          pagesNeeded: pagesForCoins,
          booksNeeded: booksForCoins,
          ratePerPage: ReadingRules.coinsPerPage,
          bonusPerBook: ReadingRules.bookCompletionCoinBonus,
        );
      case _ResourceType.gems:
        final booksForGems =
            (target / ReadingRules.bookCompletionGemBonusDefault).ceil();
        return _CalculationResult(
          resourceType: type,
          target: target,
          pagesNeeded: null,
          booksNeeded: booksForGems,
          ratePerPage: null,
          bonusPerBook: null,
        );
      case _ResourceType.wood:
        final pagesForWood = (target / ReadingRules.woodPerPage).ceil();
        return _CalculationResult(
          resourceType: type,
          target: target,
          pagesNeeded: pagesForWood,
          booksNeeded: null,
          ratePerPage: ReadingRules.woodPerPage,
          bonusPerBook: null,
        );
      case _ResourceType.metal:
        final pagesForMetal = (target / ReadingRules.metalPerPage).ceil();
        return _CalculationResult(
          resourceType: type,
          target: target,
          pagesNeeded: pagesForMetal,
          booksNeeded: null,
          ratePerPage: ReadingRules.metalPerPage,
          bonusPerBook: null,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    final landscape =
        MediaQuery.of(context).size.width > MediaQuery.of(context).size.height;

    return Padding(
      padding: EdgeInsets.only(bottom: bottom),
      child: Container(
        decoration: const BoxDecoration(
          color: AppTheme.cream,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        constraints: BoxConstraints(
          maxHeight:
              MediaQuery.of(context).size.height * (landscape ? 0.92 : 0.85),
        ),
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(20, 16, 20, landscape ? 8 : 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Icon(Icons.calculate, size: 24, color: AppTheme.darkText),
                    const SizedBox(width: 8),
                    Text(
                      context.t('resource_calculator'),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.darkText,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  context.t('resource_calculator_subtitle'),
                  style: TextStyle(
                    fontSize: 13,
                    color: AppTheme.darkText.withValues(alpha: 0.6),
                  ),
                ),
                const SizedBox(height: 16),
                _CalcModeSelector(
                  mode: _calcMode,
                  onChanged: (m) => setState(() {
                    _calcMode = m;
                    _result = null;
                    _error = null;
                    _goalRangeError = false;
                    if (m == _CalcMode.goal) {
                      _goalController.text = '${_getCurrentAmount()}';
                    }
                  }),
                ),
                const SizedBox(height: 16),
                Text(
                  context.t('calculator_resource_type'),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.darkText,
                  ),
                ),
                const SizedBox(height: 8),
                _ResourceSelector(
                  selected: _selectedResource,
                  onChanged: (r) => setState(() {
                    _selectedResource = r;
                    _result = null;
                    _error = null;
                    _goalRangeError = false;
                    if (_calcMode == _CalcMode.goal) {
                      _goalController.text = '${_getCurrentAmount()}';
                    } else {
                      _goalController.clear();
                    }
                  }),
                ),
                const SizedBox(height: 16),
                if (_calcMode == _CalcMode.net) ...[
                  Text(
                    context.t('calculator_target_amount'),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.darkText,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          controller: _amountController,
                          hint: context.t('calculator_amount_hint'),
                          errorText: _error,
                        ),
                      ),
                      const SizedBox(width: 12),
                      _buildCalcButton(),
                    ],
                  ),
                ] else ...[
                  Text(
                    context.t('calculator_current_amount'),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.darkText,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildCurrentAmountDisplay(),
                  const SizedBox(height: 12),
                  Text(
                    context.t('calculator_goal_amount'),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.darkText,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          controller: _goalController,
                          hint: context.t('calculator_goal_hint'),
                          errorText: _error,
                        ),
                      ),
                      const SizedBox(width: 12),
                      _buildCalcButton(),
                    ],
                  ),
                ],
                if (_goalRangeError) ...[
                  const SizedBox(height: 16),
                  _GoalRangeErrorCard(
                      message: context.t('calculator_goal_invalid')),
                ] else if (_result != null) ...[
                  const SizedBox(height: 16),
                  _ResultCard(result: _result!),
                ],
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppTheme.mint.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: AppTheme.mint.withValues(alpha: 0.4),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.info_outline,
                          size: 18, color: AppTheme.mediumMint),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          context.t('calculator_minigame_tip'),
                          style: TextStyle(
                            fontSize: 12,
                            color: AppTheme.darkText.withValues(alpha: 0.7),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    String? errorText,
    void Function(String)? onChanged,
  }) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              BorderSide(color: AppTheme.lavender.withValues(alpha: 0.4)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              BorderSide(color: AppTheme.lavender.withValues(alpha: 0.4)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppTheme.lavender, width: 2),
        ),
        errorText: errorText,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      onSubmitted: (_) => _calculate(),
    );
  }

  Widget _buildCurrentAmountDisplay() {
    final amount = _getCurrentAmount();
    Widget icon;
    switch (_selectedResource) {
      case _ResourceType.coins:
        icon = ResourceIcon.coin(size: 20);
      case _ResourceType.gems:
        icon = ResourceIcon.gem(size: 20);
      case _ResourceType.wood:
        icon = ResourceIcon.wood(size: 20);
      case _ResourceType.metal:
        icon = ResourceIcon.metal(size: 20);
    }
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppTheme.lavender.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.lavender.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          icon,
          const SizedBox(width: 10),
          Text(
            '$amount',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.darkLavender,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalcButton() {
    return ElevatedButton(
      onPressed: _calculate,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppTheme.lavender,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text(
        context.t('calculator_calculate'),
        style:
            const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }
}

class _CalcModeSelector extends StatelessWidget {
  final _CalcMode mode;
  final ValueChanged<_CalcMode> onChanged;

  const _CalcModeSelector({required this.mode, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: AppTheme.darkText.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: _CalcMode.values.map((m) {
          final selected = m == mode;
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(m),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: selected ? AppTheme.lavender : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: Text(
                  m == _CalcMode.net
                      ? context.t('calculator_tab_net')
                      : context.t('calculator_tab_goal'),
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: selected
                        ? Colors.white
                        : AppTheme.darkText.withValues(alpha: 0.5),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _ResourceSelector extends StatelessWidget {
  final _ResourceType selected;
  final ValueChanged<_ResourceType> onChanged;

  const _ResourceSelector({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: _ResourceType.values.map((type) {
        final isSelected = type == selected;
        return Expanded(
          child: GestureDetector(
            onTap: () => onChanged(type),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: 6),
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppTheme.lavender.withValues(alpha: 0.25)
                    : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected
                      ? AppTheme.lavender
                      : AppTheme.darkText.withValues(alpha: 0.15),
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _resourceIcon(type, 28),
                  const SizedBox(height: 4),
                  Text(
                    _resourceLabel(context, type),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected
                          ? AppTheme.darkLavender
                          : AppTheme.darkText.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _resourceIcon(_ResourceType type, double size) {
    switch (type) {
      case _ResourceType.coins:
        return ResourceIcon.coin(size: size);
      case _ResourceType.gems:
        return ResourceIcon.gem(size: size);
      case _ResourceType.wood:
        return ResourceIcon.wood(size: size);
      case _ResourceType.metal:
        return ResourceIcon.metal(size: size);
    }
  }

  String _resourceLabel(BuildContext context, _ResourceType type) {
    switch (type) {
      case _ResourceType.coins:
        return context.t('coins');
      case _ResourceType.gems:
        return context.t('gems');
      case _ResourceType.wood:
        return context.t('wood');
      case _ResourceType.metal:
        return context.t('metal');
    }
  }
}

class _CalculationResult {
  final _ResourceType resourceType;
  final int target;
  final int? pagesNeeded;
  final int? booksNeeded;
  final int? ratePerPage;
  final int? bonusPerBook;

  const _CalculationResult({
    required this.resourceType,
    required this.target,
    required this.pagesNeeded,
    required this.booksNeeded,
    required this.ratePerPage,
    required this.bonusPerBook,
  });
}

class _ResultCard extends StatelessWidget {
  final _CalculationResult result;

  const _ResultCard({required this.result});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.lavender.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.lavender.withValues(alpha: 0.4),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.auto_awesome, size: 18, color: AppTheme.darkLavender),
              const SizedBox(width: 6),
              Text(
                context
                    .t('calculator_result_title')
                    .replaceAll('{amount}', '${result.target}'),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.darkLavender,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (result.pagesNeeded != null)
            _ResultRow(
              icon: Icons.book_outlined,
              color: AppTheme.mediumMint,
              text: context
                  .t('calculator_pages_needed')
                  .replaceAll('{pages}', '${result.pagesNeeded}'),
              detail: result.ratePerPage != null
                  ? context
                      .t('calculator_rate_per_page')
                      .replaceAll('{rate}', '${result.ratePerPage}')
                  : null,
            ),
          if (result.pagesNeeded != null && result.booksNeeded != null) ...[
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                    child: Divider(
                        color: AppTheme.lavender.withValues(alpha: 0.5),
                        thickness: 1)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    context.t('or'),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.darkLavender,
                    ),
                  ),
                ),
                Expanded(
                    child: Divider(
                        color: AppTheme.lavender.withValues(alpha: 0.5),
                        thickness: 1)),
              ],
            ),
            const SizedBox(height: 10),
          ],
          if (result.resourceType == _ResourceType.gems) ...[
            _GemResultSection(target: result.target),
          ] else if (result.booksNeeded != null) ...[
            _ResultRow(
              icon: Icons.auto_stories,
              color: AppTheme.darkPink,
              text: context
                  .t('calculator_books_needed')
                  .replaceAll('{books}', '${result.booksNeeded}'),
              detail: result.bonusPerBook != null
                  ? context
                      .t('calculator_bonus_per_book')
                      .replaceAll('{bonus}', '${result.bonusPerBook}')
                  : null,
            ),
          ],
        ],
      ),
    );
  }
}

class _ResultRow extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String text;
  final String? detail;

  const _ResultRow({
    required this.icon,
    required this.color,
    required this.text,
    this.detail,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 18, color: color),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                text,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.darkText,
                ),
              ),
              if (detail != null)
                Text(
                  detail!,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.darkText.withValues(alpha: 0.55),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _GoalRangeErrorCard extends StatelessWidget {
  final String message;

  const _GoalRangeErrorCard({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.pink.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.pink.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline_rounded, size: 20, color: AppTheme.darkPink),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppTheme.darkPink,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GemResultSection extends StatelessWidget {
  final int target;
  const _GemResultSection({required this.target});

  static const _tiers = [
    (label: '500+', gems: 18),
    (label: '350–499', gems: 13),
    (label: '200–349', gems: 10),
    (label: '100–199', gems: 5),
    (label: '50–99', gems: 2),
    (label: '<50', gems: 0),
  ];

  @override
  Widget build(BuildContext context) {
    final booksLong = (target / 18).ceil();
    final booksMid = (target / 10).ceil();
    final booksShort = (target / 2).ceil();
    final pLabel = context.t('pages_label');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ResultRow(
          icon: Icons.auto_stories,
          color: AppTheme.gemPurple,
          text: context
              .t('calculator_gems_scenario_long')
              .replaceAll('{books}', '$booksLong'),
          detail: context.t('calculator_gems_detail_long'),
        ),
        const SizedBox(height: 8),
        _ResultRow(
          icon: Icons.menu_book_rounded,
          color: AppTheme.darkLavender,
          text: context
              .t('calculator_gems_scenario_std')
              .replaceAll('{books}', '$booksMid'),
          detail: context.t('calculator_gems_detail_std'),
        ),
        const SizedBox(height: 8),
        _ResultRow(
          icon: Icons.book_outlined,
          color: AppTheme.mediumMint,
          text: context
              .t('calculator_gems_scenario_short')
              .replaceAll('{books}', '$booksShort'),
          detail: context.t('calculator_gems_detail_short'),
        ),
        const SizedBox(height: 14),
        Text(
          context.t('calculator_gems_tier_title'),
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppTheme.darkText.withValues(alpha: 0.6),
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: _tiers.map((tier) {
            final hasReward = tier.gems > 0;
            return Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              decoration: BoxDecoration(
                color: hasReward
                    ? AppTheme.gemPurple.withValues(alpha: 0.07)
                    : Colors.grey.withValues(alpha: 0.07),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: hasReward
                      ? AppTheme.gemPurple.withValues(alpha: 0.35)
                      : Colors.grey.withValues(alpha: 0.25),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${tier.label} $pLabel',
                    style: TextStyle(
                      fontSize: 11,
                      color: hasReward
                          ? AppTheme.darkText.withValues(alpha: 0.75)
                          : Colors.grey,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Container(
                    width: 1,
                    height: 12,
                    color: hasReward
                        ? AppTheme.gemPurple.withValues(alpha: 0.4)
                        : Colors.grey.withValues(alpha: 0.3),
                  ),
                  const SizedBox(width: 5),
                  if (hasReward) ...[
                    ResourceIcon.gem(size: 12),
                    const SizedBox(width: 3),
                    Text(
                      '${tier.gems}',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.gemPurple,
                      ),
                    ),
                  ] else
                    Text(
                      '—',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.withValues(alpha: 0.6),
                      ),
                    ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
