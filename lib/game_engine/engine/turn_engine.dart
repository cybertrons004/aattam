import '../models/game_state.dart';

class TurnEngine {
  static GameState nextTurn(GameState state) {
    if (state.players.isEmpty) {
      return state;
    }

    final nextIndex =
        (state.currentPlayerIndex + 1) % state.players.length;

    return state.copyWith(
      currentPlayerIndex: nextIndex,
      turnNumber: state.turnNumber + 1,
      updatedAt: DateTime.now(),
    );
  }
}