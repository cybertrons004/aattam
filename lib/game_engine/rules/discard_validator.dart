import '../enums/card_rank.dart';
import '../enums/card_suit.dart';
import '../models/discard_action.dart';
import '../models/game_card.dart';

class DiscardValidator {
  static bool isValidDiscard(
    DiscardAction action,
  ) {
    if (action.mainCards.isEmpty) {
      return false;
    }

    final validPowerCards =
        _validatePowerCards(
      action.powerCards,
    );

    if (!validPowerCards) {
      return false;
    }

    // Single card including Joker
    if (action.mainCards.length == 1) {
      return true;
    }

    return _isSet(
          action.mainCards,
        ) ||
        _isPureSequence(
          action.mainCards,
        ) ||
        _isImpureSequence(
          action.mainCards,
        );
  }

  static bool _validatePowerCards(
    List<GameCard> cards,
  ) {
    for (final card in cards) {
      final valid =
          !card.isJoker &&
              card.rank ==
                  CardRank.king;

      if (!valid) {
        return false;
      }
    }

    return true;
  }

  static bool _isSet(
    List<GameCard> cards,
  ) {
    if (cards.length < 2) {
      return false;
    }

    final nonJokers =
        cards
            .where(
              (c) => !c.isJoker,
            )
            .toList();

    if (nonJokers.isEmpty) {
      return true;
    }

    final targetRank =
        nonJokers.first.rank;

    return nonJokers.every(
      (card) =>
          card.rank ==
          targetRank,
    );
  }

  static bool _isPureSequence(
    List<GameCard> cards,
  ) {
    if (cards.length < 3) {
      return false;
    }

    final jokers =
        cards.where(
      (c) => c.isJoker,
    ).length;

    final nonJokers =
        cards.where(
      (c) => !c.isJoker,
    ).toList();

    if (nonJokers.isEmpty) {
      return true;
    }

    final suit =
        nonJokers.first.suit;

    final sameSuit =
        nonJokers.every(
      (c) => c.suit == suit,
    );

    if (!sameSuit) {
      return false;
    }

    nonJokers.sort(
      (a, b) =>
          a.rank.index.compareTo(
        b.rank.index,
      ),
    );

    int gaps = 0;

    for (int i = 0;
        i < nonJokers.length - 1;
        i++) {
      final current =
          nonJokers[i]
              .rank
              .index;

      final next =
          nonJokers[i + 1]
              .rank
              .index;

      if (next == current) {
        return false;
      }

      gaps +=
          (next - current - 1);
    }

    return gaps <= jokers;
  }

  static bool _isImpureSequence(
    List<GameCard> cards,
  ) {
    if (cards.length < 4) {
      return false;
    }

    final jokers =
        cards.where(
      (c) => c.isJoker,
    ).length;

    final nonJokers =
        cards.where(
      (c) => !c.isJoker,
    ).toList();

    if (nonJokers.isEmpty) {
      return true;
    }

    nonJokers.sort(
      (a, b) =>
          a.rank.index.compareTo(
        b.rank.index,
      ),
    );

    int gaps = 0;

    for (int i = 0;
        i < nonJokers.length - 1;
        i++) {
      final current =
          nonJokers[i]
              .rank
              .index;

      final next =
          nonJokers[i + 1]
              .rank
              .index;

      if (next == current) {
        return false;
      }

      gaps +=
          (next - current - 1);
    }

    return gaps <= jokers;
  }

  static bool isPowerCard(
    GameCard card,
  ) {
    return !card.isJoker &&
        card.rank ==
            CardRank.king;
  }

  static bool isDontPickCard(
    GameCard card,
  ) {
    return !card.isJoker &&
        card.rank ==
            CardRank.king &&
        card.suit ==
            CardSuit.hearts;
  }

  static bool isDiscoverCard(
    GameCard card,
  ) {
    return !card.isJoker &&
        card.rank ==
            CardRank.king &&
        card.suit ==
            CardSuit.clubs;
  }

  static bool isDeclareNowCard(
    GameCard card,
  ) {
    return !card.isJoker &&
        card.rank ==
            CardRank.king &&
        card.suit ==
            CardSuit.diamonds;
  }

  static bool isHalfValueCard(
    GameCard card,
  ) {
    return !card.isJoker &&
        card.rank ==
            CardRank.king &&
        card.suit ==
            CardSuit.spades;
  }
}