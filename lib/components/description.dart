import 'package:flutter/material.dart';
import 'package:first_flame/my_game.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class Discription extends SpriteComponent with CollisionCallbacks {
  final JoschaGame gameRef;
  late TextPainter painter;
  late Offset positionOffset;

  Discription(this.gameRef);

  @override
  Future<void> onLoad() async {
    super.onLoad();
    painter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    painter.text = const TextSpan(
      text:
          'Joscha, mit diesem Spiel sollst du lernen \n deine Haushaltaufgaben zu erledigen.\nKlicke 3x auf eine Aufgabe um sie zu erledigen',
      style: TextStyle(
        color: Color.fromARGB(255, 146, 146, 146),
        fontSize: 25.0,
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
