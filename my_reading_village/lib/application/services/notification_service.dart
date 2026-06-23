import 'dart:math';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static const int _dailyBaseId = 1000;
  static const int _maxDailySlots = 70;
  static const int _constructionBaseId = 2000;
  static const int _minigameBaseId = 3000;
  static const int _rouletteId = 4000;
  static const int _eventBaseId = 5000;
  static const int _eventNotifsPerEvent = 3;
  static const int _storeDiscountBaseId = 6000;
  static const int _maxStoreDiscountSlots = 10;

  static const String _dailyChannelId = 'daily_reminder';
  static const String _dailyChannelName = 'Daily Reading Reminder';
  static const String _constructionChannelId = 'construction';
  static const String _constructionChannelName = 'Construction Updates';
  static const String _minigameChannelId = 'minigame_available';
  static const String _minigameChannelName = 'Minigame Available';
  static const String _rouletteChannelId = 'roulette_spin';
  static const String _rouletteChannelName = 'Roulette Spin';
  static const String _eventChannelId = 'event_reminder';
  static const String _eventChannelName = 'Event Reminders';
  static const String _storeDiscountChannelId = 'store_discount';
  static const String _storeDiscountChannelName = 'Store Discounts';

  static const Map<String, int> _minigameNotifIds = {
    'guess_author': _minigameBaseId,
    'match_character_role': _minigameBaseId + 1,
  };

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  tz.TZDateTime _fromDeviceMs(int epochMs) =>
      tz.TZDateTime.fromMillisecondsSinceEpoch(tz.local, epochMs);

  AndroidNotificationDetails _androidDetails(
      String channelId, String channelName) {
    return AndroidNotificationDetails(
      channelId,
      channelName,
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/launcher_icon',
      sound: const RawResourceAndroidNotificationSound('mobile_notification'),
    );
  }

  Future<void> initialize() async {
    if (_initialized) return;
    tz_data.initializeTimeZones();
    const androidSettings =
        AndroidInitializationSettings('@mipmap/launcher_icon');
    const initSettings = InitializationSettings(android: androidSettings);
    await _plugin.initialize(settings: initSettings);
    _initialized = true;
  }

  Future<void> requestPermission() async {
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (android == null) return;
    await android.requestNotificationsPermission();
    await android.requestExactAlarmsPermission();
  }

  Future<void> cancelAllDailyReminders() async {
    if (!_initialized) return;
    for (int i = _dailyBaseId; i < _dailyBaseId + _maxDailySlots; i++) {
      await _plugin.cancel(id: i);
    }
  }

  Future<void> scheduleNotifications({
    required List<bool> activeDays,
    required int startHour,
    required int endHour,
    required int notificationsPerDay,
    required List<Map<String, String>> messages,
  }) async {
    if (!_initialized) return;
    await cancelAllDailyReminders();

    if (messages.isEmpty) return;
    final range = endHour - startHour;
    if (range <= 0) return;

    final random = Random();
    final now = DateTime.now();
    int notifId = _dailyBaseId;

    final totalMinutes = range * 60;
    final slotMinutes =
        notificationsPerDay > 0 ? totalMinutes ~/ notificationsPerDay : totalMinutes;

    for (int dayOffset = 0; dayOffset < 7; dayOffset++) {
      if (notifId >= _dailyBaseId + _maxDailySlots) break;
      final targetDay = now.add(Duration(days: dayOffset));
      final dayIndex = targetDay.weekday - 1;
      if (dayIndex < 0 || dayIndex >= activeDays.length) continue;
      if (!activeDays[dayIndex]) continue;

      for (int n = 0; n < notificationsPerDay; n++) {
        if (notifId >= _dailyBaseId + _maxDailySlots) break;
        final slotOffsetMinutes = slotMinutes > 0
            ? n * slotMinutes + random.nextInt(slotMinutes)
            : random.nextInt(totalMinutes > 0 ? totalMinutes : 1);
        final randomHour = startHour + slotOffsetMinutes ~/ 60;
        final randomMinute = slotOffsetMinutes % 60;

        final target = DateTime(
          targetDay.year,
          targetDay.month,
          targetDay.day,
          randomHour,
          randomMinute,
        );

        if (!target.isAfter(now)) continue;

        final msgIndex = random.nextInt(messages.length);
        final msg = messages[msgIndex];

        final scheduledDate = _fromDeviceMs(target.millisecondsSinceEpoch);
        await _plugin.zonedSchedule(
          id: notifId++,
          title: msg['title'] ?? '',
          body: msg['body'] ?? '',
          scheduledDate: scheduledDate,
          notificationDetails: NotificationDetails(
            android: _androidDetails(_dailyChannelId, _dailyChannelName),
          ),
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        );
      }
    }
  }

  Future<void> scheduleConstructionComplete({
    required int buildingId,
    required String buildingName,
    required Duration remaining,
    required String title,
    required String body,
  }) async {
    if (!_initialized) return;
    final notificationId = _constructionBaseId + buildingId;
    await _plugin.cancel(id: notificationId);
    if (remaining <= Duration.zero) return;
    final scheduledDate =
        _fromDeviceMs(DateTime.now().add(remaining).millisecondsSinceEpoch);
    await _plugin.zonedSchedule(
      id: notificationId,
      title: title,
      body: '$buildingName $body',
      scheduledDate: scheduledDate,
      notificationDetails: NotificationDetails(
        android: _androidDetails(_constructionChannelId, _constructionChannelName),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  Future<void> cancelConstructionNotification(int buildingId) async {
    if (!_initialized) return;
    await _plugin.cancel(id: _constructionBaseId + buildingId);
  }

  Future<void> scheduleMinigameAvailable({
    required String minigameId,
    required Duration remaining,
    required String title,
    required String body,
  }) async {
    if (!_initialized) return;
    final notifId = _minigameNotifIds[minigameId];
    if (notifId == null) return;
    await _plugin.cancel(id: notifId);
    if (remaining <= Duration.zero) return;
    final scheduledDate =
        _fromDeviceMs(DateTime.now().add(remaining).millisecondsSinceEpoch);
    await _plugin.zonedSchedule(
      id: notifId,
      title: title,
      body: body,
      scheduledDate: scheduledDate,
      notificationDetails: NotificationDetails(
        android: _androidDetails(_minigameChannelId, _minigameChannelName),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  Future<void> scheduleRouletteFreeSpin({
    required Duration remaining,
    required String title,
    required String body,
  }) async {
    if (!_initialized) return;
    await _plugin.cancel(id: _rouletteId);
    if (remaining <= Duration.zero) return;
    final scheduledDate =
        _fromDeviceMs(DateTime.now().add(remaining).millisecondsSinceEpoch);
    await _plugin.zonedSchedule(
      id: _rouletteId,
      title: title,
      body: body,
      scheduledDate: scheduledDate,
      notificationDetails: NotificationDetails(
        android: _androidDetails(_rouletteChannelId, _rouletteChannelName),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  Future<void> scheduleEventReminders({
    required int eventIndex,
    required List<({DateTime scheduledAt, String title, String body})> notifications,
  }) async {
    if (!_initialized) return;
    final base = _eventBaseId + eventIndex * _eventNotifsPerEvent;
    for (int i = 0; i < _eventNotifsPerEvent; i++) {
      await _plugin.cancel(id: base + i);
    }
    final now = DateTime.now();
    int slot = 0;
    for (final n in notifications) {
      if (slot >= _eventNotifsPerEvent) break;
      if (!n.scheduledAt.isAfter(now)) continue;
      await _plugin.zonedSchedule(
        id: base + slot,
        title: n.title,
        body: n.body,
        scheduledDate: _fromDeviceMs(n.scheduledAt.millisecondsSinceEpoch),
        notificationDetails: NotificationDetails(
          android: _androidDetails(_eventChannelId, _eventChannelName),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );
      slot++;
    }
  }

  Future<void> scheduleStoreDiscountNotifications({
    required List<({DateTime scheduledAt, String title, String body})> notifications,
  }) async {
    if (!_initialized) return;
    for (int i = 0; i < _maxStoreDiscountSlots; i++) {
      await _plugin.cancel(id: _storeDiscountBaseId + i);
    }
    final now = DateTime.now();
    int slot = 0;
    for (final n in notifications) {
      if (slot >= _maxStoreDiscountSlots) break;
      if (!n.scheduledAt.isAfter(now)) continue;
      await _plugin.zonedSchedule(
        id: _storeDiscountBaseId + slot,
        title: n.title,
        body: n.body,
        scheduledDate: _fromDeviceMs(n.scheduledAt.millisecondsSinceEpoch),
        notificationDetails: NotificationDetails(
          android: _androidDetails(_storeDiscountChannelId, _storeDiscountChannelName),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );
      slot++;
    }
  }

  Future<void> cancelEventReminders(int eventIndex) async {
    if (!_initialized) return;
    final base = _eventBaseId + eventIndex * _eventNotifsPerEvent;
    for (int i = 0; i < _eventNotifsPerEvent; i++) {
      await _plugin.cancel(id: base + i);
    }
  }
}
