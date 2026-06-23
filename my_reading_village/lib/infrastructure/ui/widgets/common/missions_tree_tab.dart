import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_reading_village/infrastructure/ui/config/app_theme.dart';
import 'package:my_reading_village/domain/entities/mission.dart';
import 'package:my_reading_village/domain/entities/mission_data.dart';
import 'package:my_reading_village/domain/rules/holiday_rules.dart';
import 'package:my_reading_village/adapters/providers/village_provider.dart';
import 'package:my_reading_village/infrastructure/ui/widgets/common/missions_active_tab.dart';
import 'package:my_reading_village/infrastructure/ui/localization/context_ext.dart';
import 'package:my_reading_village/infrastructure/di/service_locator.dart';
import 'package:my_reading_village/application/services/time_verification_service.dart';

class MissionTreeTab extends StatelessWidget {
  final int totalPagesRead;
  final int completedBooks;

  const MissionTreeTab({
    super.key,
    required this.totalPagesRead,
    required this.completedBooks,
  });

  @override
  Widget build(BuildContext context) {
    final village = context.watch<VillageProvider>();

    final now = sl<TimeVerificationService>().trustedNow();

    return SingleChildScrollView(
      child: Column(
        children: [
          for (final branch in MissionBranch.values) ...[
            if (HolidayRules.isHolidayBranch(branch) &&
                !(HolidayRules.eventForBranch(branch)?.isActive(now) ?? false))
              const SizedBox.shrink()
            else ...[
              BranchTreeCard(
                branch: branch,
                village: village,
                totalPagesRead: totalPagesRead,
                completedBooks: completedBooks,
              ),
              const SizedBox(height: 12),
            ],
          ],
        ],
      ),
    );
  }
}

class BranchTreeCard extends StatefulWidget {
  final MissionBranch branch;
  final VillageProvider village;
  final int totalPagesRead;
  final int completedBooks;

  const BranchTreeCard({
    super.key,
    required this.branch,
    required this.village,
    required this.totalPagesRead,
    required this.completedBooks,
  });

  @override
  State<BranchTreeCard> createState() => _BranchTreeCardState();
}

class _BranchTreeCardState extends State<BranchTreeCard> {
  bool _expanded = false;
  int _visibleCount = 15;

  String _lockedDescription(
      BuildContext context, MissionBranch branch, List<MissionBranch> deps) {
    final event = HolidayRules.eventForBranch(branch);
    if (event != null) {
      return context.t('event_available_in_${event.id}');
    }
    if (deps.isNotEmpty) {
      return '${context.t('unlock_requirement_prefix')} ${deps.map((b) => context.t('branch_${b.name.replaceAllMapped(RegExp(r'[A-Z]'), (m) => '_${m[0]!.toLowerCase()}')}', fallback: b.name)).join(' and ')} ${context.t('unlock_requirement_suffix')}';
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    final color = MissionColors.forBranch(widget.branch);
    final isUnlocked = widget.village.isBranchUnlocked(widget.branch);
    final isComplete = widget.village.isBranchFullyCompleted(widget.branch);
    final missions = MissionData.getMissionsForBranch(widget.branch);
    final deps = MissionData.branchDependencies(widget.branch);

    int claimedCount = 0;
    for (final m in missions) {
      final p = widget.village.missionProgress[m.id];
      if (p != null && p.isClaimed) claimedCount++;
    }

    return Container(
      decoration: BoxDecoration(
        color: isUnlocked ? AppTheme.softWhite : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isComplete
              ? color.withValues(alpha: 0.6)
              : isUnlocked
                  ? color.withValues(alpha: 0.3)
                  : Colors.grey.shade300,
          width: isComplete ? 2 : 1.5,
        ),
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: () => setState(() {
              _expanded = !_expanded;
              if (!_expanded) _visibleCount = 15;
            }),
            child: Container(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: isUnlocked
                          ? color.withValues(alpha: 0.2)
                          : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      MissionColors.iconForBranch(widget.branch),
                      size: 22,
                      color: isUnlocked ? AppTheme.darkText : Colors.grey,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.t(
                            'branch_${widget.branch.name.replaceAllMapped(RegExp(r'[A-Z]'), (m) => '_${m[0]!.toLowerCase()}')}',
                            fallback: widget.branch.name,
                          ),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: isUnlocked ? AppTheme.darkText : Colors.grey,
                          ),
                        ),
                        if (!isUnlocked) ...[
                          if (HolidayRules.isHolidayBranch(widget.branch))
                            Text(
                              context.t(
                                  'event_available_in_${HolidayRules.eventForBranch(widget.branch)?.id ?? ''}'),
                              style: TextStyle(
                                  fontSize: 11, color: Colors.grey.shade500),
                            )
                          else if (deps.isNotEmpty)
                            Text(
                              '${context.t('requires')} ${deps.map((b) => context.t('branch_${b.name.replaceAllMapped(RegExp(r'[A-Z]'), (m) => '_${m[0]!.toLowerCase()}')}', fallback: b.name)).join(', ')}',
                              style: TextStyle(
                                  fontSize: 11, color: Colors.grey.shade500),
                            ),
                        ],
                        if (isUnlocked) ...[
                          Text(
                            '$claimedCount / ${missions.length} ${context.t('completed')}',
                            style: TextStyle(
                                fontSize: 11,
                                color:
                                    AppTheme.darkText.withValues(alpha: 0.5)),
                          ),
                          if (HolidayRules.isHolidayBranch(widget.branch)) ...[
                            const SizedBox(height: 2),
                            EventCountdownBadge(
                                branch: widget.branch, color: color),
                          ],
                        ],
                      ],
                    ),
                  ),
                  if (isComplete)
                    Icon(Icons.emoji_events,
                        size: 22, color: AppTheme.coinGold),
                  if (!isUnlocked)
                    Icon(Icons.lock, size: 20, color: Colors.grey.shade400),
                  const SizedBox(width: 4),
                  Icon(
                    _expanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    size: 22,
                    color: isUnlocked ? AppTheme.darkText : Colors.grey,
                  ),
                ],
              ),
            ),
          ),
          if (isUnlocked)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: missions.isEmpty ? 0 : claimedCount / missions.length,
                  minHeight: 4,
                  backgroundColor: color.withValues(alpha: 0.15),
                  valueColor: AlwaysStoppedAnimation(color),
                ),
              ),
            ),
          if (_expanded && isUnlocked) ...[
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  for (int i = 0;
                      i < missions.length && i < _visibleCount;
                      i++) ...[
                    MissionTreeNode(
                      mission: missions[i],
                      village: widget.village,
                      totalPagesRead: widget.totalPagesRead,
                      completedBooks: widget.completedBooks,
                      isLast: i == missions.length - 1 ||
                          i == _visibleCount - 1,
                      isActive:
                          widget.village.getActiveMission(widget.branch)?.id ==
                              missions[i].id,
                    ),
                  ],
                  if (missions.length > 15 &&
                      _visibleCount < missions.length) ...[
                    const SizedBox(height: 4),
                    GestureDetector(
                      onTap: () => setState(
                          () => _visibleCount = _visibleCount + 15),
                      child: Padding(
                        padding:
                            const EdgeInsets.symmetric(vertical: 6),
                        child: Text(
                          context.t('see_more_missions'),
                          style: TextStyle(
                            fontSize: 12,
                            color: color,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                            decorationColor: color,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 8),
          ],
          if (_expanded && !isUnlocked) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 16),
              child: Text(
                _lockedDescription(context, widget.branch, deps),
                style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                    fontStyle: FontStyle.italic),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 8),
              child: Column(
                children: [
                  for (int i = 0; i < missions.length; i++) ...[
                    MissionTreeNode(
                      mission: missions[i],
                      village: widget.village,
                      totalPagesRead: widget.totalPagesRead,
                      completedBooks: widget.completedBooks,
                      isLast: i == missions.length - 1,
                      isActive: false,
                      isLocked: true,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class MissionTreeNode extends StatelessWidget {
  final Mission mission;
  final VillageProvider village;
  final int totalPagesRead;
  final int completedBooks;
  final bool isLast;
  final bool isActive;
  final bool isLocked;

  const MissionTreeNode({
    super.key,
    required this.mission,
    required this.village,
    required this.totalPagesRead,
    required this.completedBooks,
    required this.isLast,
    required this.isActive,
    this.isLocked = false,
  });

  @override
  Widget build(BuildContext context) {
    final progress = village.missionProgress[mission.id];
    final isClaimed = progress?.isClaimed ?? false;
    final isCompleted = progress?.isCompleted ?? false;
    final color = MissionColors.forBranch(mission.branch);

    Color nodeColor;
    IconData nodeIcon;
    if (isLocked) {
      nodeColor = Colors.grey.shade300;
      nodeIcon = Icons.radio_button_unchecked;
    } else if (isClaimed) {
      nodeColor = color;
      nodeIcon = Icons.check_circle;
    } else if (isCompleted) {
      nodeColor = AppTheme.coinGold;
      nodeIcon = Icons.stars;
    } else if (isActive) {
      nodeColor = color;
      nodeIcon = Icons.radio_button_checked;
    } else {
      nodeColor = Colors.grey.shade400;
      nodeIcon = Icons.radio_button_unchecked;
    }

    final textColor = isLocked
        ? Colors.grey.shade400
        : isClaimed
            ? AppTheme.darkText.withValues(alpha: 0.5)
            : AppTheme.darkText;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 28,
          child: Column(
            children: [
              Icon(nodeIcon, size: 18, color: nodeColor),
              if (!isLast)
                Container(
                  width: 2,
                  height: 28,
                  color: isLocked
                      ? Colors.grey.shade200
                      : isClaimed
                          ? color.withValues(alpha: 0.4)
                          : Colors.grey.shade300,
                ),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(bottom: isLast ? 0 : 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  missionTitle(context, mission),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                    color: textColor,
                    decoration: isClaimed ? TextDecoration.lineThrough : null,
                  ),
                ),
                if (!isLocked) RewardBadges(reward: mission.reward),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
