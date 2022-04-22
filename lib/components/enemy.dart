import 'dart:ui';

import 'package:first_flame/my_game.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class Enemy extends SpriteComponent with CollisionCallbacks {
  final MyGame gameRef;
  int health = 3;
  int damage = 1;
  bool isDead = false;
  double speed = 2;
  Rect enemySprite;
  late Sprite taskSprite;

  Enemy(this.gameRef, this.enemySprite, Image img, this.speed) {
    taskSprite = Sprite(img);
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    health = 3;
    damage = 1;
    speed = gameRef.tileSize * 2;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    Color color;
    // switch over health
    switch (health) {
      case 3:
        color = const Color(0x00212121);
        break;
      case 2:
        color = const Color(0x44212121);
        break;
      case 1:
        color = const Color(0x88212121);
        break;
      default:
        color = const Color(0xBB212121);
    }
    Paint enemyColor = Paint()..color = color;

    Vector2 pos = Vector2(enemySprite.topLeft.dx, enemySprite.topLeft.dy);
    Vector2 dim = Vector2(enemySprite.width, enemySprite.height);
    taskSprite.render(canvas, position: pos, size: dim);
    canvas.drawRect(enemySprite, enemyColor);
  }

  void attack() {
    if (!gameRef.player.isDead) {
      gameRef.player.currentHealth -= damage;
      if (gameRef.player.currentHealth == gameRef.player.maxHealth / 2 ||
          gameRef.player.currentHealth == gameRef.player.maxHealth / 4 ||
          gameRef.player.currentHealth ==
              (gameRef.player.maxHealth / 4 + gameRef.player.maxHealth / 2)) {
        gameRef.playDamageSound();
      }
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (isDead) {
      gameRef.enemies.remove(this);
    } else {
      double stepDistance = speed * (dt * 10);
      Offset toPlayer = gameRef.player.playerRect.center - enemySprite.center;
      if ((toPlayer.distance).abs() > gameRef.tileSize * 1.25) {
        Offset stepToPlayer =
            Offset.fromDirection(toPlayer.direction, stepDistance);
        enemySprite = enemySprite.shift(stepToPlayer);
      } else {
        attack();
      }
    }
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    position = size / 2;
    size = size / 10;
  }

  void onTapDown() {
    if (!isDead) {
      health--;
      if (health <= 0) {
        isDead = true;
        gameRef.score++;
        if (gameRef.score > (gameRef.storage.getInt('highscore') ?? 0)) {
          gameRef.storage.setInt('highscore', gameRef.score);
        }
      }
    }
  }
}
