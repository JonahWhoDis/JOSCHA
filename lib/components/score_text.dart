import 'package:first_flame/my_game.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class ScoreText extends SpriteComponent with CollisionCallbacks {
  final JoschaGame gameRef;
  late TextPainter painter;
  late Offset positionOffset;

  ScoreText(this.gameRef);

  @override
  Future<void> onLoad() async {
    super.onLoad();
    painter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    positionOffset = Offset.zero;
    painter.text = const TextSpan(
      text: "",
      style: TextStyle(
        color: Color.fromARGB(255, 146, 146, 146),
        fontSize: 70.0,
      ),
    );
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
    if ((painter.text ?? '') != gameRef.score.toString()) {
      painter.text = TextSpan(
        text: gameRef.score.toString(),
        style: const TextStyle(
          color: Color.fromARGB(255, 146, 146, 146),
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
