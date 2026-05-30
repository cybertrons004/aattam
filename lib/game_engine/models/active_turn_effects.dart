class ActiveTurnEffects {
  const ActiveTurnEffects({
    required this.skipPick,
    required this.discoverMode,
  });

  final bool skipPick;

  final bool discoverMode;

  ActiveTurnEffects copyWith({
    bool? skipPick,
    bool? discoverMode,
  }) {
    return ActiveTurnEffects(
      skipPick:
          skipPick ?? this.skipPick,
      discoverMode:
          discoverMode ??
              this.discoverMode,
    );
  }

  factory ActiveTurnEffects.empty() {
    return const ActiveTurnEffects(
      skipPick: false,
      discoverMode: false,
    );
  }
}