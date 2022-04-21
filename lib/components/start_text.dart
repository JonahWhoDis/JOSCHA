import 'package:flutter/material.dart';
import 'package:first_flame/my_game.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class StartText extends SpriteComponent
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
  void render(Canvas c) {
    super.render(c);
    painter.paint(c, positionOffset);
  }

  @override
  void update(double t) {
    super.update(t);
    painter.text = const TextSpan(
      text: 'Start',
      style: TextStyle(
        color: Colors.black,
        fontSize: 50.0,
      ),
    );
    painter.layout();

    positionOffset = Offset(
      (gameRef.size[0] / 2) - (painter.width / 2),
      (gameRef.size[1] * 0.7) - (painter.height / 2),
    );
  }
}
