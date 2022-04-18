import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/timer.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'my_game.dart';

main() async {
  //Flame.device.fullScreen();
  //Flame.device.setPortrait();
  final myGame = MyGame();
  runApp(ProviderScope(
    child: GameWidget(
      game: myGame,
    ),
  ));
}

// Iniizalise all providers
final healthPoints = StateProvider((_) => 100);
final score = StateProvider((_) => 0);
final gameOver = StateProvider((_) => false);
final inGame = StateProvider((_) => false);
