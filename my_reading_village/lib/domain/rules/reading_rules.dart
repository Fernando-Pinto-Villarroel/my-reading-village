class ReadingRules {
  static const int dailyPageCelebrationThreshold = 200;
  static const int coinsPerPage = 3;
  static const int woodPerPage = 2;
  static const int metalPerPage = 1;
  static const int bookCompletionGemBonusDefault = 10;
  static const int bookCompletionCoinBonus = 30;

  static int bookCompletionGems(int totalPages) {
    if (totalPages < 50) return 0;
    if (totalPages < 100) return 2;
    if (totalPages < 200) return 5;
    if (totalPages < 350) return 10;
    if (totalPages < 500) return 13;
    return 18;
  }

  static Map<String, int> calculatePageRewards({
    required int actualPagesLogged,
    required bool isBookNowCompleted,
    required bool wasAlreadyCompleted,
    required int bookTotalPages,
  }) {
    if (actualPagesLogged <= 0) {
      return {'coins': 0, 'gems': 0, 'wood': 0, 'metal': 0, 'exp': 0};
    }

    int coinsEarned = actualPagesLogged * coinsPerPage;
    int gemsEarned = 0;
    int woodEarned = actualPagesLogged * woodPerPage;
    int metalEarned = actualPagesLogged * metalPerPage;

    if (isBookNowCompleted && !wasAlreadyCompleted) {
      coinsEarned += bookCompletionCoinBonus;
      gemsEarned += bookCompletionGems(bookTotalPages);
    }

    return {
      'coins': coinsEarned,
      'gems': gemsEarned,
      'wood': woodEarned,
      'metal': metalEarned,
      'exp': 0,
    };
  }
}
