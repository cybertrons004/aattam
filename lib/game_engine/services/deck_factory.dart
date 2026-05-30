import '../enums/card_rank.dart';
import '../enums/card_suit.dart';
import '../models/game_card.dart';

class DeckFactory {
  const DeckFactory._();

  static const List<CardSuit> _standardSuits = <CardSuit>[
    CardSuit.spades,
    CardSuit.hearts,
    CardSuit.diamonds,
    CardSuit.clubs,
  ];

  static const List<CardRank> _standardRanks = <CardRank>[
    CardRank.ace,
    CardRank.two,
    CardRank.three,
    CardRank.four,
    CardRank.five,
    CardRank.six,
    CardRank.seven,
    CardRank.eight,
    CardRank.nine,
    CardRank.ten,
    CardRank.jack,
    CardRank.queen,
    CardRank.king,
  ];

  static List<GameCard> create108CardDeck() {
    final List<GameCard> cards = <GameCard>[];

    // 2 standard decks of 52 = 104 cards
    for (var deckNumber = 1; deckNumber <= 2; deckNumber++) {
      for (final suit in _standardSuits) {
        for (final rank in _standardRanks) {
          cards.add(
            GameCard(
              id: 'D$deckNumber-${_abbrSuit(suit)}-${_abbrRank(rank)}',
              suit: suit,
              rank: rank,
              deckNumber: deckNumber,
            ),
          );
        }
      }
    }

    // 4 Jokers
    for (var jokerIndex = 1; jokerIndex <= 4; jokerIndex++) {
      cards.add(
        GameCard(
          id: 'JOKER-$jokerIndex',
          suit: CardSuit.joker,
          rank: CardRank.joker,
          deckNumber: 0,
        ),
      );
    }

    return cards;
  }

  static String _abbrSuit(CardSuit suit) {
    switch (suit) {
      case CardSuit.spades:
        return 'S';
      case CardSuit.hearts:
        return 'H';
      case CardSuit.diamonds:
        return 'D';
      case CardSuit.clubs:
        return 'C';
      case CardSuit.joker:
        return 'J';
    }
  }

  static String _abbrRank(CardRank rank) {
    switch (rank) {
      case CardRank.ace:
        return 'A';
      case CardRank.two:
        return '2';
      case CardRank.three:
        return '3';
      case CardRank.four:
        return '4';
      case CardRank.five:
        return '5';
      case CardRank.six:
        return '6';
      case CardRank.seven:
        return '7';
      case CardRank.eight:
        return '8';
      case CardRank.nine:
        return '9';
      case CardRank.ten:
        return '10';
      case CardRank.jack:
        return 'J';
      case CardRank.queen:
        return 'Q';
      case CardRank.king:
        return 'K';
      case CardRank.joker:
        return 'JK';
    }
  }
}

