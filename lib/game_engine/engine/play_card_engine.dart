import '../models/game_card.dart';
import '../models/game_state.dart';

class PlayCardEngine {
  static GameState playCards({
    required GameState state,
    required String playerId,
    required List<GameCard> cards,
  }) {
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

      currentDiscardGroup: [
        ...cards,
      ],

      updatedAt: DateTime.now(),
    );
  }
}