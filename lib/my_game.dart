import 'dart:math';
import 'dart:ui';

import 'package:first_flame/components/description.dart';
import 'package:flame/game.dart';
import 'package:first_flame/components/health_bar.dart';
import 'package:first_flame/components/highscore_text.dart';
import 'package:first_flame/components/score_text.dart';
import 'package:first_flame/components/start_text.dart';
import 'package:first_flame/enemy_spawner.dart';
import 'package:first_flame/state.dart';
import 'package:flame/input.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'components/enemy.dart';
import 'components/player.dart';

class MyGame extends FlameGame with HasCollisionDetection, TapDetector {
  double tileSize = 0;
  int numEnemies = 0;
  int numDamage = 0;
  late Player player;
  late SharedPreferences storage;
  int score = 0;
  late List<Enemy> enemies;
  late HealthBar healthBar;
  late EnemySpawner enemySpawner;
  late ScoreText scoreText;
  late Discription discription;
  State state = State.menu;
  late HighscoreText highscoreText;
  late StartText startText;
  List<String> tasks = List.empty(growable: true);
  Random rand = Random();
  double xEnemy = 0.0;
  double yEnemy = 0.0;
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    FlameAudio.bgm.initialize();
    FlameAudio.bgm.play('music/menu.mp3');
    await loadSprites();

    state = State.menu;
    tileSize = size.x / 10;
    enemySpawner = EnemySpawner(this);
    player = Player(this, images.fromCache("joscha1.png"));
    healthBar = HealthBar(this);
    scoreText = ScoreText(this);
    discription = Discription(this);
    highscoreText = HighscoreText(this);
    startText = StartText(this);
    storage = await SharedPreferences.getInstance();

    add(player);
    enemies = [];
    add(enemySpawner);
    add(healthBar);
    add(discription);
    add(scoreText);
    add(highscoreText);
    add(startText);
    spawnEnemy();
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
    Paint backgroundPaint = Paint()..color = Color.fromARGB(255, 21, 21, 21);
    canvas.drawRect(background, backgroundPaint);

    player.render(canvas);

    if (state == State.menu) {
      startText.render(canvas);
      highscoreText.render(canvas);
      discription.render(canvas);
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
    if (state == State.menu) {
      startText.update(dt);
      highscoreText.update(dt);
      discription.update(dt);
    } else if (state == State.playing) {
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
    if (state == State.menu) {
      FlameAudio.bgm.stop();
      state = State.playing;
      FlameAudio.bgm.play('music/Joscha.mp3');
    } else if (state == State.playing) {
      for (var enemy in enemies) {
        if (enemy.enemySprite.contains(info.raw.globalPosition)) {
          enemy.onTapDown();
        }
      }
    }
  }

  void playDeathSound() {
    switch (rand.nextInt(4)) {
      case 0:
        FlameAudio.play('sfx/death1.mp3');
        break;
      case 1:
        FlameAudio.play('sfx/death2.mp3');
        break;
      case 2:
        FlameAudio.play('sfx/death3.mp3');
        break;
      case 3:
        FlameAudio.play('sfx/death4.mp3');
        break;
    }
  }

  void playDamageSound() {
    switch (rand.nextInt(5)) {
      case 0:
        FlameAudio.play('sfx/damage1.mp3');
        break;
      case 1:
        FlameAudio.play('sfx/damage2.mp3');
        break;
      case 2:
        FlameAudio.play('sfx/damage3.mp3');
        break;
      case 3:
        FlameAudio.play('sfx/damage4.mp3');
        break;
      case 4:
        FlameAudio.play('sfx/damage5.mp3');
        break;
    }
  }

  void playSpawnSound() {
    switch (rand.nextInt(5)) {
      case 0:
        FlameAudio.play('sfx/Spawn.mp3');
        break;
      case 1:
        FlameAudio.play('sfx/Spawn1.mp3');
        break;
      case 2:
        FlameAudio.play('sfx/Spawn2.mp3');
        break;
      case 3:
        FlameAudio.play('sfx/Spawn3.mp3');
        break;
      case 4:
        FlameAudio.play('sfx/Spawn4.mp3');
        break;
    }
  }

  void spawnEnemy() {
    double x = 0.0;
    double y = 0.0;
    switch (rand.nextInt(4)) {
      case 0:
        // Top
        x = rand.nextDouble() * size[0];
        y = -tileSize * 2.5;
        break;
      case 1:
        // Right
        x = size[0] + tileSize * 2.5;
        y = rand.nextDouble() * size[1];
        break;
      case 2:
        // Bottom
        x = rand.nextDouble() * size[0];
        y = size[1] + tileSize * 2.5;
        break;
      case 3:
        // Left
        x = -tileSize * 2.5;
        y = rand.nextDouble() * size[1];
        break;
    }
    xEnemy = x;
    yEnemy = y;
    double sizemod = 0.25 + 0.5 * rand.nextDouble();
    Rect enemySprite = Rect.fromLTWH(
      xEnemy,
      yEnemy,
      tileSize * sizemod, //fix constant value replace with tilesize
      tileSize * sizemod,
    );

    numEnemies++;
    enemies.add(Enemy(
        this,
        enemySprite,
        images.fromCache(tasks[rand.nextInt(tasks.length)]),
        5.0 + score / 7.123));
  }
}
