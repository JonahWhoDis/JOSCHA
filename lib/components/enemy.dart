import 'dart:ui';

import 'package:first_flame/my_game.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class Enemy extends SpriteComponent
    with CollisionCallbacks, HasGameRef<MyGame> {
  int health = 3;
  int damage = 1;
  bool isDead = false;
  double speed = 0.0;
  late Rect enemySprite;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    health = 3;
    damage = 1;
    speed = gameRef.tileSize * 0.1;
    enemySprite = Rect.fromLTWH(
      gameRef.xEnemy,
      gameRef.yEnemy,
      gameRef.tileSize * 1.2, //fix constant value replace with tilesize
      gameRef.tileSize * 1.2,
    );
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    Color color;
    // switch over health
    switch (health) {
      case 3:
        color = const Color(0xFFFF4500);
        break;
      case 2:
        color = const Color(0xFFFF4C4C);
        break;
      case 1:
        color = const Color(0xFFFF7F7F);
        break;
      default:
        color = const Color(0xFFFFFFFF);
    }
    Paint enemyColor = Paint()..color = color;
    canvas.drawRect(enemySprite, enemyColor);
  }

  void attack() {
    if (!gameRef.player.isDead) {
      gameRef.player.currentHealth -= damage;
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (isDead) {
      // remove enemy from game
      gameRef.remove(this);
    } else {
      double stepDistence = speed * dt;
      Offset toPlayer = gameRef.player.playerRect.center - enemySprite.center;
      if (toPlayer.distance < stepDistence - gameRef.tileSize * 1.25) {
        Offset stepToPlayer =
            Offset.fromDirection(toPlayer.direction, stepDistence);
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
