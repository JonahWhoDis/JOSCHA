import 'dart:ui';

import 'package:first_flame/my_game.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';

class Player extends SpriteComponent with CollisionCallbacks {
  final MyGame gameRef;
  late int maxHealth;
  late int currentHealth;
  late Rect playerRect;
  late Sprite playerSprite;
  late bool isDead = false;
  late FlameAudio player;

  Player(this.gameRef, Image img) {
    playerSprite = Sprite(img);
  }

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
    //canvas.drawRect(playerRect, color);
    Vector2 pos = Vector2(playerRect.topLeft.dx, playerRect.topLeft.dy);
    Vector2 dim = Vector2(playerRect.width, playerRect.height);
    playerSprite.render(canvas, position: pos, size: dim);
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
  void update(double dt) {
    super.update(dt);
    if (!isDead && currentHealth <= 0) {
      isDead = true;
      gameRef.playDeathSound();
      FlameAudio.bgm.stop();
      gameRef.onLoad();
    }
  }
}
