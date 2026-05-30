import '../enums/card_rank.dart';
import '../enums/card_suit.dart';
import '../models/game_state.dart';
import '../rules/scoring_rules.dart';

class DeclareResult {
  DeclareResult({
    required this.winningPlayerId,
    required this.callerSucceeded,
    required this.scores,
  });

  final String winningPlayerId;

  final bool callerSucceeded;

  final Map<String, double> scores;
}

class DeclareEngine {
  static DeclareResult declare({
    required GameState state,
    required String callerId,
  }) {
    final scores =
        <String, double>{};

    for (final player
        in state.players) {
      double score =
          ScoringRules.scoreHand(
        player.hand,
      ).toDouble();

      // K♠ HALF VALUE
      final halfCards =
          player.hand.where(
        (card) =>
            !card.isJoker &&
            card.rank ==
                CardRank.king &&
            card.suit ==
                CardSuit.spades,
      ).length;

      if (halfCards > 0) {
        score =
            score /
            (1 << halfCards);
      }

      scores[player.id] = score;
    }

    final sorted =
        scores.entries.toList()
          ..sort(
            (a, b) => a.value
                .compareTo(
              b.value,
            ),
          );

    final winner =
        sorted.first.key;

    return DeclareResult(
      winningPlayerId: winner,

      callerSucceeded:
          winner == callerId,

      scores: scores,
    );
  }
}