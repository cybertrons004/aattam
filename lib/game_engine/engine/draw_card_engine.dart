import '../models/game_state.dart';

class DrawCardEngine {
  static GameState drawCard({
    required GameState state,
    required String playerId,
  }) {
    if (state.drawPile.isEmpty) {
      return state;
    }

    final updatedDrawPile = [...state.drawPile];

    final drawnCard = updatedDrawPile.removeLast();

    final updatedPlayers = state.players.map((player) {
      if (player.id != playerId) {
        return player;
      }

      return player.copyWith(
        hand: [
          ...player.hand,
          drawnCard,
        ],
      );
    }).toList();

    return state.copyWith(
      players: updatedPlayers,
      drawPile: updatedDrawPile,
      updatedAt: DateTime.now(),
    );
  }
}