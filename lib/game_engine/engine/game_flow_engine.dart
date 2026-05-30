import '../enums/player_turn_phase.dart';
import '../models/game_card.dart';
import '../models/game_state.dart';
import '../rules/discard_validator.dart';
import 'draw_card_engine.dart';
import 'play_card_engine.dart';
import 'turn_engine.dart';

class GameFlowEngine {
  static GameState discardCards({
    required GameState state,
    required String playerId,
    required List<GameCard> cards,
  }) {
    if (state.currentTurnPhase !=
        PlayerTurnPhase.discard) {
      return state;
    }

    final discardState =
        PlayCardEngine.playCards(
      state: state,
      playerId: playerId,
      cards: cards,
    );

    final hasDontPick =
        cards.any(
      DiscardValidator
          .isDontPickCard,
    );

    final hasDiscover =
        cards.any(
      DiscardValidator
          .isDiscoverCard,
    );

    // K♥
    if (hasDontPick) {
      return _completeTurn(
        discardState,
      );
    }

    // K♣
    if (hasDiscover) {
      return discardState.copyWith(
        currentTurnPhase:
            PlayerTurnPhase.draw,
        activeTurnEffects:
            discardState
                .activeTurnEffects
                .copyWith(
          discoverMode: true,
        ),
      );
    }

    return discardState.copyWith(
      currentTurnPhase:
          PlayerTurnPhase.draw,
    );
  }

  static GameState pickFromDrawPile({
    required GameState state,
    required String playerId,
  }) {
    if (state.currentTurnPhase !=
        PlayerTurnPhase.draw) {
      return state;
    }

    final drawState =
        DrawCardEngine.drawCard(
      state: state,
      playerId: playerId,
    );

    return _completeTurn(drawState);
  }

  static GameState pickPreviousDiscard({
    required GameState state,
    required String playerId,
    required GameCard pickedCard,
  }) {
    if (state.currentTurnPhase !=
        PlayerTurnPhase.draw) {
      return state;
    }

    final previous =
        [...state.previousDiscardGroup];

    if (previous.isEmpty) {
      return state;
    }

    // BLOCK POWER CARDS
    if (DiscardValidator
        .isPowerCard(
      pickedCard,
    )) {
      return state;
    }

    final first =
        previous.first;

    final last =
        previous.last;

    final valid =
        pickedCard.id ==
                first.id ||
            pickedCard.id ==
                last.id;

    if (!valid) {
      return state;
    }

    previous.removeWhere(
      (card) =>
          card.id ==
          pickedCard.id,
    );

    final updatedPlayers =
        state.players.map((player) {
      if (player.id != playerId) {
        return player;
      }

      return player.copyWith(
        hand: [
          ...player.hand,
          pickedCard,
        ],
      );
    }).toList();

    final updatedState =
        state.copyWith(
      players: updatedPlayers,
      previousDiscardGroup:
          previous,
    );

    return _completeTurn(
      updatedState,
    );
  }

  static GameState pickFromHistory({
    required GameState state,
    required String playerId,
    required GameCard pickedCard,
  }) {
    if (!state
        .activeTurnEffects
        .discoverMode) {
      return state;
    }

    // BLOCK POWER CARDS
    if (DiscardValidator
        .isPowerCard(
      pickedCard,
    )) {
      return state;
    }

    // BLOCK JOKERS
    if (pickedCard.isJoker) {
      return state;
    }

    final updatedHistory =
        [...state.discardHistory];

    updatedHistory.removeWhere(
      (card) =>
          card.id ==
          pickedCard.id,
    );

    final updatedPlayers =
        state.players.map((player) {
      if (player.id != playerId) {
        return player;
      }

      return player.copyWith(
        hand: [
          ...player.hand,
          pickedCard,
        ],
      );
    }).toList();

    final updatedState =
        state.copyWith(
      players: updatedPlayers,
      discardHistory:
          updatedHistory,
    );

    return _completeTurn(
      updatedState,
    );
  }

  static GameState _completeTurn(
    GameState state,
  ) {
    final completedState =
        state.copyWith(
      previousDiscardGroup: [
        ...state.currentDiscardGroup,
      ],
      currentDiscardGroup: [],
      discardHistory: [
        ...state.discardHistory,
        ...state.currentDiscardGroup,
      ],
      activeTurnEffects:
          state.activeTurnEffects
              .copyWith(
        skipPick: false,
        discoverMode: false,
      ),
    );

    final nextTurn =
        TurnEngine.nextTurn(
      completedState,
    );

    return nextTurn.copyWith(
      currentTurnPhase:
          PlayerTurnPhase.discard,
    );
  }
}