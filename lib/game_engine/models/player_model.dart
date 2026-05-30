import '../enums/card_rank.dart';
import '../enums/card_suit.dart';
import '../rules/scoring_rules.dart';
import 'game_card.dart';

class PlayerModel {
  PlayerModel({
    required this.id,
    required this.name,
    required List<GameCard> hand,
    required this.score,
    required this.hasDeclared,
    required this.isEliminated,
    required this.isBot,
  }) : hand = List<GameCard>.unmodifiable(hand);

  final String id;
  final String name;
  final List<GameCard> hand;
  final int score;
  final bool hasDeclared;
  final bool isEliminated;
  final bool isBot;

  bool get hasEmptyHand => hand.isEmpty;
  int get totalHandScore => ScoringRules.scoreHand(hand);

  PlayerModel copyWith({
    String? id,
    String? name,
    List<GameCard>? hand,
    int? score,
    bool? hasDeclared,
    bool? isEliminated,
    bool? isBot,
  }) {
    return PlayerModel(
      id: id ?? this.id,
      name: name ?? this.name,
      hand: hand ?? this.hand,
      score: score ?? this.score,
      hasDeclared: hasDeclared ?? this.hasDeclared,
      isEliminated: isEliminated ?? this.isEliminated,
      isBot: isBot ?? this.isBot,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'hand': hand.map(_cardToJson).toList(growable: false),
      'score': score,
      'hasDeclared': hasDeclared,
      'isEliminated': isEliminated,
      'isBot': isBot,
    };
  }

  factory PlayerModel.fromJson(Map<String, dynamic> json) {
    final rawHand = (json['hand'] as List<dynamic>? ?? <dynamic>[])
        .cast<Map<String, dynamic>>();

    return PlayerModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      hand: rawHand.map(_cardFromJson).toList(growable: false),
      score: (json['score'] as num? ?? 0).toInt(),
      hasDeclared: json['hasDeclared'] as bool? ?? false,
      isEliminated: json['isEliminated'] as bool? ?? false,
      isBot: json['isBot'] as bool? ?? false,
    );
  }

  static Map<String, dynamic> _cardToJson(GameCard card) {
    return <String, dynamic>{
      'id': card.id,
      'suit': card.suit.name,
      'rank': card.rank.name,
      'deckNumber': card.deckNumber,
    };
  }

  static GameCard _cardFromJson(Map<String, dynamic> json) {
    final suitName = json['suit'] as String? ?? CardSuit.joker.name;
    final rankName = json['rank'] as String? ?? CardRank.joker.name;

    return GameCard(
      id: json['id'] as String? ?? '',
      suit: CardSuit.values.firstWhere(
        (value) => value.name == suitName,
        orElse: () => CardSuit.joker,
      ),
      rank: CardRank.values.firstWhere(
        (value) => value.name == rankName,
        orElse: () => CardRank.joker,
      ),
      deckNumber: (json['deckNumber'] as num? ?? 0).toInt(),
    );
  }
}

