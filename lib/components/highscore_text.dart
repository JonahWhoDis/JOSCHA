import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:first_flame/my_game.dart';

class HighscoreText extends SpriteComponent with CollisionCallbacks {
  final JoschaGame gameRef;
  late TextPainter painter;
  late Offset positionOffset;
  int highscore = 0;

  HighscoreText(this.gameRef);
  @override
  Future<void> onLoad() async {
    super.onLoad();
    painter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    painter.text = TextSpan(
      text: 'Highscore: $highscore',
      style: const TextStyle(
        color: Colors.black,
        fontSize: 40.0,
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
    int highscore = gameRef.storage.getInt('highscore') ?? 0;
    painter.text = TextSpan(
      text: 'Highscore: $highscore',
      style: const TextStyle(
        color: Color.fromARGB(255, 146, 146, 146),
        fontSize: 40.0,
      ),
    );
    painter.layout();

    positionOffset = Offset(
      (gameRef.size[0] / 2) - (painter.width / 2),
      (gameRef.size[1] * 0.2) - (painter.height / 2),
    );
  }
}
