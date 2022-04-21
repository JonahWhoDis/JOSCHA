import 'package:first_flame/my_game.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class ScoreText extends SpriteComponent
    with CollisionCallbacks, HasGameRef<MyGame> {
  late TextPainter painter;
  late Offset positionOffset;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    painter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    positionOffset = Offset.zero;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    painter.paint(canvas, positionOffset);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if ((painter.text ?? '') != gameRef.score.toString()) {
      painter.text = TextSpan(
        text: gameRef.score.toString(),
        style: const TextStyle(
          color: Colors.black,
          fontSize: 70.0,
        ),
      );
      painter.layout();

      positionOffset = Offset(
        (gameRef.size[0] / 2) - (painter.width / 2),
        (gameRef.size[1] * 0.2) - (painter.height / 2),
      );
    }
  }
}
