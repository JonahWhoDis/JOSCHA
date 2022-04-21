import 'dart:ui';

import 'package:first_flame/my_game.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class HealthBar extends SpriteComponent with CollisionCallbacks {
  final MyGame gameRef;
  late Rect healthBarRect;
  late Rect remainingHealthRect;

  HealthBar(this.gameRef);
  // add onLoad method
  @override
  Future<void> onLoad() async {
    super.onLoad();
    double barWidth = gameRef.size[0] / 1.75;
    healthBarRect = Rect.fromLTWH(
      gameRef.size[0] / 2 - barWidth / 2,
      gameRef.size[1] * 0.8,
      barWidth,
      gameRef.tileSize * 0.2,
    );
    remainingHealthRect = Rect.fromLTWH(
      gameRef.size[0] / 2 - barWidth / 2,
      gameRef.size[1] * 0.8,
      barWidth,
      gameRef.tileSize * 0.2,
    );
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    Paint healthBarColor = Paint()..color = const Color(0xFFFF0000);
    Paint remainingBarColor = Paint()..color = const Color(0xFF00FF00);
    canvas.drawRect(healthBarRect, healthBarColor);
    canvas.drawRect(remainingHealthRect, remainingBarColor);
  }

  @override
  void update(double t) {
    super.update(t);
    double barWidth = gameRef.size[0] / 1.75;
    double percentHealth =
        gameRef.player.currentHealth / gameRef.player.maxHealth;
    remainingHealthRect = Rect.fromLTWH(
      gameRef.size[0] / 2 - barWidth / 2,
      gameRef.size[1] * 0.8,
      barWidth *
          percentHealth, // percent health deactivated for debugging pupposess
      gameRef.tileSize * 0.2,
    );
  }
}
