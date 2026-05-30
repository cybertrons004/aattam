import '../enums/game_phase.dart';
import '../enums/player_turn_phase.dart';
import '../models/active_turn_effects.dart';
import '../models/game_state.dart';
import '../models/player_model.dart';
import '../services/deck_factory.dart';
import '../services/shuffle_service.dart';

class GameInitializer {
  static GameState createGame({
    required List<String> playerNames,
  }) {
    final deck = const ShuffleService()
        .shuffled(
      DeckFactory.create108CardDeck(),
    );

    final players = <PlayerModel>[];

    for (int i = 0;
        i < playerNames.length;
        i++) {
      players.add(
        PlayerModel(
          id: 'player_$i',
          name: playerNames[i],
          hand: [],
          score: 0,
          hasDeclared: false,
          isEliminated: false,
          isBot: false,
        ),
      );
    }

    final mutableDeck = List.of(deck);

    for (int round = 0;
        round < 7;
        round++) {
      for (int i = 0;
          i < players.length;
          i++) {
        final card =
            mutableDeck.removeLast();

        players[i] =
            players[i].copyWith(
          hand: [
            ...players[i].hand,
            card,
          ],
        );
      }
    }

    final firstDiscard =
        mutableDeck.removeLast();

    return GameState(
      players: players,

      drawPile: mutableDeck,

      previousDiscardGroup: [
        firstDiscard,
      ],

      currentDiscardGroup: [],

      discardHistory: [
        firstDiscard,
      ],

      activeTurnEffects:
          ActiveTurnEffects.empty(),

      currentPlayerIndex: 0,

      turnNumber: 1,

      phase: GamePhase.play,

      currentTurnPhase:
          PlayerTurnPhase.discard,

      winnerId: null,

      clockwise: true,

      createdAt: DateTime.now(),

      updatedAt: DateTime.now(),
    );
  }
}