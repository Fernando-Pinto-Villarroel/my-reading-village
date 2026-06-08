import 'package:my_reading_village/domain/entities/mission.dart';

class HolidayEvent {
  final String id;
  final MissionBranch branch;
  final int startMonth;
  final int startDay;
  final int endMonth;
  final int endDay;

  const HolidayEvent({
    required this.id,
    required this.branch,
    required this.startMonth,
    required this.startDay,
    required this.endMonth,
    required this.endDay,
  });

  bool isActive(DateTime now) {
    final start = DateTime(now.year, startMonth, startDay);
    final end = DateTime(now.year, endMonth, endDay, 23, 59, 59);
    return !now.isBefore(start) && !now.isAfter(end);
  }

  DateTime eventEnd(DateTime now) =>
      DateTime(now.year, endMonth, endDay, 23, 59, 59);

  int daysRemaining(DateTime now) {
    final end = DateTime(now.year, endMonth, endDay, 23, 59, 59);
    final diff = end.difference(DateTime(now.year, now.month, now.day));
    return diff.inDays.clamp(0, 9999);
  }
}

class HolidayRules {
  static const List<HolidayEvent> allEvents = [
    HolidayEvent(
      id: 'halloween',
      branch: MissionBranch.halloween,
      startMonth: 10,
      startDay: 1,
      endMonth: 10,
      endDay: 31,
    ),
    HolidayEvent(
      id: 'thanksgiving',
      branch: MissionBranch.thanksgiving,
      startMonth: 11,
      startDay: 1,
      endMonth: 11,
      endDay: 30,
    ),
    HolidayEvent(
      id: 'christmas',
      branch: MissionBranch.christmas,
      startMonth: 12,
      startDay: 1,
      endMonth: 12,
      endDay: 31,
    ),
    HolidayEvent(
      id: 'new_year',
      branch: MissionBranch.newYear,
      startMonth: 1,
      startDay: 1,
      endMonth: 1,
      endDay: 15,
    ),
    HolidayEvent(
      id: 'san_valentin',
      branch: MissionBranch.sanValentin,
      startMonth: 2,
      startDay: 1,
      endMonth: 2,
      endDay: 14,
    ),
    HolidayEvent(
      id: 'carnival',
      branch: MissionBranch.carnival,
      startMonth: 2,
      startDay: 15,
      endMonth: 3,
      endDay: 15,
    ),
    HolidayEvent(
      id: 'easter',
      branch: MissionBranch.easter,
      startMonth: 4,
      startDay: 1,
      endMonth: 4,
      endDay: 30,
    ),
    HolidayEvent(
      id: 'workers_day',
      branch: MissionBranch.workersDay,
      startMonth: 5,
      startDay: 1,
      endMonth: 5,
      endDay: 15,
    ),
    HolidayEvent(
      id: 'environment_day',
      branch: MissionBranch.environmentDay,
      startMonth: 6,
      startDay: 1,
      endMonth: 6,
      endDay: 15,
    ),
    HolidayEvent(
      id: 'chocolate_day',
      branch: MissionBranch.chocolateDay,
      startMonth: 7,
      startDay: 1,
      endMonth: 7,
      endDay: 10,
    ),
    HolidayEvent(
      id: 'friendship_day',
      branch: MissionBranch.friendshipDay,
      startMonth: 7,
      startDay: 20,
      endMonth: 7,
      endDay: 31,
    ),
    HolidayEvent(
      id: 'youth_day',
      branch: MissionBranch.youthDay,
      startMonth: 8,
      startDay: 1,
      endMonth: 8,
      endDay: 15,
    ),
    HolidayEvent(
      id: 'literacy_day',
      branch: MissionBranch.literacyDay,
      startMonth: 9,
      startDay: 1,
      endMonth: 9,
      endDay: 30,
    ),
  ];

  static List<String>? speciesChainForEvent(String eventId) {
    switch (eventId) {
      case 'new_year':
        return ['lion', 'tiger'];
      case 'thanksgiving':
        return ['turkey', 'cow'];
      case 'christmas':
        return ['polar_bear', 'reindeer'];
      default:
        return null;
    }
  }

  static bool isHolidayBranch(MissionBranch branch) =>
      allEvents.any((e) => e.branch == branch);

  static HolidayEvent? eventForBranch(MissionBranch branch) {
    try {
      return allEvents.firstWhere((e) => e.branch == branch);
    } catch (_) {
      return null;
    }
  }

  static List<HolidayEvent> activeEvents(DateTime now) =>
      allEvents.where((e) => e.isActive(now)).toList();

  static String eventMonthRangeKey(HolidayEvent event) => event.id;
}
