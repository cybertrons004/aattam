import '../models/game_card.dart';
import '../models/game_state.dart';

class PlayCardEngine {
  static GameState playCards({
    required GameState state,
    required String playerId,
    required List<GameCard> cards,
  }) {
    final orderedCards =
        _orderDiscardCards(cards);

    final updatedPlayers =
        state.players.map((player) {
      if (player.id != playerId) {
        return player;
      }

      final updatedHand =
          [...player.hand];

      for (final card in cards) {
        updatedHand.removeWhere(
          (c) => c.id == card.id,
        );
      }

      return player.copyWith(
        hand: updatedHand,
      );
    }).toList();

    return state.copyWith(
      players: updatedPlayers,

      currentDiscardGroup:
          orderedCards,

      updatedAt: DateTime.now(),
    );
  }

  static List<GameCard>
      _orderDiscardCards(
    List<GameCard> cards,
  ) {
    if (cards.length <= 1) {
      return cards;
    }

    final jokers =
        cards.where(
      (c) => c.isJoker,
    ).toList();

    final nonJokers =
        cards.where(
      (c) => !c.isJoker,
    ).toList();

    if (nonJokers.isEmpty) {
      return cards;
    }

    nonJokers.sort(
      (a, b) =>
          a.rank.index.compareTo(
        b.rank.index,
      ),
    );

    // No joker
    if (jokers.isEmpty) {
      return nonJokers;
    }

    // Determine missing ranks
    final result =
        <GameCard>[];

    int jokerIndex = 0;

    for (int i = 0;
        i < nonJokers.length - 1;
        i++) {
      result.add(
        nonJokers[i],
      );

      final current =
          nonJokers[i]
              .rank
              .index;

      final next =
          nonJokers[i + 1]
              .rank
              .index;

      final gap =
          next - current - 1;

      for (int j = 0;
          j < gap &&
              jokerIndex <
                  jokers.length;
          j++) {
        result.add(
          jokers[
              jokerIndex++],
        );
      }
    }

    result.add(
      nonJokers.last,
    );

    // Remaining jokers
    while (jokerIndex <
        jokers.length) {
      result.insert(
        result.length - 1,
        jokers[
            jokerIndex++],
      );
    }

    return result;
  }
}