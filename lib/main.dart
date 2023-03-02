import 'package:first_flame/my_game.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Iniizalise all providers
final healthPoints = StateProvider((_) => 100);
//final score = StateProvider((_) => 0);
final gameOver = StateProvider((_) => false);
final inGame = StateProvider((_) => false);
final isPaused = StateProvider((ref) => false);
main() {
  runApp(
    GameWidget(
      game: JoschaGame(),
    ),
  );
}
