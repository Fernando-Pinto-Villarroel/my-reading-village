import 'dart:math';

enum VillagerRarity { common, rare, extraordinary, legendary, godly }

class VillagerSpeciesData {
  final String id;
  final VillagerRarity rarity;
  final String unlockType;
  final int? unlockLevel;
  final double? realPrice;
  final String nameKey;
  final String descriptionKey;

  const VillagerSpeciesData({
    required this.id,
    required this.rarity,
    required this.unlockType,
    this.unlockLevel,
    this.realPrice,
    required this.nameKey,
    required this.descriptionKey,
  });
}

class SpeciesRules {
  static const double speciesBonusProbability = 0.005;
  static const int duplicateSpeciesGemCompensation = 20;

  static const List<VillagerSpeciesData> allSpecies = [
    VillagerSpeciesData(
      id: 'cat', rarity: VillagerRarity.common, unlockType: 'starter',
      nameKey: 'species_cat', descriptionKey: 'species_desc_cat',
    ),
    VillagerSpeciesData(
      id: 'dog', rarity: VillagerRarity.common, unlockType: 'starter',
      nameKey: 'species_dog', descriptionKey: 'species_desc_dog',
    ),
    VillagerSpeciesData(
      id: 'rabbit', rarity: VillagerRarity.common, unlockType: 'starter',
      nameKey: 'species_rabbit', descriptionKey: 'species_desc_rabbit',
    ),
    VillagerSpeciesData(
      id: 'koala', rarity: VillagerRarity.common, unlockType: 'level',
      unlockLevel: 4, nameKey: 'species_koala', descriptionKey: 'species_desc_koala',
    ),
    VillagerSpeciesData(
      id: 'raccoon', rarity: VillagerRarity.common, unlockType: 'level',
      unlockLevel: 8, nameKey: 'species_raccoon', descriptionKey: 'species_desc_raccoon',
    ),
    VillagerSpeciesData(
      id: 'elephant', rarity: VillagerRarity.common, unlockType: 'level',
      unlockLevel: 12, nameKey: 'species_elephant', descriptionKey: 'species_desc_elephant',
    ),
    VillagerSpeciesData(
      id: 'duck', rarity: VillagerRarity.common, unlockType: 'level',
      unlockLevel: 16, nameKey: 'species_duck', descriptionKey: 'species_desc_duck',
    ),
    VillagerSpeciesData(
      id: 'pig', rarity: VillagerRarity.common, unlockType: 'level',
      unlockLevel: 20, nameKey: 'species_pig', descriptionKey: 'species_desc_pig',
    ),
    VillagerSpeciesData(
      id: 'hamster', rarity: VillagerRarity.common, unlockType: 'level',
      unlockLevel: 24, nameKey: 'species_hamster', descriptionKey: 'species_desc_hamster',
    ),
    VillagerSpeciesData(
      id: 'platypus', rarity: VillagerRarity.common, unlockType: 'level',
      unlockLevel: 28, nameKey: 'species_platypus', descriptionKey: 'species_desc_platypus',
    ),
    VillagerSpeciesData(
      id: 'grizzly_bear', rarity: VillagerRarity.rare, unlockType: 'special',
      realPrice: 0.99, nameKey: 'species_grizzly_bear', descriptionKey: 'species_desc_grizzly_bear',
    ),
    VillagerSpeciesData(
      id: 'polar_bear', rarity: VillagerRarity.rare, unlockType: 'special',
      realPrice: 0.99, nameKey: 'species_polar_bear', descriptionKey: 'species_desc_polar_bear',
    ),
    VillagerSpeciesData(
      id: 'panda_bear', rarity: VillagerRarity.rare, unlockType: 'special',
      realPrice: 0.99, nameKey: 'species_panda_bear', descriptionKey: 'species_desc_panda_bear',
    ),
    VillagerSpeciesData(
      id: 'red_panda', rarity: VillagerRarity.rare, unlockType: 'special',
      realPrice: 0.99, nameKey: 'species_red_panda', descriptionKey: 'species_desc_red_panda',
    ),
    VillagerSpeciesData(
      id: 'sloth', rarity: VillagerRarity.rare, unlockType: 'special',
      realPrice: 0.99, nameKey: 'species_sloth', descriptionKey: 'species_desc_sloth',
    ),
    VillagerSpeciesData(
      id: 'hedgehog', rarity: VillagerRarity.rare, unlockType: 'special',
      realPrice: 0.99, nameKey: 'species_hedgehog', descriptionKey: 'species_desc_hedgehog',
    ),
    VillagerSpeciesData(
      id: 'capybara', rarity: VillagerRarity.rare, unlockType: 'special',
      realPrice: 0.99, nameKey: 'species_capybara', descriptionKey: 'species_desc_capybara',
    ),
    VillagerSpeciesData(
      id: 'cow', rarity: VillagerRarity.rare, unlockType: 'special',
      realPrice: 0.99, nameKey: 'species_cow', descriptionKey: 'species_desc_cow',
    ),
    VillagerSpeciesData(
      id: 'sheep', rarity: VillagerRarity.rare, unlockType: 'special',
      realPrice: 0.99, nameKey: 'species_sheep', descriptionKey: 'species_desc_sheep',
    ),
    VillagerSpeciesData(
      id: 'bull', rarity: VillagerRarity.extraordinary, unlockType: 'special',
      realPrice: 2.99, nameKey: 'species_bull', descriptionKey: 'species_desc_bull',
    ),
    VillagerSpeciesData(
      id: 'otter', rarity: VillagerRarity.extraordinary, unlockType: 'special',
      realPrice: 2.99, nameKey: 'species_otter', descriptionKey: 'species_desc_otter',
    ),
    VillagerSpeciesData(
      id: 'kangaroo', rarity: VillagerRarity.extraordinary, unlockType: 'special',
      realPrice: 2.99, nameKey: 'species_kangaroo', descriptionKey: 'species_desc_kangaroo',
    ),
    VillagerSpeciesData(
      id: 'reindeer', rarity: VillagerRarity.extraordinary, unlockType: 'special',
      realPrice: 2.99, nameKey: 'species_reindeer', descriptionKey: 'species_desc_reindeer',
    ),
    VillagerSpeciesData(
      id: 'ferret', rarity: VillagerRarity.extraordinary, unlockType: 'special',
      realPrice: 2.99, nameKey: 'species_ferret', descriptionKey: 'species_desc_ferret',
    ),
    VillagerSpeciesData(
      id: 'mole', rarity: VillagerRarity.extraordinary, unlockType: 'special',
      realPrice: 2.99, nameKey: 'species_mole', descriptionKey: 'species_desc_mole',
    ),
    VillagerSpeciesData(
      id: 'bat', rarity: VillagerRarity.extraordinary, unlockType: 'special',
      realPrice: 2.99, nameKey: 'species_bat', descriptionKey: 'species_desc_bat',
    ),
    VillagerSpeciesData(
      id: 'donkey', rarity: VillagerRarity.extraordinary, unlockType: 'special',
      realPrice: 2.99, nameKey: 'species_donkey', descriptionKey: 'species_desc_donkey',
    ),
    VillagerSpeciesData(
      id: 'turkey', rarity: VillagerRarity.extraordinary, unlockType: 'special',
      realPrice: 2.99, nameKey: 'species_turkey', descriptionKey: 'species_desc_turkey',
    ),
    VillagerSpeciesData(
      id: 'monkey', rarity: VillagerRarity.legendary, unlockType: 'special',
      realPrice: 5.99, nameKey: 'species_monkey', descriptionKey: 'species_desc_monkey',
    ),
    VillagerSpeciesData(
      id: 'gorilla', rarity: VillagerRarity.legendary, unlockType: 'special',
      realPrice: 5.99, nameKey: 'species_gorilla', descriptionKey: 'species_desc_gorilla',
    ),
    VillagerSpeciesData(
      id: 'zebra', rarity: VillagerRarity.legendary, unlockType: 'special',
      realPrice: 5.99, nameKey: 'species_zebra', descriptionKey: 'species_desc_zebra',
    ),
    VillagerSpeciesData(
      id: 'horse', rarity: VillagerRarity.legendary, unlockType: 'special',
      realPrice: 5.99, nameKey: 'species_horse', descriptionKey: 'species_desc_horse',
    ),
    VillagerSpeciesData(
      id: 'skunk', rarity: VillagerRarity.legendary, unlockType: 'special',
      realPrice: 5.99, nameKey: 'species_skunk', descriptionKey: 'species_desc_skunk',
    ),
    VillagerSpeciesData(
      id: 'hyena', rarity: VillagerRarity.legendary, unlockType: 'special',
      realPrice: 5.99, nameKey: 'species_hyena', descriptionKey: 'species_desc_hyena',
    ),
    VillagerSpeciesData(
      id: 'mouse', rarity: VillagerRarity.legendary, unlockType: 'special',
      realPrice: 5.99, nameKey: 'species_mouse', descriptionKey: 'species_desc_mouse',
    ),
    VillagerSpeciesData(
      id: 'lion', rarity: VillagerRarity.godly, unlockType: 'special',
      realPrice: 9.99, nameKey: 'species_lion', descriptionKey: 'species_desc_lion',
    ),
    VillagerSpeciesData(
      id: 'armadillo', rarity: VillagerRarity.godly, unlockType: 'special',
      realPrice: 9.99, nameKey: 'species_armadillo', descriptionKey: 'species_desc_armadillo',
    ),
    VillagerSpeciesData(
      id: 'beaver', rarity: VillagerRarity.godly, unlockType: 'special',
      realPrice: 9.99, nameKey: 'species_beaver', descriptionKey: 'species_desc_beaver',
    ),
    VillagerSpeciesData(
      id: 'fox', rarity: VillagerRarity.godly, unlockType: 'special',
      realPrice: 9.99, nameKey: 'species_fox', descriptionKey: 'species_desc_fox',
    ),
    VillagerSpeciesData(
      id: 'tiger', rarity: VillagerRarity.godly, unlockType: 'special',
      realPrice: 9.99, nameKey: 'species_tiger', descriptionKey: 'species_desc_tiger',
    ),
    VillagerSpeciesData(
      id: 'leopard', rarity: VillagerRarity.godly, unlockType: 'special',
      realPrice: 9.99, nameKey: 'species_leopard', descriptionKey: 'species_desc_leopard',
    ),
  ];

  static const List<String> starterSpecies = ['cat', 'dog', 'rabbit'];

  static VillagerSpeciesData? findById(String id) {
    try {
      return allSpecies.firstWhere((s) => s.id == id);
    } catch (_) {
      return null;
    }
  }

  static String? speciesUnlockedAtLevel(int level) {
    for (final s in allSpecies) {
      if (s.unlockType == 'level' && s.unlockLevel == level) return s.id;
    }
    return null;
  }

  static List<VillagerSpeciesData> getByRarity(VillagerRarity rarity) =>
      allSpecies.where((s) => s.rarity == rarity).toList();

  static List<VillagerSpeciesData> getSpecialSpecies() =>
      allSpecies.where((s) => s.unlockType == 'special').toList();

  static List<VillagerSpeciesData> getAvailableForStore(List<String> unlockedIds) {
    final today = DateTime.now();
    final dayseed = today.year * 10000 + today.month * 100 + today.day;
    final result = <VillagerSpeciesData>[];
    for (final rarity in [
      VillagerRarity.rare,
      VillagerRarity.extraordinary,
      VillagerRarity.legendary,
      VillagerRarity.godly,
    ]) {
      final pool = allSpecies
          .where((s) => s.rarity == rarity && !unlockedIds.contains(s.id))
          .toList();
      if (pool.isEmpty) continue;
      final rng = Random(dayseed + rarity.index);
      pool.shuffle(rng);
      result.add(pool.first);
    }
    return result;
  }

  static List<VillagerSpeciesData> getNonCommonNonOwned(List<String> unlockedIds) {
    return allSpecies
        .where((s) => s.rarity != VillagerRarity.common && !unlockedIds.contains(s.id))
        .toList();
  }

  static VillagerSpeciesData? pickRandomSpeciesReward(
      List<String> unlockedIds, Random random) {
    final available = getNonCommonNonOwned(unlockedIds);
    if (available.isEmpty) return null;
    return available[random.nextInt(available.length)];
  }

  static bool rollSpeciesBonus(Random random) =>
      random.nextDouble() < speciesBonusProbability;

  static VillagerSpeciesData? weeklySpeciesReward() {
    final now = DateTime.now();
    final seed = now.year * 100 + _isoWeek(now);
    final rng = Random(seed);
    final pool = allSpecies.where((s) => s.rarity != VillagerRarity.common).toList();
    if (pool.isEmpty) return null;
    return pool[rng.nextInt(pool.length)];
  }

  static int _isoWeek(DateTime date) {
    final doy = date.difference(DateTime(date.year, 1, 1)).inDays + 1;
    return ((doy - date.weekday + 10) / 7).floor();
  }

  static String productIdForSpecies(String speciesId) => 'species_$speciesId';

  static String rarityKey(VillagerRarity rarity) {
    switch (rarity) {
      case VillagerRarity.common: return 'rarity_common';
      case VillagerRarity.rare: return 'rarity_rare';
      case VillagerRarity.extraordinary: return 'rarity_extraordinary';
      case VillagerRarity.legendary: return 'rarity_legendary';
      case VillagerRarity.godly: return 'rarity_godly';
    }
  }
}
