import '../models/game_card.dart';

class DrawService {
  const DrawService();

  GameCard drawTop(List<GameCard> drawPile) {
    if (drawPile.isEmpty) {
      throw StateError('Cannot draw from an empty pile.');
    }
    return drawPile.removeAt(0);
  }

  List<GameCard> drawMany(List<GameCard> drawPile, int count) {
    if (count < 0) {
      throw ArgumentError.value(count, 'count', 'Draw count cannot be negative.');
    }
    if (drawPile.length < count) {
      throw StateError('Not enough cards to draw $count card(s).');
    }

    final List<GameCard> cards = <GameCard>[];
    for (var i = 0; i < count; i++) {
      cards.add(drawTop(drawPile));
    }
    return cards;
  }
}

