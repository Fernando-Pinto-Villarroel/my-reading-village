enum SecretRewardType { coins, gems, wood, metal, item, species }

class SecretReward {
  final SecretRewardType type;
  final int amount;
  final String? itemType;
  final String? speciesId;

  const SecretReward({
    required this.type,
    this.amount = 1,
    this.itemType,
    this.speciesId,
  });

  const SecretReward.coins(int amt)
      : type = SecretRewardType.coins,
        amount = amt,
        itemType = null,
        speciesId = null;

  const SecretReward.gems(int amt)
      : type = SecretRewardType.gems,
        amount = amt,
        itemType = null,
        speciesId = null;

  const SecretReward.wood(int amt)
      : type = SecretRewardType.wood,
        amount = amt,
        itemType = null,
        speciesId = null;

  const SecretReward.metal(int amt)
      : type = SecretRewardType.metal,
        amount = amt,
        itemType = null,
        speciesId = null;

  const SecretReward.item(String item, [int qty = 1])
      : type = SecretRewardType.item,
        amount = qty,
        itemType = item,
        speciesId = null;

  const SecretReward.species(String id)
      : type = SecretRewardType.species,
        amount = 1,
        itemType = null,
        speciesId = id;
}

class SecretCode {
  final String code;
  final List<SecretReward> rewards;
  const SecretCode({required this.code, required this.rewards});
}

class SecretCodesRules {
  static const List<SecretCode> allCodes = [
    SecretCode(
      code: 'GWF-CHE-SDI',
      rewards: [
        SecretReward.item('hammer'),
        SecretReward.gems(5),
      ],
    ),
    SecretCode(
      code: 'MAX-BRA-YAN',
      rewards: [
        SecretReward.species('grizzly_bear'),
        SecretReward.species('panda_bear'),
        SecretReward.item('glasses'),
      ],
    ),
    SecretCode(
      code: 'LOR-ENA-AMU',
      rewards: [
        SecretReward.species('lion'),
        SecretReward.item('glasses', 3),
        SecretReward.item('sandwich', 2),
      ],
    ),
    SecretCode(
      code: 'PNK-MNT-LAV',
      rewards: [
        SecretReward.coins(500),
        SecretReward.wood(100),
      ],
    ),
    SecretCode(
      code: 'SKY-BLU-PCT',
      rewards: [
        SecretReward.item('glasses', 2),
        SecretReward.item('book', 2),
      ],
    ),
    SecretCode(
      code: 'RDG-TWN-MRT',
      rewards: [
        SecretReward.gems(15),
        SecretReward.item('hammer', 2),
      ],
    ),
    SecretCode(
      code: 'CAT-DOG-RBT',
      rewards: [
        SecretReward.item('sandwich', 3),
        SecretReward.coins(200),
      ],
    ),
    SecretCode(
      code: 'STR-GZR-XYZ',
      rewards: [
        SecretReward.species('polar_bear'),
        SecretReward.gems(10),
      ],
    ),
    SecretCode(
      code: 'KWI-PLM-FNT',
      rewards: [
        SecretReward.coins(1000),
        SecretReward.metal(150),
      ],
    ),
    SecretCode(
      code: 'DMN-TGR-FXX',
      rewards: [
        SecretReward.species('tiger'),
        SecretReward.item('sandwich'),
        SecretReward.item('hammer'),
      ],
    ),
  ];

  static SecretCode? findCode(String input) {
    final normalized = input.trim().toUpperCase();
    for (final code in allCodes) {
      if (code.code.toUpperCase() == normalized) return code;
    }
    return null;
  }
}
