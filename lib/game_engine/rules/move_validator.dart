import '../models/game_card.dart';

class MoveValidator {
  static bool canPlay({
    required GameCard playedCard,
    required GameCard topDiscard,
  }) {
    // Joker always playable
    if (playedCard.isJoker) return true;

    // Kings always playable
    if (playedCard.isKing) return true;

    // Match suit
    if (playedCard.suit == topDiscard.suit) return true;

    // Match rank
    if (playedCard.rank == topDiscard.rank) return true;

    return false;
  }
}