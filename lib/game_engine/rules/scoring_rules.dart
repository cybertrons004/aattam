import '../enums/card_rank.dart';
import '../models/game_card.dart';

class ScoringRules {
  const ScoringRules._();

  static int scoreCard(GameCard card) {
    switch (card.rank) {
      case CardRank.ace:
        return 1;
      case CardRank.two:
        return 2;
      case CardRank.three:
        return 3;
      case CardRank.four:
        return 4;
      case CardRank.five:
        return 5;
      case CardRank.six:
        return 6;
      case CardRank.seven:
        return 7;
      case CardRank.eight:
        return 8;
      case CardRank.nine:
        return 9;
      case CardRank.ten:
        return 10;
      case CardRank.jack:
        return 11;
      case CardRank.queen:
        return 12;
      case CardRank.king:
      case CardRank.joker:
        return 0;
    }
  }

  static int scoreHand(Iterable<GameCard> cards) {
    return cards.fold<int>(0, (total, card) => total + scoreCard(card));
  }
}

