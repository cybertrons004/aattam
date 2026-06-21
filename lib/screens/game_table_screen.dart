import 'package:flutter/material.dart';

import '../game_engine/engine/declare_engine.dart';
import '../game_engine/engine/game_flow_engine.dart';
import '../game_engine/engine/game_initializer.dart';
import '../game_engine/enums/player_turn_phase.dart';
import '../game_engine/models/discard_action.dart';
import '../game_engine/models/game_card.dart';
import '../game_engine/models/game_state.dart';
import '../game_engine/models/player_model.dart';
import '../game_engine/rules/discard_validator.dart';

class GameTableScreen extends StatefulWidget {
  const GameTableScreen({super.key});

  @override
  State<GameTableScreen> createState() =>
      _GameTableScreenState();
}

class _GameTableScreenState
    extends State<GameTableScreen> {
  late GameState gameState;

  final List<GameCard>
      selectedMainCards = [];

  final List<GameCard>
      selectedPowerCards = [];

  @override
  void initState() {
    super.initState();
    _startNewRound();
  }

  void _startNewRound() {
    gameState = GameInitializer.createGame(
      playerNames: [
        'You',
        'Wife',
      ],
    );

    selectedMainCards.clear();
    selectedPowerCards.clear();
  }
  bool canDeclareNow() {
  return gameState.players.any(
    (player) =>
        player.id == currentPlayer.id &&
        player.hand.any(
          (card) =>
              DiscardValidator
                  .isDeclareNowCard(
            card,
          ),
        ),
  );
}

  PlayerModel get currentPlayer =>
      gameState.players[
          gameState.currentPlayerIndex];

  bool get isDiscardPhase =>
      gameState.currentTurnPhase ==
      PlayerTurnPhase.discard;

  bool get isDrawPhase =>
      gameState.currentTurnPhase ==
      PlayerTurnPhase.draw;

String cardLabel(GameCard card) {
  if (card.isJoker) {
    return '🃏\nJOKER';
  }

  String suit = '';

  switch (card.suit.name) {
    case 'spades':
      suit = '♠';
      break;

    case 'hearts':
      suit = '♥';
      break;

    case 'clubs':
      suit = '♣';
      break;

    case 'diamonds':
      suit = '♦';
      break;
  }

  return '${card.rank.name.toUpperCase()}\n$suit';
}
Color _cardColor(
  GameCard card,
) {
  if (card.isJoker) {
    return Colors.deepPurple;
  }

  switch (card.suit.name) {
    case 'spades':
      return Colors.black;

    case 'hearts':
      return Colors.red;

    case 'clubs':
      return Colors.grey;

    case 'diamonds':
      return Colors.pink;

    default:
      return Colors.black;
  }
}

Color _powerGlow(
  GameCard card,
) {
  if (!DiscardValidator.isPowerCard(card)) {
    return Colors.transparent;
  }

  switch (card.suit.name) {
    case 'spades':
      return Colors.blueAccent;

    case 'hearts':
      return Colors.redAccent;

    case 'clubs':
      return Colors.greenAccent;

    case 'diamonds':
      return Colors.amber;

    default:
      return Colors.purpleAccent;
  }
}

bool isEdgeCard(
  GameCard card,
  List<GameCard> cards,
) {
  if (cards.isEmpty) {
    return false;
  }

  final playableCards =
      cards.where(
    (c) =>
        !DiscardValidator
            .isPowerCard(c),
  ).toList();

  if (playableCards.isEmpty) {
    return false;
  }

  return card.id ==
          playableCards.first.id ||
      card.id ==
          playableCards.last.id;
}

  void _toggleCardSelection(
    GameCard card,
  ) {
    if (!isDiscardPhase) {
      return;
    }

    final isPower =
        DiscardValidator
            .isPowerCard(card);

    setState(() {
      if (isPower) {
        final exists =
            selectedPowerCards.any(
          (c) => c.id == card.id,
        );

        if (exists) {
          selectedPowerCards
              .removeWhere(
            (c) => c.id == card.id,
          );
        } else {
          selectedPowerCards
              .add(card);
        }

        return;
      }

      final exists =
          selectedMainCards.any(
        (c) => c.id == card.id,
      );

      if (exists) {
        selectedMainCards.removeWhere(
          (c) => c.id == card.id,
        );
      } else {
        selectedMainCards.add(card);
      }
    });
  }

  void _discardSelectedCards() {
    final action =
        DiscardAction(
      mainCards:
          selectedMainCards,
      powerCards:
          selectedPowerCards,
    );

    final valid =
        DiscardValidator
            .isValidDiscard(
      action,
    );

    if (!valid) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Invalid discard',
          ),
        ),
      );

      return;
    }

    setState(() {
      gameState =
          GameFlowEngine.discardCards(
        state: gameState,
        playerId: currentPlayer.id,
        cards: action.allCards,
      );

      selectedMainCards.clear();
      selectedPowerCards.clear();
    });
  }

  void _pickDrawPile() {
    setState(() {
      gameState =
          GameFlowEngine.pickFromDrawPile(
        state: gameState,
        playerId: currentPlayer.id,
      );
    });
  }

  void _pickPreviousDiscard(
    GameCard card,
  ) {
    setState(() {
      gameState =
          GameFlowEngine
              .pickPreviousDiscard(
        state: gameState,
        playerId: currentPlayer.id,
        pickedCard: card,
      );
    });
  }

  void _openDiscoverDialog() {
    showDialog(
      context: context,
      builder: (_) {
        final allowedCards =
            gameState.discardHistory
                .where(
          (card) =>
              !card.isJoker &&
              !DiscardValidator
                  .isPowerCard(card),
        ).toList();

        return AlertDialog(
          backgroundColor:
              const Color(
            0xFF07131A,
          ),
          title: const Text(
            'DISCOVER PICK',
          ),
          content: SizedBox(
            width: 700,
            height: 300,
            child: GridView.builder(
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                crossAxisSpacing:
                    12,
                mainAxisSpacing:
                    12,
                childAspectRatio:
                    0.7,
              ),
              itemCount:
                  allowedCards.length,
              itemBuilder:
                  (context, index) {
                final card =
                    allowedCards[index];

                return buildCard(
                  card,
                  clickable: true,
                  color: Colors
                      .green
                      .shade100,
                  onTap: () {
                    Navigator.pop(
                      context,
                    );

                    setState(() {
                      gameState =
                          GameFlowEngine
                              .pickFromHistory(
                        state:
                            gameState,
                        playerId:
                            currentPlayer
                                .id,
                        pickedCard:
                            card,
                      );
                    });
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  void _declareRound() {
    final result = DeclareEngine.declare(
      state: gameState,
      callerId: currentPlayer.id,
    );

    final winnerName =
        gameState.players
            .firstWhere(
              (player) =>
                  player.id ==
                  result.winningPlayerId,
            )
            .name;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return AlertDialog(
          title: const Text(
            'Round Result',
          ),
          content: Column(
            mainAxisSize:
                MainAxisSize.min,
            children: [
              Text(
                'Winner: $winnerName',
                style: const TextStyle(
                  fontWeight:
                      FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                result.callerSucceeded
                    ? 'Successful Declare'
                    : 'Wrong Declare',
              ),
              const SizedBox(height: 20),
              const Divider(),
              ...result.scores.entries.map(
                (entry) {
                  final player =
                      gameState.players
                          .firstWhere(
                    (p) =>
                        p.id ==
                        entry.key,
                  );

                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(
                      vertical: 6,
                    ),
                    child: Row(
                      mainAxisAlignment:
                          MainAxisAlignment
                              .spaceBetween,
                      children: [
                        Text(
                          player.name,
                          style:
                              const TextStyle(
                            fontWeight:
                                FontWeight
                                    .bold,
                          ),
                        ),
                        Text(
                          '${entry.value} pts',
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);

                setState(() {
                  _startNewRound();
                });
              },
              child: const Text(
                'Next Round',
              ),
            ),
          ],
        );
      },
    );
  }

  Widget buildCard(
    GameCard card, {
    double width = 90,
    double height = 130,
    bool selected = false,
    bool clickable = false,
    VoidCallback? onTap,
    Color? color,
  }) {
    final isPower =
        DiscardValidator
            .isPowerCard(card);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration:
            const Duration(
          milliseconds: 200,
        ),
        transform:
            Matrix4.translationValues(
          0,
          selected ? -20 : 0,
          0,
        ),
        width: width,
        height: height,
        margin:
            const EdgeInsets.symmetric(
          horizontal: 4,
        ),
        decoration: BoxDecoration(
          color:
              color ?? Colors.white,
          borderRadius:
              BorderRadius.circular(
            14,
          ),
          border: Border.all(
            color: clickable
                ? Colors.greenAccent
                : isPower
                    ? Colors.purpleAccent
                    : Colors.black26,
            width:
                clickable || isPower
                    ? 3
                    : 1,
          ),
          boxShadow: [
  BoxShadow(
    blurRadius: 12,
    spreadRadius:
        isPower ? 2 : 0,
    color: isPower
        ? _powerGlow(card)
        : Colors.black
            .withOpacity(0.3),
  ),
],
        ),
        child: Center(
          child: Text(
            cardLabel(card),
            textAlign:
                TextAlign.center,
            style: TextStyle(
  color: _cardColor(card),
  fontWeight:
      FontWeight.bold,
  fontSize: card.isJoker
      ? 18
      : 16,
),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final previousDiscard =
        gameState.previousDiscardGroup;

    final currentDiscard =
        gameState.currentDiscardGroup;

    final action =
        DiscardAction(
      mainCards:
          selectedMainCards,
      powerCards:
          selectedPowerCards,
    );

    final selectedValid =
        DiscardValidator
            .isValidDiscard(
      action,
    );

    return Scaffold(
      backgroundColor:
          const Color(0xFF07131A),
      appBar: AppBar(
        title: const Text('Aattam'),
        backgroundColor:
            Colors.transparent,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),

          if (gameState
              .activeTurnEffects
              .discoverMode)
            const Padding(
              padding:
                  EdgeInsets.only(
                bottom: 10,
              ),
              child: Text(
                'DISCOVER ACTIVE',
                style: TextStyle(
                  color:
                      Colors.greenAccent,
                  fontWeight:
                      FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),

          Row(
            mainAxisAlignment:
                MainAxisAlignment
                    .spaceEvenly,
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: isDrawPhase
                    ? _pickDrawPile
                    : null,
                child: Container(
                  width: 140,
                  height: 200,
                  decoration:
                      BoxDecoration(
                    color: Colors.teal
                        .shade900,
                    borderRadius:
                        BorderRadius
                            .circular(
                      18,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment:
                        MainAxisAlignment
                            .center,
                    children: [
                      const Text(
                        'DRAW PILE',
                        style: TextStyle(
                          color: Colors
                              .cyanAccent,
                        ),
                      ),
                      const SizedBox(
                          height: 10),
                      Text(
                        gameState
                            .drawPile
                            .length
                            .toString(),
                        style:
                            const TextStyle(
                          fontSize: 32,
                          fontWeight:
                              FontWeight
                                  .bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Container(
                width: 420,
                padding:
                    const EdgeInsets.all(
                  16,
                ),
                decoration:
                    BoxDecoration(
                  color: Colors.black26,
                  borderRadius:
                      BorderRadius
                          .circular(20),
                ),
                child: Column(
                  children: [
                    const Text(
                      'PREVIOUS THROW',
                      style: TextStyle(
                        color: Colors
                            .cyanAccent,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                        height: 14),
                    SizedBox(
                      height: 150,
                      child: ListView(
                        scrollDirection:
                            Axis.horizontal,
                        children:
                            previousDiscard
                                .map(
                          (card) {
                            final pickable =
                                isEdgeCard(
                              card,
                              previousDiscard,
                            )&&
    !DiscardValidator
        .isPowerCard(
      card,
    );

                            return buildCard(
                              card,
                              clickable:
                                  pickable &&
                                      isDrawPhase,
                              color: Colors
                                  .red
                                  .shade100,
                              onTap:
                                  pickable &&
                                          isDrawPhase
                                      ? () =>
                                          _pickPreviousDiscard(
                                            card,
                                          )
                                      : null,
                            );
                          },
                        ).toList(),
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                width: 420,
                padding:
                    const EdgeInsets.all(
                  16,
                ),
                decoration:
                    BoxDecoration(
                  color: Colors
                      .orange.shade900,
                  borderRadius:
                      BorderRadius.circular(
                    20,
                  ),
                ),
                child: Column(
                  children: [
                    const Text(
                      'YOUR THROW',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    const SizedBox(
                        height: 14),

                    SizedBox(
                      height: 150,
                      child: ListView(
                        scrollDirection:
                            Axis.horizontal,
                        children:
                            currentDiscard.map(
                          (card) {
                            return buildCard(
                              card,
                              color: Colors
                                  .orange
                                  .shade200,
                            );
                          },
                        ).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const Spacer(),

          Container(
            width: double.infinity,
            padding:
                const EdgeInsets.all(20),
            decoration:
                const BoxDecoration(
              color: Color(
                0xFF041018,
              ),
              borderRadius:
                  BorderRadius.vertical(
                top: Radius.circular(
                  24,
                ),
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      currentPlayer.name,
                      style:
                          const TextStyle(
                        fontSize: 22,
                        fontWeight:
                            FontWeight
                                .bold,
                      ),
                    ),

                    const Spacer(),

                    ElevatedButton(
                      onPressed:
                          selectedValid
                              ? _discardSelectedCards
                              : null,
                      child: const Text(
                        'Discard',
                      ),
                    ),

                    const SizedBox(
                        width: 12),

                    ElevatedButton(
                      onPressed:
                          _declareRound,
                      child: const Text(
                        'Declare',
                      ),
                    ),

                    if (gameState
                        .activeTurnEffects
                        .discoverMode)
                      Padding(
                        padding:
                            const EdgeInsets.only(
                          left: 12,
                        ),
                        child: ElevatedButton(
                          style:
                              ElevatedButton.styleFrom(
                            backgroundColor:
                                Colors.green,
                          ),
                          onPressed:
                              _openDiscoverDialog,
                          child: const Text(
                            'DISCOVER',
                          ),
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 20),

                SizedBox(
                  height: 170,
                  child: SingleChildScrollView(
                    scrollDirection:
                        Axis.horizontal,
                    child: SizedBox(
                      width: currentPlayer
                              .hand.length *
                          70,
                      child: Stack(
                        children: currentPlayer
                            .hand
                            .asMap()
                            .entries
                            .map(
                          (entry) {
                            final index =
                                entry.key;

                            final card =
                                entry.value;

                            final selected =
                                selectedMainCards.any(
                                      (c) =>
                                          c.id ==
                                          card.id,
                                    ) ||
                                    selectedPowerCards.any(
                                      (c) =>
                                          c.id ==
                                          card.id,
                                    );

                            return Positioned(
                              left:
                                  index * 70,
                              child:
                                  buildCard(
                                card,
                                selected:
                                    selected,
                                color:
                                    selected
                                        ? Colors.orange
                                        : Colors.white,
                                onTap:
                                    isDiscardPhase
                                        ? () =>
                                            _toggleCardSelection(
                                              card,
                                            )
                                        : null,
                              ),
                            );
                          },
                        ).toList(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}