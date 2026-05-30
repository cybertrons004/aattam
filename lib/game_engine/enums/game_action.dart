import '../models/game_card.dart';

enum GameActionType {
  draw,
  discard,
  declare,
  skip,
  power,
  finish,
}

class GameAction {
  final String playerId;
  final GameActionType type;
  final GameCard? card;
  final DateTime timestamp;

  const GameAction({
    required this.playerId,
    required this.type,
    this.card,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'playerId': playerId,
      'type': type.name,
      'card': card?.toJson(),
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory GameAction.fromJson(Map<String, dynamic> json) {
    return GameAction(
      playerId: json['playerId'],
      type: GameActionType.values.firstWhere(
        (e) => e.name == json['type'],
      ),
      card: json['card'] != null
          ? GameCard.fromJson(json['card'])
          : null,
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}