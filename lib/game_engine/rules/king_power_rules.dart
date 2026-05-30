import '../enums/king_power.dart';
import '../models/game_card.dart';

class KingPowerRules {
  const KingPowerRules._();

  static KingPower? getPower(GameCard card) => card.kingPower;

  static bool hasKingPower(GameCard card) => getPower(card) != null;
}

