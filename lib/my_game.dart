import 'dart:math';
import 'dart:ui';

import 'package:flame/game.dart';
import 'package:first_flame/components/health_bar.dart';
import 'package:first_flame/components/highscore_text.dart';
import 'package:first_flame/components/score_text.dart';
import 'package:first_flame/components/start_text.dart';
import 'package:first_flame/enemy_spawner.dart';
import 'package:first_flame/state.dart';
import 'package:flame/input.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'components/enemy.dart';
import 'components/player.dart';

class MyGame extends FlameGame with HasCollisionDetection, TapDetector {
  double tileSize = 0;
  Player player = Player();
  late SharedPreferences storage;
  int score = 0;
  List<Enemy> enemies = [];
  HealthBar healthBar = HealthBar();
  EnemySpawner enemySpawner = EnemySpawner();
  ScoreText scoreText = ScoreText();
  State state = State.menu;
  HighscoreText highscoreText = HighscoreText();
  StartText startText = StartText();
  Random rand = Random();
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    //final SharedPreferences prefs = await SharedPreferences.getInstance();
    rand = Random();
    score = 0;
    tileSize = size.x / 10;
    add(player);
    add(healthBar);
    add(scoreText);
    add(highscoreText);
    add(startText);
    add(enemySpawner);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    Rect background = Rect.fromLTWH(0, 0, size[0], size[1]);
    Paint backgroundPaint = Paint()
      ..color = const Color.fromARGB(255, 186, 31, 31);
    canvas.drawRect(background, backgroundPaint);

    player.render(canvas);

    if (state == State.menu) {
      startText.render(canvas);
      highscoreText.render(canvas);
    } else if (state == State.playing) {
      for (var enemy in enemies) {
        enemy.render(canvas);
      }
      scoreText.render(canvas);
      healthBar.render(canvas);
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (state == State.menu) {
      startText.update(dt);
      highscoreText.update(dt);
    } else if (state == State.playing) {
      enemySpawner.update(dt);
      for (var enemy in enemies) {
        enemy.update(dt);
      }
      enemies.removeWhere((Enemy enemy) => enemy.isDead);
      player.update(dt);
      scoreText.update(dt);
      healthBar.update(dt);
    }
  }

  void resize(Canvas canvas) {
    tileSize = size[0] / size[1];
    player.resize(canvas);
  }

  @override
  void onTapDown(TapDownInfo info) {
    if (state == State.menu) {
      state = State.playing;
    } else if (state == State.playing) {
      for (var enemy in enemies) {
        if (enemy.enemySprite.contains(info.raw.globalPosition)) {
          enemy.onTapDown();
        }
      }
    }
  }

  void spawnEnemy() {
    double x = 0.0;
    double y = 0.0;
    switch (rand.nextInt(4)) {
      case 0:
        // Top
        x = rand.nextDouble() * size[0];
        size[1] - tileSize * 2.5;
        break;
      case 1:
        // Right
        x = size[0] + size[1] * 2.5;
        y = rand.nextDouble() * size[1];
        break;
      case 2:
        // Bottom
        x = rand.nextDouble() * size[0];
        size[1] + tileSize * 2.5;
        break;
      case 3:
        // Left
        x = -tileSize * 2.5;
        y = rand.nextDouble() * size[1];
        break;
    }
    enemies.add(Enemy(x, y));
  }
}
