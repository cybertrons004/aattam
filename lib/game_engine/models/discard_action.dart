import 'game_card.dart';

class DiscardAction {
  const DiscardAction({
    required this.mainCards,
    required this.powerCards,
  });

  final List<GameCard> mainCards;

  final List<GameCard> powerCards;

  bool get hasCards =>
      mainCards.isNotEmpty;

  bool get hasPowerCards =>
      powerCards.isNotEmpty;

  List<GameCard> get allCards => [
        ...mainCards,
        ...powerCards,
      ];
}