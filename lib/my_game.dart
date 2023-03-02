import 'dart:math';
import 'dart:ui';

import 'package:first_flame/components/description.dart';
import 'package:first_flame/components/game_over_text.dart';
import 'package:first_flame/components/pause_menu.dart';
import 'package:flame/game.dart';
import 'package:first_flame/components/health_bar.dart';
import 'package:first_flame/components/highscore_text.dart';
import 'package:first_flame/components/score_text.dart';
import 'package:first_flame/components/start_text.dart';
import 'package:first_flame/enemy_spawner.dart';
import 'package:first_flame/state.dart' as flame;
import 'package:flame/input.dart';
import 'package:flame_audio/audio_pool.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'components/enemy.dart';
import 'components/player.dart';

class JoschaGame extends FlameGame with HasCollisionDetection, TapDetector {
  double tileSize = 0;
  int numEnemies = 0;
  int numDamage = 0;
  late Player player;
  late SharedPreferences storage;
  late AudioPool pool;
  int score = 0;
  late List<Enemy> enemies;
  late HealthBar healthBar;
  late EnemySpawner enemySpawner;
  late PauseMenu pauseMenu;
  late ScoreText scoreText;
  late Discription discription;
  late GameOverText gameOverText;
  flame.State state = flame.State.menu;
  late HighscoreText highscoreText;
  late StartText startText;
  List<String> tasks = List.empty(growable: true);
  Random rand = Random();
  double xEnemy = 0.0;
  double yEnemy = 0.0;
  @override
  Future<void> onLoad() async {
    super.onLoad();
    score = 0;
    FlameAudio.bgm.initialize();
    FlameAudio.audioCache.clearAll();
    await loadAudioFiles();
    await loadSprites();
    state = flame.State.menu;
    FlameAudio.bgm.play('music/menu.mp3', volume: .75);
    tileSize = size.x / 10;
    enemySpawner = EnemySpawner(this);
    player = Player(this, images.fromCache("joscha1.png"));
    healthBar = HealthBar(this);
    scoreText = ScoreText(this);
    discription = Discription(this);
    highscoreText = HighscoreText(this);
    startText = StartText(this);
    gameOverText = GameOverText(this);
    storage = await SharedPreferences.getInstance();
    pauseMenu = PauseMenu(this);

    add(player);
    enemies = [];
    add(enemySpawner);
    add(healthBar);
    add(discription);
    add(scoreText);
    add(highscoreText);
    add(startText);
    add(gameOverText);
    add(pauseMenu);
    spawnEnemy();
  }

  Future<void> loadAudioFiles() async {
    await FlameAudio.audioCache.loadAll([
      'sfx/damage1.mp3',
      'sfx/damage2.mp3',
      'sfx/damage3.mp3',
      'sfx/damage4.mp3',
      'sfx/damage5.mp3',
      'sfx/damage6.mp3',
      'sfx/death1.mp3',
      'sfx/death2.mp3',
      'sfx/death3.mp3',
      'sfx/death4.mp3',
      'sfx/death5.mp3',
      'sfx/death6.mp3',
      'sfx/Spawn.mp3',
      'sfx/Spawn1.mp3',
      'sfx/Spawn2.mp3',
      'sfx/Spawn3.mp3',
      'sfx/Spawn4.mp3',
      'sfx/Spawn5.mp3',
      'sfx/Spawn6.mp3',
      'sfx/Spawn7.mp3',
    ]);
  }

  Future<void> loadSprites() async {
    tasks.add("tasks/car-wash.png");
    tasks.add("tasks/cooking.png");
    tasks.add("tasks/dishwasher.png");
    tasks.add("tasks/iron.png");
    tasks.add("tasks/magic-broom.png");
    tasks.add("tasks/trash-can.png");
    tasks.add("tasks/tyre.png");
    tasks.add("tasks/washing-machine.png");
    tasks.add("tasks/workplace.png");
    for (String s in tasks) {
      await images.load(s);
    }
    await images.load("joscha1.png");
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    Rect background = Rect.fromLTWH(0, 0, size[0], size[1]);
    Paint backgroundPaint = Paint()
      ..color = const Color.fromARGB(255, 21, 21, 21);
    canvas.drawRect(background, backgroundPaint);

    player.render(canvas);

    if (state == flame.State.menu) {
      startText.render(canvas);
      highscoreText.render(canvas);
      discription.render(canvas);
    } else if (state == flame.State.playing) {
      for (var enemy in enemies) {
        enemy.render(canvas);
      }
      pauseMenu.render(canvas);
      scoreText.render(canvas);
      healthBar.render(canvas);
    }
  }

  // ignore: must_call_super
  @override
  void update(double dt) {
    //super.update(dt);
    if (state == flame.State.menu) {
      startText.update(dt);
      highscoreText.update(dt);
      discription.update(dt);
    } else if (state == flame.State.playing) {
      enemySpawner.update(dt);
      for (int i = 0; i < enemies.length; i++) {
        enemies[i].update(dt);
      }
      //enemies.removeWhere((Enemy enemy) => enemy.isDead);
      player.update(dt);
      scoreText.update(dt);
      healthBar.update(dt);
    }
  }

  void resize(Canvas canvas) {
    tileSize = size[0] / 10;
    player.resize(canvas);
  }

  @override
  void onTapDown(TapDownInfo info) {
    if (state == flame.State.menu) {
      state = flame.State.playing;
      FlameAudio.bgm.stop();
      FlameAudio.bgm.play('music/Joscha.mp3', volume: 0.75);
    } else if (state == flame.State.playing) {
      for (var enemy in enemies) {
        if (enemy.enemySprite.contains(info.raw.globalPosition)) {
          enemy.onTapDown();
        }
      }
    }
  }

  void playDeathSound() {
    final deathSounds = [
      'sfx/death1.mp3',
      'sfx/death2.mp3',
      'sfx/death3.mp3',
      'sfx/death4.mp3',
      'sfx/death5.mp3',
      'sfx/death6.mp3',
    ];
    final randomIndex = rand.nextInt(deathSounds.length);
    FlameAudio.play(deathSounds[randomIndex]);
  }

  void playDamageSound() {
    final damageSounds = [
      'sfx/damage1.mp3',
      'sfx/damage2.mp3',
      'sfx/damage3.mp3',
      'sfx/damage4.mp3',
      'sfx/damage5.mp3',
      'sfx/damage6.mp3',
    ];
    final randomIndex = rand.nextInt(damageSounds.length);
    FlameAudio.play(damageSounds[randomIndex]);
  }

  void playSpawnSound() {
    final spawnSounds = [
      'sfx/Spawn.mp3',
      'sfx/Spawn1.mp3',
      'sfx/Spawn2.mp3',
      'sfx/Spawn3.mp3',
      'sfx/Spawn4.mp3',
      'sfx/Spawn5.mp3',
      'sfx/Spawn6.mp3',
      'sfx/Spawn7.mp3',
    ];
    final randomIndex = rand.nextInt(spawnSounds.length);
    FlameAudio.play(spawnSounds[randomIndex]);
  }

  void spawnEnemy() {
    const tileSize = 32; // Replace constant value with tileSize
    final xOffsets = [-tileSize * 2.5, 0, 0, -tileSize * 2.5];
    final yOffsets = [-tileSize * 2.5, tileSize * 2.5, tileSize * 2.5, 0];
    final spawnIndex = rand.nextInt(4);
    final x = rand.nextDouble() * size[0] + xOffsets[spawnIndex];
    final y = rand.nextDouble() * size[1] + yOffsets[spawnIndex];

    final sizemod = 0.25 + 0.5 * rand.nextDouble();
    final enemySprite =
        Rect.fromLTWH(x, y, tileSize * sizemod, tileSize * sizemod);

    numEnemies++;
    enemies.add(
      Enemy(
          this,
          enemySprite,
          images.fromCache(tasks[rand.nextInt(tasks.length)]),
          5.0 + score / 7.123),
    );
  }
}
