import '../enums/card_rank.dart';
import '../enums/card_suit.dart';
import '../enums/king_power.dart';

class GameCard {
  final String id;
  final CardSuit suit;
  final CardRank rank;
  final int deckNumber;

  const GameCard({
    required this.id,
    required this.suit,
    required this.rank,
    required this.deckNumber,
  });

  bool get isJoker =>
      rank == CardRank.joker;

  bool get isKing =>
      rank == CardRank.king;

  KingPower? get kingPower {
    if (!isKing) {
      return null;
    }

    switch (suit) {
      case CardSuit.spades:
        return KingPower.myHalfValue;

      case CardSuit.hearts:
        return KingPower.dontPick;

      case CardSuit.diamonds:
        return KingPower.declareNow;

      case CardSuit.clubs:
        return KingPower.discoverNow;

      default:
        return null;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'suit': suit.name,
      'rank': rank.name,
      'deckNumber': deckNumber,
    };
  }

  factory GameCard.fromJson(
    Map<String, dynamic> json,
  ) {
    return GameCard(
      id: json['id'],
      suit: CardSuit.values.firstWhere(
        (e) =>
            e.name == json['suit'],
      ),
      rank: CardRank.values.firstWhere(
        (e) =>
            e.name == json['rank'],
      ),
      deckNumber: json['deckNumber'],
    );
  }
}