import 'package:flutter/material.dart';

import 'screens/game_table_screen.dart';

void main() {
  runApp(const AattamApp());
}

class AattamApp extends StatelessWidget {
  const AattamApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Aattam',
      theme: ThemeData.dark(),
      home: const GameTableScreen(),
    );
  }
}