import 'dart:math';

import '../models/game_card.dart';

class ShuffleService {
  const ShuffleService({Random? random}) : _random = random;

  final Random? _random;

  List<GameCard> shuffled(List<GameCard> cards) {
    final result = List<GameCard>.from(cards);
    result.shuffle(_random);
    return result;
  }
}

