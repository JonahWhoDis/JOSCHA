import 'dart:ui';

import 'package:first_flame/my_game.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class Player extends SpriteComponent
    with CollisionCallbacks, HasGameRef<MyGame> {
  late int maxHealth;
  late int currentHealth;
  late Rect playerRect;
  late bool isDead = false;
  @override
  Future<void> onLoad() async {
    super.onLoad();
    maxHealth = currentHealth = 300;
    final size = gameRef.tileSize * 1.5;
    playerRect = Rect.fromLTWH(
      gameRef.size[0] / 2 - size / 2,
      gameRef.size[1] / 2 - size / 2,
      size,
      size,
    );
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    Paint color = Paint()..color = Color.fromARGB(255, 116, 116, 240);
    canvas.drawRect(playerRect, color);
  }

  void resize(Canvas canvas) {
    final size = gameRef.tileSize * 1.5;
    playerRect = Rect.fromLTWH(
      gameRef.size[0] / 2 - size / 2,
      gameRef.size[1] / 2 - size / 2,
      size,
      size,
    );
  }

  @override
  void update(double t) {
    super.update(t);
    if (!isDead && currentHealth <= 0) {
      isDead = true;
      gameRef.onLoad();
    }
  }
}
