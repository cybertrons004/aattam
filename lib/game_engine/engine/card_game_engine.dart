import '../models/game_card.dart';
import '../rules/scoring_rules.dart';
import '../services/deck_factory.dart';
import '../services/draw_service.dart';
import '../services/shuffle_service.dart';

class CardGameEngine {
  CardGameEngine({
    ShuffleService? shuffleService,
    DrawService? drawService,
  })  : _shuffleService = shuffleService ?? const ShuffleService(),
        _drawService = drawService ?? const DrawService();

  final ShuffleService _shuffleService;
  final DrawService _drawService;

  final List<GameCard> _drawPile = <GameCard>[];
  final List<GameCard> _discardPile = <GameCard>[];

  List<GameCard> get drawPile => List<GameCard>.unmodifiable(_drawPile);
  List<GameCard> get discardPile => List<GameCard>.unmodifiable(_discardPile);

  void initializeDeck() {
    _drawPile
      ..clear()
      ..addAll(DeckFactory.create108CardDeck());
    _discardPile.clear();
  }

  void shuffleDeck() {
    final shuffled = _shuffleService.shuffled(_drawPile);
    _drawPile
      ..clear()
      ..addAll(shuffled);
  }

  GameCard drawCard() => _drawService.drawTop(_drawPile);

  List<GameCard> drawCards(int count) => _drawService.drawMany(_drawPile, count);

  void discard(GameCard card) => _discardPile.add(card);

  int calculateScore(Iterable<GameCard> hand) => ScoringRules.scoreHand(hand);
}

