import 'package:flutter/material.dart';
import 'package:first_flame/my_game.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class GameOverText extends SpriteComponent with CollisionCallbacks {
  final JoschaGame gameRef;
  late TextPainter painter;
  late Offset positionOffset;

  GameOverText(this.gameRef);

  @override
  Future<void> onLoad() async {
    super.onLoad();
    painter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    painter.text = const TextSpan(
      text: 'GAME OVER',
      style: TextStyle(
        color: Color.fromARGB(255, 227, 66, 66),
        fontSize: 50.0,
      ),
    );
    positionOffset = Offset.zero;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    painter.layout();
    painter.paint(canvas, positionOffset);
  }

  @override
  void update(double dt) {
    super.update(dt);

    painter.layout();

    positionOffset = Offset(
      (gameRef.size[0] / 2) - (painter.width / 2),
      (gameRef.size[1] * 0.3) - (painter.height / 2),
    );
  }
}
