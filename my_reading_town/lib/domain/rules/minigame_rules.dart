import 'dart:math';
import 'package:my_reading_town/app_constants.dart';

class MinigameRules {
  static const Map<String, MinigameConfig> configs = {
    'guess_author': MinigameConfig(winsNeeded: 5, cooldownHours: 4),
    'match_character_role': MinigameConfig(winsNeeded: 10, cooldownHours: 5),
    'first_or_last_line': MinigameConfig(winsNeeded: 7, cooldownHours: 4),
    'book_or_not': MinigameConfig(winsNeeded: 6, cooldownHours: 4),
  };

  static const Map<String, double> rewardWeights = {
    'coins_10': 0.22,
    'coins_20': 0.15,
    'coins_30': 0.10,
    'wood_10': 0.18,
    'wood_20': 0.10,
    'gems_5': 0.10,
    'book': 0.06,
    'sandwich': 0.05,
    'hammer': 0.03,
    'glasses': 0.01,
  };

  static Map<String, double> get _effectiveWeights {
    if (!AppConstants.testMode) return rewardWeights;
    final entries = rewardWeights.entries.toList()
      ..sort((a, b) => a.value.compareTo(b.value));
    final reversedValues = entries.map((e) => e.value).toList().reversed.toList();
    return {
      for (int i = 0; i < entries.length; i++) entries[i].key: reversedValues[i]
    };
  }

  static String pickRewardType(Random random) {
    final weights = _effectiveWeights;
    final keys = weights.keys.toList();
    final roll = random.nextDouble();
    double cumulative = 0.0;
    for (int i = 0; i < keys.length; i++) {
      cumulative += weights[keys[i]] ?? 0.0;
      if (roll < cumulative) return keys[i];
    }
    return keys.last;
  }
}

class MinigameConfig {
  final int winsNeeded;
  final int cooldownHours;

  const MinigameConfig({required this.winsNeeded, required this.cooldownHours});
}
