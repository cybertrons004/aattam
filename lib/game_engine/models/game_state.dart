import '../enums/game_phase.dart';
import '../enums/player_turn_phase.dart';
import 'active_turn_effects.dart';
import 'game_card.dart';
import 'player_model.dart';

class GameState {
  GameState({
    required this.players,
    required this.drawPile,
    required this.previousDiscardGroup,
    required this.currentDiscardGroup,
    required this.discardHistory,
    required this.activeTurnEffects,
    required this.currentPlayerIndex,
    required this.turnNumber,
    required this.phase,
    required this.currentTurnPhase,
    required this.winnerId,
    required this.clockwise,
    required this.createdAt,
    required this.updatedAt,
  });

  final List<PlayerModel> players;

  final List<GameCard> drawPile;

  // previous player's discard
  final List<GameCard>
      previousDiscardGroup;

  // current player's discard
  final List<GameCard>
      currentDiscardGroup;

  // ALL discarded cards
  final List<GameCard> discardHistory;

  final ActiveTurnEffects
      activeTurnEffects;

  final int currentPlayerIndex;

  final int turnNumber;

  final GamePhase phase;

  final PlayerTurnPhase
      currentTurnPhase;

  final String? winnerId;

  final bool clockwise;

  final DateTime createdAt;

  final DateTime updatedAt;

  PlayerModel get currentPlayer =>
      players[currentPlayerIndex];

  GameState copyWith({
    List<PlayerModel>? players,
    List<GameCard>? drawPile,
    List<GameCard>?
        previousDiscardGroup,
    List<GameCard>?
        currentDiscardGroup,
    List<GameCard>? discardHistory,
    ActiveTurnEffects?
        activeTurnEffects,
    int? currentPlayerIndex,
    int? turnNumber,
    GamePhase? phase,
    PlayerTurnPhase?
        currentTurnPhase,
    String? winnerId,
    bool? clockwise,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return GameState(
      players: players ?? this.players,

      drawPile:
          drawPile ?? this.drawPile,

      previousDiscardGroup:
          previousDiscardGroup ??
              this
                  .previousDiscardGroup,

      currentDiscardGroup:
          currentDiscardGroup ??
              this
                  .currentDiscardGroup,

      discardHistory:
          discardHistory ??
              this.discardHistory,

      activeTurnEffects:
          activeTurnEffects ??
              this
                  .activeTurnEffects,

      currentPlayerIndex:
          currentPlayerIndex ??
              this
                  .currentPlayerIndex,

      turnNumber:
          turnNumber ??
              this.turnNumber,

      phase: phase ?? this.phase,

      currentTurnPhase:
          currentTurnPhase ??
              this
                  .currentTurnPhase,

      winnerId:
          winnerId ?? this.winnerId,

      clockwise:
          clockwise ?? this.clockwise,

      createdAt:
          createdAt ??
              this.createdAt,

      updatedAt:
          updatedAt ??
              this.updatedAt,
    );
  }
}