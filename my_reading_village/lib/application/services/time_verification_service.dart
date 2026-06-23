import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:my_reading_village/infrastructure/persistence/database_helper.dart';

class TimeVerificationService {
  final DatabaseHelper _db;

  final Stopwatch _stopwatch = Stopwatch();
  DateTime? _sessionStart;
  bool _isSuspicious = false;
  bool _dismissed = false;
  bool _lastSyncSucceeded = false;
  Future<void>? _initFuture;

  int _pendingFraudCount = 0;
  DateTime? _restoreTarget;

  TimeVerificationService(this._db);

  bool get isSuspicious => _isSuspicious && !_dismissed;
  void dismissForSession() => _dismissed = true;

  bool get hasPendingFraudDecision => _pendingFraudCount > 0;
  int get pendingFraudCount => _pendingFraudCount;
  DateTime? get restoreTarget => _restoreTarget;

  DateTime trustedNow() {
    if (_sessionStart == null) return DateTime.now();
    return _sessionStart!.add(_stopwatch.elapsed);
  }

  Future<void> ensureInitialized() => _initFuture ??= _initialize();

  Future<void> _initialize() async {
    final lastSeen = await _db.getLastSeenAt();
    final deviceNow = DateTime.now();
    if (lastSeen != null &&
        deviceNow.isBefore(lastSeen.subtract(const Duration(minutes: 5)))) {
      _isSuspicious = true;
    }

    await _db.setLastSeenAt(deviceNow);

    _sessionStart = deviceNow;
    _stopwatch.start();

    await _syncWithNetwork();
    await _evaluateFraud(lastSeen);
  }

  Future<({int rolledBack, bool pendingDecision})> onResume() async {
    final deviceNow = DateTime.now();
    final trusted = trustedNow();
    final drift = deviceNow.difference(trusted);

    if (drift > const Duration(minutes: 2)) {
      _sessionStart = deviceNow;
      _stopwatch.reset();
      _stopwatch.start();
    } else if (drift < const Duration(minutes: -2)) {
      _isSuspicious = true;
      _dismissed = false;
    }

    await _syncWithNetwork();
    final rolledBack = await _evaluateFraud(null);
    await _db.setLastSeenAt(deviceNow);
    return (rolledBack: rolledBack, pendingDecision: hasPendingFraudDecision);
  }

  Future<void> onPause() async {
    await _db.setLastSeenAt(DateTime.now());
  }

  Future<int> _evaluateFraud(DateTime? previousLastSeen) async {
    final info = await _db.getFraudulentConstructionsInfo(trustedNow());
    if (info.count == 0) {
      _pendingFraudCount = 0;
      return 0;
    }

    _isSuspicious = true;
    _dismissed = false;

    if (_lastSyncSucceeded) {
      final rolledBack =
          await _db.rollbackFraudulentConstructions(trustedNow());
      _pendingFraudCount = 0;
      return rolledBack;
    }

    _pendingFraudCount = info.count;
    var target = info.latestTimestamp;
    if (previousLastSeen != null &&
        (target == null || previousLastSeen.isAfter(target))) {
      target = previousLastSeen;
    }
    _restoreTarget = target;
    return 0;
  }

  Future<int> acceptPendingRollback() async {
    final rolledBack = await _db.rollbackFraudulentConstructions(trustedNow());
    _pendingFraudCount = 0;
    return rolledBack;
  }

  Future<void> _syncWithNetwork() async {
    _lastSyncSucceeded = false;
    try {
      final response = await http
          .head(Uri.parse('https://www.google.com'))
          .timeout(const Duration(seconds: 5));
      final dateStr = response.headers['date'];
      if (dateStr == null) return;
      final serverTime = HttpDate.parse(dateStr).toLocal();
      final drift = DateTime.now().difference(serverTime);
      if (drift.abs() > const Duration(minutes: 5)) {
        _isSuspicious = true;
        _dismissed = false;
        _sessionStart = serverTime;
        _stopwatch.reset();
        _stopwatch.start();
      } else {
        _isSuspicious = false;
        _sessionStart = serverTime;
        _stopwatch.reset();
        _stopwatch.start();
      }
      await _db.setLastTrustedAt(serverTime);
      _lastSyncSucceeded = true;
    } catch (_) {}
  }
}
